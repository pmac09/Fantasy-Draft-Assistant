################################################################################
# DRAFT SETTINGS - SERVER

observeEvent(input$uiCreateDraft, {
  
  vValidNames <- TRUE
  for (i in 1:input$uiLeagueSize){
    if(input[[paste0('draftOrderPos',i)]] == ''){
      vValidNames <- FALSE
    }
  }
  
  if(vValidNames){
    rv$validateCoaches <- ''
    
    confirmSweetAlert(
      session,
      inputId = 'uiConfirmCreateDraft',
      title = paste0('Confirm draft settings?'),
      btn_labels = c("Cancel", "Create Draft")
    )
  } else {
    rv$validateCoaches <- 'Please enter a name in each position.'
  }

})
observeEvent(input$uiConfirmCreateDraft, {
  
  if(input$uiConfirmCreateDraft){
    
    # Create draft
    vEmail <- trimws(input$uiNewEmail)
    vDraftName <- trimws(input$uiNewDraftName)
    
    vDraftCode <- create_draft(vEmail, vDraftName)
    
    # Create Settings
    coaches <- c()
    for (i in 1:input$uiLeagueSize){
      coaches <- c(coaches, input[[paste0('draftOrderPos',i)]])
    }
    
    vSettings <- list(
      leagueSize = input$uiLeagueSize,
      fieldStructure = list(DEF=input$uiStructureDEF,
                            MID=input$uiStructureMID,
                            RUC=input$uiStructureRUC,
                            FWD=input$uiStructureFWD,
                            BEN=input$uiStructureBEN),
      draftOrder = input$uiDraftOrder,
      turnLength = input$uiTurnLength,
      coaches = coaches)
    
    # Complete Setup
    setup_draft(vDraftCode, vSettings)
    
    # Confirm Setup
    sendSweetAlert(
      session = session,
      title = "Draft Created!",
      text = HTML(paste0('<b>Draft Code: ', vDraftCode, '</b><br/>', 'Your draft code is required to access your draft later.')),
      type = "success",
      html = TRUE
    )
    
    # Assign reactiveVal
    rDraftCode <- vDraftCode
    
    # Change Tabs
    updateTabItems(session, 'sidebarTabs', 'tabDraft')
  }
  
})

output$uiDraftOrder <- renderUI({
  
  # Get how many teams have been selected
  vLeagueSize <- input$uiLeagueSize
  
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
output$uiValidateCoaches <- renderText({
  ui <- rv$validateCoaches
  return(ui)
})
