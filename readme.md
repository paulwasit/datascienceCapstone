# Data Science Specialization Capstone Project

This is the Capstone Project for the Johns Hopkins University **Data Science Specialization** on [Coursera](https://www.coursera.org/specializations/jhu-data-science).

## Project Overview

_Excerpt from the project introduction [page](https://www.coursera.org/learn/data-science-project/supplement/FrBtO/project-overview)_

> Around the world, people are spending an increasing amount of time on their mobile devices for email, 
> social networking, banking and a whole range of other activities. 
> But typing on mobile devices can be a serious pain. SwiftKey, our corporate partner in this capstone, 
> builds a smart keyboard that makes it easier for people to type on their mobile devices. 
> One cornerstone of their smart keyboard is predictive text models. When someone types:

> I went to the

> the keyboard presents three options for what the next word might be. 
> For example, the three words might be gym, store, restaurant. 
> In this capstone you will work on understanding and building predictive text models like those used by SwiftKey.


## Data Source

The data is from a corpus called [HC Corpora](http://www.corpora.heliohost.org/). As explained in their website:

> HC corpora is a collection of corpora for various languages freely available to download.
> The corpora have been collected from numerous different webpages, with the aim of getting a varied and comprehensive corpus of current use of the respective language.
> I have strived to search from many different types of sources, such as newspapers, magazines, (personal and professional) blogs and Twitter updates.

> The corpora are collected from publicly available sources by a web crawler. The crawler checks for language, so as to mainly get texts consisting of the desired language.
> Each entry is tagged with it's date of publication. Where user comments are included they will be tagged with the date of the main entry.
> Each entry is tagged with the type of entry, based on the type of website it is collected from (e.g. newspaper or personal blog) 
> If possible, each entry is tagged with one or more subjects based on the title or keywords of the entry 
> (e.g. if the entry comes from the sports section of a newspaper it will be tagged with "sports" subject).
> In many cases it's not feasible to tag the entries or no subject is found by the automated process, in which case the entry is tagged with a '0'.
> To save space, the subject and type is given as a numerical code.

_Note: the automatic language checker sometimes fails to differentiate very similar languages. This is why there are some foreign text in the files._

The raw data can be downloaded from [here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip).



## Additional Resources

+ [Natural language processing Wikipedia page](https://en.wikipedia.org/wiki/Natural_language_processing)
+ [Text mining infrastucture in R](https://www.jstatsoft.org/article/view/v025i05)
+ [CRAN Task View: Natural Language Processing](https://cran.r-project.org/web/views/NaturalLanguageProcessing.html)
+ [Coursera course on NLP](https://www.coursera.org/course/nlp)


## Appendix - Specialization content

The [Specialization](https://www.coursera.org/specializations/jhu-data-science) is divided in 9 courses:

1. Data Scientist Toolbox
2. R Programming
3. Getting and Cleaning Data
4. Exploratory Data Analysis
5. Reproducible Research
6. Statistical Inference
7. Regression Models
8. Practical Machine Learning
9. Developing Data Products

Notes and course projects are available [here](https://github.com/paulwasit/datasciencecoursera).