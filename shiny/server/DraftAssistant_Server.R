################################################################################
## DRAFT ASSISTANT - SERVER

################################################################################
## REACTIVE FUNCTIONS

rDraft <- reactive({
  req(rv$draftCode)
  vDraftCode <- rv$draftCode
  vDraft <- get_draft(vDraftCode)
  rv$draftTable <- vDraft$draft_table
  return(vDraft)
})
rPlayers <- reactive({
  vDraft <- rDraft()
  vPlayers <- vDraft$players
  return(vPlayers)
})
rSettings <- reactive({
  vDraft <- rDraft()
  vSettings <- vDraft$settings
  return(vSettings)
})
rTimerReset <- reactive({
  vSettings <- rSettings()
  vTurnLength <- vSettings$turnLength
  
  vTimerReset <- case_when(
    vTurnLength == '30 seconds' ~ 30,
    vTurnLength == '60 seconds' ~ 60,
    vTurnLength == '90 seconds' ~ 90,
    vTurnLength == '120 seconds' ~ 120,
    TRUE ~ 0
  ) + 1
  
  rv$timer <- vTimerReset
  
  return(vTimerReset)
})
rCurrentPick <- reactive({
  req(rv$draftTable)
  vDraftTable <- rv$draftTable
  vCurrentPick <- current_pick(vDraftTable)
  return(vCurrentPick)
})
rDraftSelection <- reactive({
  req(input$js.button_clicked)
  
  vButtonID <- input$js.button_clicked
  vPlayers <- rPlayers()
  
  vDraftSelection <- draft_selection(vButtonID, vPlayers)
  return(vDraftSelection)
})

################################################################################
## OBSERVES

observeEvent(rDraftSelection(), {
  
  vDraftSelection <- rDraftSelection()
  
  if(vDraftSelection$buttonType == 'btnDraft'){
    # Selection Confirmation
    confirmSweetAlert(
      session,
      inputId = 'uiConfirmDraft',
      title = paste0('Draft ', vDraftSelection$playerName, ' as a ', vDraftSelection$pos,'?'),
      btn_labels = c("Cancel", "Confirm")
    )
  }
})
observeEvent(input$uiConfirmDraft,{
  
  vConfirmDraft <- input$uiConfirmDraft
  if(vConfirmDraft){
  
    vDraftCode <- rv$draftCode
    vDraftTable <- rv$draftTable
    vCurrentPick <- rCurrentPick()
    vDraftSelection <- rDraftSelection()
    vTimerReset <- rTimerReset()
  
    vDraftTable <- make_selection(vDraftTable, vDraftSelection, vCurrentPick$pick)
    rv$draftTable <- vDraftTable
    
    # Reset Filters
    updateTextInput(session, "uiTextSearch", value = '')
    updateSelectInput(session, "uiTeamFilter", selected = 'ALL')
    updateSelectInput(session, "uiPosFilter", selected = 'ALL')
    
    # Reset Timer
    rv$timer <- vTimerReset
  }
})
observeEvent(rv$draftTable,{
  
  vDraftCode <- rv$draftCode
  vDraftTable <- rv$draftTable
  
  save_draft_table(vDraftCode, vDraftTable)
  
  vPicksRemaining <- nrow(vDraftTable %>% filter(player_id == ""))
  if(vPicksRemaining == 0){
    sendSweetAlert(
      session = session,
      title = "Draft Complete!",
      type = "success"
    )
    
    updateTabItems(session, 'sidebarTabs', 'tabSummary')
  }

})
observe({
  invalidateLater(1000, session)
  isolate({
    if(rv$timer > 0){
      rv$timer<- rv$timer -1
    } 
  })
})

################################################################################
## UI RENDERS

output$uiTeamName <- renderText({
  vCurrentPick <- rCurrentPick()
  vTeamName <- paste0(toupper(vCurrentPick$coach[1]), "'S TEAM")
  ui <- vTeamName
  return(ui)
})
output$uiFieldLayout <- renderUI({
  
  vCurrentPick <- rCurrentPick()
  vDraftTable <- rv$draftTable
  vPlayers <- rPlayers()
  vSettings <- rSettings()
  
  selections <- vDraftTable %>%
    filter(order_id == vCurrentPick$order_id[1]) %>%
    filter(player_id != '') %>%
    mutate(player_id = as.numeric(player_id)) %>%
    left_join(vPlayers, by=c('player_id'))
  
  pos <- list(
    DEF = list(),
    MID = list(),
    RUC = list(),
    FWD = list(),
    BEN = list()
  )
  
  if(nrow(selections)>0){
    for(i in 1:nrow(selections)){
      
      vPlayerName <- selections$player_name[i]
      vTeam <- selections$team[i]
      vPos <- sub(' ','/', selections$pos[i])
      vSelectedPos <- selections$position[i]
      vBench <- FALSE
      
      posCount <- length(pos[[vSelectedPos]])
      
      if(posCount == vSettings$fieldStructure[[vSelectedPos]]){
        vSelectedPos <- 'BEN'
        vBench <- TRUE
      }
      
      posCount <- length(pos[[vSelectedPos]]) + 1
      pos[[vSelectedPos]][[posCount]] <- playerCell(vPlayerName, vTeam, vPos, vBench)
    }
  }
  
  # Row structure
  n <- length(pos$DEF)
  if(n == 3){
    pos$DEF <- append(pos$DEF, list(br()), 1)
  } else if(n %in% c(4,5)){
    pos$DEF <- append(pos$DEF, list(br()), 2)
  } else if(n == 6) {
    pos$DEF <- append(pos$DEF, list(br()), 3)
  }
  
  n <- length(pos$MID)
  if(n == 4){
    pos$MID <- append(pos$MID, list(br()), 2)
  } else if(n %in% c(5,6)){
    pos$MID <- append(pos$MID, list(br()), 3)
  } else if(n == 7){
    pos$MID <- append(pos$MID, list(br()), 5)
    pos$MID <- append(pos$MID, list(br()), 2)
  } else if(n >= 8){
    pos$MID <- append(pos$MID, list(br()), 6)
    pos$MID <- append(pos$MID, list(br()), 3)
  } 
  
  n <- length(pos$FWD)
  if(n %in% c(3,4)){
    pos$FWD <- append(pos$FWD, list(br()), 2)
  } else if(n >= 5) {
    pos$FWD <- append(pos$FWD, list(br()), 3)
  }
  
  ui <- div(
         id="fieldLayout",
         
         div(
           id="onFieldLayout",
           div(
             class="positionalLine",
             div(),
             div(pos$DEF)
           ),
           div(
             class="positionalLine",
             div(pos$MID)
           ),
           div(
             class="positionalLine",
             div(pos$RUC)
           ),
           div(
             class="positionalLine",
             div(pos$FWD),
             div()
           )
         ),
         div(
           id="offFieldLayout",
           div(
             id='benchLine',
             pos$BEN
           )
         )
       )
  
  return(ui)
})
output$uiPlayerPool <- renderUI({
  
  vDraftTable <- rv$draftTable
  vPlayers <- rPlayers()
  vTextSearch <- input$uiTextSearch
  vTeamFilter <- input$uiTeamFilter
  vPosFilter <- input$uiPosFilter
  
  vPlayerPool <- get_player_pool(vPlayers, vDraftTable, vTextSearch, vTeamFilter, vPosFilter)
  
  ui <- wellPanel(
    style = "overflow-y:scroll; height:650px; background:white;", 
    productList(
      vPlayerPool
    )
  )
  
  return(ui)
})
output$uiDraftCode <- renderText({
  req(rv$draftCode)
  ui <- paste0('Draft Code: ', rv$draftCode)
  return(ui)
})
output$uiPickCounter <- renderUI({
  
  vCurrentPick <- rCurrentPick()
  
  vRound <- vCurrentPick$round
  vPick <- vCurrentPick$pick
  
  ui <- valueBox(vPick, paste0('Round ',vRound), width=12, icon = icon("hashtag"))
  return(ui)
})
output$uiPickTimer <- renderUI({
  
  vTimer <- rv$timer
  if(vTimer > 20) {
    vColour <- 'green'
  } else if (vTimer > 10){
    vColour <- 'yellow'
  } else {
    vColour <- 'red'
  }
  
  ui <- valueBox(vTimer, "Time Remaining", width=12, icon = icon('stopwatch'), color=vColour)
  return(ui)
})
output$uiDraftLog <- renderUI({
  
  vDraftTable <- rv$draftTable
  vPlayers <- rPlayers()
  
  vDraftLog <- vDraftTable %>%
    mutate(player_id = as.numeric(player_id)) %>%
    inner_join(vPlayers, by=c('player_id')) %>%
    mutate(horizontal_line = ifelse(pick/8==round, '<hr/>', '')) %>%
    mutate(draft_log = paste0(horizontal_line, pick, '. ', player_name, ' (',team,')')) %>%
    arrange(desc(pick)) %>%
    select(draft_log)
  
  ui <- wellPanel(
    style = "overflow-y:scroll; 
                   height:435px; 
                   background:white;", 
    HTML(paste(vDraftLog$draft_log, br()))
  )
  
  return(ui)
})
