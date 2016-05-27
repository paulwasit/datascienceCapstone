
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
ngramFreq <- readRDS("../data/en_US.fullSample10.nGramFreq10.Rds")
ngramFreq[["1"]] <- ngramFreq[["1"]][-2,] # remove <unk> freq

# create custom textarea input
textareaInput <- function(id, label=NULL, value="", placeholder="start typing", 
                          rows=20, cols=35, 
                          class="form-control reactiveTextarea"){
  
  tags$div(
    class="form-group shiny-input-container",
    tags$textarea(id=id,class=class,rows=rows,cols=cols,placeholder=placeholder,value))
  
}

# update button labels
updateButtonLabels <- function(i, output, ngram) {
  output[[paste0("my_word",i)]] <- renderUI({actionButton(paste0("word",i), label = ngram$shortList[i])})
  return (output)
}

# get suggested words table
getWordsTable <- function(wordsList) {
  wordsTable <- DT::renderDataTable(
    DT::datatable(
      wordsList, 
      colnames = c("Word","Score","nGram"),
      rownames = FALSE,
      options = list(
        dom='t',
        ordering = FALSE,
        columnDefs = list(
          list(className = 'dt-center', targets = c(1,2))
          ,list(className = 'dt-right', targets = 0)
        )
      )
    )
  )
  return (wordsTable)
}

updateSuggestedWordsList <- function (inputText) {
  
  ptm <- proc.time()
  
  suggestedWords <- getSuggestedWords(ngramFreq,inputText)
  fullList <- suggestedWords[["new"]]
  fullListTable <- getWordsTable(fullList)
  currentText <- suggestedWords[["current"]]
  ptm <- proc.time()-ptm
  print(round(1000*ptm[3],4))
  
  return(list("fullList"=fullListTable,"shortList"=fullList[1:3,1],"currentText"=currentText))
  
}

registerInputHandler("keypressBinding", function(data, ...) {
# data comes from binding.getValue
#  if (is.null(data))
#    NULL
#  else
    data
}, force = TRUE)

# custom col with custom class
customColumn <- function(customClass, ...) {
  div(class = customClass, ...)
}

