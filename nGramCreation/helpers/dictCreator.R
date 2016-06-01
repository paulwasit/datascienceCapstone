
createDictList <- function (dict,col) {
  
  dictList <- list() 
  az <- "abcdefghijklmnopqrstuvwxyz"

  for (i in 1:26) {
    letter <- substr(az,i,i)
    print(letter)
    grepPattern <- paste0("^", letter) #matches all words starting with the letter
    letterWords <- dict[grepl(grepPattern, dict[,col]),]
    dictList[[letter]] <- letterWords
  }
  
  return (dictList)
 
}