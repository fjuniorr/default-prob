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
        ret <- purrr::possibly(xls_parser1, NA_real_)(x = x) 
    }
    
    if(is.na(ret)) { 
        ret <- purrr::possibly(xls_parser2, NA_real_)(x = x) 
    }
    
    if(is.na(ret)) { 
        ret <- purrr::possibly(xls_parser3, NA_real_)(x = x) 
    }
    
    if(is.na(ret)) { 
        ret <- purrr::possibly(xls_parser4, NA_real_)(x = x) 
    }
    
    if(is.na(ret)) { 
        ret <- purrr::possibly(xls_parser5, NA_real_)(x = x) 
    }
    
    if(is.na(ret)) { 
        ret <- purrr::possibly(xls_parser6, NA_real_)(x = x) 
    }
    
    if(is.na(ret)) { 
        ret <- purrr::possibly(xls_parser7, NA_real_)(x = x) 
    }
    
    if(is.na(ret)) { 
        ret <- purrr::possibly(xls_parser8, NA_real_)(x = x) 
    }
    
    if(is.na(ret)) { 
        ret <- purrr::possibly(xls_parser9, NA_real_)(x = x) 
    }
    
    if(is.na(ret)) { 
        ret <- purrr::possibly(xls_parser10, NA_real_)(x = x) 
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
                       sheet = "RGF-Anexo 05",
                       range = "A44:H44", 
                       col_names = FALSE,
                       col_types = c("text",rep("numeric", 7)))
    
    if(grepl("Total dos Recursos", blob[[1]])) {
        ret <- as.numeric(blob[[7]])
    }
    # ==========================================================
    # return value
    ret
}

xls_parser2 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RGF-Anexo 05",
                               range = "A54:H54", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("Total dos Recursos", blob[[1]])) {
        ret <- as.numeric(blob[[7]])
    }
    # ==========================================================
    # return value
    ret
}

xls_parser3 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RGF-Anexo 05",
                               range = "A53:H53", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("Total dos Recursos", blob[[1]])) {
        ret <- as.numeric(blob[[7]])
    }
    # ==========================================================
    # return value
    ret
}

xls_parser4 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RGF-Anexo 05",
                               range = "A82:H82", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("Total dos Recursos", blob[[1]])) {
        ret <- as.numeric(blob[[7]])
    }
    # ==========================================================
    # return value
    ret
}

xls_parser5 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RGF-Anexo 05",
                               range = "A78:H78", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("Total dos Recursos", blob[[1]])) {
        ret <- as.numeric(blob[[7]])
    }
    # ==========================================================
    # return value
    ret
}

xls_parser6 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RGF-Anexo 05",
                               range = "A94:H94", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("Total dos Recursos", blob[[1]])) {
        ret <- as.numeric(blob[[7]])
    }
    # ==========================================================
    # return value
    ret
}

xls_parser7 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RGF-Anexo 05",
                               range = "A49:H49", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("Total dos Recursos", blob[[1]])) {
        ret <- as.numeric(blob[[7]])
    }
    # ==========================================================
    # return value
    ret
}

xls_parser8 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RGF-Anexo 05",
                               range = "A102:H102", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("Total dos Recursos", blob[[1]])) {
        ret <- as.numeric(blob[[7]])
    }
    # ==========================================================
    # return value
    ret
}

xls_parser9 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RGF-Anexo 05",
                               range = "A710:H710", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("Total dos Recursos", blob[[1]])) {
        ret <- as.numeric(blob[[7]])
    }
    # ==========================================================
    # return value
    ret
}

xls_parser10 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    blob <- readxl::read_excel(x, 
                               sheet = "RGF-Anexo 05",
                               range = "A145:H145", 
                               col_names = FALSE,
                               col_types = c("text",rep("numeric", 7)))
    
    if(grepl("Total dos Recursos", blob[[1]])) {
        ret <- as.numeric(blob[[7]])
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
    report <- "DEMONSTRATIVO DA DISPONIBILIDADE DE CAIXA"
    pdf_txt <- pdftools::pdf_text(x)
    page <- which(stringr::str_detect(pdf_txt, report))[1]
    
    blob <- tabulizer::extract_tables(x, pages = page, guess = FALSE)

    # ==========================================================
    # call dispatchers
    if(is.na(ret)) {
        ret <- purrr::possibly(pdf_parser1, NA_real_)(blob = blob) 
    }
    
    if(is.na(ret)) {
        ret <- purrr::possibly(pdf_parser2, NA_real_)(blob = blob) 
    }
    
    if(is.na(ret)) {
        ret <- purrr::possibly(pdf_parser3, NA_real_)(blob = blob, x = x) 
    }
    
    if(is.na(ret)) {
        ret <- purrr::possibly(pdf_parser4, NA_real_)(blob = blob, x = x) 
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
    # ==========================================================
    # parser logic
    tbl <- blob[[1]]
    regex <- "^OBRIGAÇÕES FINANCEIRAS$"
    match_regex <- apply(tbl, 2, stringr::str_detect, pattern = regex)
    index <- which(match_regex, arr.ind = TRUE)
    row <- index[1, "row"]
    
    
    regex_col <- "VALOR"
    match_regex_col <- apply(tbl, 2, stringr::str_detect, pattern = regex_col)
    index_col <- which(match_regex_col, arr.ind = TRUE)
    col <- index_col[index_col[, "row"] == 1, ][2, "col"]
        
    ret <- tbl[row, col] %>% to_numeric()
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
    # ==========================================================
    # parser logic
    tbl <- blob[[1]]
    regex <- "TOTAL"
    match_regex <- apply(tbl, 2, stringr::str_detect, pattern = regex)
    index <- which(match_regex, arr.ind = TRUE)
    row <- index[nrow(index), "row"]
    
    
    regex_col <- "^OBRIGAÇÕES(\\s|\\r)FINANCEIRAS(\\s|\\r)"
    match_regex_col <- apply(tbl, 2, stringr::str_detect, pattern = regex_col)
    index_col <- which(match_regex_col, arr.ind = TRUE)
    col <- index_col[1, "col"]
    
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
    x <- args$x
    # ==========================================================
    # parser logic
    report <- "DEMONSTRATIVO DA DISPONIBILIDADE DE CAIXA"
    pdf_txt <- pdftools::pdf_text(x)
    pages <- which(stringr::str_detect(pdf_txt, report))
    page <- pages[length(pages) - 1]
    
    blob <- tabulizer::extract_tables(x, pages = page, spreadsheet = TRUE)
    
    tbl <- blob[[1]]
    regex_col <- "^OBRIGAÇÕES(\\s|\\r)FINANCEIRAS(\\s|\\r)"
    match_regex <- apply(tbl, 2, stringr::str_detect, pattern = regex)
    index <- which(match_regex, arr.ind = TRUE)
    row <- index[nrow(index), "row"]
    
    col <- index[1, "col"] + 1
    
    ret <- tbl[row, col] %>% to_numeric()
    # ==========================================================
    # return value
    ret
}

pdf_parser4 <- function(...) {
    ret <- NA_real_
    # ==========================================================
    # parser arguments
    args <- list(...)
    x <- args$x
    # ==========================================================
    # parser logic
    report <- "DEMONSTRATIVO DA DISPONIBILIDADE DE CAIXA"
    pdf_txt <- pdftools::pdf_text(x)
    pages <- which(stringr::str_detect(pdf_txt, report))
    page <- pages[length(pages)]
    
    blob <- tabulizer::extract_tables(x, pages = page, spreadsheet = TRUE)
    
    tbl <- blob[[1]]
    regex_col <- "^OBRIGAÇÕES(\\s|\\r)FINANCEIRAS(\\s|\\r)"
    match_regex <- apply(tbl, 2, stringr::str_detect, pattern = regex)
    index <- which(match_regex, arr.ind = TRUE)
    row <- index[nrow(index), "row"]
    
    col <- index[1, "col"] + 1
    
    ret <- tbl[row, col] %>% to_numeric()
    # ==========================================================
    # return value
    ret
}

