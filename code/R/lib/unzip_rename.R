unzip_rename <- function(zipfile, exdir) {
    file <- str_extract(zipfile, "\\d{4}.*\\.zip$") %>% 
        str_replace("finbra_ESTDF_", "") %>% 
        str_replace("\\.zip", "") %>% 
        str_replace("\\(Anexo.*", "") %>% 
        str_replace("/", "_") %>% 
        paste0(., ".csv") %>% 
        file.path("data-raw/dca/", .)
    
    path <- unzip(zipfile = zipfile, exdir = exdir)
    file.rename(path, file)
    file
}