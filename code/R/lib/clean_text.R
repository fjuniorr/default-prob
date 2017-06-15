clean_text <- function(str) {
    str <- trimws(str, which = "both") # espacos iniciais e finais
    str <- iconv(str, to='ASCII//TRANSLIT') # acentos
    str <- gsub("  *"," ", str) # multiplos espacos
    str <- toupper(str) # caixa alta
    str
}
