#!/usr/bin/env python3
import os
import re
import yaml

# --- Configuration ---
BASE_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "content")

# Sections to migrate: folder_name -> type
SECTIONS = {
    "blog": "post",
    "notes": "note"
}

# Regex to parse folder names: YYYY-MM-DD--slug
FOLDER_RE = re.compile(r"(\d{4}-\d{2}-\d{2})--(.+)")

# --- Helper function to update front-matter ---
def update_frontmatter(index_file, date_part, slug_part, post_type):
    with open(index_file, "r", encoding="utf-8") as f:
        content = f.read()

    # Split front-matter and body
    if content.startswith("---"):
        parts = content.split("---", 2)
        if len(parts) < 3:
            print(f"Skipping invalid front-matter: {index_file}")
            return
        fm_raw = parts[1]
        body = parts[2]
    else:
        fm_raw = ""
        body = content

    # Load YAML front-matter
    try:
        fm = yaml.safe_load(fm_raw) or {}
    except yaml.YAMLError:
        print(f"Error parsing YAML: {index_file}")
        return

    # Update fields
    fm["date"] = date_part
    fm["slug"] = slug_part
    fm["type"] = post_type
    if "draft" not in fm:
        fm["draft"] = False

    # Dump back to YAML
    fm_yaml = yaml.dump(fm, sort_keys=False, allow_unicode=True)

    # Reconstruct index.md
    new_content = f"---\n{fm_yaml}---\n{body.lstrip()}"
    with open(index_file, "w", encoding="utf-8") as f:
        f.write(new_content)

    print(f"Updated front-matter: {index_file}")

# --- Main migration ---
for section, post_type in SECTIONS.items():
    section_path = os.path.join(BASE_DIR, section)
    if not os.path.exists(section_path):
        print(f"Section not found, skipping: {section}")
        continue

    for folder in os.listdir(section_path):
        folder_path = os.path.join(section_path, folder)
        index_file = os.path.join(folder_path, "index.md")
        if not os.path.isfile(index_file):
            continue

        m = FOLDER_RE.match(folder)
        if not m:
            print(f"Skipping folder (invalid format): {folder}")
            continue

        date_part, slug_part = m.groups()
        update_frontmatter(index_file, date_part, slug_part, post_type)
