
# we load the required library & functions
library(RWeka)

stupidBackoffCalc <- function (nGramFreq, previousWords, currentWord) {
  ptm <- proc.time()
  suggestedWords <- data.frame(c2=character(),
                               score=numeric(), 
                               ngram=numeric(), 
                               stringsAsFactors=FALSE) 
  
  len <- length(previousWords)
  
  for (i in len:0) {
    
    # identify the freq table
    ngramSuggestedWords <- nGramFreq[[as.character(i+1)]]
    
    # if previousWords exists (ie. not unigram table), filter table by c1 + c2 not equal to the previous word
    if (len>0) {
      lastWord <- previousWords[len]
      ngramSuggestedWords <- ngramSuggestedWords %>% filter (c2 != lastWord) 
      if (i>0) {
        token <- paste(previousWords[(len-i+1):len],collapse=" ")  
        ngramSuggestedWords <- ngramSuggestedWords %>% filter(c1 == tolower(token))
      }
    }

    # exclude words already suggested by higher ngrams 
    ngramSuggestedWords <- ngramSuggestedWords %>% 
                           filter( !(c2 %in% data.frame(suggestedWords)[,1]) ) %>% 
                           select(c2,score) %>% 
                           mutate(ngram=i+1) %>% 
                           mutate(score=score+round((len-i)*log(0.4),4)) %>% #stupid bo penalty
                           mutate(score=round(100*exp(score),2)) # convert back to percent
    
    # additional filter if a word is being typed
    if (length(currentWord)>0) {
      ngramSuggestedWords <- ngramSuggestedWords %>% filter(grepl(paste0("^",currentWord),c2))
      if ( (!currentWord %in% data.frame(suggestedWords)[,1]) ) {
        if (!currentWord %in% ngramSuggestedWords[,1]) {
          ngramSuggestedWords <- data.frame(bind_rows(ngramSuggestedWords,list("c2"=currentWord,"score"=100,"ngram"=i+1)))
        }
        else {
          ngramSuggestedWords[ngramSuggestedWords$c2==currentWord,2] <- 100
        }
        ngramSuggestedWords <- ngramSuggestedWords %>% arrange(desc(score))
      } 
    }
    
    # select the three most likely candidates for each ngram
    ngramSuggestedWords <- ngramSuggestedWords[1:min(3,nrow(ngramSuggestedWords)),]
    
    # merge with previous words
    suggestedWords <- bind_rows(suggestedWords,ngramSuggestedWords)

  }
  
  # sort & return
  suggestedWords <- data.frame(suggestedWords %>% arrange(desc(score)))
  return (suggestedWords)  
  
}

exp(round(log(0.4),4))

    