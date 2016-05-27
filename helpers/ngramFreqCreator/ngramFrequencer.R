
getFrequencies <- function (previousFull,G1_list,ngram=2,minOccurences=10) {
  
  #-----
  print("----- building ngram list -----")
  ptm1 <- proc.time()
  print("build list");ptm<-proc.time()
  #-----
  
  previousFreq <- previousFull[["ngramFreq"]] %>% select(-score)
  previousList <- previousFull[["previousList"]]
  
  uniGramListFilter <- G1_list[,1] != "<unk>"
  nGramListFilter <- G1_list[,1] != "eol#" & G1_list[,1] != "<unk>"
  
  # logical vector; TRUE for ngrams where (n-1)grams are ok & new words are neither eol# nor <unk>
  # note: ok to start with #eol (to handle beg of sent)
  if (ngram==2) {
    nGramListFilter <- uniGramListFilter[-nrow(previousList)] & nGramListFilter[-(1:(ngram-1))]
  }
  else {
    previousListFilter <- previousFull[["previousListFilter"]]
    nGramListFilter <- previousListFilter[-nrow(previousList)] & nGramListFilter[-(1:(ngram-1))]
  }
  
  # drop first/last items (prepare to combine)
  previousList <- previousList[-nrow(previousList),,drop=FALSE]
  G1_list <- G1_list[-(1:(ngram-1)),,drop=FALSE]
  
  # combine previous & new
  nGramList <- bind_cols(previousList,G1_list)
  nGramList$pos <- as.numeric(row(nGramList[,1]))
  names(nGramList) <- c("c1","c2","pos")
  
  #-----
  print(paste(">", round((proc.time() - ptm)[3],2)))
  print("get ngram freq");ptm<-proc.time()
  #-----
  
  # get freq & positions
  nGramListFreq <- nGramList %>% filter (nGramListFilter) %>% 
                   group_by(c1,c2) %>% summarize(freq=n(),pos=list(pos))
  
  nGramListFreqGood <- nGramListFreq %>% filter (freq > minOccurences)
  
  # identify position of ok ngrams
  nGramListGoodIndex <- as.numeric(unlist(nGramListFreqGood$pos))
  nGramListFilter <- rep(FALSE,length(nGramListFilter))
  nGramListFilter[nGramListGoodIndex] <- TRUE
  
  # cleanup freq table
  nGramListFreqGood <- data.frame(nGramListFreqGood %>% select(-pos)) %>% arrange(desc(freq))
  nGramListFreqGood <- droplevels(nGramListFreqGood)
  
  #-----
  print(paste(">", round((proc.time() - ptm)[3],2)))
  print("build aggregated table");ptm<-proc.time()
  #-----
  
  # combine previous & new for next level ngrams
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
  print("add (n-1)gram freq & calculate score");ptm<-proc.time()
  #-----
  
  # prep (n-1)gram freq list
  if (ngram > 2) {
    previousFreq$ngram <- paste(previousFreq$c1,previousFreq$c2)
    previousFreq <- select(previousFreq,ngram,freq)
  }
  names(previousFreq) <- c("c1","freq1")
  
  # merge ngram & (n-1)gram freq lists
  nGramListFreqGood <- nGramListFreqGood %>% left_join(previousFreq)
  
  # add score
  nGramListFreqGood$score <- round(log(nGramListFreqGood$freq) - log(nGramListFreqGood$freq1),4)
  
  #-----
  print(paste(">", round((proc.time() - ptm)[3],2)))
  print(paste("==>", round((proc.time() - ptm1)[3],2)))
  #-----
  
  return(list("ngramFreq"=nGramListFreqGood,"previousList"=nGramAggregate,"previousListFilter"=nGramListFilter))
  
}
