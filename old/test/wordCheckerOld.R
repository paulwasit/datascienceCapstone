


wordCheckOld <- function (nGramList) {
  
  print('----- Check words -----')
  
  ptm <- proc.time()
  
  print("removing non words")
  nGramIndex <- createIndex(nGramList)
  good <- nGramIndex %>% filter(grepl("[a-z0-9]",word))
  good <- sort(unlist(good[,2]))
  nGramList <- nGramList[good]

  print("identifying years")
  nGramIndex <- createIndex(nGramList)
  years <- nGramIndex %>% filter(grepl("^(19|20)[0-9]{2}$",word))
  nGramList[unlist(years[,2])] <- "<year>"
  
  print("identifying numbers")
  nGramIndex <- createIndex(nGramList)
  numbers <- nGramIndex %>% filter(grepl("^[0-9]+$",word))
  nGramList[unlist(numbers[,2])] <- "<number>"

  print("identifying unknown words")
  nGramIndex <- createIndex(nGramList)
  
  library(qdap)
  dict <- qdapDictionaries::GradyAugmented
  dict <- c(dict, 
            "<year>", "<number>", "eol#", "blog", "here's", 
            "online", "email", "emails", "internet", "london", "blogs",
            "facebook", "obama", "favourite", "blogging", "europe", "chicago", "england", "blogger", "bloggers",
            "boyfriend", "girlfriend", "awareness", "los", "angeles", "usa", "santa")
  ?qdapDictionaries
  test <- filter(nGramIndex, !(word %in% dict))
  test <- unlist(test[,2])
    
  unkFreq <- data.frame(table(nGramList[test]))
  unkFreq <- arrange(unkFreq, desc(Freq))
  
  nGramList[test] <- "<unk>"
  
  ptm <- proc.time() - ptm
  print (paste("total-",round(ptm[3],2)))
  
  return (list(nGramList, unkFreq))
  #return(list(nGramList, c("unk")))
}

createIndex <- function (nGramList) {
  df <- data.frame("word"=nGramList)
  df$pos <- as.numeric(row(df))
  nGramIndex <- group_by(df,word) %>% summarize(pos=list(pos))
  return(nGramIndex)
}

