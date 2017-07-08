# ==========================================================
# xls parser dispatcher
# ==========================================================
xls_parser <- function(x) {    
    ret <- NA_real_
    # ==========================================================
    # general logic
    
    # ==========================================================
    # call dispatchers
    if(is.na(ret)) { 
        ret <- safe_xls_parser1(x = x) 
    }
    
    if(is.na(ret)) { 
        ret <- safe_xls_parser2(x = x) 
    }
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
                               sheet = "RREO-Anexo 06", 
                               range = "A78:H78", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("RESULTADO PRIMÁRIO", blob[[1]])) {
        ret <- as.numeric(blob[[3]])
    }
    # ==========================================================
    # return value
    ret
}
safe_xls_parser1 <- purrr::possibly(xls_parser1, NA_real_)

xls_parser2 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RREO-Anexo 06", 
                               range = "A80:H80", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("RESULTADO PRIMÁRIO", toupper(blob[[1]]))) {
        ret <- as.numeric(blob[[3]])
    }
    # ==========================================================
    # return value
    ret
}
safe_xls_parser2 <- purrr::possibly(xls_parser2, NA_real_)

# ==========================================================
# pdf parser dispatcher
# ==========================================================
pdf_parser <- function(x) {
    ret <- NA_real_
    # ==========================================================
    # general logic
    
    pages <- pdftools::pdf_info(x)$pages
    report <- "DEMONSTRATIVO DO RESULTADO PRIMÁRIO"
    pdf_txt <- pdftools::pdf_text(x)
    page <- which(stringr::str_detect(pdf_txt, report))[1]
    
    blob <- tabulizer::extract_tables(x, pages = page)
    regex <- "PRIMÁRIO.+"
    
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
    
    if(is.na(ret)) { 
        ret <- safe_pdf_parser5(blob = blob, regex = regex) 
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
    row <- stringr::str_detect(blob[[3]][, 2], regex)

    if(row == TRUE) {
        ret <- to_numeric(blob[[3]][, 5])
    } 
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
    row <- stringr::str_detect(blob[[3]][, 2], regex)

    if(row == TRUE) {
        ret <- to_numeric(blob[[3]][, 6])
    }
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
    row <- stringr::str_detect(blob[[3]][, 2], regex)

    if(row == TRUE) {
        ret <- to_numeric(blob[[3]][, 4])
    } 
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
    row <- stringr::str_detect(blob[[3]][, 2], regex)

    if(row == TRUE) {
        ret <- to_numeric(blob[[3]][, 8])
    } 
    # ==========================================================
    # return value
    ret
}
safe_pdf_parser4 <- purrr::possibly(pdf_parser4, NA_real_)

pdf_parser5 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    blob <- args$blob
    regex <- args$regex
    # ==========================================================
    # parser logic
    row <- stringr::str_detect(blob[[3]][, 2], regex)

    if(row == TRUE) {
        ret <- to_numeric(blob[[3]][, 7])
    } 
    # ==========================================================
    # return value
    ret
}
safe_pdf_parser5 <- purrr::possibly(pdf_parser5, NA_real_)


