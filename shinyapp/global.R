
library(RColorBrewer)

# specify local port
options(shiny.port = 8000)

# prepare tooltips beg & end
ttBgn <- "#!function(geo, data) {
return '<div class=\"hoverinfo\">' +
'<strong>' + data.stateName + '</strong><br>' +"

ttEnd <- "'</div>';}!#"
