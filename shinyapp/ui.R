library(shiny)
library(shinydashboard)
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
  
  #enable shinyjs
  useShinyjs(),
  
  # css to properly resize the map svg
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),

# ------------------------------ LEFT PANEL ----------------------------------- #   
  
  fluidRow(
    
    column(width = 2),
           
    #left panel
    column(width = 7,
           
      # harm map
      box(width = NULL, status = "primary", solidHeader = TRUE, 
          title = tagList(htmlOutput("textBoxTitle", container = tags$span, class = "centerSpan"),
                          tags$i(id="textTT", shiny::icon("question-circle"))),
          bsTooltip("textTT", 
                    "the three most likely words will appear in the yellow box",
                    "bottom"),

# ------------------------------ MAP ------------------------------------------ # 

        # SELECT BOX: three most likely words (action on click: add to input box)
        fluidRow(
          column(width=1),
          column(
            width = 10,
            div(class="tags",
              div(style="display:inline-block",uiOutput("my_word1")),
              div(style="display:inline-block",uiOutput("my_word2")),
              div(style="display:inline-block",uiOutput("my_word3"))
            )
          )
        ),
        
        # INPUT BOX: triggers three most likely words
        fluidRow(
          column(width=1),
          column(
            width = 10,
            textInput("inputText", label = NULL, value = "", width = NULL, placeholder = "start typing")
            #showOutput("chart1", "datamaps", package="rMaps")
          )
        )
      )
    ),  

# ------------------------------ RIGHT PANEL ---------------------------------- # 

    # right panel
    column(width = 3,

      #hr(),
      
      fluidRow(
        column(width = 12,
          box(width = NULL, status = "primary", solidHeader = TRUE, 
              title = tagList("Top 10", tags$i(id="top10TT", shiny::icon("question-circle"))),
              bsTooltip("top10TT", 
                        "Top 10",
                        "bottom")
            
                #,DT::dataTableOutput("table")

          )
        )
      )
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
