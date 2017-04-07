source("https://bioconductor.org/biocLite.R")
#biocLite('shinyjs')
#install.packages('shinyjs')


library(DT)
library(data.table)
library(stringr)
library(dplyr)
library(ggplot2)
library("data.table")
library("Matrix")
library("shiny")
library("annotate")
library("affy")
library("oligo")
library("Biobase")
library("convert")
library("SCAN.UPC")
library("cluster")
library("affycoretools")
library("AnnotationHub")
library("limma")
library("openxlsx")
library("shinyHeatmaply")
library("d3heatmap")
library("plotly")
library("shinydashboard")
library("robustHD")
library("shinyjs")
library("V8")
library(DT)
library(shiny)
#selectedrowindex = 0

# Server.R
shinyServer(function(input, output,session) {
  options(shiny.maxRequestSize=1000*1024^2)
  
  
  fun<- function(myData){ 
    
    dane <- myData$datapath
    dane <- read.csv(dane, sep=",", header=T)
    
    return(dane)
  }
  
  
  myData <- reactive({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    inFile
  }) 
  
  
  observeEvent(input$analysis, {
    myData <- myData()
    if (is.null(myData$datapath)){
      return(NULL)
    } 
    return(myData)
  })
  
  
  observeEvent(input$refresh_button, {
    js$reset()
  })     

  
  sampletable <- eventReactive(input$analysis, {
    myData <- myData()
    if (!is.null(myData)){
      Tab <- fun(myData)
      
      return(Tab)
    }  
  })
  
  
  variable <- reactive( {
   
     selectedrowindex <<- input$sampletable_rows_selected
    selectedrowindex <<- as.numeric(unlist(selectedrowindex))
    selectedrow <- (sampletable()[selectedrowindex,])
    
    if(input$norm=='Norm')
      return(selectedrow<-(selectedrow-min(selectedrow))/(max(selectedrow)-min(selectedrow)))
    if(input$norm=='No_Norm')
      return(selectedrow)
  } )
  
  
  ##########table_messages##########
  
  
  output$tableMessage1 <- renderUI({
    myData <- myData()
    if (is.null(myData)){
      br()
      h3("Please, upload your file to show the table.")
    }
  })
  
  output$tableMessage2 <- renderUI({
    myData <- myData()
    if (is.null(myData)){
      br()
      h3("Please, select your data in the first table.")
    }
  })
 
  output$tableMessage3 <- renderUI({
    myData <- myData()
    if (is.null(myData)){
      br()
      h3("Please, select your data to show the heatmap.")
    }
  })
  
  output$tableMessage4 <- renderUI({
    myData <- myData()
    if (is.null(myData)){
      br()
      h3("Please, select your data to show the barplot.")
    }
  })
  
  
  ##########table##########
  
  
  output$sampletable <- DT::renderDataTable({
    
    sampletable()
 
    }, server = TRUE,selection = 'multiple')
  
  
  ##########new_table##########
  
  
  output$selectedrow <- DT::renderDataTable({
    

    selectedrowindex <<- input$sampletable_rows_selected
    selectedrowindex <<- as.numeric(unlist(selectedrowindex))
    selectedrow <- (sampletable()[selectedrowindex,])
    
    variable <- reactive( {
      if(input$norm=='Norm')
        return(selectedrow<-(selectedrow-min(selectedrow))/(max(selectedrow)-min(selectedrow)))
      if(input$norm=='No_Norm')
        return(selectedrow)
    } )
    variable()
    
  })
  
  
  ##########barplot##########
  
  
  output$plot <- renderPlot({
    
    dane2 <- cbind(variable(), rownames(variable()))
    data3 <- melt(dane2)
    colnames(data3) <- c("gene", "sample", "value")
    data3 <- as.data.table(data3)
    data3$value=as.numeric(data3$value)
    
    plot_geom_bar_2 <- ggplot(data3, aes(sample , value) ) + 
      geom_bar(aes(fill = factor( gene)), position = "dodge", stat = "identity") 
    # facet_grid(gene ~ .)
    
    plot_geom_bar_2
  })
  
  
  ##########heatmap##########
  
  
  output$heatmap <- renderD3heatmap({

     d3heatmap(variable(), scale = "column")
  })
  

 
})