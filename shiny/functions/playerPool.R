
playerCell <- function(vPlayerName='P.LayerName', vTeam='ESS', vPos='MID', vBench=FALSE){
  
  styles <- ifelse(vBench, '', 'display:inline-block; width:150px;')
  
  ui<- div(
    class='playerCell',
    style=styles,
    div(
      class='teamLogo',
      img(src = paste0('./teams/logos/',vTeam,'.jpg'))
    ),
    div(
      class='playerInfo',
      div(class='playerName', vPlayerName),
      div(class='playerPos', vPos)
    )
  )
  return(ui)
}

playerItem <- function(vPlayerID=999999, vPlayerName='No Player Found', vTeam=NULL, vPos=NULL){
  
  vPos <- unlist(str_split(vPos, ' '))
  pos_list <- list()
  if(length(vPos)>0){
    for(i in 1:length(vPos)){
      pos_list[[i]] <- actionButton(paste0('btnDraft_',vPlayerID,'_',vPos[i]),vPos[i], width = 60)
    }
  }
  
  team_img <- NULL
  if(!is.null(vTeam)){
    team_img <- img(src = paste0('./teams/colours/',vTeam,'.png'))
  }

  
  shiny::tags$li(
    class = "item", 
    div(
      class='playerItem',
      div(class='playerPos', pos_list),
      div(class='teamLogo', team_img),
      div(class='playerName', vPlayerName)
    )
  )
  
}


