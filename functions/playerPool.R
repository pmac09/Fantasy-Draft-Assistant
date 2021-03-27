
playerCell <- function(bench=FALSE){
  
  styles <- ifelse(bench, '', 'display:inline-block; width:150px;')
  
  ui<- div(
    class='playerCell',
    style=styles,
    div(
      class='teamLogo',
      img(src = './teams/logos/ESS.jpg')
    ),
    div(
      class='playerInfo',
      div(class='playerName', "M.Bontempelli"),
      div(class='playerPos', "MID/FWD")
    )
  )
  return(ui)
}

playerItem <- function(vPlayerName='P.Layer-Name', vTeam='ESS', vPos='MID FWD'){
  
  vPos <- unlist(str_split(vPos, ' '))
  
  pos_list <- list()
  if(length(pos_list)>0){
    for(i in 1:length(vPos)){
      pos_list[[i]] <- actionButton('btn',vPos[i], width = 60)
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


