
fluidPage(
  box(width=12,
    tabsetPanel(
      type='tabs',
## Draft table #################################################################
      tabPanel(
        "Draft Table", 
        fluidRow(
          column(
            width=10,
            DT::dataTableOutput('uiDraftSummary')
          ),
          column(
            width=2,
            br(),
            uiOutput("uiDownloadDraftBtn"),
            br(),
            uiOutput("uiDownloadDataBtn")
          )
        )
      )

## Draft table #################################################################
#      tabPanel("Summary", 'summary'),

## Draft table #################################################################
#      tabPanel("Table", 'table')
    )
  )
)
