
shinyServer(function(input, output, session) {
  
  # init ngram
  n <- reactiveValues(
    "gram" = getNextWords(nGramFreq,"eol#",character(0)),
    "text" = getSplitText("",0)
  )
  
  # update cursor pos
  shinyjs::onevent("keyup","inputText", { js$getCursorPos("inputText") })
  shinyjs::onclick("inputText", { js$getCursorPos("inputText") })
  
  # update ngram when cursor pos change
  observeEvent(input$cursorPos,{
    n$text <- getSplitText(input$inputText,input$cursorPos)
    n$gram <- getNextWords(nGramFreq,n$text$previousWords,n$text$currentWord)
    lapply(1:3, function(i) {updateButtonLabels(i,output,n$gram)})
  })
  
  # update input & shortList when the user clicks on a suggested word
  lapply(1:3, function(i) {
    observeEvent(input[[paste0("word",i)]], { 
      updateTextArea(i,session,input,n$gram,n$text)
    })
  })
  
})
