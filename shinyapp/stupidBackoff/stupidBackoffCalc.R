
# we load the required library & functions
library(RWeka)
library(dplyr)

getNextWords <- function (nGramFreq, previousWords, currentWord, tList) {
  
  suggestedWords <- data.frame(c2=character(),
                               score=numeric(), 
                               ngram=numeric(), 
                               stringsAsFactors=FALSE) 
  
  len <- length(previousWords)
  lenCW <- nchar(currentWord)
  
  for (i in len:0) {

    if (len>0 && i>0) {
      token <- tolower(paste(previousWords[(len-i+1):len],collapse=" "))
      ngramSuggestedWords <- nGramFreq[[as.character(i+1)]][[token]]
      if (is.null(ngramSuggestedWords)) next
    }
    ## otherwise, i==0. We use the [az] freq table if a word is being typed
    else if (length(currentWord)>0 && grepl("^[a-zA-Z]$",substr(currentWord,1,1))) {
      firstLetter <- tolower(substr(currentWord,1,1))
      ngramSuggestedWords <- nGramFreq[["0"]][[firstLetter]]
    }
    # otherwise, we use the regular "1" table (3max, 3 possibly already taken before, 1 = lastword)
    else {
      ngramSuggestedWords <- nGramFreq[["1"]][1:7,]
      # duplicate word have been removed from the sample, so it can only occur for unigrams
      if (len>0) {
        lastWord <- previousWords[len]
        if (!is.null(tList[[lastWord]])) {
          ngramSuggestedWords <- ngramSuggestedWords[-tList[[lastWord]],]
        }
      }
    }

    ## additional filter if a word is being typed
    if (length(lenCW)>0 && lenCW>0) {
      ngramSuggestedWords <- ngramSuggestedWords[substr(ngramSuggestedWords$c2,1,lenCW)==currentWord,]
    }
    
    # only keep the first 7 items (3max, 3 possibly already taken before)
    ngramSuggestedWords <- ngramSuggestedWords[1:min(6,nrow(ngramSuggestedWords)),]
    
    # calculate score
    ngramSuggestedWords[,c("score")] <- ngramSuggestedWords[,c("score")]+round((len-i)*log(0.4),4)

    # merge with previous words
    suggestedWords <- bind_rows(suggestedWords,ngramSuggestedWords)

  }
  
  # add word being typed
  if (length(currentWord)>0) bind_rows(suggestedWords,list("c2"=currentWord,"score"=100))
  
  # sort & return
  suggestedWords <- data.frame(suggestedWords %>% arrange(desc(score)))
  suggestedWords <- unique(suggestedWords[,1])

  return (suggestedWords[1:3])  
  
}
