
# we load the required library & functions
library(RWeka)
library(dplyr)

getNextWords <- function (nGramFreq, previousWords, currentWord) {
  
  ptm <- proc.time()
  
  suggestedWords <- data.frame(c2=character(),
                               score=numeric(), 
                               ngram=numeric(), 
                               stringsAsFactors=FALSE) 
  
  len <- length(previousWords)
  lenCW <- nchar(currentWord)
  
  for (i in len:0) {
    
    # if previousWords exists (ie. not first word of sentence), filter table by c1
    if (len>0 && i>0) {
      token <- paste(previousWords[(len-i+1):len],collapse=" ")
      firstLetter <- tolower(substr(token,1,1))
      ngramSuggestedWords <- nGramFreq[[paste0(as.character(i+1),as.character(i+1))]][[firstLetter]]
      if (is.null(ngramSuggestedWords)) next
      ngramSuggestedWords <- ngramSuggestedWords %>% filter(c1 == tolower(token))
    }
    # otherwise, i==0. We use the [az] freq table if a word is being typed
    else if (length(currentWord)>0 && grepl("^[a-zA-Z]$",substr(currentWord,1,1))) {
      firstLetter <- tolower(substr(currentWord,1,1))
      ngramSuggestedWords <- nGramFreq[["0"]][[firstLetter]]
    }
    # otherwise, we use the regular "1" table (3max, 3 possibly already taken before, 1 = lastword)
    else {
      ngramSuggestedWords <- nGramFreq[["1"]][1:7,]
    }
    
    # additional filter if a word is being typed
    if (length(lenCW)>0 && lenCW>0) {
      ngramSuggestedWords <- ngramSuggestedWords[substr(ngramSuggestedWords$c2,1,lenCW)==currentWord,]
    }
    
    # only keep the first 7 items (3max, 3 possibly already taken before, 1 = lastword)
    ngramSuggestedWords <- ngramSuggestedWords[1:min(7,nrow(ngramSuggestedWords)),c("c2","score")]
    
    # calculate score
    ngramSuggestedWords[,c("score")] <- ngramSuggestedWords[,c("score")]+round((len-i)*log(0.4),4)

    # merge with previous words
    suggestedWords <- bind_rows(suggestedWords,ngramSuggestedWords)

  }
  
  # remove c2 = last word
  if (len>0) {
    lastWord <- previousWords[len]
    suggestedWords <- suggestedWords %>% filter (c2 != lastWord) 
  }
  
  # add word being typed
  if (length(currentWord)>0) bind_rows(suggestedWords,list("c2"=currentWord,"score"=100))
  
  # identify duplicate words
  suggestedWords <- data.frame(suggestedWords %>% arrange(c2,desc(score)))
  testDuplicate <- suggestedWords[,c("c2")]
  testDuplicateFilter <- c(TRUE,testDuplicate[-length(testDuplicate)] != testDuplicate[-1])
  
  # sort & return
  suggestedWords <- suggestedWords[testDuplicateFilter,] %>% arrange(desc(score))
  
  ptm <- proc.time()-ptm
  #print(paste0(round(1000*ptm[3],0)))
  
  return (suggestedWords[1:3,1])  
  
}
