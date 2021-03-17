# install.packages("shinydashboard")
library("shinydashboard")

library(shiny)
library("RMySQL")
lapply(dbListConnections(MySQL()), dbDisconnect)
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    mysqlconnection <- reactive({
        dbConnect(MySQL(), 
                  user = 'jjz', 
                  password = 'v0v3v6v9', 
                  dbname = 'orders',
                  host = '204.2.63.19',
                  port = 20755)
    }) 
    
    
    db_table_list <- reactive({
        return(dbListTables(mysqlconnection()))
        dbClearResult(dbListResults(mysqlconnection())[[1]])
    })
    
    observe({
        updateSelectInput(session = session, "col", choices = db_table_list())
    })
    
    output$db_table <- renderTable({
        
        if(input$col!=""){
            result = dbGetQuery(mysqlconnection(), paste0("select * from ", input$col))
            return(result)
        }
        
    })
    
})
