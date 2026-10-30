#!/usr/bin/env bash
#
# Builds public/search-index.json (an inverted index) from public/search-data.json,
# which Hugo generates via layouts/index.searchdata.json.
#
# Usage:  hugo && ./scripts/build-search-index.sh
# Any configuration value below can be overridden from the environment,
# e.g. OUTPUT=static/search-index.json ./scripts/build-search-index.sh

set -euo pipefail
trap 'rm -f "${OUTPUT:-}.tmp"' EXIT

# ---- Configuration ----
INPUT="${INPUT:-public/search-data.json}"
OUTPUT="${OUTPUT:-public/search-index.json}"
MIN_WORD_LEN="${MIN_WORD_LEN:-2}"
MIN_PREFIX_LEN="${MIN_PREFIX_LEN:-3}"    # written into the index for the client
BOOST_TITLE="${BOOST_TITLE:-10}"
BOOST_TAGS="${BOOST_TAGS:-5}"
BOOST_HEADINGS="${BOOST_HEADINGS:-3}"
BOOST_BODY="${BOOST_BODY:-1}"
TF_CAP="${TF_CAP:-10}"                   # a word repeated 50 times in the body can't outweigh a title match
REMOVE_SOURCE="${REMOVE_SOURCE:-true}"   # delete INPUT after indexing
# Written into the index so the client tokenizes queries exactly the same way.
TOKEN_PATTERN='[a-z0-9]+(?:\+\+|#)?'     # keeps c++, c#, f# intact
STOP_WORDS="a about above after again against all am an and any are as at be because been before being
below between both but by can could did do does doing down during each few for from further had has
have having he her here hers herself him himself his how i if in into is it its itself just let me more
most my myself no nor not now of off on once only or other our ours ourselves out over own same she
should so some such than that the their theirs them themselves then there these they this those through
to too under until up very was we were what when where which while who whom why will with would you
your yours yourself yourselves also can't don't i'm it's let's we'll you'll"

# ---- Build ----
command -v jq >/dev/null || { echo "error: jq is required" >&2; exit 1; }
[[ -f "$INPUT" ]] || { echo "error: $INPUT not found (run hugo first)" >&2; exit 1; }

jq -c \
  --argjson minWordLen "$MIN_WORD_LEN" \
  --argjson minPrefixLen "$MIN_PREFIX_LEN" \
  --argjson boostTitle "$BOOST_TITLE" \
  --argjson boostTags "$BOOST_TAGS" \
  --argjson boostHeadings "$BOOST_HEADINGS" \
  --argjson boostBody "$BOOST_BODY" \
  --argjson tfCap "$TF_CAP" \
  --arg tokenPattern "$TOKEN_PATTERN" \
  --arg stopWords "$STOP_WORDS" '
  ($stopWords | [splits("\\s+")] | map(select(length > 0)) | unique) as $stopList
  | ($stopList | map({key: ., value: true}) | from_entries) as $stop

  | def tokens:
      ascii_downcase
      | [scan($tokenPattern)]
      | map(select(length >= $minWordLen and ($stop[.] | not)));

    # word -> boost * min(count, cap) for one field
    def fieldScores($boost):
      tokens | group_by(.) | map({key: .[0], value: (([length, $tfCap] | min) * $boost)});

  . as $posts
  | [
      $posts | to_entries[] | .key as $i | .value
      | reduce (
          (.title | fieldScores($boostTitle))[],
          ((.tags // []) | join(" ") | fieldScores($boostTags))[],
          ((.headings // []) | join(" ") | fieldScores($boostHeadings))[],
          ((.body // "") | fieldScores($boostBody))[]
        ) as $e ({}; .[$e.key] += $e.value)
      | to_entries[] | [.key, $i, .value]
    ]
  | group_by(.[0]) as $groups
  | {
      config: {
        minPrefixLen: $minPrefixLen,
        minWordLen: $minWordLen,
        tokenPattern: $tokenPattern,
        stopWords: $stopList
      },
      posts: ($posts | map({title, url, date})),
      words: ($groups | map(.[0][0])),
      postIndexAndScore: ($groups | map(map([.[1], .[2]]) | sort_by(-.[1], .[0])))
    }
' "$INPUT" > "$OUTPUT.tmp"
mv "$OUTPUT.tmp" "$OUTPUT"

posts=$(jq '.posts | length' "$OUTPUT")
words=$(jq '.words | length' "$OUTPUT")
size=$(wc -c < "$OUTPUT" | tr -d ' ')
gzipped=$(gzip -c "$OUTPUT" | wc -c | tr -d ' ')
echo "Search index: $posts posts, $words words, $size bytes ($gzipped gzipped) -> $OUTPUT"

if [[ "$REMOVE_SOURCE" == "true" ]]; then
  rm -f "$INPUT"
fi
