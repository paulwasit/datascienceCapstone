

wordCheck <- function (nGramList) {
  
  print("removing non words")
  nGramIndex <- createIndex(nGramList)
  good <- nGramIndex %>% filter(grepl("[a-z0-9]",word))
  nGramList <- nGramList[unlist(good[,2])]
  
  print("identifying years")
  nGramIndex <- createIndex(nGramList)
  years <- nGramIndex %>% filter(grepl("^(19|20)[0-9]{2}$",word))
  nGramList[unlist(years[,2])] <- "<year>"
  
  print("identifying numbers")
  nGramIndex <- createIndex(nGramList)
  numbers <- nGramIndex %>% filter(grepl("^[0-9]+$",word))
  nGramList[unlist(numbers[,2])] <- "<number>"
  
  print("identifying unknown words")
  library(qdap)
  dict <- qdapDictionaries::GradyAugmented
  dict <- c(dict, 
            "<year>", "<number>", "eol#", "blog", "here's", 
            "online", "email", "emails", "internet", "london", "blogs",
            "facebook", "obama", "favourite", "blogging", "europe", "chicago", "england", "blogger", "bloggers",
            "boyfriend", "girlfriend", "awareness", "los", "angeles", "usa", "santa")
  
  test <- filter(nGramIndex, !(word %in% dict))
  test <- unlist(test[,2])
  
  unkFreq <- data.frame(table(nGramList[test]))
  unkFreq <- arrange(unkFreq, desc(Freq))
  
  nGramList[test] <- "<unk>"
  return (list(nGramList, unkFreq))
  
}

createIndex <- function (nGramList) {
  df <- data.frame("word"=nGramList)
  df$pos <- as.numeric(row(df))
  nGramIndex <- group_by(df,word) %>% summarize(pos=list(pos))
  return(nGramIndex)
}

