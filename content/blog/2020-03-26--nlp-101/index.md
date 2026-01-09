---
title: NLP 101
tags:
- DATA SCIENCE
- MACHINE LEARNING
- NLP
- PROGRAMMING
- PROJECT
- PYTHON
cover: pqtv2tnlwpb41.jpg
author: Amita Shukla
date: '2020-03-26'
slug: nlp-101
type: post
draft: false
---
In this post, I would go over a few commonly used Natural Language Processing techniques. There's a lot of emphasis on what techniques to use for processing data, be it for data analysis, or data science, or big data depending on the scenario. But just like for Physics problems we assume negligible air resistance, friction, etc., for data problems we assume negligible poor quality data. In real life though, poor quality data is not so negligible. In fact, it is substantial and significant effort goes into data preparation before it is ready to be consumed by our data science models. 
 
We will be talking about these cleaning efforts here. 
 


![image](pqtv2tnlwpb41.jpg)

 
When I say 'cleaning up the data' what does it actually mean? Mostly it depends on your problem. At first, you may get your data from some source in a very unstructured format, like, from a website. For extracting the content of a web page, you would scrape through it, and with that, you would get a lot of gibberish along with the actual content. You might not need all of it though. 
 
In this post, I will walk through where I applied it in my project: [Relevance of News Articles w.r.t. Economic News](https://github.com/amita-shukla/nlp-economic-news). Given a number of news articles, the goal is to detect if that article is relevant to U.S. economy (I'm choosing U.S. because that's the data set I got from here). This project is mainly text-heavy, so I will move ahead with discussing Natural Language Processing techniques I used. 
 
To begin with, from all the news articles, I have chosen a random article, let's call it `sample_text`: 
 
```python
> sample_text
"Farewell Blast For a Hotel In Pittsburgh A \x89Û÷\x89Û÷controlled implosion\x89Û\x9d (top) begins to crumble the 16-story Carlton House Hotel in downtown Pittsburgh Saturday morning. The 28-vear-old building is being razed to make way for Renaissance II, the second phase of a major redevelopment of the city. Thick smoke billows from the building (center) as more than 1,000 explosive charges do their work. Seven seconds after it began, the demolition is completed (bottom). Construction of a 52-story office building has been proposed in place of the hotel, where former Soviet Premier Khrushchev stayed while visiting the city during his tour of the United States in 1959.</br></br>ROANOKE (UPI)\x89ÛÓIndustry analysts believe recent labor unrest and other problems in Poland, South Africa and Australia may lead foreign coal buyers to depend more heavily on the United States than in recent years.</br></br>Poland\x89Ûªs labor changes, racial unrest in South Africa and a major miners\x89Ûª strike in Australia\x89ÛÓthe world\x89Ûªs three largest coal exporters behind the United States\x89ÛÓare spreading the he-' lief that the United States may be t he most stable source of coal, analysts' said.</br></br>\x89ÛÏThe United States\x89Ûª image as a coal supplier has made a big comeback. Our problems are beginning to pale in com-parispn (with other coal exporters),\x89Û\x9d said Jack Kawa, a coal analyst with. Wheat, First Securities.</br></br>\x89ÛÏThe outlook for I he U.S. export is getting stronger and stronger as the world turns to coal. Customers are turning towards American coal,\x89Û\x9d ho said."

``` 


### Clean HTML

The first step is to eliminate the HTML style tags. Now for this purpose, the first thought that comes up is to use regex. However, it soon got a bit complicated... 
And then I came across [this](https://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags/1732454?stw=2#1732454): 
 


![image](stackoverflow_regex_parser.png)

```python
from bs4 import BeautifulSoup
def remove_tags(text):
    cleantext = BeautifulSoup(text, "lxml").text
    return cleantext
``` 

```python
sample_text1 = remove_tags(sample_text)
sample_text1
"Farewell Blast For a Hotel In Pittsburgh A \x89Û÷\x89Û÷controlled implosion\x89Û\x9d (top) begins to crumble the 16-story Carlton House Hotel in downtown Pittsburgh Saturday morning. The 28-vear-old building is being razed to make way for Renaissance II, the second phase of a major redevelopment of the city. Thick smoke billows from the building (center) as more than 1,000 explosive charges do their work. Seven seconds after it began, the demolition is completed (bottom). Construction of a 52-story office building has been proposed in place of the hotel, where former Soviet Premier Khrushchev stayed while visiting the city during his tour of the United States in 1959.ROANOKE (UPI)\x89ÛÓIndustry analysts believe recent labor unrest and other problems in Poland, South Africa and Australia may lead foreign coal buyers to depend more heavily on the United States than in recent years.Poland\x89Ûªs labor changes, racial unrest in South Africa and a major miners\x89Ûª strike in Australia\x89ÛÓthe world\x89Ûªs three largest coal exporters behind the United States\x89ÛÓare spreading the he-' lief that the United States may be t he most stable source of coal, analysts' said.\x89ÛÏThe United States\x89Ûª image as a coal supplier has made a big comeback. Our problems are beginning to pale in com-parispn (with other coal exporters),\x89Û\x9d said Jack Kawa, a coal analyst with. Wheat, First Securities.\x89ÛÏThe outlook for I he U.S. export is getting stronger and stronger as the world turns to coal. Customers are turning towards American coal,\x89Û\x9d ho said."
```


And therefore, I went ahead to use the well-known python library BeautifulSoup. 
 
 


### Process Single Quotes

Now as you see in the sample_text, there are a lot of special characters there. On some investigation, I observed that the pattern `'\x89Ûª'` is basically the substitute of an apostrophe or a single quote. Therefore, particular to this data, I removed the pattern: 
 
```python
import re
def process_single_quote(text):
    text = text.replace('\x89Ûª', '\'')
    return text
```
```python
sample_text2 = process_single_quote(sample_text1)
sample_text2
"Farewell Blast For a Hotel In Pittsburgh A \x89Û÷\x89Û÷controlled implosion\x89Û\x9d (top) begins to crumble the 16-story Carlton House Hotel in downtown Pittsburgh Saturday morning. The 28-vear-old building is being razed to make way for Renaissance II, the second phase of a major redevelopment of the city. Thick smoke billows from the building (center) as more than 1,000 explosive charges do their work. Seven seconds after it began, the demolition is completed (bottom). Construction of a 52-story office building has been proposed in place of the hotel, where former Soviet Premier Khrushchev stayed while visiting the city during his tour of the United States in 1959.ROANOKE (UPI)\x89ÛÓIndustry analysts believe recent labor unrest and other problems in Poland, South Africa and Australia may lead foreign coal buyers to depend more heavily on the United States than in recent years.Poland's labor changes, racial unrest in South Africa and a major miners' strike in Australia\x89ÛÓthe world's three largest coal exporters behind the United States\x89ÛÓare spreading the he-' lief that the United States may be t he most stable source of coal, analysts' said.\x89ÛÏThe United States' image as a coal supplier has made a big comeback. Our problems are beginning to pale in com-parispn (with other coal exporters),\x89Û\x9d said Jack Kawa, a coal analyst with. Wheat, First Securities.\x89ÛÏThe outlook for I he U.S. export is getting stronger and stronger as the world turns to coal. Customers are turning towards American coal,\x89Û\x9d ho said."
```


### Expand Contractions

But now the question that arises: do we want these apostrophes to processed as single words later? Suppose, if a word is _America's_, I know that the important word here is _America_ and not the apostrophe. But this might get treated as a separate word later. Therefore, I need to **decontract** these words, meaning I expand these words into their natural form. How to do it? Just by using simple regex replace. 
 
```python
import re

def decontract(phrase):
    # specific
    phrase = re.sub(r"won\'t", "would not", phrase)
    phrase = re.sub(r"can\'t", "can not", phrase)

    # general
    phrase = re.sub(r"n\'t", " not", phrase)
    phrase = re.sub(r"\'re", " are", phrase)
    phrase = re.sub(r"\'s", " is", phrase)
    phrase = re.sub(r"\'d", " would", phrase)
    phrase = re.sub(r"\'ll", " will", phrase)
    phrase = re.sub(r"\'t", " not", phrase)
    phrase = re.sub(r"\'ve", " have", phrase)
    phrase = re.sub(r"\'m", " am", phrase)
    return phrase
```
 
Now this is not entirely accurate because I see words such as _he's_, or _let's_, which get transformed into _he is_ and _let is_ respectively. But I chose to ignore them as these words are unimportant and would get eliminated later. 
 


### Remove Special Characters

As you see in the `sample_text3` above, there are still some special characters left that seem to add no meaning to the content of news articles. Time to extract them out. 
 
```python
def remove_special_chars(text):
    text = re.sub('[ÛªÓåÈ‰Ï÷ÐÊ¢~å¤|^Ç*\]{ª¨>\(\)]', ' ', text)
    text = re.sub('\x89',' ', text)
    text = re.sub('\x9d',' ', text)
    return text
```
```python
sample_text4 = remove_special_chars(sample_text3)
sample_text4
"Farewell Blast For a Hotel In Pittsburgh A controlled implosion top begins to crumble the 16-story Carlton House Hotel in downtown Pittsburgh Saturday morning. The 28-vear-old building is being razed to make way for Renaissance II, the second phase of a major redevelopment of the city. Thick smoke billows from the building center as more than 1,000 explosive charges do their work. Seven seconds after it began, the demolition is completed bottom . Construction of a 52-story office building has been proposed in place of the hotel, where former Soviet Premier Khrushchev stayed while visiting the city during his tour of the United States in 1959.ROANOKE UPI Industry analysts believe recent labor unrest and other problems in Poland, South Africa and Australia may lead foreign coal buyers to depend more heavily on the United States than in recent years.Poland is labor changes, racial unrest in South Africa and a major miners' strike in Australia the world is three largest coal exporters behind the United States are spreading the he-' lief that the United States may be t he most stable source of coal, analysts' said. The United States' image as a coal supplier has made a big comeback. Our problems are beginning to pale in com-parispn with other coal exporters , said Jack Kawa, a coal analyst with. Wheat, First Securities. The outlook for I he U.S. export is getting stronger and stronger as the world turns to coal. Customers are turning towards American coal, ho said."
```


### Trim Extra Spaces

In the above part section, I substituted the special characters with spaces `' '` instead of an empty string `''`. 

```python
def remove_more_than_single_space(text):
    return ' '.join(text.split())
```
```python
sample_text5 = remove_more_than_single_space(sample_text4)
sample_text5
"Farewell Blast For a Hotel In Pittsburgh A controlled implosion top begins to crumble the 16-story Carlton House Hotel in downtown Pittsburgh Saturday morning. The 28-vear-old building is being razed to make way for Renaissance II, the second phase of a major redevelopment of the city. Thick smoke billows from the building center as more than 1,000 explosive charges do their work. Seven seconds after it began, the demolition is completed bottom . Construction of a 52-story office building has been proposed in place of the hotel, where former Soviet Premier Khrushchev stayed while visiting the city during his tour of the United States in 1959.ROANOKE UPI Industry analysts believe recent labor unrest and other problems in Poland, South Africa and Australia may lead foreign coal buyers to depend more heavily on the United States than in recent years.Poland is labor changes, racial unrest in South Africa and a major miners' strike in Australia the world is three largest coal exporters behind the United States are spreading the he-' lief that the United States may be t he most stable source of coal, analysts' said. The United States' image as a coal supplier has made a big comeback. Our problems are beginning to pale in com-parispn with other coal exporters , said Jack Kawa, a coal analyst with. Wheat, First Securities. The outlook for I he U.S. export is getting stronger and stronger as the world turns to coal. Customers are turning towards American coal, ho said."
```
 
This was done after careful consideration, because some characters were actually acting as hyphens (-) and replacing hyphens with nothing resulted in two words joined together. And this would have been difficult to separate out. Hence, just trim these extra spaces. 
 


### Tokenize words

Now that we have dealt with the processing on the complete text, we can go on now to take things word-wise. But how do we create words out of text (This is called **tokenization**)? It's simple: split by space. But is it this simple? Because when we treat text as just a bunch of characters separated by spaces, we create a lot of meaning-less words when we split such a text. This is because, practically, text contains punctuation too. So if we split this text by spaces, what we get is a lot of words with punctuation attached: which for a program these are completely new words. 


 


So what? You would say. Just remove the punctuation marks! I tried something like this: 

```python
import re
import string

punctuation = string.punctuation
def remove_punctuation(text):
    return re.sub(r'[^a-zA-Z]',' ',text)
```
 
At least for my case, this did not turn out to be that simple. Because while removing punctuation marks and then splitting the text by space sanitized my words, a lot of meaningful words got lost. e.g. _U.S.A._: this word gets split into 3 separate words: _U, S, A_. Totally meaningless. 
 
The Solution I derived was using the function `word_tokenize` from `nltk` library, which is more intelligent in generating such tokens. 

```python
import nltk
from nltk import word_tokenize

tokens = word_tokenize(text) 
tokens = [token for token in tokens if (not isNumber(token) and token!='.' and token!=',') ]
```

For a term like _u.s.a._ 
 
```python
word_tokenize("u.s.a.")
['u.s.a', '.']
``` 
For our `sample_text`, these were the tokens generated. Observe that these tokens have periods and commas and other punctuation generated as separate tokens, which can be filtered as given in the code above. But `word_tokenize` from `nltk` is smart enough in not splitting all the words by punctuation, such as the phrases _28-year-old_ and _U.S._ are treated as single tokens. 

```python
from nltk import word_tokenize
word_tokenize(sample_text5)
['Farewell', 'Blast', 'For', 'a', 'Hotel', 'In', 'Pittsburgh', 'A', 'controlled', 'implosion', 'top', 'begins', 'to', 'crumble', 'the', '16-story', 'Carlton', 'House', 'Hotel', 'in', 'downtown', 'Pittsburgh', 'Saturday', 'morning', '.', 'The', '28-vear-old', 'building', 'is', 'being', 'razed', 'to', 'make', 'way', 'for', 'Renaissance', 'II', ',', 'the', 'second', 'phase', 'of', 'a', 'major', 'redevelopment', 'of', 'the', 'city', '.', 'Thick', 'smoke', 'billows', 'from', 'the', 'building', 'center', 'as', 'more', 'than', '1,000', 'explosive', 'charges', 'do', 'their', 'work', '.', 'Seven', 'seconds', 'after', 'it', 'began', ',', 'the', 'demolition', 'is', 'completed', 'bottom', '.', 'Construction', 'of', 'a', '52-story', 'office', 'building', 'has', 'been', 'proposed', 'in', 'place', 'of', 'the', 'hotel', ',', 'where', 'former', 'Soviet', 'Premier', 'Khrushchev', 'stayed', 'while', 'visiting', 'the', 'city', 'during', 'his', 'tour', 'of', 'the', 'United', 'States', 'in', '1959.ROANOKE', 'UPI', 'Industry', 'analysts', 'believe', 'recent', 'labor', 'unrest', 'and', 'other', 'problems', 'in', 'Poland', ',', 'South', 'Africa', 'and', 'Australia', 'may', 'lead', 'foreign', 'coal', 'buyers', 'to', 'depend', 'more', 'heavily', 'on', 'the', 'United', 'States', 'than', 'in', 'recent', 'years.Poland', 'is', 'labor', 'changes', ',', 'racial', 'unrest', 'in', 'South', 'Africa', 'and', 'a', 'major', 'miners', "'", 'strike', 'in', 'Australia', 'the', 'world', 'is', 'three', 'largest', 'coal', 'exporters', 'behind', 'the', 'United', 'States', 'are', 'spreading', 'the', 'he-', "'", 'lief', 'that', 'the', 'United', 'States', 'may', 'be', 't', 'he', 'most', 'stable', 'source', 'of', 'coal', ',', 'analysts', "'", 'said', '.', 'The', 'United', 'States', "'", 'image', 'as', 'a', 'coal', 'supplier', 'has', 'made', 'a', 'big', 'comeback', '.', 'Our', 'problems', 'are', 'beginning', 'to', 'pale', 'in', 'com-parispn', 'with', 'other', 'coal', 'exporters', ',', 'said', 'Jack', 'Kawa', ',', 'a', 'coal', 'analyst', 'with', '.', 'Wheat', ',', 'First', 'Securities', '.', 'The', 'outlook', 'for', 'I', 'he', 'U.S.', 'export', 'is', 'getting', 'stronger', 'and', 'stronger', 'as', 'the', 'world', 'turns', 'to', 'coal', '.', 'Customers', 'are', 'turning', 'towards', 'American', 'coal', ',', 'ho', 'said', '.']
```

Obviously, this generic tokenizer is not fool-proof, as you would see some totally useless tokens generated, such as _years.Poland_. But this is a trade-off: you can either decide to handle each and every special case yourself, or give way to a bit more generalization. 


 


What is to be done with these token you ask? Let's move on to the next step.

 


### Stem Text

This is an important lesson (and the most commonly used) when it comes to Natural Language Processing.

When we want to process the data, we usually need to determine the count of the occurrences of a word. For example, for our problem to detect economic news for US economy, we may need to count the number of times (frequency) the words such as _economy_, _America_, _USA_, _dollars_ etc occur in a given news article. But, as these articles are written in natural English, each English word may occur in a different form, such as, for _economy_different words can be _economic, economical, economics_ etc. Now, these words are to be treated in the same way by our model. How to do that? By reducing all these words to the same word, i.e. by reducing it to its root form.

So, _economy_ gets reduced to_economi_.

This reduction of words to its canonical roots is achieved by two techniques, Stemming and Lemmatization. Let's go over both of them.

 


#### Stemming v/s Lemmatization

While the purpose of both techniques is the same, the results are quite different. Stemming relies on a set of certain rules to derive the root of a word. In a linguistic sense, these derived roots might not be actual words. Consider that Stemming applies a formula for a word to derive the result. It may remove prefixes, suffixes etc.

Lemmatization, on the other hand, relies heavily on linguistics knowledge. A proper dictionary, vocabulary and morphological analysis (the study of how a word is formed, from what language(s) etc.) is needed.

What do we need for our purpose? I tried both: 
 


#### Stemming

I used the `PorterStemmer` from `nltk` library for this purpose: 
 
```python
import nltk
nltk.download('punkt')

from nltk.stem import PorterStemmer
from nltk import word_tokenize

stemmer = PorterStemmer()

def stem_token(token):
    stemmed_token = stemmer.stem(token)
    return stemmed_token

def stem_text(text):
    tokens = word_tokenize(text) 
    tokens = [token for token in tokens if (not isNumber(token) and token!='.' and token!=',') ] # filter numbers, periods
    stemmed_tokens = [stem_token(token) for token in tokens]
    stemmed_sentence = ' '.join(stemmed_tokens) # construct the text again
    return stemmed_sentence
```


#### Lemmatization

I used the `WordNetLemmatizer` from the nltk library for this purpose: 
 
```python
import nltk
nltk.download('wordnet')

from nltk.stem import WordNetLemmatizer
from nltk import word_tokenize

wnl = WordNetLemmatizer()

def lemmatize_text(text):
    tokens = word_tokenize(text)
    lemmatized_tokens = [wnl.lemmatize(token) for token in tokens if not (isNumber(token) and token!='.' and token!=',')]
    lemmatized_sentence = ' '.join(lemmatized_tokens)
    return lemmatized_sentence
```


- Though lemmatizer looks better to the human eye, it fails to solve our purpose. This is because of the way we're going to use these processed tokens. On passing these tokens to some vectorizer later (in very simple terms, [**vectorizers**](https://scikit-learn.org/stable/modules/feature_extraction.html#text-feature-extraction) are used to turn text into vectors, to be processed later by the model), the number of features using stemmer turn out to be less than what lemmatizer produced. You can think of 'number of features' as the number of unique words generated. The frequency of these unique words decides how much they dominate the model results, hence acting as a feature. As the lemmatizer tries to generate a perfect English language word (lemma), it generates a lot more unique root words than the Stemmer overall. The number of features needs to calibrated very carefully for the overall performance of our model (threw me an OutOfMemory error), or even, may cause our data to [**overfit**](https://en.wikipedia.org/wiki/Overfitting).
- Theoretically too, a Stemmer is far simpler, and faster than Lemmatizer.
- Lemmatizer is stricter than Stemmer.
- Hence, for data science problems where the focus is not on the linguistics and it's not a language application but on using the text as input, we do not need such aggressive and perfect reduction of words that Lemmatizer provides. Stemming is usually sufficient.

 


### Process All

Time to process all these steps together to get our nice, clean data! 
 
```python
def process_all(text):
    text = remove_tags(text)
    text = process_single_quote(text)
    text = decontract(text)
    text = remove_special_chars(text)
    text = remove_more_than_single_space(text)
    text = text.lower()
    text = stem_sentence(text)
    return text
```

 
Well, that's all for this post now. And this was just the pre-processing I covered here. A lot more insight about your data is needed before feeding your input to a model. For this problem, you can check out the rest of the notebook [here](https://github.com/amita-shukla/nlp-economic-news/blob/master/news_relevance.ipynb), if you want to see what all I did. 
I would also suggest going through [the NLTK book](https://www.nltk.org/book/), it helped me a lot while trying to gulp the data set down.

