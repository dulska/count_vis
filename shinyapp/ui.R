jsResetCode <- "shinyjs.reset = function() {history.go(0)}"
style = "background-color:  #ffffcc"
shinyUI(fluidPage(style = "background-color:  #ffffcc; irs-line: #b30000",
  
  tags$head(
    tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
  "))
  ),
  tags$hr(),
  headerPanel(h1("RNA Seq Data Visualization ", 
                 style = "font-family: 'Lobster', cursive;
                 font-weight: 1200; color: #990000; text-align: center;")),
  br(),
  tags$hr(),
  br(),
  br(),
  sidebarLayout(
    sidebarPanel( style = "background-color:  #80b3ff;",
      fileInput("file1", label = h4("Choose your file (.csv):"), multiple = FALSE, accept = c(".csv")),
      actionButton("analysis", "Run"),
   br(),
   br(),
   useShinyjs(),                                        
   extendShinyjs(text = jsResetCode),                     
   actionButton("refresh_button",  "Refresh"),
      br(),
      br(),
      
      radioButtons('norm', 'Standarization:',
                   c(No = 'No_Norm',
                     Yes = 'Norm'),
                   'No_Norm'),
      tags$hr(),
      br()
    ),

   
    mainPanel(
      mainPanel(style = "background-color:  #ffffcc;", tabsetPanel(type = "tabs",
                  tabPanel("Description", uiOutput("descript"),
                           
                           h3("A web application for RNA Seq data visualization.", 
                              style ="font-weight: 500; line-height: 1.1; color: #404040;"),
                           br(),
                           p("The standarization method is used to normalize the data.", 
                             style ="font-weight: 500; line-height: 1.1; color: #404040;"),
                           br(),
                           h4("Data Format  :", 
                              style ="font-weight: 500; line-height: 1.1; color: #404040;"),
                           p("- ",tags$b("'.csv'"), "are requied. ", 
                             style ="font-weight: 500; line-height: 1.1; color: #404040;") 
                           
                  ),
                  tabPanel("Interactive Table", uiOutput("tableMessage1"),
                           DT::dataTableOutput("sampletable")
                  ),
                  tabPanel("Selected data", uiOutput("tableMessage2"),
                           DT::dataTableOutput("selectedrow")
                  ),

                  tabPanel("Heatmap",uiOutput("tableMessage3"),
                           d3heatmapOutput("heatmap")
                  ),
                  tabPanel("Barplot",uiOutput("tableMessage4"),
                           plotOutput("plot")
                  
                  )
                  ))
      )
    )
  )
)
