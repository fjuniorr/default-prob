source("code/R/lib/parsers.R")

possible_test_cases <- c("19.226.189.909,25 17.004.819.518,34",
          "19.226.189.909,25",
          "19.226 . 189.909,25",
          "19.226 .189.909,25",
          "19.226. 189.909,25",
          "19.22  6.189.909,25",
          "19.226.189.909,2  17.004.819.518,34"
          )

real_test_cases <- c("19.226.189.909,25 17.004.819.518,34", 
                     "7 .898.296.864,02", 
                     "7 55.342.169,39")

real_test_cases %>% as_numeric() %>% formattable::accounting()


real_test_cases %>% 
    stringr::str_trim() %>% 
    stringr::str_replace_all("\\s+\\.", ".") %>% 
    stringr::str_replace_all("\\.\\s+", ".") %>% 
    stringr::str_view(",.*\\b\\s.*")

real_test_cases %>% 
    stringr::str_trim() %>% 
    stringr::str_replace_all("\\s+\\.", ".") %>% 
    stringr::str_replace_all("\\.\\s+", ".") %>% 
    stringr::str_replace("(,.*)(\\b\\s.*)", "\\1") %>%
    stringr::str_replace_all("\\s", "") %>% 
    stringr::str_replace_all("\\.", "") %>% 
    stringr::str_replace(",", ".") %>% 
    as.numeric %>% suppressWarnings %>% formattable::accounting()

    
possible_test_cases %>% 
    stringr::str_trim() %>% 
    stringr::str_replace_all("\\s+\\.", ".") %>% 
    stringr::str_replace_all("\\.\\s+", ".") %>% 
    stringr::str_replace("(,.*)(\\b\\s.*)", "\\1") %>%
    stringr::str_replace_all("\\s", "") %>% 
    stringr::str_replace_all("\\.", "") %>% 
    stringr::str_replace(",", ".") %>% 
    as.numeric %>% suppressWarnings %>% formattable::accounting()
    