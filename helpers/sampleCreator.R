
createSample <- function (lang, sampleSize) {
  
  print("---------- Create Sample ----------")
  ptm <- proc.time()
  
  # sampling - fullSample.txt
  source('./helpers/sampleUnigramsCreator/sampler.R')
  createRawSample(lang, c("blogs","news","twitter"), sampleSize)

  # sentence tokenization - .sent.txt (15sec/10k lines)
  source('./helpers/sampleUnigramsCreator/sentTokenizer.R')
  tokenizeSent(paste0("./data/",lang,".fullSample",sampleSize,".txt"))

}

ptm <- proc.time() - ptm
print("----------")
print(paste("sampling done-", round(ptm[3],2)))
  
}