library(tidyverse); library(data.table)

cfg <- yaml::yaml.load_file("data/fiscal-variables.yaml")

statement <- rbindlist(cfg[["tbl_statement_of_operations"]], idcol = "campo")

