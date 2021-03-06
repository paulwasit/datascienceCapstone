
getNgramFrequencies <- function (G1_list,minOccurrences=10) {
  
  #-----
  print("---------- full ngram frequencies list ----------")
  ptm1 <- proc.time()
  #-----
  
  source('./helpers/ngramFreqCreator/ngramFrequencer.R')
  
  G1_freq <- G1_list %>% 
             group_by(c2) %>% summarize(freq = n()) %>% arrange(desc(freq)) %>%
             transform(c2 = as.character(c2))
  
  names(G1_freq)
  G1_freq$score <- round(log(G1_freq$freq) - log(nrow(G1_list)),4)
  
  G1_full <- list("ngramFreq"=G1_freq,"previousList"=G1_list)
  
  G2_full <- getFrequencies(G1_full,G1_list,ngram=2,minOccurrences)
  G3_full <- getFrequencies(G2_full,G1_list,ngram=3,minOccurrences)
  G4_full <- getFrequencies(G3_full,G1_list,ngram=4,minOccurrences)
  
  G2_freq <- G2_full[["ngramFreq"]]
  G3_freq <- G3_full[["ngramFreq"]]
  G4_freq <- G4_full[["ngramFreq"]]

  # drop eol# & <unk> freqs
  G1_freq <- G1_freq %>% filter(!c2 %in% c('eol#','<unk>'))
    
  nGramFreq <- list("1"=G1_freq, "2"=G2_freq,"3"=G3_freq,"4"=G4_freq)
  
  #-----
  print(paste("=====>", round((proc.time() - ptm1)[3],2)))
  #-----
  
  return(nGramFreq)
  
}
