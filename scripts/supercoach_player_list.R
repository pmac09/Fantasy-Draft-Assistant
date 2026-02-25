################################################################################
# SETUP

options(stringsAsFactors = FALSE)
library(tidyverse)
library(data.table)
library(httr)


library(cluster)
library(httr)
library(jsonlite)
library(tidyverse)

tkn <- '084cc4e6c4c58926b971491a424dc71bbd2a3cda'
auth <- add_headers(Authorization = paste0('Bearer ', tkn))

sc_download <- function(auth, url){
  sc_data <- content(GET(url=url,config=auth))
  return(sc_data)
}
sc_setup <- function(auth){
  # Output Variable
  sc <- list()
  sc$auth <- auth
  
  # URL components
  sc$url$base    <- paste0('https://supercoach.heraldsun.com.au/', year(Sys.Date()), '/api/afl/')
  sc$url$draft   <- paste0(sc$url$base, 'draft/v1/')
  sc$url$classic <- paste0(sc$url$base, 'classic/v1/')
  
  # Generate API URLs
  sc$url$settings <- paste0(sc$url$draft,'settings')
  sc$url$me <- paste0(sc$url$draft,'me')
  
  # Call API
  sc$api$settings <- sc_download(sc$auth, sc$url$settings)
  sc$api$me <- sc_download(sc$auth, sc$url$me)
  
  # Save common variables
  sc$var$user_id <- sc$api$me$id
  
  # Generate API URLs
  sc$url$user <- paste0(sc$url$draft,'users/', sc$var$user_id, '/stats')
  
  # Call API
  sc$api$user <- sc_download(sc$auth, sc$url$user)
  
  # Save common variables
  sc$var$season        <- as.numeric(sc$api$settings$content$season)
  sc$var$league_id     <- sc$api$user$classic$leagues[[1]]$id
  sc$var$current_round <- sc$api$settings$competition$current_round
  sc$var$next_round    <- sc$api$settings$competition$next_round
  
  # Generate API URLs
  sc$url$players <- paste0(sc$url$draft,'players-cf?embed=notes%2Codds%2Cplayer_stats%2Cpositions%2Cplayer_match_stats&round=')
  sc$url$player  <- paste0(sc$url$draft,'players/%s?embed=notes,odds,player_stats,player_match_stats,positions,trades')
  sc$url$league  <- paste0(sc$url$draft,'leagues/',sc$var$league_id,'/ladderAndFixtures?round=%s&scores=true')
  sc$url$team    <- paste0(sc$url$draft,'userteams/%s/statsPlayers?round=%s')
  
  # Call API
  #sc$api$league <- sc_download(sc$auth, sprintf(sc$url$league, sc$var$current_round))
  
  # Generate API URLs
  sc$url$playerStatus <- paste0(sc$url$draft,'leagues/',sc$var$league_id,'/playersStatus')
  sc$url$playerStats  <- paste0(sc$url$draft,'completeStatspack?player_id=')
  
  sc$url$aflFixture <- paste0(sc$url$draft,'real_fixture')
  
  sc$url$teamTrades       <- paste0(sc$url$draft,'leagues/',sc$var$league_id,'/teamtrades')
  sc$url$trades           <- paste0(sc$url$draft,'leagues/',sc$var$league_id,'/trades')
  sc$url$processedWaivers <- paste0(sc$url$draft,'leagues/',sc$var$league_id,'/processedWaivers')
  sc$url$draftResult      <- paste0(sc$url$draft,'leagues/',sc$var$league_id,'/recap')
  
  return(sc)
}

sc <- sc_setup(auth)

players_raw <- sc_download(sc$auth,paste0(sc$url$players,0))
players_raw <- lapply(players_raw, unlist)
players_raw <- bind_rows(lapply(players_raw, as.data.frame.list))

# Format player data
player_data <- tibble(
  player_id        = as.numeric(players_raw$feed_id),
  supercoach_id    = as.numeric(players_raw$id),
  first_name       = players_raw$first_name,
  last_name        = players_raw$last_name,
  team             = players_raw$team.abbrev,
  pos              = trimws(paste(players_raw$positions.position, ifelse(is.na(players_raw$positions.position.1),"",players_raw$positions.position.1))),
  average          = as.numeric(players_raw$previous_average),
  price            = as.numeric(players_raw$player_stats.price)
) %>%
  arrange(desc(price))

# Export player list
write.csv(player_data, paste0('./data/supercoach_player_list_',year(Sys.Date()),'.csv'), row.names = FALSE, na="")
write.csv(player_data, paste0('./shiny/www/player_lists/supercoach_player_list_',year(Sys.Date()),'.csv'), row.names = FALSE, na="")
