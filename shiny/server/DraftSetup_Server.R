################################################################################
# DRAFT SETUP - SERVER

rv <- reactiveValues(
  validateNewEmail = '',
  validateNewDraft = '',
  validateContinueEmail = '',
  validateDraftCode = '',
  validateCoaches = ''
)

observeEvent(input$uiNewDraft, {
  
  vEmail <- trimws(input$uiNewEmail)
  vDraftName <- trimws(input$uiNewDraftName)
  
  # Validate email input
  vEmailValid <- validate_email(vEmail)
  if(!vEmailValid){
    rv$validateNewEmail <- 'Please enter a valid email address.'
  } else {
    rv$validateNewEmail <- ''
  }
  
  # Validate draft name input
  vDraftNameValid <- vDraftName != ''
  if(!vDraftNameValid){
    rv$validateNewDraft <- 'Please enter a name for your draft.'
  } else {
    rv$validateNewDraft <- ''
  }
  
  # Proceed if all valid
  if(vEmailValid & vDraftNameValid){
    # Change page
    updateTabItems(session, 'sidebarTabs', 'tabSettings')
  }
})
observeEvent(input$uiContinueDraft, {
  
  vEmail <- trimws(input$uiContinueEmail)
  vDraftCode <- trimws(input$uiDraftCode)
  
  # Validate email input
  vEmailValid <- validate_email(vEmail)
  if(!vEmailValid){
    rv$validateContinueEmail <- 'Please enter a valid email address.'
  } else {
    rv$validateContinueEmail <- ''
  }
  
  # Validate draft Code input
  vDraftCodeValid <- nchar(vDraftCode) == 12
  if(!vDraftCodeValid){
    rv$validateDraftCode <- 'Please enter a valid draft code.'
  } else {
    rv$validateDraftCode <- ''
  }
  
  # Proceed if all valid
  if(vEmailValid & vDraftCodeValid){
    # Change page
    updateTabItems(session, 'sidebarTabs', 'tabDraft')
  }
})

output$uiValidateNewEmail <- renderText({
  ui <- rv$validateNewEmail
  return(ui)
})
output$uiValidateNewDraft <- renderText({
  ui <- rv$validateNewDraft
  return(ui)
})
output$uiValidateContinueEmail <- renderText({
  ui <- rv$validateContinueEmail
  return(ui)
})
output$uiValidateDraftCode <- renderText({
  ui <- rv$validateDraftCode
  return(ui)
})