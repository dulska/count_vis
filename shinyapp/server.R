#selectedrowindex = 0

# Server.R
shinyServer(function(input, output,session) {
  options(shiny.maxRequestSize=1000*1024^2)
  
  
  fun<- function(myData){ 
    
    dane <- myData$datapath
    dane <- read.csv(dane, sep=",", header=T)
    
    if 
    (colnames(dane)[1]=="gene_id") 
      rownames(dane) <- dane[,1]
    else
      dane <- dane
    
    if 
    (colnames(dane)[1]=="gene_id") 
    dane <- dane %>% select(-gene_id)
    else 
      dane <- dane
    
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
  
#  variable2 <- reactive( {
    
#    selectedcolindex <<- variable()$variable_cols_selected
#    selectedcolindex <<- as.numeric(unlist(selectedcolindex))
    
#    selectedcol <- (variable()[,selectedcolindex])
#  } )

  
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
    
    }, server = TRUE, selection = 'multiple')
  
  
  
  ##########new_table##########
  
  
  output$selectedrow <- DT::renderDataTable({
    
    variable()
    
  }, extensions = 'Buttons', options = list(dom = 'Bfrtip', buttons = I('colvis')))
 
  ####################
  
 # output$sampletable2 <- DT::renderDataTable({
    
#    variable2()
    
 # }, server = TRUE, selection = list(target = 'column'))
  
  ##########barplot##########
  
  
  output$plot <- renderPlot({
    
    dane2 <- cbind(variable(), rownames(variable()))
    data3 <- melt(dane2)
    colnames(data3) <- c("gene", "sample", "value")
    data3 <- as.data.table(data3)
    data3$value=as.numeric(data3$value)
    
    plot_geom_bar_2 <- ggplot(data3, aes(sample , value, fill=gene) ) + 
      geom_bar(aes(fill = factor( gene)), position = "dodge", stat = "identity") 
    # facet_grid(gene ~ .)
    
    plot_geom_bar_2
  })
  
  
  ##########heatmap##########
  
  
  output$heatmap <- renderD3heatmap({
    
     d3heatmap(variable(), scale = "column")
  })
  

 
})