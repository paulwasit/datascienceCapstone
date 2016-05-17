
createSampleUnigrams <- function (lang, sampleSize, minOccurences=10) {
  
  print("---------- Create Sample Unigrams ----------")
  ptm <- proc.time()
  
  # sampling - fullSample.txt
  source('./helpers/sampleUnigramsCreator/sampler.R')
  createSample(lang, c("blogs","news","twitter"), sampleSize)

  # sentence tokenization - .sent.txt (15sec/10k lines)
  source('./helpers/sampleUnigramsCreator/sentTokenizer.R')
  tokenizeSent(paste0("./data/",lang,".fullSample",sampleSize,".txt"))

  # first tokenization (40sec/1M lines)
  source('./helpers/sampleUnigramsCreator/tokenizer.R') # custom split: remove ', add =<>~*&_/\
  G1_list <- tokenize(paste0("./data/",lang,".fullSample",sampleSize,".sent.txt"), 1, TRUE)
  G1_list <- data.frame('ngram'=G1_list)
  saveRDS(G1_list,paste0("./data/",lang,".fullSample",sampleSize,".G1raw.Rds"))

  # remove non words & duplicates
  source('./helpers/sampleUnigramsCreator/unigramCleaner.R')
  G1_list <- cleanUnigrams(G1_list)

  # remove rare unigrams
  source('./helpers/sampleUnigramsCreator/unigramFilter.R')
  G1_list <- filterUnigrams(G1_list, minOccurences)

  saveRDS(G1_list,paste0("./data/",lang,".fullSample",sampleSize,".G1clean.Rds"))
  
  ptm <- proc.time() - ptm
  print("----------")
  print(paste("sampling done-", round(ptm[3],2)))
  
}