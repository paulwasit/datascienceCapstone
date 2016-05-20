
# we load the required library & functions
library(RWeka)

stupidBackoff <- function (start, wordArray) {
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
    comp <- rbind(
      comp, 
      data.frame('word' = word, 
                 'score' = round(stupidBackoffCalc(token)[1],2),
                 'ngram' = stupidBackoffCalc(token)[2]
      )
    )
  }
  comp <- arrange(comp, desc(score))
  print(proc.time() - ptm)
  return (comp)
}

getFrequency <- function (tokenLength, tokenText) {
  value <- Gfreq[[as.character(tokenLength)]] %>% 
    filter(list == tokenText) %>%
    select(freq)
  value <- log(value[,1])
  return (value)
}

stupidBackoffCalc <- function(token) {
  
  tokenLength <- length(token)
  tokenTextN <- paste(token, collapse = ' ')
  
  # get frequency of the ngram
  valueN <- getFrequency (tokenLength, tokenTextN)
  
  # if ngram is found, we calculate its s-value
  if (length(valueN) > 0) {
    if (tokenLength > 1) {
      tokenTextD <- paste(token[1:tokenLength-1], collapse = ' ') # starting (n-1) gram
      valueD <- getFrequency (tokenLength-1, tokenTextD)
    }
    else {
      valueD <- log(sum(Gfreq[["1"]][,2]))
    }
    sValue <- valueN - valueD
    sFound <- tokenLength
  }
  
  #otherwise we recursively get the s-value of the (n-1)gram
  else if (tokenLength > 1) {
    recSBO <- stupidBackoffCalc(token[2:tokenLength])
    sValue <- log(0.4) + recSBO[1]
    sFound <- recSBO[2]
  }
  
  else {
    #print('not found')
    sValue <- log(0)
    sFound <- 5
  }
  return(c(sValue,sFound))
}