library(NLP)
library(openNLP)
sent_token_annotator <- Maxent_Sent_Token_Annotator()

tokenizeSent <- function (src) {
  
  print("----- Tokenize sentences -----")
  
  fullText <- character(length = 0)
  i <- 0
  
  ptm <- proc.time()
  ptm1 <- proc.time()
  con <- file(src, "rb")
  while(TRUE) {
    
    # prepare chunk for tokenization
    chunk <- tolower(readLines(con, encoding = "ISO-8859-1", n=1000))
    if ( length(chunk) == 0 ) break
    chunk <- as.String(chunk)
    
    # annotate
    a1 <- annotate(chunk, sent_token_annotator)
    chunk <- chunk[a1]
    
    # split chunk's sentences
    token <- gsub("(\\.){3}",".\n",chunk)
    
    # append split chunk to full text
    fullText <- c(fullText, token)
    
    # display progress
    i <- i+1
    if (i %% 10 == 0) {
      ptm1 <- proc.time() - ptm1
      print (paste(i,"-",round(ptm1[3],2)))
      ptm1 <- proc.time()
    }
    
  }
  close(con)
  
  dest <- gsub(".txt$",".sent.txt", src)
  write(fullText, dest, sep = "\t")
  
  ptm <- proc.time() - ptm
  print (paste("total-",round(ptm[3],2)))
  
}
