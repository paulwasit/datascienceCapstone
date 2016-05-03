
# we load the required library & functions
library(RWeka)

# our tokenize function
tokenize <- function (conPath, ngram, keepEOL=FALSE) {
  
  fullText <- character(length = 0)
  i <- 0
  
  con <- file(conPath, "rb")
  while(TRUE) {
    
    # prepare chunk for tokenization
    chunk <- tolower(readLines(con, 10000))
    if ( length(chunk) == 0 ) break
    if ( keepEOL==TRUE ) {
      chunk <- paste(chunk,"eol#") #this will be used to keep the line breaks after cleaning unknown words
    }
    token <- NGramTokenizer(
      chunk, 
      Weka_control(
        min=ngram,
        max=ngram, 
        delimiters=' /\t\r\n=~*&_.,;:"()?!'
      )
    )
    fullText <- c(fullText, token)
    i <- i+1
    print(i)
    
  }
  close(con)
  
  return(fullText)

}