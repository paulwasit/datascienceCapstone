
shinyServer(function(input, output, session) {
  
  # init ngram
  #n <- reactiveValues(
  #  "gram" = getNextWords(nGramFreq,"eol#",character(0),tList),
  #  "text" = getSplitText("",0)
  #)
  
  # update ngram when cursor pos change
  observeEvent(input$cursorPos,{
    #n$text <- getSplitText(input$inputText,input$cursorPos)
    #print(input$cursorPos)
    
    #n$gram <- getNextWords(nGramFreq,
    #                       as.character(input$cursorPos$previousWords),
    #                       as.character(input$cursorPos$currentWord),
    #                       tList)
    lapply(1:3, function(i) {updateButtonLabels(i,output,input$cursorPos)})
  })
  
  # update input & shortList when the user clicks on a suggested word
  lapply(1:3, function(i) {
    observeEvent(input[[paste0("word",i)]], { 
      #updateTextArea(i,session,input,n$gram,input$cursorPos)
    })
  })
  
})
