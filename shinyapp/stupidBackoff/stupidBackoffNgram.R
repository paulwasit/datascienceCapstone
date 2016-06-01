
# we load the required library & functions
library(RWeka)

# prepare chunk for tokenization
getSplitText <- function(text,cursorPos) {
  
  #Split Text List
  STL <- getSTL(text,cursorPos)
  
  # identify current word if last char before cursor is not a space (ie. a letter or a number)
  if (grepl("[a-zA-Z0-9\']$", STL$lastChar)) {
    c <- regexpr("^[a-zA-Z0-9\']+",STL$afterPos)
    if (c[1] != -1) {
      cursorPos <- cursorPos + attr(c,"match.length") # the substring starts at the first char so end pos=length
      STL <- getSTL(text,cursorPos)
    }
  }
  
  # we can now get the last words before the cursor
  sent <- tokenize(STL$beforePos,'[^a-zA-Z0-9\' ]')
  currentSent <- sent[length(sent)]
  ngram <- tokenize(currentSent,' ')
  len <- length(ngram)

  # if no words for the sentence yet
  if (len == 0 || !grepl("^[a-zA-Z0-9\' ]$", STL$lastChar)) {
    c1 <- "eol#"
    c2 <- character(0)
  }
  # otherwise, 
  else {
    
    # if no word is currently being typed
    if (STL$lastChar == ' ') {
      c2 <- character(0)
    }
    # otherwise
    else {
      c2 <- ngram[len]
      cursorPos <- cursorPos - nchar(c2)
      STL$beforePos <- substr(STL$beforePos,1,STL$lenText-nchar(c2)) # keep everything but the word being typed
      ngram <- ngram[-len]; len <- length(ngram)
    }
      
    # we only keep ngrams up to 4, so c1 length is 3 max 
    if (len <= 3) c1 <- ngram
    else c1 <- ngram[(len-2):len]
  
  }
  
  return(splitTextList(c1,c2,STL$beforePos,STL$afterPos,cursorPos))

}

tokenize <- function (text, delimiter) {
  return(NGramTokenizer(text, Weka_control(min=1,max=1,delimiters=delimiter)))
}

getSTL <- function (text,cursorPos) {
  beforePos <- substr(text,1,cursorPos)
  afterPos <- substr(text,cursorPos+1,nchar(text))
  lenText <- nchar(beforePos)
  lastChar <- substr(beforePos,lenText,lenText)
  return(
    list(
      "beforePos"=beforePos,
      "afterPos"=afterPos,
      "lenText"=lenText,
      "lastChar"=lastChar
    )
  )
}


splitTextList <- function (previousWords, currentWord, previousText, nextText,cursorPos) {
  return (
    list(
      "previousWords"=previousWords,
      "currentWord"=currentWord,
      "previousText"=previousText,
      "nextText"=nextText,
      "cursorPos"=cursorPos
    )
  )
}
    