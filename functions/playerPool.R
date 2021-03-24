
playerPool <- function (...) {
  shiny::tags$ul(class = "products-list product-list-in-box", ...)
}

playerPoolItem <-function (..., src = NULL, productTitle = NULL, productPrice = NULL, priceColor = NULL) {
  cl <- "label pull-right"
  if (!is.null(priceColor)) 
    cl <- paste0(cl, " label-", priceColor)
shiny::tags$li(class = "item", 
shiny::tags$div(class = "product-img", shiny::tags$img(src = src, alt = "Product Image")), 
shiny::tags$div(class = "product-info", 
shiny::tags$a(href = "javascript:void(0)", class = "product-title", 
             productTitle, shiny::tags$span(class = cl, productPrice)), 
shiny::tags$span(class = "product-description", ...)))
}


playerCell <- function(bench=FALSE){
  
  styles <- ifelse(bench, '', 'display:inline-block;')
  
  ui<- div(
    class='playerCell',
    style=styles,
    div(
      class='teamLogo',
      img(src = './teams/logos/ESS.jpg')
    ),
    div(
      class='playerInfo',
      div(class='playerName', "A.Mcdonald-Tipungwuti"),
      div(class='playerPos', "MID/FWD")
    )
  )
  return(ui)
  
}