munge <- function(stem, report) {
    path_to_parsers <- file.path("code/R/lib", paste0("parsers_", stem, ".R"))
    path_to_source <- file.path("data-raw", report)
    path_to_manual <- file.path("data/manual", paste0(stem, ".xlsx"))
    path_to_munged <- file.path("data/munged", paste0(report, "-", stem, ".csv"))
    # ==========================================================
    # parsers implementation
    # ==========================================================
    source(path_to_parsers)
    # ==========================================================
    # scripted data collection
    # ==========================================================
    files <- list.files(path_to_source, full.names = TRUE)
    DF <- files %>% 
            purrr::map(get_record) %>% 
            dplyr::bind_rows()
    # ==========================================================
    # manual data collection
    # ==========================================================
    DF <- replace_values(data = DF, path = path_to_manual)
    # ==========================================================
    # save
    # ==========================================================
    readr::write_csv(DF, path_to_munged) 
}

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

as_numeric <- function(x) {
    
    stringr::str_trim(x) %>% 
    stringr::str_replace("\\b\\s.*", "") %>%
    stringr::str_replace_all("\\s", "") %>% 
    stringr::str_replace_all("\\.", "") %>% 
    stringr::str_replace(",", ".") %>% 
    as.numeric %>% suppressWarnings
}

# convert string to numeric
to_numeric <- function(x, min_value = 1000) {
    
    ret <- NA_real_
    
    value <- as_numeric(x)
    
    if(length(value) == 1) {
        if(ifelse(is.na(value), 0, abs(value)) >= min_value) {
            ret <- value   
        }
    }
    
    ret
}

replace_values <- function(data, path, full = c("no", "yes")) {
    
    full <- match.arg(full)
    
    if(!file.exists(path)) {
        stop("Can't find file with manual data collection")
    }
    
    manual <- readxl::read_excel(path)
    stopifnot(anyDuplicated(manual$id) == 0)
    
    index <- match(data$id, manual$id) %>% .[!is.na(.)]
    values <- manual[index, "value"] %>% unlist()
    rows <- manual[index, "id"] %>% unlist()
    
    data$old_value <- data$value
    data[match(rows, data$id), "value"] <- values
    
    switch(full,
           no = data[, c("id", "state", "year", "value")],
           yes = data[match(rows, data$id), ])
}
