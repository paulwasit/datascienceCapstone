
# we load the required library & functions
library(RWeka)

# prepare chunk for tokenization
getSplitText <- function(text,cursorPos) {
  
  beforePos <- substr(text,1,cursorPos)
  afterPos <- substr(text,cursorPos+1,nchar(text))

  lenText <- nchar(beforePos)
  lastChar <- substr(beforePos,lenText,lenText)
  
  # new sentence if last char is not a word or a space
  if (!grepl("^[a-zA-Z0-9\' ]$", lastChar)) {
    return(list(
      "previousWords"="eol#",
      "currentWord"=character(0),
      "previousText"=beforePos,
      "nextText"=afterPos,
      "cursorPos"=cursorPos)
    )
  }
  
  # identify current word if last char before cursor is not a space (ie. a letter or a number)
  if (lastChar != ' ') {
    i <- 1
    while(grepl("^[a-zA-Z0-9]+$", substr(afterPos,1,i)) && i<=nchar(afterPos)) {
      i <- i+1
    }
    if (i>1) {
      cursorPos <- cursorPos+i-1
      beforePos <- substr(text,1,cursorPos)
      afterPos <- substr(text,cursorPos+1,nchar(text))
      lenText <- nchar(beforePos)
      lastChar <- substr(beforePos,lenText,lenText)
    }
  }
  
  # we can now get the last words before the cursor
  sent <- tokenize(beforePos,'[^a-zA-Z0-9\' ]')
  currentSent <- sent[length(sent)]
  ngram <- tokenize(currentSent,' ')
  len <- length(ngram)

  # if no words for the sentence yet
  if (len == 0) {
    c1 <- "eol#"
    c2 <- character(0)
  }
  # otherwise, if no word is currently being typed
  else {
    
    if (lastChar == ' ') {
      c2 <- character(0)
    }
    # otherwise
    else {
      c2 <- ngram[len]
      cursorPos <- cursorPos - nchar(c2)
      beforePos <- substr(beforePos,1,lenText-nchar(c2)) # keep everything but the word being typed
      ngram <- ngram[-len]; len <- length(ngram)
    }
      
    # we only keep ngrams up to 4, so c1 length is 3 max 
    if (len <= 3) c1 <- ngram
    else c1 <- ngram[(len-2):len]
  
  }
  
  return (
    list(
      "previousWords"=c1,
      "currentWord"=c2,
      "previousText"=beforePos,
      "nextText"=afterPos,
      "cursorPos"=cursorPos
    )
  )
  
}

tokenize <- function (text, delimiter) {
  return(NGramTokenizer(text, Weka_control(min=1,max=1,delimiters=delimiter)))
}
    