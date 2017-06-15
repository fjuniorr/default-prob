library(tabulizer)

state <- "to"
files <- list.files("data-raw/PDFS/", recursive = TRUE)
stopifnot(sum(grepl(paste0(toupper(state),".*",state), files)) == 20) # 20
stopifnot(sum(grepl(paste0(toupper(state),".*",state, ".*rreo"), files)) == 7) # 7
stopifnot(sum(grepl(paste0(toupper(state),".*",state, ".*rgf"), files)) == 7) # 7
stopifnot(sum(grepl(paste0(toupper(state),".*",state, ".*coc"), files)) == 6) # 6




regex1 <- "DESPESA BRUTA COM PESSOAL"
regex2 <- "Pessoal Inativo e Pensionistas"
regex3 <- "RECEITA CORRENTE"
regex4 <- "^II)"


path <- "data-raw/PDFS/AC/2014_ac_rgf.pdf"

l <- extract_tables(path, pages = 4)


match1 <- grepl(regex1, l[[1]][, 2])
stopifnot(sum(match1) == 1) # regex must have single match
l[[1]][match1]

match2 <- grepl(regex2, l[[1]][, 2])
stopifnot(sum(match2) == 1) # regex must have single match
l[[1]][match2]

match3 <- grepl(regex3, l[[1]][, 2])
stopifnot(sum(match3) == 1) # regex must have single match
l[[1]][match3]

match4 <- grepl(regex4, l[[1]][, 2])
stopifnot(sum(match4) == 1) # regex must have single match
l[[1]][match4]
