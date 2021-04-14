
setwd('/Users/paulmcgrath/Github/Fantasy-Draft-Assistant/shiny')

# Source functions
source('../functions/secrets.R', local=TRUE)
source('../functions/firebase_functions.R', local=TRUE)
source('../functions/setup_functions.R', local=TRUE)

################################################################################
## SETUP

# Get draft details
vDrafts <- get_drafts()
vDraftCode <- vDrafts$draft_code[1]

# Save settings to firebase
settings <- list(
  leagueSize = 8,
  fieldStructure = list(DEF=5, MID=7, RUC=1, FWD=5, BEN=4),
  draftOrder = 'ASL Custom',
  turnLength = 'No Limit',
  coaches = c('Kappaz', 'Lester', 'Chief', 'Jmerc', 'Melons', 'Pmac', 'Richo', 'Garter')
)

path = paste0('data/',vDraftCode,'/settings')
firebaseSave(projectURL, path, settings)

settings <- firebaseDownload(projectURL, path)

# Save player list to firebase
path = paste0('./www/player_lists/2021_sc_player_list.csv')
players <- read_csv(path) %>%
  mutate(player_name = paste0(
    substr(first_name,1,1), '.',
    ifelse(is.na(str_extract(first_name, '.\\.')), '', str_extract(first_name, '.\\.')),
    last_name)) %>%
  select(player_id, player_name, team, pos, average, price) %>%
  arrange(desc(price))

path = paste0('data/')
path = paste0('drafts/')
firebaseSave(projectURL, path, NULL)

players <- firebaseDownload(projectURL, path)

# Create the draft table
path = paste0('data/',vDraftCode,'/settings')
settings <- firebaseDownload(projectURL, path)

vRounds <- sum(unlist(settings$fieldStructure))
vPicks <- vRounds * settings$leagueSize
vOrderID <- c(seq(1:8), rep(c(seq(1:8),rev(seq(1:8))), vRounds))[1:vPicks]
vCoaches <- settings$coaches[vOrderID]

vDraftTable <- tibble( 
  round = sort(rep(seq(1:vRounds), settings$leagueSize)),
  pick = seq(1:vPicks),
  order_id = vOrderID,
  coach = vCoaches,
  player_id = '',
  position = '',
  time = ''
)

path = paste0('data/',vDraftCode,'/draft_table')
firebaseSave(projectURL, path, vDraftTable)

vDraftTable <- firebaseDownload(projectURL, path)

################################################################################
## 

vDraftTable <- get_draft_table(vDraftCode)

vCurrentPick <- current_pick(vDraftTable)

