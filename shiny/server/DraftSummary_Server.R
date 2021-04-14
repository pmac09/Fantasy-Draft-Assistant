################################################################################
## DRAFT SUMMARY - SERVER

################################################################################
## REACTIVE FUNCTIONS

rDraftData <- reactive({
  vDraftTable <- rv$draftTable
  vPlayers <- rPlayers()
  
  vDraftData <- get_draft_data(vDraftTable, vPlayers)
  return(vDraftData)
})
rDraftSummary <- reactive({
  vDraftData <- rDraftData()
  vDraftSummary <- get_draft_summary(vDraftData)
  return(vDraftSummary)
})
rDraftName <- reactive({
  
  vDraftCode <- rv$draftCode
  vDrafts <- get_drafts()
  
  vDraftName <- vDrafts$draft_name[vDrafts$draft_code == vDraftCode]
  
  if(nchar(vDraftName)==0){
    vDraftName <- 'Fantasy Draft Assistant'
  }
  
  return(vDraftName)
})

################################################################################
## UI RENDERS

output$uiDraftSummary <- DT::renderDataTable({
  vDraftSummary <- rDraftSummary()
  colnames(vDraftSummary) <- toupper(colnames(vDraftSummary))
  
  ui <- datatable(
    vDraftSummary, 
    class = 'stripe',
    rownames = FALSE,
    options = list(
      dom = 't',
      ordering=F,
      pageLength = -1,
      scrollX = TRUE,
      columnDefs = list(list(className = 'dt-center', targets="_all"))
    ) 
  ) %>%
    formatStyle(0, target='row', lineHeight='70%')
  
  return(ui)
})

output$uiDownloadDraftBtn <- renderUI( {
  downloadButton('uiDownloadDraft', 'Download Draft', style = "width:100%;")
})
output$uiDownloadDataBtn <- renderUI( {
  downloadButton('uiDownloadData', 'Download Data', style = "width:100%;")
})

output$uiDownloadDraft <- downloadHandler(
  filename = function() {paste0(gsub(' ','_', rDraftName()),".csv")},
  content = function(file) {write.csv(rDraftSummary(), file, row.names = FALSE, na='')}
)
output$uiDownloadData <- downloadHandler(
  filename = function() {paste0(gsub(' ','_', rDraftName()),"_data.csv")},
  content = function(file) {write.csv(rDraftData(), file, row.names = FALSE, na='')}
)
