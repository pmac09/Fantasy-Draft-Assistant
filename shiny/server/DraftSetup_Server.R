################################################################################
# DRAFT SETUP - SERVER

vEmail <- reactive({
  return(input$uiNewEmail)
})

vDraftName <- reactive({
  return(input$uiNewDraftName)
})

observeEvent(input$uiNewDraft, {
  
  vEmail <- vEmail()
  vDraftName <- vDraftName()
  
  if(vEmail != '' & vDraftName != ''){
    updateTabItems(session, 'sidebarTabs', 'tabSettings')
  }
})