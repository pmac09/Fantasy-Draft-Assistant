################################################################################
# DRAFT SETUP

fluidRow(
  
  tags$head(
    # Used for inline labels for draft order
    tags$style(type="text/css", "#inline label{ display: table-cell; text-align: center; vertical-align: middle; } #inline .form-group { display: table-row;}")
  ),
  
  
  ## LEFT SIDE
  column(
    width = 6,
    h3('Draft Settings'),
    
    #league size
    numericInput(
      inputId = "uiLeagueSize", 
      label = 'League Size:', 
      value = 8, 
      min = 6, 
      max = 18
    ),
    
    #Field Structure
    selectInput(
      inputId = "uiFieldStructure", 
      label = 'Field Structure (D/M/R/F - B):', 
      choices = list('2/2/1/2 - 5' = 1, 
                     '2/3/1/2 - 4' = 2, 
                     '3/4/1/3 - 4' = 3,
                     '5/7/1/5 - 4' = 4,
                     '4/5/1/4 - 5' = 5,
                     '6/8/2/6 - 4' = 6), 
      selected = 4
    ),
    
    #Draft order
    selectInput(
      inputId = "uiDraftOrder", 
      label = 'Draft Order:', 
      choices = list('Snake', 
                     'Linear', 
                     'Bonzai',
                     'ASL Custom' ), 
      selected = 'ASL Custom'
    ),
    
    #Turn length    
    selectInput(
      inputId = "uiTurnLength", 
      label = 'Turn Length:', 
      choices = list('30 seconds'  = 1, 
                     '60 seconds'  = 2, 
                     '90 seconds'  = 3,
                     '120 seconds' = 4,
                     'No Limit'    = 5), 
      selected = 5
    )

  ),
  
  ## RIGHT SIDE
  column(
    width = 6,
    h3('Draft Order'),
    uiOutput('uiDraftOrder'),
    br(), br(), 
    actionButton("action", label = "Create Draft")
  )
)
