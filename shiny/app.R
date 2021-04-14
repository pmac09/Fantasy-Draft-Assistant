################################################################################
# GLOBAL

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(fireData)
library(fun)
library(tidyverse)
library(DT)

source('../functions/secrets.R', local=TRUE)
source('../functions/styles.R', local=TRUE)
source('../functions/playerPool.R', local=TRUE)
source('../functions/firebase_functions.R', local=TRUE)
source('../functions/setup_functions.R', local=TRUE)

################################################################################
# UI

ui <- dashboardPage(
    dashboardHeader(
        title = 'Fantasy Draft Assistant'
    ),
    
    dashboardSidebar(#disable=TRUE,
      collapsed = TRUE,
      sidebarMenu(
          id = "sidebarTabs",
          menuItem("Draft Setup",     tabName = "tabSetup",    icon = icon("cog")),
          menuItem("Draft Settings",  tabName = "tabSettings", icon = icon("cog")),
          menuItem("Draft Assistant", tabName = "tabDraft",    icon = icon("list-ol")),
          menuItem("Draft Summary",   tabName = "tabSummary",  icon = icon("users"))
      )
    ),
    
    dashboardBody(
      tags$style(type = "text/css", "#tabSummary {height: calc(100vh - 80px) !important;}"),
      
      
      tabItems(        
            tabItem(tabName = "tabSetup",    source('./ui/DraftSetup.R',     local= TRUE)$value),
            tabItem(tabName = "tabSettings", source('./ui/DraftSettings.R',  local= TRUE)$value),
            tabItem(tabName = "tabDraft",    source('./ui/DraftAssistant.R', local= TRUE)$value),
            tabItem(tabName = "tabSummary",  source('./ui/DraftSummary.R',   local= TRUE)$value)
        )
    )
)


################################################################################
# SERVER

server <- function(input, output, session) {
  
  ##############################################################################
  
  source('./server/DraftSetup_Server.R', local= TRUE)$value
  source('./server/DraftSettings_Server.R', local= TRUE)$value
  source('./server/DraftAssistant_Server.R', local= TRUE)$value
  source('./server/DraftSummary_Server.R', local= TRUE)$value
  
}


################################################################################
# RUN

shinyApp(ui = ui, server = server)
