
createDictList <- function (dict,col) {
  
  dictList <- list() 
  az <- "abcdefghijklmnopqrstuvwxyz"
  pb <- txtProgressBar(min = 0, max = 26, style = 3)
  
  for (i in 1:26) {
    letter <- substr(az,i,i)
    setTxtProgressBar(pb, i)
    grepPattern <- paste0("^", letter) #matches all words starting with the letter
    letterWords <- dict[grepl(grepPattern, dict[,col]),c("c2","score")]
    dictList[[letter]] <- letterWords
  }
  close(pb)
  return (dictList)
 
}

createValueList <- function(src) {
  src$c2 <- as.character(src$c2)
  totalRows <- nrow(src)
  newNgramFreq <- list()
  pb <- txtProgressBar(min = 0, max = totalRows, style = 3)
  for (i in 1:totalRows) {
    setTxtProgressBar(pb, i)
    tmp <- src[i,]
    newNgramFreq[[tmp[1,c("c1")]]] <- data.frame(
      bind_rows(
        newNgramFreq[[tmp[1,c("c1")]]],
        tmp[1,c("c2","score")])
    )
  }
  close(pb)
  return(newNgramFreq)
}