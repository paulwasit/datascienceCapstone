
# -------------------- SETUP -------------------- #

library(shiny)
library(shinydashboard)
library(V8) # required for extendshinyjs in shinyapps
library(shinyjs) #used to hide some inputs
library(shinyBS) #used for tooltips
source("./stupidBackoff/stupidBackoffCalc.R")
source("./stupidBackoff/stupidBackoffNgram.R")
options(shiny.port = 8000) # specify local port

# load DB
nGramFreq <- readRDS("./data/en_US.10.freq.1000.Rds")
nGramFreq[["1"]] <- nGramFreq[["1"]][-2,] # remove <unk> freq


# -------------------- APP FUNCTiONS -------------------- #

# update button labels
updateButtonLabels <- function(i, output, ngram) {
  output[[paste0("my_word",i)]] <- renderUI({
    actionButton(paste0("word",i), label = ngram[i])
  })
  return (output)
}

# update textArea text on suggested word click
updateTextArea <- function (i,session,input,ngram,ntext) {
  
  # new text before cursor
  newValue <- paste0(ntext$previousText,ngram[i])
  
  #identify if we should add a space after the new word or not
  if (length(ntext$nextText)>0 && substr(ntext$nextText,1,1)==' ') {
    newValue <- paste0(newValue,ntext$nextText)
  }
  else {
    newValue <- paste(newValue,ntext$nextText)
  }
  
  # update text & cursor pos
  session$sendCustomMessage(
    type = "setCursorPos", 
    list(textareaID="inputText", newValue=newValue, cursorPos=ntext$cursorPos+nchar(ngram[i])+1)
  )
  
}


# -------------------- UI -------------------- #

# prepare tooltips beg & end
ttBgn <- "#!function(geo, data) {
return '<div class=\"hoverinfo\">' +
'<strong>' + data.stateName + '</strong><br>' +"

ttEnd <- "'</div>';}!#"

# create custom textarea input
textareaInput <- function(id, label=NULL, value="", placeholder="start typing", 
                          rows=20, cols=35, 
                          class="form-control reactiveTextarea"){
  
  tags$div(
    class="form-group shiny-input-container",
    tags$textarea(id=id,class=class,rows=rows,cols=cols,placeholder=placeholder,value))
  
}

# custom layouts
customColumn <- function(customClass, ...) {
  div(class = customClass, ...)
}

FRC12 <- function (...) {
  fluidRow(
    column(
      width = 12,
      ... )
  )
}
