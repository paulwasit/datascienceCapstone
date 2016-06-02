
createSample <- function (lang="en_US", sampleSize="10", testSize="0") {
  
  print("---------- Create Sample ----------")
  ptm <- proc.time()
  
  # sampling - fullSample.txt
  source('./helpers/sampleCreator/sampler.R')
  createRawSample(lang, c("blogs","news","twitter"), sampleSize, testSize)

  # sentence tokenization - .sent.txt (15sec/10k lines)
  source('./helpers/sampleCreator/sentTokenizer.R')
  if (as.numeric(testSize)>0) {
    tokenizeSent(paste0('./data/', lang, '.test.', testSize, '.txt'))
  }
  else {
    tokenizeSent(paste0("./data/",lang,".",sampleSize,".txt"))
  }

  ptm <- proc.time() - ptm
  print("----------")
  print(paste("sampling done-", round(ptm[3],2)))
  
}