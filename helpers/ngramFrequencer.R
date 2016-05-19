
getFrequencies <- function (G1_list,ngram=2,minOccurences=10) {
  
  ptm2 <- proc.time()
  
  print("----- building ngram list -----")
  ptm1 <- proc.time()
  
  print("aggregate G1_list")
  ptm <- proc.time()
  
  n <- list()
  len <- nrow(G1_list)
  for (i in 1:(ngram-1)) {
    k <- len - ngram + i
    n[[i]] <- G1_list[i:k,,drop=FALSE]
      #filter(G1_list, between(row_number(), i, n()-k))
  }
  m <- G1_list[ngram:len,,drop=FALSE]
  #t <- as.integer(ngram)
  #m <- filter(G1_list, between(row_number(), t, n()))
  
  nGramList <- bind_cols(n)
  nGramList$newCol <- do.call(paste,nGramList)
  nGramList <- nGramList[,ngram]
  nGramList <- bind_cols(nGramList, m)
  names(nGramList) <- c("c1","c2")
  ptm <- proc.time() - ptm
  print(paste("done in", round(ptm[3],2)))
  
  print("ngram list as factors")
  ptm <- proc.time()
  nGramList$c1 <- as.factor(nGramList$c1)
  ptm <- proc.time() - ptm
  print(paste("done in", round(ptm[3],2)))
  
  print("cleaning eol#")
  ptm <- proc.time()
  nGramList <- nGramList %>% 
               filter(c1 != "eol#") %>% 
               filter(c1 != "<unk>") %>% 
               filter(c2 != "eol#") %>% 
               filter(c2 != "<unk>")
  
  ptm <- proc.time() - ptm
  print(paste("done in", round(ptm[3],2)))
  
  ptm1 <- proc.time() - ptm1
  print(paste("=> done in", round(ptm1[3],2)))
  return(nGramList)
  
  

  print("----- filtering n gram list -----")
  ptm1 <- proc.time()
  
  print("grouping")
  ptm <- proc.time()
  
  nGramFreq <- group_by(nGramList,c1,c2) %>% summarize(count=n())
  nGramFreq$pos <- as.numeric(row(nGramFreq[,1]))
  
  ptm <- proc.time() - ptm
  print(paste("done in", round(ptm[3],2)))
  
  print("identifying rare occurences")
  ptm <- proc.time()
  
  nGramFreqBad <- (nGramFreq %>% filter(count <= minOccurences))[,4][[1]]
  nGramFreq[nGramFreqBad, 2] <- "<unk>"
  nGramFreq <- nGramFreq[, -4]
  
  ptm <- proc.time() - ptm
  print(paste("done in", round(ptm[3],2)))
  
  print("consolidating")
  ptm <- proc.time()
  
  nGramFreq <- group_by(nGramFreq,c1,c2) %>% summarize(count=sum(count))
  
  ptm <- proc.time() - ptm
  print(paste("done in", round(ptm[3],2)))
  
  ptm1 <- proc.time() - ptm1
  print(paste("=> done in", round(ptm1[3],2)))
  #return(nGramFreq)
  
  

  print("----- filtering n-1 gram list -----")
  ptm1 <- proc.time()
  
  print("building index of (n-1)-grams")
  ptm <- proc.time()
  
  df <- select(nGramFreq,c1)
  df$pos <- as.numeric(row(df))
  nGramIndex <- group_by(df,c1) %>% summarize(pos=list(pos), count=n())
  
  ptm <- proc.time() - ptm
  print(paste("done in", round(ptm[3],2)))
  
  print("filtering non-rare (n-1)-grams")
  ptm <- proc.time()
  
  nGramGood <- nGramIndex %>% filter(count > minOccurences)
  nGramGoodPos <- unlist(nGramGood$pos)
  nGramFreq <- nGramFreq[nGramGoodPos, ]
  
  ptm <- proc.time() - ptm
  print(paste("done in", round(ptm[3],2)))
  
  print("filtering eol# & <unk> in (n-1)-grams")
  ptm <- proc.time()
  
  nGramFreq <- nGramFreq %>% filter(!grepl("eol#",c1))
  nGramFreq <- nGramFreq %>% filter(!grepl("<unk>",c1))
  
  ptm <- proc.time() - ptm
  print(paste("done in", round(ptm[3],2)))
  
  ptm1 <- proc.time() - ptm1
  print(paste("=> done in", round(ptm1[3],2)))
  
  ptm2 <- proc.time() - ptm2
  print(paste("===> ngram freq built in", round(ptm2[3],2)))
  
  return(nGramFreq)
  
  
  
}
