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
                               range = "A39:B39", 
                               col_names = FALSE,
                               col_types = c("text","numeric"))
    
    if(grepl("RCL", blob[[1]])) {
        ret <- as.numeric(blob[[2]])
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
    regex <- "RECEITA CORRENTE LÍQUIDA"
    
    # ==========================================================
    # call dispatchers
    if(is.na(ret)) {
        ret <- safe_pdf_parser1(blob = blob, regex = regex) 
    }

    if(is.na(ret)) {
        ret <- safe_pdf_parser2(blob = blob, regex = regex)    
    }

    if(is.na(ret)) {
        ret <- safe_pdf_parser3(blob = blob, regex = regex) 
    }

    if(is.na(ret)) {
        ret <- safe_pdf_parser4(blob = blob, regex = regex) 
    }   
    # ==========================================================
    # return value
    ret
}

# ==========================================================
# pdf parsers implementations
# ==========================================================
pdf_parser1 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    blob <- args$blob
    regex <- args$regex
    # ==========================================================
    # parser logic
    row <- stringr::str_detect(blob[[2]][, 2], regex)
    ret <- blob[[2]][, 4][row] %>% to_numeric()
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
    row <- stringr::str_detect(blob[[2]][, 2], regex)
    ret <- blob[[2]][, 6][row] %>% to_numeric()
    # ==========================================================
    # return value
    ret    
}
safe_pdf_parser2 <- purrr::possibly(pdf_parser2, NA_real_)

pdf_parser3 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    blob <- args$blob
    regex <- args$regex
    # ==========================================================
    # parser logic
    row <- stringr::str_detect(blob[[1]][, 2], regex)
    ret <- blob[[1]][, 3][row] %>% to_numeric()
    # ==========================================================
    # return value
    ret    
}
safe_pdf_parser3 <- purrr::possibly(pdf_parser3, NA_real_)

pdf_parser4 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    blob <- args$blob
    regex <- args$regex
    # ==========================================================
    # parser logic
    row <- stringr::str_detect(blob[[1]][, 2], regex)
    ret <- blob[[1]][, 4][row] %>% to_numeric()
    # ==========================================================
    # return value
    ret    
}
safe_pdf_parser4 <- purrr::possibly(pdf_parser4, NA_real_)

