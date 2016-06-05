### Introduction

This project aims to create a program that makes it easier for people to type on their mobile devices, by suggesting three options for what the next word might be. It should approximate the smart keyboard made by SwiftKey, our corporate partner in this capstone. 

It will be based on predictive models, built from large amounts of data collected on the internet (the corpus is called [HC Corpora](http://www.corpora.heliohost.org/)):

+ newspapers and magazines
+ personal and professional blogs
+ Twitter updates

When building our models, we will focus on:

+ **speed**: predictions should not take more than one second to appear
+ **accuracy**: predictions should be relevant to the user
+ **correctness**: predictions should be actual english words

The last point is not to be neglected, especially for data coming from Twitter (use of hashtags, spelling errors, etc.).


### Training size

The [Brown Corpus](https://en.wikipedia.org/wiki/Brown_Corpus), which has been created in the 1960's and which for many years has been among the most-cited resources in the field, contains only one million words. Contemporary corpora tend to be much larger, on the order of 100 million words.

Our corpus totals more than **60 million words**. Working with such a large amount of data can be computationally intensive, so we will start by keeping only a **15% sample**, or approx. **10 million words**. This will allow us to familiarize with the data, start building our model, and do our first optimizations. We will consider enlarging our training set afterwards if nessessary.

Our three sources vary in size. As we want each to have the same weight in our training set, we will keep:

+ 100% of the newspapers and magazines data
+ 10% of the personal and professional blogs data
+ 10% of Twitter updates

This will give us roughly **3 million words per source**.

In order to limit the bias during sampling, we will:

1. fully randomize the lines of each sampled text
2. give each line 10% chance to be selected
3. save our sample in a new file

*Note: we will set seeds for each step, which will guarantee the reproducibility of the sampling.*


### Tokenization

Our predictive models will be based on N-gram probabilities, so our first step is to tokenize our samples and **build frequency tables for uni- to 4-grams**. We use the RWeka library, as it is up to 100 times faster than others. It splits words like `don't` in two tokens `don`and `t`by default, so we use a custom parsing  method where we remove `'` from the delimiters and add a few more. 

```r
# Zoom on the technical details: custom delimiters
delimiters=' /\\\r\n\t=<>~*&_.,;:"()?!'
```

<br/>
The exact steps are the following:

1. extract all unigrams (ie. single words) from our sample using RWeka
2. clean all the wrongly encoded UTF-8 characters, using this [table](http://www.i18nqa.com/debug/utf8-debug.html) and the `gsub`function
3. replace all unknown words by the token "&lt;UNK&gt;", using the dictionary available in the qdap library
4. save our cleaned-up sample in a new file
5. build frequency tables for uni- to 4-grams from our cleaned-up sample, using RWeka again

```r
# Zoom on the technical details: we will use the qdap dictionary (100k+ words)
qdapDictionaries::GradyAugmented
# note: spliting the dictionary in 26 sub-lists (one per letter) and 
# searching the relevant sub-list for each word instead of the whole dictionary
# makes the computation 100x faster (which is handy as it takes 10 minutes when optimized)
```


### Final training set

Building our data set takes approx. one hour. The longest computation is by far the filtering of non existing words, as the dictionary is 100k-words long and each sample is roughly 3m-words long (this task alone takes approx. 10 minutes per sample).

Here is our training set after the cleanup:

| N-gram | Unique Before | 
|:-------|--------------:|
| unigrams |     52 031  | 
| bigrams  |  2 001 316  |  
| trigrams |  4 488 650  | 
| 4-grams  |  5 598 643  | 


Here is the list of top10 N-grams for the cleaned-up training set (excl. &lt;UNK&gt;):

| Top10 | 1-gram | 2-gram   | 3-gram | 4-gram |
|:-----:|:-------|:---------|:-------|:-------|
|     1 |    the |   of the |      one of the |         the end of the |
|     2 |     to |   in the |        a lot of |          at the end of |
|     3 |    and |   to the |  thanks for the |  thanks for the follow |
|     4 |      a |  for the |     going to be |        the rest of the |
|     5 |     of |   on the |         to be a |     for the first time |
|     6 |      i |    to be |       i want to |       at the same time |
|     7 |     in |   at the |      the end of |         is going to be |
|     8 |    for |  and the |      out of the |          is one of the |
|     9 |     is |     in a |        it was a |        one of the most |
|    10 |   that | with the |      as well as |       in the middle of |


As an example of 3-gram, and in anticipation to the next steps, here is the 3 most frequent words occuring in the training set after "on my...":

| Word | Count | 
|:-------|-----:|
| ...way  |  227 | 
| ...mind |   92 |  
| ...own  |   91 | 


### Next steps

Now that we have built our training set, the next steps will be to build our predictive model. Our next steps will be to:

+ filter bad words from our suggestions, as soon as we find the dictionary to do so
+ limit our calculations to small N-grams (see [Markov Chains](https://en.wikipedia.org/wiki/Markov_chain))
+ see how pruning unfrequent N-grams can lead to faster computation without losing accuracy
+ implement smoothing to handle unkwnown words typed by the users
  + having our "&lt;UNK&gt;" tokens will probably help
  + [stupid backoff](http://www.aclweb.org/anthology/D07-1090.pdf) should work well, as our training set is quite large
  + if not, we will consider more advanced algorithms like [Kneser-Ney](https://en.wikipedia.org/wiki/Kneser%E2%80%93Ney_smoothing)
+ lastly, we will consider adding large corpora to our training set, like the [Google N-gram](http://storage.googleapis.com/books/ngrams/books/datasetsv2.html)