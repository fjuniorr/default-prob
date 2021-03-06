clean_text <- function(str) {
    str <- trimws(str, which = "both") # espacos iniciais e finais
    str <- stringi::stri_trans_general(str, id = "latin-ascii") # acentos
    str <- gsub("  *"," ", str) # multiplos espacos
    str <- toupper(str) # caixa alta
    str
}


is_equal <- function(x, y) {
    x <- round(x, digits = 2)
    y <- round(y, digits = 2)
    isTRUE(all.equal(x, y))
}


