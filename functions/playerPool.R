
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

playerItem <- function(){
  
  shiny::tags$li(
    class = "item", 
    div(
      class='playerItem',
      div(class='playerPos', actionButton('b','MID'), actionButton('b','FWD')),
      div(class='teamLogo', img(src = './teams/colours/ESS.png')),
      div(class='playerName', "A.McDonald-Tipungwuti")
    )
  )
  
}


