
setwd('D:\\datascienceCapstone')
library(dplyr)
library(ffbase)

lang <- "en_US"
sampleSize <- 10
minOccurences <- 10

G1_list <- readRDS(paste0("./data/",lang,".fullSample",sampleSize,".G1clean.Rds"))
str(G1_list)

G1 <- as.ffdf(G1_list)
G3 <- as.ffdf(G3_freq)
str(G1)

?as.ffdf

ptm <- proc.time()
test <- table.ff(G1$ngram)
print( proc.time() - ptm)

ptm <- proc.time()
test2 <- table(G1_list$ngram)
print( proc.time() - ptm)

ptm <- proc.time()
testA <- G1[G1$ngram %in% ff(factor(c("the"))),]
print( proc.time() - ptm)

ptm <- proc.time()
testB <- G1_list[G1_list$ngram == "the",,drop=FALSE]
print( proc.time() - ptm)


ptm <- proc.time()
filt <- !(G3$c2 %in% ff(factor(c("eol#"))))
testC <- G3[filt,]
print( proc.time() - ptm)

ptm <- proc.time()
filt <- G3_freq$c2 != 'eol#'
testD <- filter(G3_freq,filt)
print(proc.time() - ptm)

ptm <- proc.time()
filt <- G3_freq$c2 != 'eol#'
testE <- G3_freq[filt==TRUE,]
print(proc.time() - ptm)
