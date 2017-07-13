# ==========================================================
# xls parser dispatcher
# ==========================================================
xls_parser <- function(x) {
    ret <- NA_real_
    # ==========================================================
    # general logic

    # ==========================================================
    # call dispatchers
    ret <- purrr::possibly(xls_parser1, NA_real_)(x = x) 
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
                       sheet = "RREO-Anexo 05",
                       range = "A39:C39", 
                       col_names = FALSE,
                       col_types = c("text",rep("numeric", 2)))
    
    if(grepl("VALOR", blob[[1]])) {
        ret <- as.numeric(blob[[3]])
    }
    # ==========================================================
    # return value
    ret
}

# ==========================================================
# pdf parser dispatcher
# ==========================================================
pdf_parser <- function(x) {
    ret <- NA_real_
    # ==========================================================
    # general logic

    pages <- pdftools::pdf_info(x)$pages
    report <- "DEMONSTRATIVO DO RESULTADO NOMINAL"
    pdf_txt <- pdftools::pdf_text(x)
    page <- which(stringr::str_detect(pdf_txt, report))[1]
    
    blob <- tabulizer::extract_tables(x, pages = page)
    regex <- "^RESULTADO NOMINAL"

    # ==========================================================
    # call dispatchers
    if(is.na(ret)) {
        ret <- purrr::possibly(pdf_parser1, NA_real_)(blob = blob, regex = regex) 
    }
    
    if(is.na(ret)) {
        ret <- purrr::possibly(pdf_parser2, NA_real_)(blob = blob, regex = regex) 
    }
    
    if(is.na(ret)) {
        ret <- purrr::possibly(pdf_parser3, NA_real_)(blob = blob, regex = regex) 
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
    tbl <- blob[[1]]
    match_regex <- apply(tbl, 2, stringr::str_detect, pattern = regex)
    index <- which(match_regex, arr.ind = TRUE)
    row <- index[1, "row"]
    col <- ncol(tbl)
        
    ret <- tbl[row, col-1] %>% to_numeric()
    # ==========================================================
    # return value
    ret
}

pdf_parser2 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    blob <- args$blob
    regex <- args$regex
    # ==========================================================
    # parser logic
    tbl <- blob[[2]]
    match_regex <- stringr::str_detect(tbl, pattern = regex) %>% any()
    stopifnot(match_regex)
    row <- nrow(tbl)
    col <- ncol(tbl)
    ret <- tbl[row, col] %>% to_numeric()
    # ==========================================================
    # return value
    ret
}

pdf_parser3 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    blob <- args$blob
    regex <- args$regex
    # ==========================================================
    # parser logic
    tbl <- blob[[1]]
    match_regex <- apply(tbl, 2, stringr::str_detect, pattern = "^VALOR$")
    index <- which(match_regex, arr.ind = TRUE)
    row <- index[1, "row"]
    col <- ncol(tbl)
    
    ret <- tbl[row, col-1] %>% to_numeric()
    # ==========================================================
    # return value
    ret
}