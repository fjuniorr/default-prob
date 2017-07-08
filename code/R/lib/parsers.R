get_record <- function(x) {
    filetype <- basename(x) %>% 
                    stringr::str_replace('.*\\.', "")
    
    info <- basename(x) %>% 
                    stringr::str_replace("\\..*", "") %>% 
                    stringr::str_replace("_rgf$", "") %>% 
                    stringr::str_split("_") %>% unlist()
    
    ret <- list(id = paste0(info[2], as.integer(info[1])),
                state = info[2],
                year = as.integer(info[1]),
                value =  get_value(x, filetype))
    
    ret
}

# this functions tries all the parsers until find one that can actually parse a valid number
get_value <- function(x, filetype) {
    ret <- switch(filetype,
                  pdf = pdf_parser(x),
                  xls = xls_parser(x),
                  NA_real_)
    ret
}

# convert string to numeric
to_numeric <- function(x) {
    value <- stringr::str_replace_all(x, stringr::fixed(" "), "") %>% 
        stringr::str_replace_all("\\.", "") %>% 
        stringr::str_replace(",", ".") %>% 
        as.numeric %>% 
        suppressWarnings
    
    ret <- NA_real_
    
    if(length(value) == 1) {
        if(ifelse(is.na(value), 0, abs(value)) > 1000) {
            ret <- value   
        }
    }
    
    ret
}