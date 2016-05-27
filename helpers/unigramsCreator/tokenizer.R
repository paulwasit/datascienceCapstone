
# we load the required library & functions
library(RWeka)

# our tokenize function
tokenize <- function (conPath, ngram, keepEOL=FALSE) {
  
  print('----- Tokenize ngrams -----')
  
  fullText <- character(length = 0)
  i <- 0
  
  ptm <- proc.time()
  ptm1 <- proc.time()
  
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
    ptm1 <- proc.time() - ptm1
    print (paste(i,"-",round(ptm1[3],2)))
    ptm1 <- proc.time()
    
  }
  close(con)
  
  ptm <- proc.time() - ptm
  print (paste("total-",round(ptm[3],2)))
  
  return(fullText)

}