
filterUnigrams <- function (nGramList, minOccurences) {
  
  print ("----- Remove Rare Unigrams -----")
  
  ptm <- proc.time()
  
  print("building frequency table")
  nGramFreq <- data.frame(table(nGramList))
  names(nGramFreq) <- c('ngram','freq')
  nGramFreq <- arrange(nGramFreq, desc(freq))
  
  print("identifying rare occurences")
  unkNgrams <- nGramFreq %>% filter(freq <= minOccurences)
  unkNgrams <- data.frame(unkNgrams[,1])
  
  print("building position index")
  nGramIndex <- createIndex(nGramList)
  
  print("removing rare occurences")
  unk <- nGramIndex %>% filter(ngram %in% unkNgrams[,1])
  nGramList[unlist(unk[,2]), 1] <- "<unk>"
  
  ptm <- proc.time() - ptm
  print (paste("total-",round(ptm[3],2)))
  
  return (nGramList)

}

createIndex <- function (nGramList) {
  df <- select(nGramList,ngram)
  df$pos <- as.numeric(row(df))
  nGramIndex <- group_by(df,ngram) %>% summarize(pos=list(pos))
  return(nGramIndex)
}

