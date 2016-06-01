
filterUnigrams <- function (nGramList, minOccurrences) {
  
  print ("----- Remove Rare Unigrams -----")
  
  ptm <- proc.time()
  
  print("building frequency table")
  nGramFreq <- data.frame(table(nGramList))
  names(nGramFreq) <- c('c2','freq')
  nGramFreq <- arrange(nGramFreq, desc(freq))
  
  print("identifying rare occurences")
  unkNgrams <- nGramFreq %>% filter(freq <= minOccurrences)
  unkNgrams <- data.frame(unkNgrams[,1])
  
  print("building position index")
  nGramIndex <- createIndex(nGramList)
  
  print("removing rare occurences")
  unk <- nGramIndex %>% filter(c2 %in% unkNgrams[,1])
  nGramList[unlist(unk[,2]), 1] <- "<unk>"
  
  ptm <- proc.time() - ptm
  print (paste("total-",round(ptm[3],2)))
  
  return (nGramList)

}

createIndex <- function (nGramList) {
  df <- select(nGramList,c2)
  df$pos <- as.numeric(row(df))
  nGramIndex <- group_by(df,c2) %>% summarize(pos=list(pos))
  return(nGramIndex)
}

