
source("../helpers/stupidBackoff/stupidBackoffNgram.R")
source("../helpers/stupidBackoff/stupidBackoffCalc.R")

getSuggestedWords <- function (ngramFreq,inputText) {
  
  if (is.null(inputText)) {
    c1 <- "eol#"
    c2 <- character(0)
    current <- ""
  }
  else {
    currentNgram <- getCurrentNgram(inputText)
    c1 <- currentNgram[["c1"]]
    c2 <- currentNgram[["c2"]]
    current <- currentNgram[["current"]]
  }

  suggestedWordsDF <- stupidBackoffCalc(ngramFreq, c1, c2)
  return(list("new"=suggestedWordsDF,"current"=current))
  
}
