
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
  conLines <- length(readLines(con))
  conLines2 <- round(conLines/10000,0)+1
  close(con)
  con <- file(conPath, "rb")
  pb <- txtProgressBar(min = 0, max = conLines2, style = 3)
  
  #while(TRUE) {
  for (i in 1:conLines2) {
    # prepare chunk for tokenization
    chunkSize <- if (i==conLines2) conLines-10000*(i-1) else 10000
    
    chunk <- tolower(readLines(con, chunkSize))
    setTxtProgressBar(pb, i)
    
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
    #print (paste(i,"-",round(ptm1[3],2)))
    ptm1 <- proc.time()
    
  }
  close(con)
  close(pb)
  
  ptm <- proc.time() - ptm
  print (paste("total-",round(ptm[3],2)))
  
  return(fullText)

}