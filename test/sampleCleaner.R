

sampleCleaner <- function (lang, type, size) {
    
  # sampling - 15 sec
  print("----- Sample creation -----")
  ptm <- proc.time()
  source('./helpers/sampler.R')
  src <- paste0('./data/', lang, '/', lang, '.', type, '.txt')
  dest <- paste0('./data/', lang, '.', type, '.sample', size, '.txt') 
  sample(src, dest, size)
  ptm <- proc.time() - ptm
  print(ptm[["elapsed"]])
  
  # create unigrams list
  print("----- Unigrams extraction -----")
  ptm <- proc.time()
  source('./helpers/tokenizer.R') # custom split: remove ', add =~*&_/\ plus numbers
  G1_list <- tokenize(dest, 1, keepEOL=TRUE)
  ptm <- proc.time() - ptm
  print(ptm[["elapsed"]])
  
  # clean non-words, years & numbers
  print("----- Clean unigrams -----")
  ptm <- proc.time()
  source('./helpers/wordChecker.R')
  wordChecked <- wordCheck(G1_list)
  G1_list <- wordChecked[[1]]
  ptm <- proc.time() - ptm
  print(ptm[["elapsed"]])
  
}
