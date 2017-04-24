# count_vis 

This is a Shiny app to visualize any count tables mostly supported to RNASeq data. 

Required packages:
```
list.of.packages <- c("DT", "data.table", "stringr", "stringi", 
                      "dplyr", "ggplot2", "shiny", "openxlsx", 
                      "d3heatmap", "shinyjs", "reshape2", 
                      "plyr", "scales", "V8")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
```

To run a Shiny app type:
```
library(shiny)
runGitHub("count_vis", "dulska", subdir = "/shinyapp/")
```
