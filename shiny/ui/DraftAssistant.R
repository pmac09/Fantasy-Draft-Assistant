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
      h4("PMAC'S TEAM"),
      # FIELD START ################################################################## 
      div(
        id="fieldLayout",
        
        div(
          id="onFieldLayout",
          div(
            class="positionalLine",
            div(),
            div(playerCell(),playerCell()),
            div(playerCell(),playerCell(),playerCell())
          ),
          div(
            class="positionalLine",
            div(playerCell(),playerCell()),
            div(playerCell(),playerCell(),playerCell()),
            div(playerCell(),playerCell())
          ),
          div(
            class="positionalLine",
            div(playerCell())
          ),
          div(
            class="positionalLine",
            div(playerCell(),playerCell(),playerCell()),
            div(playerCell(),playerCell()),
            div()
          )
        ),
        div(
          id="offFieldLayout",
          div(
            id='benchLine',
            playerCell(bench=TRUE),
            playerCell(bench=TRUE),
            playerCell(bench=TRUE),
            playerCell(bench=TRUE),
            playerCell(bench=TRUE)
            
          )
        )
      )
      # FIELD END ####################################################################
    ),
     
    
    # MIDDLE #######################################################################
    column(
      width=4,
      h4('PLAYER POOL'),
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
      uiOutput('uiPickCounter'),
      valueBox(0:00, "Time Remaining", width=12, icon = icon('stopwatch'), color='red'),
      column(
        width=12,
        h4('DRAFT LOG'),
        wellPanel(
          style = "overflow-y:scroll; 
                   height:460px; 
                   background:white;", 
          "30. A.Gaff",br(),
          "29. R.O'Brien",br(),
          "28. L.Parker",br(),
          "27. T.Rockliff",br(),
          "26. L.Ryan",br(),
          "25. S.Menegola",br(),
          hr(),
          "24. A.Treloar",br(),
          "23. S.Sidebottom",br(),
          "22. T.Adams",br(),
          "21. T.Boak",br(),
          "20. S.Pendlebury",br(),
          "19. N.Naitanui",br(),
          "18. M.Crouch",br(),
          "17. T.Goldstein",br(),
          hr(),
          "16. J.Lyons",br(),
          "15. N.Fyfe",br(),
          "14. T.Mitchell",br(),
          "13. P.Dangerfield",br(),
          "12. J.Kelly",br(),
          "11. L.Hunter",br(),
          "10. Z.Merrett",br(),
          "9. M.Bontempelli",br(),
          hr(),
          "8. C.Petracca",br(),
          "7. B.Grundy",br(),
          "6. J.Macrae",br(),
          "5. J.Lloyd",br(),
          "4. C.Oliver",br(),
          "3. J.Steele",br(),
          "2. L.Neale",br(),
          "1. M.Gawn",br()
        )
      )
    )
    
    # END  #########################################################################
  )
)
