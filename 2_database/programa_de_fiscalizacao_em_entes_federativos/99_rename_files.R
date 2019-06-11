
library(pdftools)

##### CHANGE HERE ######
path_to_folder_to_edit <- "/teste/teste_01"
########################

path = paste0(".", path_to_folder_to_edit)

file_names <- list.files(path = path)

for (i in 1:(length(file_names) - 1)) {
  print(file_names[i])
  
  # file name with no extension
  file_name_no_ext <- substr(file_names[i], 1, nchar(file_names[i]) - 4)
  
  # read pdf
  text <- pdf_text(paste0(path, '/', file_names[i]))
  
  # read lines from pdf
  text_divided <- strsplit(text, "\n")
  
  # create new name with city and state name
  new_name_no_ext <- paste0(file_name_no_ext,
                            '-',
                            trimws(gsub('\r', '', gsub(pattern = '/', '-', text_divided[[1]][7])), which = 'left'),
                            '.pdf')
  
  # copy the file with the new name
  file.copy(paste0(path, '/', file_names[i]),
            paste0(path, '/', new_name_no_ext))
}

