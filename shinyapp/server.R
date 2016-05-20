library(dplyr)
library(RWeka)

#server side
shinyServer(function(input, output, session) {
  
  # title for the charts box - indicate if some events have been filtered out
  output$textBoxTitle <- renderUI({
    HTML("<b>Input Zone</b>")
  })
  
  ngram <- reactiveValues(
    suggestedWords = getSuggestedWords(list("c1"=character(0),"c2"=character(0))), 
    clickedWord = NULL
  )
  
  observe({
    currentNgram <- getCurrentNgram(input$inputText)
    suggestedWordsDF <- getSuggestedWords(currentNgram)
    print(suggestedWordsDF)
    ngram$suggestedWords <- suggestedWordsDF[,1]
  })

  observeEvent(ngram$suggestedWords, {
    output$my_word1 <- renderUI({actionButton("word1", label = ngram$suggestedWords[1])})
    output$my_word2 <- renderUI({actionButton("word2", label = ngram$suggestedWords[2])})
    output$my_word3 <- renderUI({actionButton("word3", label = ngram$suggestedWords[3])})
  })
  
  # identify the clicked word
  observeEvent(input$word1, { ngram$clickedWord <- ngram$suggestedWords[1] })
  observeEvent(input$word2, { ngram$clickedWord <- ngram$suggestedWords[2] })
  observeEvent(input$word3, { ngram$clickedWord <- ngram$suggestedWords[3] })
  
  observeEvent(ngram$clickedWord,{
               
    y <- isolate(input$inputText)
    
    # This will change the value of input$inText, based on x
    updateTextInput(session, "inputText", 
                    value = paste(y,ngram$clickedWord,""))
    
  })
  
  
  
})

