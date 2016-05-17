library(NLP)
library(openNLP)
sent_token_annotator <- Maxent_Sent_Token_Annotator()

src <- "./data/en_US.fullSample10.txt"

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
  
  # split chunk's sentences
  a1 <- annotate(chunk, sent_token_annotator)
  token <- chunk[a1]
  
  # append split chunk to full text
  fullText <- c(fullText, token)
  
  # display progress
  i <- i+1
  if (i %% 10 == 0) {
    ptm1 <- proc.time() - ptm1
    print (paste(i,"-",ptm1[3]))
  }
  
}
close(con)
ptm <- proc.time() - ptm
ptm[3]

dest <- "./data/en_US.fullSample10.sent.txt"
write(fullText, dest, sep = "\t")
