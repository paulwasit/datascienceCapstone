
getFrequencies <- function (previousList,previousListFilter,G1_list,ngram=2,minOccurences=10) {
  
  #-----
  print("----- building ngram list -----")
  ptm1 <- proc.time()
  print("build filter");ptm<-proc.time()
  #-----
  
  nGramListFilter <- G1_list[,1] != "eol#" & G1_list[,1] != "<unk>"
  
  if (ngram==2) {
    nGramListFilter <- nGramListFilter[-nrow(previousList)] & nGramListFilter[-(1:(ngram-1))]
  }
  else {
    nGramListFilter <- previousListFilter[-nrow(previousList)] & nGramListFilter[-(1:(ngram-1))]
  }
  
  #-----
  print(paste(">", round((proc.time() - ptm)[3],2)))
  print("group unigram columns");ptm<-proc.time()
  #-----
  
  previousList <- previousList[-nrow(previousList),,drop=FALSE]
  G1_list <- G1_list[-(1:(ngram-1)),,drop=FALSE]
  
  nGramList <- bind_cols(previousList,G1_list)
  nGramList$pos <- as.numeric(row(nGramList[,1]))
  names(nGramList) <- c("c1","c2","pos")
  
  #-----
  print(paste(">", round((proc.time() - ptm)[3],2)))
  print("get ngram freq");ptm<-proc.time()
  #-----
  
  #nGramList <- nGramList %>% filter (nGramListFilter)
  nGramListFreq <- nGramList %>% filter (nGramListFilter) %>% 
                   group_by(c1,c2) %>% summarize(freq=n(),pos=list(pos))
  
  nGramListFreqGood <- nGramListFreq %>% filter (freq > minOccurences)
  
  nGramListGoodIndex <- as.numeric(unlist(nGramListFreqGood$pos))
  nGramListFilter <- rep(FALSE,length(nGramListFilter))
  nGramListFilter[nGramListGoodIndex] <- TRUE

  nGramListFreqGood <- data.frame(nGramListFreqGood %>% select(-pos)) %>% arrange(desc(freq))
  
  #-----
  print(paste(">", round((proc.time() - ptm)[3],2)))
  print("build aggregated table");ptm<-proc.time()
  #-----
  
  nGramAggregate <- data.frame("c1"=rep("<unk>",length(nGramListFilter)),stringsAsFactors = FALSE)
  c1 <- nGramList[nGramListGoodIndex,1]
  c2 <- nGramList[nGramListGoodIndex,2]
  c3 <- bind_cols(c1,c2)
  c3$newCol <- do.call(paste,c3)
  c3 <- c3[,3]
  nGramAggregate[nGramListGoodIndex,1] <- c3
  nGramAggregate[,1] <- as.factor(nGramAggregate[,1])
  
  #-----
  print(paste(">", round((proc.time() - ptm)[3],2)))
  print(paste("==>", round((proc.time() - ptm1)[3],2)))
  #-----
  
  return(list("ngramFreq"=nGramListFreqGood,"previousList"=nGramAggregate,"previousListFilter"=nGramListFilter))
  
}
