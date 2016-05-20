
# we load the required library & functions
library(RWeka)

stupidBackoff <- function (nGramFreq, start, wordArray) {
  ptm <- proc.time()
  comp <- data.frame(word=character(),
                     score=numeric(), 
                     ngram=numeric(), 
                     stringsAsFactors=FALSE) 
  
  for (word in wordArray) {
    ngram <- tolower(paste(start, word))
    token <- NGramTokenizer(
      ngram, 
      Weka_control(
        min=1,
        max=1, 
        delimiters=' /\t\r\n=~*&_.,;:"()?!'
      )
    )
    SBO <- stupidBackoffCalc(nGramFreq,token)
    comp <- rbind(
      comp, 
      data.frame('word' = word, 
                 'score' = SBO[1],
                 'ngram' = SBO[2]
      )
    )
  }
  comp <- arrange(comp, desc(score))
  print(proc.time() - ptm)
  return (comp)
}

stupidBackoffCalc <- function(nGramFreq, token) {
  
  tokenLength <- length(token)
  newWord <- token[tokenLength]
  
  if (tokenLength > 1) {
    previousNgram <- paste(token[1:tokenLength-1], collapse = ' ')
    sValue <- nGramFreq[[as.character(tokenLength)]] %>% 
              filter(c1 == previousNgram) %>% filter(c2 == newWord)
  }
  else {
    sValue <- nGramFreq[[as.character(tokenLength)]] %>% 
              filter(c1 == newWord)
  }
  sValue <- sValue$score
  
  if (length(sValue) > 0) {
    sFound <- tokenLength
  }
  else if (tokenLength > 1) {
    recSBO <- stupidBackoffCalc(nGramFreq, token[2:tokenLength])
    sValue <- round(log(0.4),2) + recSBO[1]
    sFound <- recSBO[2]
  }
  else {
    #print('not found')
    sValue <- log(0)
    sFound <- 5
  }
  return(c(sValue,sFound))
  
}
