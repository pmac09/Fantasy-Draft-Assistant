fluidPage(

  # CSS for player cells
  tags$head(tags$style(styles)),

  # JQuery Script for the drafting buttons
  tags$head(
    tags$script(
      '$(document).on("click", "button", function(e) {
        e.stopPropagation()
        if(typeof BUTTON_CLICK_COUNT == "undefined") {
          BUTTON_CLICK_COUNT = 1;
        } else {
          BUTTON_CLICK_COUNT ++;
        }
        Shiny.onInputChange("js.button_clicked",
                            e.target.id + "_" + BUTTON_CLICK_COUNT);
      });'
    )
  ),

  fluidRow(

    # LEFT #########################################################################
    column(
      width=6,
      h3(textOutput('uiTeamName')),
      uiOutput('uiFieldLayout')
    ),

    # MIDDLE #######################################################################
    column(
      width=4,
      h3('PLAYER POOL'),
      fluidRow(
        column(
          width=12,
          column(
            width=6,
            style='padding:0px;',
            textInput(inputId= 'uiTextSearch', label=NULL)
          ),
          column(
            width=3,
            style='padding:0px;',
            selectInput(inputId= "uiTeamFilter", label=NULL, choices = list('ALL','ADE','BRL','CAR','COL','ESS','FRE','GCS','GEE','GWS','HAW','MEL','NTH','PTA','RIC','STK','SYD','WBD','WCE')),
          ),
          column(
            width=3,
            style='padding:0px;',
            selectInput(inputId= "uiPosFilter" , label=NULL, choices = list('ALL','DEF','MID','RUC','FWD'))
          )
        )
      ),
      uiOutput('uiPlayerPool')
    ),
    
    # RIGHT ########################################################################
    column(
      width=2,
      style='padding:0px;',
      div(style='text-align:center; padding:2px;', textOutput('uiDraftCode')),
      uiOutput('uiPickCounter'),
      uiOutput('uiPickTimer'),
      column(
        width=12,
        h3('DRAFT LOG'),
        uiOutput('uiDraftLog')
      )
    )
    
    # END  #########################################################################
  )
)
