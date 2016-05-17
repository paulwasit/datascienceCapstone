
getFrequencies <- function (G1_list,ngram=2,minOccurences=10) {
  
  ptm <- proc.time()
  print("building ngram list")
  
  n <- list()
  for (i in 1:(ngram-1)) {
    k <- ngram - i
    n[[i]] <- filter(G1_list, between(row_number(), i, n()-k))
  }
  t <- as.integer(ngram)
  m <- filter(G1_list, between(row_number(), t, n()))
  
  nGramList <- bind_cols(n)
  nGramList$newCol <- do.call(paste,nGramList)
  nGramList <- nGramList[,ngram]
  nGramList <- bind_cols(nGramList, m)
  names(nGramList) <- c("c1","c2")
  nGramList$c2 <- as.character(nGramList$c2)
  
  #return(nGramList)
  
  print("build raw ngram freq list")
  nGramFreq <- nGramList %>% group_by(c1,c2) %>% summarize (freq=n()) 
  print(proc.time() - ptm)
  return(nGramFreq)
  print("filter freq list - 1")
  nGramFreq <- nGramFreq[nGramFreq$c2 != 'eol#',]
  print("filter freq list - 2")
  nGramFreq <- nGramFreq %>% filter(!grepl("eol#",c1))
  print("freq list pos")
  nGramFreq$pos <- as.numeric(row(nGramFreq[,1]))
  
  print("group rare occurences as unk")
  nGramFreqUnk <- nGramFreq %>% filter(freq <= minOccurences)
  nGramFreqUnk <- nGramFreqUnk$pos
  nGramFreq[nGramFreqUnk, 'c2'] <- "<unk>"
  
  print("rebuild the now complete freq list")
  nGramFreq <- nGramFreq %>% group_by(c1,c2) %>% summarize (freq=sum(freq)) %>% 
               filter(c2!="<unk>") 
  
  print("remove small (n-1) grams & final prepping")
  #nGramFreq <- nGramFreq %>% filter(c1!="eol#")

  # final prepping
  nGramFreq <- data.frame(nGramFreq)
  nGramFreq <- arrange(nGramFreq, desc(freq))
  
  print(proc.time() - ptm)
  return(nGramFreq)
  
}
