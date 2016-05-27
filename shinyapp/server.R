library(dplyr)
library(RWeka)

#server side
shinyServer(function(input, output, session) {
  
  # title for the charts box - indicate if some events have been filtered out
  output$textBoxTitle <- renderUI({
    HTML("<b>Input Zone</b>")
  })
  
  #ngram <- reactiveValues()
  n <- reactiveValues(gram=updateSuggestedWordsList(""), newValue="")
  
  # update button labels when ngram changes
  observe({
    lapply(1:3, function(i) {updateButtonLabels(i,output,n$gram)})
    output$table <- n$gram$fullList
  })
  
  # update shortList when the user types
  #shinyjs::onevent("keypress","inputText", {
    #n$gram <- updateSuggestedWordsList(input$inputText)
  #})
  
  shinyjs::onevent("keyup","inputText", {
    js$getCursorPos("inputText") # fire fn
  })
  
  shinyjs::onclick("inputText", {
    js$getCursorPos("inputText") # fire fn
  })
  
  observeEvent(input$inputText, {
    js$getCursorPos("inputText") # fire fn
  })
  
  observeEvent(input$cursorPos,{
    print(input$cursorPos)
    tempGram <- updateSuggestedWordsList(input$cursorPos[1])
    if (n$gram[["shortList"]][1] != tempGram[["shortList"]][1]) {
      n$gram <- tempGram
    }
  })
  
  # update input & shortList when the user clicks on a suggested word
  lapply(1:3, function(i) {
    observeEvent(input[[paste0("word",i)]], { 
      if (substr(input$cursorPos[2],1,1)!=' ') {
        newValue <- paste(paste0(n$gram$currentText,n$gram$shortList[i]),input$cursorPos[2])
      }
      else {
        newValue <- paste0(n$gram$currentText,n$gram$shortList[i],input$cursorPos[2])
      }
      
      n$gram <- updateSuggestedWordsList(newValue)
      session$sendInputMessage("inputText", list(value = newValue))
    })
  })

})

