
createUnigrams <- function (lang, sampleSize, minOccurrences, testSize="0") {
  
  print("---------- Create Unigrams ----------")
  ptm <- proc.time()
  
  srcName <- paste0("./data/",lang,".",sampleSize)
  if (as.numeric(testSize)>0) srcName <- paste0(srcName,".test.",testSize)
  srcName <- paste0(srcName,".sent")
  
  # first tokenization (40sec/1M lines)
  source('./helpers/unigramsCreator/tokenizer.R') # custom split: remove ', add =<>~*&_/\
  G1_list <- tokenize(paste0(srcName,".txt"), 1, TRUE)
  G1_list <- data.frame('c2'=G1_list)
  # saveRDS(G1_list,paste0("./data/",lang,".",sampleSize,".G1.raw.Rds"))

  # remove non words & duplicates
  source('./helpers/unigramsCreator/unigramCleaner.R')
  G1_list <- cleanUnigrams(G1_list)

  # remove rare unigrams when building the freq table
  if (testSize=="0") {
    source('./helpers/unigramsCreator/unigramFilter.R')
    G1_list <- filterUnigrams(G1_list, as.numeric(minOccurrences))
  }
  
  print("----- Concatanate Text -----")
  ptm1 <- proc.time()
  
  G1_text <- G1_list
  levels(G1_text[,1]) <- c(levels(G1_text[,1]), "\n")
  
  G1_eol <- G1_text[,1] == "eol#"
  G1_text[G1_eol==TRUE,1] <- "\n"
  G1_text <- as.character(G1_text[,1])
  G1_text <- paste(G1_text,collapse=" ")
  
  ptm1 <- proc.time()-ptm1
  print (paste("total-",round(ptm1[3],2)))
  
  print("----- Clean Text -----") 
  ptm1 <- proc.time()
  
  G1_text <- gsub(" a m ", " am ", G1_text)
  G1_text <- gsub(" p m ", " pm ", G1_text)
  G1_text <- gsub(" u s a ", " usa ", G1_text)
  G1_text <- gsub(" u s ", " us ", G1_text)
  
  ptm1 <- proc.time()-ptm1
  print (paste("total-",round(ptm1[3],2)))
  
  print("----- Save Clean Text -----")
  ptm1 <- proc.time()
  
  destName <- paste0(srcName,".clean")
  if (testSize=="0") destName <- paste0(destName,".",minOccurrences)
  write(G1_text, paste0(destName,".txt"), sep = "\t")
  
  ptm1 <- proc.time()-ptm1
  print (paste("total-",round(ptm1[3],2)))
  
  # save G1 list
  G1_list <- tokenize(paste0(destName,".txt"), 1, TRUE)
  G1_list <- data.frame('c2'=G1_list)
  
  # saveRDS(G1_list,paste0("./data/",lang,".",sampleSize,".G1.clean.",minOccurrences,".Rds"))
  return(G1_list)
  
  ptm <- proc.time() - ptm
  print("----------")
  print(paste("sampling done-", round(ptm[3],2)))
  
}