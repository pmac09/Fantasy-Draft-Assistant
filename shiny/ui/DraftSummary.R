
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
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem(),
        playerItem()
      )
      
    )
  )
)
# FIELD END ####################################################################
