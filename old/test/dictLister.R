

# our dict list function
createDictList <- function (dict) {

  dictList <- list() 
  az <- "abcdefghijklmnopqrstuvwxyz"

  for (i in 1:26) {
    letter <- substr(az,i,i)
    grepPattern <- paste0("^", letter) #matches all words starting with the letter
    letterWords <- dict[grepl(grepPattern, dict)]
    dictList[[letter]] <- letterWords
  }
  
  return (dictList)
  
}

# our getUnknownWords function
getUnknownWords <- function (wordList, dictList, isUnknownDict=FALSE) {
  
  unknownWords <- sapply(wordList, function(x) {
    #if (is.na(x)) {
    #  print(x)
    #  return(TRUE)
    #}
    if (x=="eol#") {
      return(FALSE)
    }
    letter <- substr(x, 1, 1)   # get first letter of x
    if (grepl("[^a-z]",letter) == TRUE) {
      return(TRUE)
    }
    
    else if (isUnknownDict == TRUE) {
      return(any(dictList[[letter]]==x)) # check if x is in the sub-dict
    }
    else {
      return(!any(dictList[[letter]]==x)) # check if x is in the sub-dict
    }
  })
  
  return (unknownWords)
  
}                              