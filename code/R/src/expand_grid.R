library(data.table)

states <- readxl::read_excel("data/states.xlsx")
years <- 2008:2016

DT <- as.data.table(expand.grid(state = states$state, 
                                year = years,
                                stringsAsFactors = FALSE))

DT[, id := paste0(state, year)]
setcolorder(DT, c("id", "state", "year"))
setorderv(DT, c("state", "year"))

fwrite(DT, "data/state_year_full.csv")
