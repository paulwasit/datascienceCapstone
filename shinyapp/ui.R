library(shiny)
library(shinydashboard)
 library(V8) # required for extendshinyjs in shinyapps
library(shinyjs) #used to hide some inputs
library(shinyBS) #used for tooltips
library(markdown)

header <- dashboardHeader(
  title = "autoKeyboard"
)

#sidebar <- dashboardSidebar(
#  sidebarMenu(
#    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
#    menuItem("Presentation", icon = icon("th"), tabName = "intro")
#  )
#)

header$children[[2]]$children <-  tags$span("auto", tags$b("Keyboard"))

#tab1 <- tabItem(tabName = "dashboard",
body <- dashboardBody(
  
  useShinyjs(),
  extendShinyjs(script = "./www/cursorPosTextarea.js"),
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$script(src = "keypressTextarea.js"),
    tags$script(src = "cursorPosTextarea.js"),
    tags$script(src = "focusTextarea.js")
  ),

# ------------------------------ LEFT PANEL ----------------------------------- #   
  
  fluidRow(
    
    #left panel
    customColumn(customClass="col-md-6 col-md-offset-3",
     
      # text box
      #box(width = NULL, status = "primary", solidHeader = TRUE, 
      #    title = tagList(htmlOutput("textBoxTitle", container = tags$span, class = "centerSpan"),
      #                    tags$i(id="textTT", shiny::icon("question-circle"))),
      #    bsTooltip("textTT", 
      #              "the three most likely words will appear in the yellow box",
      #              "bottom"),

# ------------------------------ MAP ------------------------------------------ # 

        # SELECT BOX: three most likely words (action on click: add to input box)
        fluidRow(
          column(
            width = 12,
            div(class="tags",
              div(class="col-xs-4",uiOutput("my_word1")),
              div(class="col-xs-4",uiOutput("my_word2")),
              div(class="col-xs-4",uiOutput("my_word3"))
            )
          )
        ),
        
        # INPUT BOX: triggers three most likely words
        fluidRow(
          column(
            width = 12,
            textareaInput("inputText", rows = 5, cols = 35)
          )
        )

      #)
    ),  

# ------------------------------ RIGHT PANEL ---------------------------------- # 

    # right panel
    customColumn(customClass="col-md-3 visible-md-block visible-lg-block",
    
      fluidRow(column(width = 12,
        box(width = NULL, status = "primary", solidHeader = TRUE, 
          title = tagList("Top 10", tags$i(id="top10TT", shiny::icon("question-circle"))),
          bsTooltip("top10TT", "Top 10", "bottom"),
            
          DT::dataTableOutput("table")
          
        )
      ))
      
      #fluidRow(infoBox(width = 12, 
      #  "% auto",
      #  NULL,
      #  icon = icon("exclamation"),
      #  color="light-blue")
      #)
      
    )

  )
)



#body <- dashboardBody(
  
  #tabItems(
  #  tab1,
    
    #tabItem(tabName = "intro",
    #  fluidRow(
    #    column(width = 3),
    #    column(width = 6,
    #      includeMarkdown("introMD.md")
    #    )
    #  )
    #)
  #)
#)




shinyUI(dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
))
