jsCode<-'shinyjs.gettime = function(params) {
  var time = Date();
Shiny.onInputChange("jstime", time);
}' 

ui <- shinyUI(fluidPage(mainPanel(
  useShinyjs(),
  extendShinyjs(text = jsCode)
)))

server <- function(input, output)
{
  observe({
    js$gettime()
  })
  
  observe({
    cat(input$jstime)
  })
}

shinyApp(ui=ui, server=server)
