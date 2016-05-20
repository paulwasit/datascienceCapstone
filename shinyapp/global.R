
# stupid backoff
source("../helpers/stupidBackoff.R")

# specify local port
options(shiny.port = 8000)

# prepare tooltips beg & end
ttBgn <- "#!function(geo, data) {
return '<div class=\"hoverinfo\">' +
'<strong>' + data.stateName + '</strong><br>' +"

ttEnd <- "'</div>';}!#"

# load DB
ngramFreq <- readRDS("../data/en_US.fullSample10.nGramFreq.Rds")
ngramFreq[["1"]] <- ngramFreq[["1"]][-2,] # remove <unk> freq

# prepare chunk for tokenization
getCurrentNgram <- function(text) {
  
  print("text")
  
  # split text into sentences
  sent <- NGramTokenizer(
    text, 
    Weka_control(
      min=1,
      max=1, 
      delimiters='/\t\r\n=~*&_.,;:"()?!'
    )
  )
  
  print("currentSent")
  
  # select the last one only
  currentSent <- sent[length(sent)]
  
  print("ngram")
  
  # split the sentence into words
  ngram <- NGramTokenizer(
    currentSent, 
    Weka_control(
      min=1,
      max=1, 
      delimiters=' '
    )
  )
  
  print("bousin")
  
  len <- nchar(text)
  lastChar <- substr(text,len,len)
  len <- length(ngram)
  
  print("if/else")
  
  # if no word is currently being typed, suggest most likely
  if (lastChar == ' ') {
    print("if")
    if (len <= 3) return (list("c1"=ngram,"c2"=character(0)))
    return (list("c1"=ngram[(len-2):len],"c2"=character(0)))
  }
  
  # otherwise, suggest most likely based on the beginning of the word
  else {
    print("else")
    c2 <- ngram[len]
    ngram <- ngram[-len]; len <- length(ngram)
    if (len <= 3) return (list("c1"=ngram,"c2"=c2))
    return (list("c1"=ngram[(len-2):len],"c2"=c2))
  }
  
}

# get list of suggested words
getSuggestedWords <- function (currentNgram) {
  c1 <- currentNgram[["c1"]]
  c2 <- currentNgram[["c2"]]
  suggestedWords <- stupidBackoff(ngramFreq, c1, c2)
  return(suggestedWords)
}
