################################################################################
## DRAFT ASSISTANT - SERVER
################################################################################

vDraftCode <- 'ACM7LDxkZJfj'
vPlayers <- get_players(vDraftCode)

################################################################################
## REACTIVE FUNCTIONS
rDraftTable <- get_draft_table(vDraftCode)
makeReactiveBinding('rDraftTable')

rCurrentPick <- reactive({
  req(rDraftTable)
  vCurrentPick <- current_pick(rDraftTable)
  return(vCurrentPick)
})
rDraftSelection <- reactive({
  req(input$js.button_clicked)
  vButtonID <- input$js.button_clicked
  vDraftSelection <- draft_selection(vButtonID, vPlayers)
  return(vDraftSelection)
})

################################################################################
## OBSERVES

observeEvent(rDraftSelection(), {
  
  vDraftSelection <- rDraftSelection()
  
  # Selection Confirmation
  confirmSweetAlert(
    session,
    inputId = 'uiConfirmDraft',
    title = paste0('Draft ', vDraftSelection$playerName, ' as a ', vDraftSelection$pos,'?'),
    btn_labels = c("Cancel", "Confirm")
  )
  
})
observeEvent(input$uiConfirmDraft,{
  
  vConfirmDraft <- input$uiConfirmDraft
  if(vConfirmDraft){
  
    vDraftSelection <- rDraftSelection()
    vCurrentPick <- rCurrentPick()
    vDraftTable <- rDraftTable
  
    vDraftTable <- make_selection(vDraftTable, vDraftSelection, vCurrentPick$pick)
    
    rDraftTable <<- vDraftTable
    
    # Reset Filters
    updateTextInput(session, "uiTextSearch", value = '')
    updateSelectInput(session, "uiTeamFilter", selected = 'ALL')
    updateSelectInput(session, "uiPosFilter", selected = 'ALL')
  
  }
})
observeEvent(rDraftTable,{
  vDraftTable <- rDraftTable
  save_draft_table(vDraftCode, vDraftTable)
})


################################################################################
## UI RENDERS

output$uiPickCounter <- renderUI({
  
  vCurrentPick <- rCurrentPick()
  
  vRound <- vCurrentPick$round
  vPick <- vCurrentPick$pick
  
  ui <- valueBox(vPick, paste0('Round ',vRound), width=12, icon = icon("hashtag"))
  return(ui)
})
output$uiPlayerPool <- renderUI({
  
  vPlayerPool <- get_player_pool(vPlayers, rDraftTable, input$uiTextSearch, input$uiTeamFilter, input$uiPosFilter)
  
  ui <- wellPanel(
    style = "overflow-y:scroll; height:650px; background:white;", 
    productList(
      vPlayerPool
    )
  )
  
  return(ui)
})
output$uiDraftLog <- renderUI({
  
  vDraftTable <- rDraftTable
  
  vDraftLog <- vDraftTable %>%
    mutate(player_id = as.numeric(player_id)) %>%
    inner_join(vPlayers, by=c('player_id')) %>%
    mutate(horizontal_line = ifelse(pick/8==round, '<hr/>', '')) %>%
    mutate(draft_log = paste0(horizontal_line, pick, '. ', player_name, ' (',team,')')) %>%
    arrange(desc(pick)) %>%
    select(draft_log)
  
  ui <- wellPanel(
    style = "overflow-y:scroll; 
                   height:460px; 
                   background:white;", 
    HTML(paste(vDraftLog$draft_log, br()))
  )
  
  return(ui)
})






