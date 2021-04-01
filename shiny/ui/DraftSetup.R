################################################################################
# DRAFT SETUP

fluidRow(
  
  tags$head(
    # Used for inline labels for draft order
    tags$style(type="text/css", "#inline label{ display: table-cell; text-align: center; vertical-align: middle; } #inline .form-group { display: table-row;}")
  ),
  
  
  ## LEFT SIDE
  column(
    width = 5,
    offset=1,
    h3('New Draft'),
    textInput(
      inputId= 'uiNewEmail',
      label= 'Email:',
    ),
    div(class='errorMsg',textOutput('uiValidateNewEmail')),
    br(),br(),
    textInput(
      inputId= 'uiNewDraftName',
      label= 'Draft Name:'
    ),
    div(class='errorMsg',textOutput('uiValidateNewDraft')),
    br(),br(),
    actionButton(
      inputId = 'uiNewDraft',
      label = 'Create Draft'
    )
  ),
  
  ## RIGHT SIDE
  column(
    width = 5,
    offset=1,
    h3('Continue Draft'),
    textInput(
      inputId= 'uiContinueEmail',
      label= 'Email:'
    ),
    div(class='errorMsg',textOutput('uiValidateContinueEmail')),
    br(),br(),
    textInput(
      inputId= 'uiDraftCode',
      label= 'Draft Code:'
    ),
    div(class='errorMsg',textOutput('uiValidateDraftCode')),
    br(),br(),
    actionButton(
      inputId = 'uiContinueDraft',
      label = 'Continue Draft'
    )
  )
)
