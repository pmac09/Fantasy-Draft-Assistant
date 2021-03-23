################################################################################
# DRAFT SETUP - SERVER

output$uiDraftOrder <- renderUI({
  
  # Get how many teams have been selected
  leagueSize <- input$uiLeagueSize
  
  # loop through to create boxes
  draftOrder <- list()
  for (i in 1:leagueSize){
    draftOrder[[i]] <- tags$div(
      id = "inline", 
      textInput(inputId = paste0('draftOrderPos',i), 
                label = paste0(i,'. '))
    )
  }
  
  return(draftOrder)
})


