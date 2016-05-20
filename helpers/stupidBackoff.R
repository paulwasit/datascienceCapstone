
# we load the required library & functions
library(RWeka)

stupidBackoff <- function (nGramFreq, c1, c2) {
  ptm <- proc.time()
  suggestedWords <- data.frame(c2=character(),
                               score=numeric(), 
                               ngram=numeric(), 
                               stringsAsFactors=FALSE) 
  
  len <- length(c1)
  # g1 freq
  suggestedWords <- nGramFreq[["1"]][1:3,] %>% 
                    select(c2,score) %>%
                    mutate(ngram=1)
  
  # if this is the start of a sentence, return g1 freq
  if (len == 0) return (suggestedWords)
    
  # otherwise, penalize score (stupid backoff)
  suggestedWords$score <- suggestedWords$score + round(len*log(0.4),4)
  
  # then check for (n>1)grams
  for (i in 1:len) {
    
    # identify all candidates for the ngram
    token <- paste(c1[i:len])  
    lenT <- length(token)
    ngramSuggestedWords <- nGramFreq[[as.character(lenT+1)]] %>% 
                           filter(c1 == tolower(token)) %>%
                           select(c2,score) %>%
                           mutate(ngram=lenT+1) %>%
                           mutate(score=score+round((len-i)*log(0.4),4)) #stupid bo penalty
    
    # select the three most likely candidates for each ngram
    ngramSuggestedWords <- ngramSuggestedWords[1:min(3,nrow(ngramSuggestedWords)),]
    
    # merge with previous words
    suggestedWords <- bind_rows(suggestedWords,ngramSuggestedWords)
    
  }
  
  suggestedWords <- suggestedWords %>% filter (c2 != c1[len]) %>% arrange(desc(score))
  suggestedWords <- data.frame(suggestedWords[1:3,])
  
  return (suggestedWords)  
  
}
    
    