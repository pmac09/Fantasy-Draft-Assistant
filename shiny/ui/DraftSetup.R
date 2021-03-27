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
      label= 'Email:'
    ),
    textInput(
      inputId= 'uiNewDraftName',
      label= 'Draft Name:'
    ),
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
    textInput(
      inputId= 'uiDraftCode',
      label= 'Draft Code:'
    ),
    actionButton(
      inputId = 'uiContinueDraft',
      label = 'Continue Draft'
    )
  )
)
