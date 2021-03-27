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

current_pick <- function(vDraftTable){
  vCurrentPick <- draft_table %>%
    filter(player_id == '') %>%
    arrange(pick) %>%
    top_n(-1, pick)
  
  return(vCurrentPick)
}
