
header <- dashboardHeader(
  title = "autoKeyboard"
)

header$children[[2]]$children <- tags$span("auto", tags$b("Keyboard"))

body <- dashboardBody(
  
  useShinyjs(),
  #extendShinyjs(script = "./www/getCursorPos.js"),
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    #tags$script(src = "keypressTextarea.js"),
    #tags$script(src = "getCursorPos.js"),
    #tags$script(src = "focusTextarea.js"),
    tags$script(src = "getNgram.js"),
    tags$script(src = "getWords.js"),
    tags$script(src = "setCursorPos.js")
    
  ),

  customColumn(customClass="col-md-6 col-md-offset-3",

    # INPUT BOX: triggers three most likely words
    FRC12( 
      textareaInput("inputText", rows = 5, cols = 35)
    ),

    # SELECT BOX: three most likely words (action on click: add to input box)
    FRC12(
      div(class="tags",
        div(class="col-xs-4",uiOutput("my_word1")),
        div(class="col-xs-4",uiOutput("my_word2")),
        div(class="col-xs-4",uiOutput("my_word3"))
      )
    )

  )
)

shinyUI(dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
))
