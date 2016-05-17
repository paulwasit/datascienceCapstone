

wordCheck <- function (nGramList) {
  
  print('----- Check words -----')
  
  ptm <- proc.time()
  print("removing non words")
  nGramIndex <- createIndex(nGramList)
  unk <- nGramIndex %>% filter(grepl("^[^a-z0-9]",word))
  nGramList[unlist(unk[,2])] <- "<unk>"
  
  print("identifying years")
  nGramIndex <- createIndex(nGramList)
  years <- nGramIndex %>% filter(grepl("^(19|20)[0-9]{2}$",word))
  nGramList[unlist(years[,2])] <- "<year>"
  
  print("identifying numbers")
  nGramIndex <- createIndex(nGramList)
  numbers <- nGramIndex %>% filter(grepl("^[0-9]+$",word))
  nGramList[unlist(numbers[,2])] <- "<number>"

  return (nGramList)
  #return(list(nGramList, c("unk")))
}

createIndex <- function (nGramList) {
  df <- data.frame("word"=nGramList)
  df$pos <- as.numeric(row(df))
  nGramIndex <- group_by(df,word) %>% summarize(pos=list(pos))
  return(nGramIndex)
}

else {
  
  unkNgrams <- nGramFreq %>% filter(freq <= minOccurences)
  unkNgrams <- data.frame(unkNgrams[,1])
  unk <- nGramIndex %>% filter(ngram %in% unkNgrams[,1])
  unk <- unk %>% filter(!grepl('eol#$',ngram))
  nGramList[unlist(unk[,2]), 3] <- "<unk1>"
  nGramList[unlist(unk[,2]), 1] <- paste(nGramList[unlist(unk[,2]), 2],
                                         nGramList[unlist(unk[,2]), 3])
}
