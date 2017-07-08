files <- list.files("data-raw/excel/", recursive = TRUE)
path_from <- file.path("data-raw/excel", files)
filename <- str_sub(files, 4)


# copy RGF files
rgf_filename <- str_subset(filename, "rgf")
path_from_rgf <- str_subset(path_from, "rgf")
path_to_rgf <- file.path("data-raw/RGF/xls/", rgf_filename) 

rgf_copy <- file.copy(from = path_from_rgf, to = path_to_rgf)
all(rgf_copy)


# copy RREO files
rreo_filename <- str_subset(filename, "rreo")
path_from_rreo <- str_subset(path_from, "rreo")
path_to_rreo <- file.path("data-raw/RREO/xls/", rreo_filename) 

rreo_copy <- file.copy(from = path_from_rreo, to = path_to_rreo)
all(rreo_copy)


