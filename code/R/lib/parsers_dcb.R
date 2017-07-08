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
                       sheet = "RGF-Anexo 02", 
                       range = "A21:E21", 
                       col_names = FALSE,
                       col_types = c("text",rep("numeric", 4)))
    
    
    if(grepl("(I)", blob[[1]])) {
        ret <- as.numeric(blob[[5]])
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

    pages <- pdftools::pdf_info(x)$pages
    report <- "DEMONSTRATIVO DA DÍVIDA CONSOLIDADA LÍQUIDA"
    pdf_txt <- pdftools::pdf_text(x)
    page <- which(stringr::str_detect(pdf_txt, report))[1]
    
    blob <- tabulizer::extract_tables(x, pages = page)
    regex <- "^DÍVIDA CONSOLIDADA.+"

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
    row <- stringr::str_detect(blob[[1]][, 2], regex) # find rcl row
    txt <- blob[[1]][, 4][which(row)[1]+1]
    ret <- to_numeric(unlist(stringr::str_split(txt, " "))[3])
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
    row <- stringr::str_detect(blob[[1]][, 2], regex) # find rcl row
    txt <- blob[[1]][, 3][which(row)[1]]
    ret <- to_numeric(unlist(stringr::str_split(txt, " "))[4])
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
    row <- stringr::str_detect(blob[[1]][, 2], regex) # find rcl row
    txt <- blob[[1]][, 3][which(row)[1]+1]
    ret <- to_numeric(unlist(stringr::str_split(txt, " "))[4])
    # ==========================================================
    # return value
    ret
}
safe_pdf_parser3 <- purrr::possibly(pdf_parser3, NA_real_)


