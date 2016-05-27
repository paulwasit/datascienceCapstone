
# prepare chunk for tokenization
getCurrentNgram <- function(text) {
  
  # split text into sentences
  sent <- NGramTokenizer(
    text, 
    Weka_control(
      min=1,
      max=1, 
      delimiters='/\t\r\n=~*&_.,;:"()?!'
    )
  )
  
  # select the last one only
  currentSent <- sent[length(sent)]
  
  # split the sentence into words
  ngram <- NGramTokenizer(
    currentSent, 
    Weka_control(
      min=1,
      max=1, 
      delimiters=' '
    )
  )
  
  len <- length(ngram)
  
  # if no words for the sentence yet
  if (len == 0) {
    return (list("c1"="eol#","c2"=character(0),"current"=text))
  }
  # otherwise
  else {
    
    lenText <- nchar(text)
    lastChar <- substr(text,lenText,lenText)

    # if no word is currently being typed, suggest most likely (keep only the last three words of the sentence)
    if (lastChar == ' ') {
      if (len <= 3) return (list("c1"=ngram,"c2"=character(0),"current"=text))
      return (list("c1"=ngram[(len-2):len],"c2"=character(0),"current"=text))
    }
  
    # otherwise, suggest most likely based on the beginning of the word
    else {
      c2 <- ngram[len]
      text <- substr(text,1,lenText-nchar(c2)) # keep everything but the word being typed
      ngram <- ngram[-len]; len <- length(ngram)
      if (len <= 3) return (list("c1"=ngram,"c2"=c2,"current"=text))
      return (list("c1"=ngram[(len-2):len],"c2"=c2,"current"=text))
    }
    
  }
  
}
    
    