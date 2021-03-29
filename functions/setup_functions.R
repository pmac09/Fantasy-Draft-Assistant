get_drafts <- function(){
  drafts <- firebaseDownload(projectURL, 'drafts')
  return(drafts)
}
create_draft <- function(vEmail, vDraftName){
  
  drafts <- get_drafts()
  
  vID <- nrow(drafts) + 1
  vDraftCode <- random_password(extended=FALSE)
  
  newDraft <- tibble(
    id = vID,
    email = vEmail,
    draft_name = vDraftName,
    draft_code = vDraftCode
  )
  
  drafts <- bind_rows(drafts,newDraft)
  
  firebaseSave(projectURL, 'drafts', drafts)
  
  return(vDraftCode)
}
delete_draft <- function(vDraftCode){
  
  drafts <- get_drafts()
  
  drafts <- drafts %>%
    filter(draft_code != vDraftCode)
  
  firebaseSave(projectURL, 'drafts', drafts)
  
  return(drafts)
  
}

get_settings <- function(vDraftCode){
  path = paste0('data/',vDraftCode,'/settings')
  settings <- firebaseDownload(projectURL, path)
  return(settings)
}
get_players <- function(vDraftCode){
  path = paste0('data/',vDraftCode,'/players')
  players <- as_tibble(firebaseDownload(projectURL, path))
  return(players)
}

get_draft_table <- function(vDraftCode){
  path = paste0('data/',vDraftCode,'/draft_table')
  draft_table <- as_tibble(firebaseDownload(projectURL, path))
  return(draft_table)
}
save_draft_table <- function(vDraftCode, vDraftTable){
  path = paste0('data/',vDraftCode,'/draft_table')
  firebaseSave(projectURL, path, vDraftTable)
}

current_pick <- function(vDraftTable){
  vCurrentPick <- vDraftTable %>%
    filter(player_id == '') %>%
    arrange(pick) %>%
    top_n(-1, pick)
  
  return(vCurrentPick)
}
draft_selection <- function(vButtonID, vPlayers){
  
  #Parse button ID
  btnID = str_split(vButtonID, "_")
  
  vDraftSelection <- list(
    buttonType = btnID[[1]][1],
    playerID = btnID[[1]][2],
    playerName = vPlayers$player_name[which(vPlayers$player_id == btnID[[1]][2])],
    pos = btnID[[1]][3],
    count = btnID[[1]][4]
  )
  
  return(vDraftSelection)
}
make_selection <- function(vDraftTable, vDraftSelection, vPick){
  
  newTable <- vDraftTable
  
  newTable$player_id[which(newTable$pick == vPick)] <- vDraftSelection$playerID
  newTable$position[which(newTable$pick == vPick)] <- vDraftSelection$pos
  newTable$time[which(newTable$pick == vPick)] <- format(Sys.time())
  
  return(newTable)
}

get_player_pool <- function(vPlayers, vDraftTable, vTextSearch='', vTeamFilter='ALL', vPosFilter='ALL'){
  
  vTeamFilter <- ifelse(vTeamFilter=='ALL','',vTeamFilter)
  vPosFilter <- ifelse(vPosFilter=='ALL','',vPosFilter)
  
  vFilteredPlayers <- vPlayers %>%
    filter(!(player_id %in% vDraftTable$player_id))
  
  if(!(vTextSearch=='' & vTeamFilter=='' & vPosFilter == '')){
    vFilteredPlayers <- vFilteredPlayers %>%
      filter(grepl(toupper(vTextSearch), toupper(player_name))) %>%
      filter(grepl(vTeamFilter, team)) %>%
      filter(grepl(vPosFilter, pos))
  }
  
  vPlayerPool <- list()
  if(nrow(vFilteredPlayers)>0){
    for(i in 1:nrow(vFilteredPlayers)){
      vPlayerPool[[i]] <- playerItem(vFilteredPlayers$player_id[i], vFilteredPlayers$player_name[i],vFilteredPlayers$team[i], vFilteredPlayers$pos[i])
    }
  } else {
    vPlayerPool[[1]] <- playerItem()
  }
  
  return(vPlayerPool)
  
}
