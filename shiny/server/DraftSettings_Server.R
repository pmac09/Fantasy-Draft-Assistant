################################################################################
# DRAFT SETTINGS - SERVER

vLeagueSize <- reactive({
  return(input$uiLeagueSize)
})
vFieldStructure <- reactive({
  return(input$uiFieldStructure)
})
vDraftOrder <- reactive({
  return(input$uiDraftOrder)
})
vTurnLength <- reactive({
  return(input$uiTurnLength)
})

output$uiDraftOrder <- renderUI({
  
  # Get how many teams have been selected
  vLeagueSize <- vLeagueSize()
  
  # loop through to create boxes
  draftOrder <- list()
  for (i in 1:vLeagueSize){
    draftOrder[[i]] <- tags$div(
      id = "inline", 
      textInput(inputId = paste0('draftOrderPos',i), 
                label = paste0(i,'. '))
    )
  }
  
  return(draftOrder)
})

observeEvent(input$uiCreateDraft, {
  
  vEmail <- vEmail()
  vDraftName <- vDraftName()
  
  vLeagueSize <- vLeagueSize()
  vFieldStructure <- vFieldStructure()
  vDraftOrder <- vDraftOrder()
  vTurnLength <- vTurnLength()
  
  if(vEmail != '' & vDraftName != ''){
    updateTabItems(session, 'sidebarTabs', 'tabSettings')
  }
})



