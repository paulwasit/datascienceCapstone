
createRawSample <- function (lang, types, sampleSize) {

  print("----- Build sample -----")
  
  ptm <- proc.time()
  
  exportText <- character(0)
  
  for (type in types) {
    
    print(paste("---",type,"---"))
    
    src <- paste0('../rawData/', lang, '/', lang, '.', type, '.txt')
    
    # readLines - 9.5sec
    print("read src")
    f <- file(src, "rb")
    fullText <- readLines(f, encoding = "ISO-8859-1")
    close(f)
    
    print("randomize src")
    set.seed(23)
    fullText <- base::sample(fullText)
    
    print("select sample lines")
    set.seed(23)
    inSample <- rbinom(n=length(fullText),size=1,prob=as.numeric(sampleSize)/100)
    sampleText <- fullText[inSample==1] 
    
    print("convert UTF-8 characters")
    sampleText <- gsub("\u00E2\u20AC\u00A6", '...', sampleText)
    sampleText <- gsub("\u00E2\u20AC\u02DC", "'", sampleText)
    sampleText <- gsub("\u00E2\u20AC\u2122", "'", sampleText)
    sampleText <- gsub("\u00E2\u20AC\u201C", '-', sampleText)
    sampleText <- gsub("\u00E2\u20AC\u201D", '-', sampleText)
    sampleText <- gsub("\u00E2\u20AC\u0153", '"', sampleText)
    sampleText <- gsub("\u00E2\u20AC\u009d", '"', sampleText)
  
    exportText <- c(exportText,sampleText)
      
  }

  print("save sample file")
  dest <- paste0('./data/', lang, '.', sampleSize, '.txt') 
  write(exportText, dest, sep = "\t")
  
  ptm <- proc.time() - ptm
  print (paste("total-",round(ptm[3],2)))
  
}
