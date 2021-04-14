################################################################################
# DRAFT SETUP - SERVER

rv <- reactiveValues(
  timer = 0,
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
    
    vValidDraft <- validate_draft(vEmail, vDraftCode)
    
    if(vValidDraft){
      # Change page
      updateTabItems(session, 'sidebarTabs', 'tabDraft')
      
      # Alert confirmation
      sendSweetAlert(
        session = session,
        title = "Draft Loaded!",
        type = "success"
      )
      
      # Load draft code
      rv$draftCode <- vDraftCode
      
    } else{
      
      # Alert fail
      sendSweetAlert(
        session = session,
        title = "Draft not found!",
        text= 'Check your details and try again.',
        type = "error"
      )
      
    }
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