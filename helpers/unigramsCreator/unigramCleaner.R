
cleanUnigrams <- function (nGramList) {
  
  print ("----- Clean Unigrams -----")
  
  levels(nGramList$c2) <- c(levels(nGramList$c2), '<unk>')
  
  ptm <- proc.time()
  
  print("removing non words")
  nGramIndex <- createIndex(nGramList)
  unk <- nGramIndex %>% filter(grepl("^[^a-z0-9]+$",c2))
  nGramList[unlist(unk[,2]), 1] <- "<unk>"
  
  print ("removing duplicates")
  n1 <- filter(nGramList, between(row_number(), 1, n()-1))
  n2 <- filter(nGramList, between(row_number(), 2, n()))
  duplicateIndex <- c(FALSE,n1 == n2)
  nGramList <- filter(nGramList, duplicateIndex == FALSE)
  
  ptm <- proc.time() - ptm
  print (paste("total-",round(ptm[3],2)))
  
  return (nGramList)

}

createIndex <- function (nGramList) {
  df <- nGramList
  df$pos <- as.numeric(row(df))
  nGramIndex <- group_by(df,c2) %>% summarize(pos=list(pos))
  return(nGramIndex)
}

