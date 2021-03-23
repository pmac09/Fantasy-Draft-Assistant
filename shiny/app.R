################################################################################
# GLOBAL

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)

################################################################################
# UI

ui <- dashboardPage(
    dashboardHeader(
        title = 'Fantasy Draft Assistant'
    ),
    
    dashboardSidebar(#disable=TRUE,
        sidebarMenu(
            id = "sidebarTabs",
            menuItem("Draft Setup",     tabName = "tabSetup",   icon = icon("cog")),
            menuItem("Draft Assistant", tabName = "tabDraft",   icon = icon("list-ol")),
            menuItem("Draft Summary",   tabName = "tabSummary", icon = icon("users"))
        )
    ),
    
    dashboardBody(
      tags$style(type = "text/css", "#tabSummary {height: calc(100vh - 80px) !important;}"),
      
      
      tabItems(        
            tabItem(tabName = "tabSetup",   source('./ui/DraftSetup.R', local= TRUE)$value),
            tabItem(tabName = "tabDraft",   source('./ui/DraftAssistant.R', local= TRUE)$value),
            tabItem(tabName = "tabSummary", source('./ui/DraftSummary.R', local= TRUE)$value)
        )
    )
)


################################################################################
# SERVER

server <- function(input, output, session) {
    
    source('./server/DraftSetup_Server.R', local= TRUE)$value
    
    
    observeEvent(input$switchtab, {
        newtab <- switch(input$tabs, "one" = "two","two" = "one")
        updateTabItems(session, "tabs", newtab)
    })
  
}


################################################################################
# RUN

shinyApp(ui = ui, server = server)
