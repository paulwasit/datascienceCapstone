
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
nGramName <- paste0("../nGramFreq/",lang,".",sampleSize,".freq.")
setwd('D:\\datascienceCapstone\\nGramPerf')

source("../shinyapp/stupidBackoff/stupidBackoffCalc.R")

# load test sample
conPath <- "./data/en_US.10.test.0.02.sent.clean.txt"
con <- file(conPath, "rb")
chunk <- tolower(readLines(con))
close(con)
rm(conPath,con)

# perf functions
cleanChunk <- function(sent) {
  sent <- tokenize(sent,'[^a-zA-Z0-9\' ]')
  iSent <- 0
  result <- list() 
  for (currentSent in sent) {
    iSent <- iSent + 1
    ngram <- tokenize(currentSent,' ')
    result[[iSent]] <- ngram
  }
  return(result)
}
checkSent <- function (sent,freqValue) {
  
  print(paste0(nGramName,freqValue,".Rds"))
  nGramFreq <- readRDS(paste0(nGramName,freqValue,".Rds"))
  nGramFreq[["1"]] <- nGramFreq[["1"]][-2,] # remove <unk> freq
  
  ptm <- proc.time()
  
  kpi <- data.frame(
    "alphaCount"=0,
    "keypressCount"=0,
    "words"=0,
    "words0"=0,
    "words1"=0,
    "words2"=0,
    "words3p"=0,
    "words100"=0,
    "elapsed"=0
  )
  
  # setup progress bar
  sentLen <- length(sent)
  iSent <- 0
  pb <- txtProgressBar(min = 0, max = sentLen, style = 3)
  
  for (iSent in 1:sentLen) {

    setTxtProgressBar(pb, iSent)
    
    ngram <- sent[[iSent]]
    kpi$alphaCount <- kpi$alphaCount + sum(nchar(ngram))
    
    if (sum(nchar(ngram))>0) {
      
      kpi$words <- kpi$words+length(ngram)
      
      for (i in 1:length(ngram)) {
        if (ngram[i]=="unk") {
          kpi$words <- kpi$words - 1
          kpi$alphaCount <- kpi$alphaCount - 3
        }
        else{
          keypressTmp <- 0
          previousWords <- if (i==1) "eol#" else ngram[max(i-3,1):(i-1)]
          currentWord <- character(0)
          suggestedWords <- getNextWords (nGramFreq, previousWords, currentWord) 
          
          while (!(tolower(ngram[i]) %in% suggestedWords) && keypressTmp<nchar(ngram[i])) {
            keypressTmp <- keypressTmp + 1
            currentWord <- substr(ngram[i],1,keypressTmp)
            suggestedWords <- getNextWords (nGramFreq, previousWords, currentWord) 
          }
          
          kpi$keypressCount <- kpi$keypressCount + keypressTmp
          if (keypressTmp==0) {
            kpi$words0 <- kpi$words0+1
          }
          else if (keypressTmp==1) {
            kpi$words1 <- kpi$words1+1
          }
          else if (keypressTmp==2) {
            kpi$words2 <- kpi$words2+1
          }
          else {
            kpi$words3p <- kpi$words3p+1
            if (keypressTmp==nchar(ngram[i])) kpi$words100 <- kpi$words100+1
          }
        }
      }
    }
  }
  
  close(pb)
  ptm <- proc.time()-ptm
  kpi$elapsed <- round(ptm[3],2)
  return(kpi)
  
}
tokenize <- function (text, delimiter) {
  return(NGramTokenizer(text, Weka_control(min=1,max=1,delimiters=delimiter)))
}

# run test
sent <- cleanChunk(chunk[1:100])
checkSent(sent,"10")

tail(nGramFreq[["1"]])
