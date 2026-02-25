projectURL <- 'https://fantasy-banter-082017.firebaseio.com'

firebaseDownload <- function(projectURL, path = NULL){
  data <- suppressWarnings(download(projectURL, paste0('Fantasy-Draft-Assistant/',path)))
  return(data)
} # Download data from firebase location

firebaseSave <- function(projectURL, path = NULL, data){
  if(is.null(path)) return(NULL)
  put(data, projectURL, paste0('Fantasy-Draft-Assistant/', path))
} # Save data to firebase location
