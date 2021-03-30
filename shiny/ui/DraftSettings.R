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
    fluidRow(
      column(width=12,'Field Structure:'),
      column(
        width=12,
        column(width=2,style='padding:0px;',
               numericInput(inputId= 'uiStructureDEF', label='DEF:', value=5, min=1, max=6)),
        column(width=2,style='padding:0px;',
               numericInput(inputId= 'uiStructureMID', label='MID:', value=7, min=1, max=9)),
        column(width=2,style='padding:0px;',
               numericInput(inputId= 'uiStructureRUC', label='RUC:', value=1, min=1, max=3)),
        column(width=2,style='padding:0px;',
               numericInput(inputId= 'uiStructureFWD', label='FWD:', value=5, min=1, max=6)),
        column(width=2,style='padding:0px;',
               numericInput(inputId= 'uiStructureBEN', label='BEN:', value=4, min=1, max=12))
        
      )
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
      choices = list('30 seconds', 
                     '60 seconds', 
                     '90 seconds',
                     '120 seconds',
                     'No Limit'), 
      selected = 'No Limit'
    )

  ),
  
  ## RIGHT SIDE
  column(
    width = 5,
    offset=1,
    h3('Draft Order'),
    uiOutput('uiDraftOrder'),
    br(), br(), 
    actionButton(inputId= "uiCreateDraft", label = "Create Draft")
  )
)
