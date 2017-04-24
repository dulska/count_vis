list.of.packages <- c("DT","data.table", "stringr", "stringi", "dplyr", "ggplot2","shiny", "openxlsx", "d3heatmap", "shinyjs", "reshape2", "plyr", "scales", "V8", "canvasXpress")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

Vectorize(require)(package = c("DT","data.table", "stringr", "stringi", "dplyr", "ggplot2","shiny", "openxlsx", "d3heatmap", "shinyjs", "reshape2", "plyr", "scales", "V8", "canvasXpress"), character.only = TRUE)

#devtools::install_github('neuhausi/canvasXpress')

##########UI##########

jsResetCode <- "shinyjs.reset = function() {history.go(0)}"
style = "background-color:  #ffffff"
shinyUI(fluidPage(style = "background-color:  #ffffff; irs-line: #b30000",
  
  tags$head(
    tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
  "))
  ),
  
  headerPanel(h1("RNA Seq Data Visualization ", 
                 style = "font-family: 'Lobster', cursive;
                 font-weight: 1200; color: #00b36b; text-align: center;")),
  br(),
  br(),
  br(),
  tags$hr(),
  sidebarLayout(
    sidebarPanel( style = "background-color:  #00ff99;",
      fileInput("file1", label = h4("Choose your file (.csv):"), multiple = FALSE, accept = c(".csv")),
      
      tags$hr(),
      h4("Please, push the button to start the analysis."),
      actionButton("analysis", "Run"),
      
      tags$hr(),
      selectInput ("columns",h4("Choose samples:"),
                   choices="",    selected=TRUE, multiple = TRUE),

      useShinyjs(),                                        
      extendShinyjs(text = jsResetCode), 

      tags$hr(),
      radioButtons('norm', h4('Standarization:'),
                   c(No = 'No_Norm',
                     Yes = 'Norm'),
                   'No_Norm'),
      
      tags$hr(),
      downloadButton('selectedData.csv', 'Download Selected Data (.csv)'),
      actionButton("refresh_button",  "Refresh")

    ),

   
    mainPanel(
      mainPanel(style = "background-color:  #ffffff;", tabsetPanel(type = "tabs",
                  tabPanel("Description", uiOutput("descript"),
                           
                           h3("A web application for RNA Seq data visualization.", 
                              style ="font-weight: 500; line-height: 1.1; color: #404040;"),
                           br(),
                           
                           p("This is a Shiny app to visualize any count tables mostly supported to RNASeq data.", 
                             style ="font-weight: 500; line-height: 1.1; color: #404040;"),
                           br(),
                           
                           p("The standarization method is used to normalize the data.", 
                             style ="font-weight: 500; line-height: 1.1; color: #404040;"),
                           br(),
                           
                           h4("Data Format  :", 
                              style ="font-weight: 500; line-height: 1.1; color: #404040;"),
                           
                           p("- ",tags$b("'.csv'"), "are requied. ", 
                             style ="font-weight: 500; line-height: 1.1; color: #404040;") ,
                           
                           p("- First/Left-hand column must be gene identifiers ",tags$b("'(gene_id)'"), ", or rownames must be gene identifiers.", 
                             style ="font-weight: 500; line-height: 1.1; color: #404040;") , 
                           
                           p("- Colnames must be the names of samples.", 
                             style ="font-weight: 500; line-height: 1.1; color: #404040;") 
                           
                  ),
                  tabPanel("Interactive Table", uiOutput("tableMessage1"),
                           DT::dataTableOutput("sampletable")
                          
                  ),
                  
                  tabPanel("Selected data", uiOutput("tableMessage2"),
                           DT::dataTableOutput("selectedrow")
                  ),

                  tabPanel("Heatmap",uiOutput("tableMessage3"),
                           br(),
                           downloadButton('downloadheatmap.png', 'Download Plot (.png)'),
                           br(),
                           br(),
                           numericInput("width", "Width [cm]:", value =""),
                           numericInput("height", "Height [cm]:", value =""),
                           br(),
                           br(),
                           plotOutput("heatmap2"),
                           br(),
                           br(),
                           d3heatmapOutput("heatmap")
                  ),
                  tabPanel("Barplot",uiOutput("tableMessage4"),
                           br(),
                           downloadButton('downloadPlot.png', 'Download Plot (.png)'),
                           br(),
                           br(),
                           numericInput("width2", "Width [cm]:", value =""),
                           numericInput("height2", "Height [cm]:", value =""),
                           br(),
                           br(),
                           plotOutput("plot")

                 )
                  ))
      )
    )
  )
)
