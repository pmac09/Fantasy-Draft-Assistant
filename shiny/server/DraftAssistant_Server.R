################################################################################
## DRAFT ASSISTANT - SERVER

vDraftCode <- 'ACM7LDxkZJfj'

vPlayers <- get_players(vDraftCode)
vDraftTable <- get_draft_table(vDraftCode)

vCurrentPick <- current_pick(vDraftTable)



################################################################################
## UI RENDERS

output$uiPickCounter <- renderUI({
  
  vCurrentPick
  
  vRound <- vCurrentPick$round
  vPick <- vCurrentPick$pick
  
  ui <- valueBox(vPick, paste0('Round ',vRound), width=12, icon = icon("hashtag"))
  return(ui)
})

output$uiPlayerPool <- renderUI({
  
  vTextSearch <- input$uiTextSearch
  
  vTeamFilter <- input$uiTeamFilter
  vTeamFilter <- ifelse(vTeamFilter=='ALL','',vTeamFilter)
  
  vPosFilter  <- input$uiPosFilter
  vPosFilter <- ifelse(vPosFilter=='ALL','',vPosFilter)
  
  vFilteredPlayers <- vPlayers %>%
    filter(grepl(toupper(vTextSearch), toupper(player_name))) %>%
    filter(grepl(vTeamFilter, team)) %>%
    filter(grepl(vPosFilter, pos))
  

  print(nrow(vFilteredPlayers))
  
  vPlayerPool <- list()
  if(nrow(vFilteredPlayers)>0){
    for(i in 1:nrow(vFilteredPlayers)){
      vPlayerPool[[i]] <- playerItem(vFilteredPlayers$player_name[i],vFilteredPlayers$team[i], vFilteredPlayers$pos[i])
    }
  } else {
    vPlayerPool[[1]] <- playerItem('No Players Found', NULL, NULL)
  }
  

  
  
  
  ui <- wellPanel(
    style = "overflow-y:scroll; height:650px; background:white;", 
    productList(
      vPlayerPool
    )
  )
  
  return(ui)
})







