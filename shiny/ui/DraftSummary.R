
fluidPage(
  column(
    width=4,
    h4('PLAYER POOL'),
    fluidRow(
      column(
        width=12,
        column(
          width=6,
          style='padding:0px;',
          textInput(inputId= 'textSearch', label=NULL)
        ),
        column(
          width=3,
          style='padding:0px;',
          selectInput(inputId= "uiTeamFilter", label=NULL, choices = list('ALL','ADE','BRL', 'CAR')),
        ),
        column(
          width=3,
          style='padding:0px;',
          selectInput(inputId= "uiPosFilter" , label=NULL, choices = list('ALL','DEF','MID', 'RUC'))
        )
      )
    ),
    wellPanel(
      style = "overflow-y:scroll; height:650px; background:white;", 
      
      productList(
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC'),
        productListItem(src='./teams/MEL.png',productTitle = 'Max Gawn','RUC')
      )
      
    )
  )
)
# FIELD END ####################################################################


# 
# playerPoolItem <-function (..., src = NULL, productTitle = NULL, productPrice = NULL, priceColor = NULL) {
#   cl <- "label pull-right"
#   if (!is.null(priceColor)) 
#     cl <- paste0(cl, " label-", priceColor)
#   shiny::tags$li(class = "item", 
#                  shiny::tags$div(class = "product-img", shiny::tags$img(src = src, alt = "Product Image")), 
#                  shiny::tags$div(class = "product-info", shiny::tags$a(href = "javascript:void(0)", class = "product-title", 
#                                                productTitle, shiny::tags$span(class = cl, productPrice)), 
#                                  shiny::tags$span(class = "product-description", ...)))
# }