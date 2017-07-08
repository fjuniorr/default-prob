# ==========================================================
# xls parser dispatcher
# ==========================================================
xls_parser <- function(x) {
    ret <- NA_real_
    # ==========================================================
    # general logic
    
    # ==========================================================
    # call dispatchers
    ret <- safe_xls_parser1(x = x) 
    # ==========================================================
    # return value
    ret
}

# ==========================================================
# xls parsers implementations
# ==========================================================
xls_parser1 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RGF-Anexo 01", 
                               range = "A23:C23", 
                               col_names = FALSE,
                               col_types = c("text","numeric", "numeric"))
    
    if(grepl("Pessoal Inativo e Pensionistas", blob[[1]])) {
        ret <- as.numeric(blob[[2]]) + ifelse(is.na(as.numeric(blob[[3]])), 0, as.numeric(blob[[3]])) 
    }
    # ==========================================================
    # return value
    ret
}
safe_xls_parser1 <- purrr::possibly(xls_parser1, NA_real_)

# ==========================================================
# pdf parser dispatcher
# ==========================================================
pdf_parser <- function(x) {
    ret <- NA_real_
    # ==========================================================
    # general logic
    
    blob <- tabulizer::extract_tables(x, pages = 1)
    regex <- "Pessoal Inativo e Pensionistas"
    
    # ==========================================================
    # call dispatchers
    if(is.na(ret)) {
        ret <- safe_pdf_parser0(blob = blob, regex = regex) 
    }
    
    if(is.na(ret)) {
        ret <- safe_pdf_parser1(blob = blob, regex = regex) 
    }
    
    if(is.na(ret)) {
        ret <- safe_pdf_parser2(blob = blob, regex = regex) 
    }
    # ==========================================================
    # return value
    ret
}

# ==========================================================
# pdf parsers implementations
# ==========================================================
pdf_parser0 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    blob <- args$blob
    regex <- args$regex
    # ==========================================================
    # parser logic
    row <- stringr::str_detect(blob[[1]][, 2], regex)
    
    ret1 <- blob[[1]][, 3][row] %>% to_numeric()
    ret2 <- blob[[1]][, 4][row] %>% to_numeric(min_value = 0)
    
    ret <- ret1 + ret2
    # ==========================================================
    # return value
    ret    
}
safe_pdf_parser0 <- purrr::possibly(pdf_parser0, NA_real_)

pdf_parser1 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    blob <- args$blob
    regex <- args$regex
    # ==========================================================
    # parser logic
    row <- stringr::str_detect(blob[[1]][, 2], regex)
    ret_vec <- blob[[1]][, 3][row] %>% 
                stringr::str_split(" ") %>% 
                unlist()
    
    ret1 <- to_numeric(ret_vec[1])
    ret2 <- to_numeric(ret_vec[2], min_value = 0)
    ret <- ret1 + ret2
    # ==========================================================
    # return value
    ret    
}
safe_pdf_parser1 <- purrr::possibly(pdf_parser1, NA_real_)

pdf_parser2 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    blob <- args$blob
    regex <- args$regex
    # ==========================================================
    # parser logic
    row <- stringr::str_detect(blob[[1]][, 2], regex)
    ret <- blob[[1]][, 3][row] %>% 
                stringr::str_split(" ") %>% 
                unlist() %>% 
                to_numeric()
    # ==========================================================
    # return value
    ret    
}
safe_pdf_parser2 <- purrr::possibly(pdf_parser2, NA_real_)