files <- list.files("data-raw/coc/")
path_from <- file.path("data-raw/coc/", files)
filename <- stringr::str_replace(files, "(\\d{4})_(.{2})", "\\2_\\1")


# copy coc files
path_to <- file.path("data-raw/new_coc", filename) 
copy <- file.copy(from = path_from, to = path_to)
all(copy)
