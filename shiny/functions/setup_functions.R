get_drafts <- function(){
  drafts <- firebaseDownload(projectURL, 'drafts')
  return(drafts)
}
create_draft <- function(vEmail, vDraftName){
  
  drafts <- get_drafts()
  
  vID <- max(drafts$id) + 1
  vDraftCode <- random_password(extended=FALSE)
  
  newDraft <- tibble(
    id = vID,
    email = vEmail,
    draft_name = vDraftName,
    draft_code = vDraftCode,
    date_time = format(Sys.time())
  )
  
  drafts <- bind_rows(newDraft,drafts)
  
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
get_draft <- function(vDraftCode){
  path = paste0('data/',vDraftCode)
  draft <- firebaseDownload(projectURL, path)
  return(draft)
}
validate_draft <- function(vEmail, vDraftCode){
  
  vDrafts <- get_drafts()
  
  n <- vDrafts %>%
    filter(toupper(email) == toupper(vEmail)) %>%
    filter(draft_code == vDraftCode) %>%
    nrow()
  
  vValid <- n == 1
  
  return(vValid)
}

setup_draft <- function(vDraftCode, vSettings){
  
  # Save settings
  save_settings(vDraftCode, vSettings)
  
  # Save Player List
  vPath <- paste0('./www/player_lists/supercoach_player_list_',year(Sys.Date()),'.csv')
  vPlayers <- read_csv(vPath) %>%
    mutate(player_name = paste0(
      substr(first_name,1,1), '.',
      ifelse(is.na(str_extract(first_name, '.\\.')), '', str_extract(first_name, '.\\.')),
      last_name)) %>%
    select(player_id, player_name, team, pos, average, price) %>%
    arrange(desc(price))
  
  save_players(vDraftCode, vPlayers)
  
  # Create draft table
  vSettings <- get_settings(vDraftCode)
  
  vSize <- vSettings$leagueSize
  vRounds <- sum(unlist(vSettings$fieldStructure))
  vPicks <- vRounds * vSize
  
  if(vSettings$draftOrder == 'Snake'){
    vOrderID <- rep(c(seq(1:vSize), rev(seq(1:vSize))), vRounds)[1:vPicks]
  } else if(vSettings$draftOrder == 'Linear'){
    vOrderID <- rep(seq(1:vSize), vRounds)[1:vPicks]
  } else if(vSettings$draftOrder == 'Banzai'){
    vOrderID <- c(seq(1:vSize),rev(seq(1:vSize)), rep(c(rev(seq(1:vSize)),seq(1:8)),vRounds))[1:vPicks]
  } else if(vSettings$draftOrder == 'ASL Custom'){
    vOrderID <- c(seq(1:vSize), rep(c(seq(1:vSize),rev(seq(1:vSize))), vRounds))[1:vPicks]
  }

  vCoaches <- vSettings$coaches[vOrderID]
  
  vDraftTable <- tibble( 
    round = sort(rep(seq(1:vRounds), vSize)),
    pick = seq(1:vPicks),
    order_id = vOrderID,
    coach = vCoaches,
    player_id = '',
    position = '',
    time = ''
  )
  
  save_draft_table(vDraftCode, vDraftTable)
  
}

get_settings <- function(vDraftCode){
  path = paste0('data/',vDraftCode,'/settings')
  settings <- firebaseDownload(projectURL, path)
  return(settings)
}
save_settings <- function(vDraftCode, vSettings){
  path = paste0('data/',vDraftCode,'/settings')
  firebaseSave(projectURL, path, vSettings)
}

get_players <- function(vDraftCode){
  path = paste0('data/',vDraftCode,'/players')
  players <- as_tibble(firebaseDownload(projectURL, path))
  return(players)
}
save_players <- function(vDraftCode, vPlayers){
  path = paste0('data/',vDraftCode,'/players')
  firebaseSave(projectURL, path, vPlayers)
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

validate_email <- function(vEmail){
   vValid <- grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(vEmail), ignore.case=TRUE)
   return(vValid)
}
msglog <- function(msg){
  verbose <- TRUE
  if(verbose){
    msg <- paste0(Sys.time(), ': ', msg)
    print(msg)
  }
}


get_draft_data <- function(vDraftTable, vPlayers){
  
  vDraftData <- as_tibble(vDraftTable) %>%
    mutate(player_id = as.numeric(player_id)) %>%
    left_join(vPlayers, by='player_id') %>%
    select(round, pick, order_id, coach, player_id, player_name, team, pos, position, time) %>%
    rename(position_drafted = position,
           position = pos,
          time_drafted = time)
  
  return(vDraftData)
}
get_draft_summary <- function(vDraftData){
  
  vDraftOrder <- unique(vDraftData$coach)
  
  vDraftSummary <-vDraftData %>%
    select(round, coach, player_name) %>%
    spread(key='coach', value='player_name')
  
  vDraftSummary <- vDraftSummary[,c('round', vDraftOrder)]
  
  return(vDraftSummary)
}
