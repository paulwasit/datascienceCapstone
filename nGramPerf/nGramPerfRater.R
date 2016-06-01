
# read sentence
# tokenize sentence (letters/numbers) then words
# for each word:
# get previous words
# get most likely words for current=0
# while FALSE, add a letter to current & count

# params
lang <- "en_US"
sampleSize <- "10"
minOccurrences <- "10"

source("../shinyapp/stupidBackoff/stupidBackoffCalc.R")

# load DB
nGramFreq <- readRDS(paste0("../nGramFreq/",lang,".",sampleSize,".freq.",minOccurrences,".Rds"))
nGramFreq[["1"]] <- nGramFreq[["1"]][-2,] # remove <unk> freq

checkSent <- function (sent) {
  ptm <- proc.time()
  keypressCount <- 0
  alphaCount <- 0
  
  sent <- tokenize(sent,'[^a-zA-Z0-9\' ]')
  for (currentSent in sent) {
    ngram <- tokenize(currentSent,' ')
    alphaCount <- alphaCount + sum(nchar(ngram))
    for (i in 1:length(ngram)) {
      keypressTmp <- 0
      previousWords <- if (i==1) "eol#" else ngram[max(i-3,1):(i-1)]
      currentWord <- character(0)
      suggestedWords <- getNextWords (nGramFreq, previousWords, currentWord) 
      while (!(tolower(ngram[i]) %in% suggestedWords) && keypressTmp<nchar(ngram[i])) {
        keypressTmp <- keypressTmp + 1
        currentWord <- substr(ngram[i],1,keypressTmp)
        suggestedWords <- getNextWords (nGramFreq, previousWords, currentWord) 
      }
      keypressCount <- keypressCount + keypressTmp
    }
  }
  print(proc.time()-ptm)
  return(list("alpha"=alphaCount,"keypress"=keypressCount))
  
}

tokenize <- function (text, delimiter) {
  return(NGramTokenizer(text, Weka_control(min=1,max=1,delimiters=delimiter)))
}

# load sentence
sent <- c("I want to know what love is")
checkSent(sent)

