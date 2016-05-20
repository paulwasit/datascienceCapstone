library(dplyr)
library(RWeka)

#server side
shinyServer(function(input, output, session) {
  
  # title for the charts box - indicate if some events have been filtered out
  output$textBoxTitle <- renderUI({
    HTML("<b>Input Zone</b>")
  })
  
  suggestedWords <- c("a1","a2","a3",1)
  ngram <- reactiveValues(suggestedWords = suggestedWords, clickedWord = NULL)
  
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
                    value = paste(y,ngram$clickedWord))
    
    t <- as.numeric(ngram$suggestedWords[4])
    ngram$suggestedWords <- c(paste0("a",t+3),
                      paste0("a",t+4),
                      paste0("a",t+5),
                      t+3)
  })
  
  observe({
    print(relevantNgram(input$inputText))
  })
  
})

# prepare chunk for tokenization
relevantNgram <- function(text) {
  
  # split text into sentences
  sent <- NGramTokenizer(
    text, 
    Weka_control(
      min=1,
      max=1, 
      delimiters='/\t\r\n=~*&_.,;:"()?!'
    )
  )
  
  # select the last one only
  currentSent <- sent[length(sent)]
  
  # split the sentence into words
  ngram <- NGramTokenizer(
    currentSent, 
    Weka_control(
      min=1,
      max=1, 
      delimiters=' '
    )
  )
  
  
  len <- nchar(text)
  lastChar <- substr(text,len,len)
  len <- length(ngram)
  
  # if no word is currently being typed, suggest most likely
  if (lastChar == ' ') {
    if (len <= 3) return (list("c1"=ngram,"c2"=NULL))
    return (list("c1"=ngram[(len-2):len],"c2"=NULL))
  }
  
  # otherwise, suggest most likely based on the beginning of the word
  else {
    c2 <- ngram[len]
    ngram <- ngram[-len]; len <- length(ngram)
    if (len <= 3) return (list("c1"=ngram,"c2"=c2))
    return (list("c1"=ngram[(len-2):len],"c2"=c2))
  }
  
}

