library(tidyverse); library(readxl); library(data.table)

states <- readxl::read_excel("data/states.xlsx")
years <- 2008:2016

DT <- as.data.table(expand.grid(state = states$state, 
                                  year = years,
                                  stringsAsFactors = FALSE))

# ==========================================================
# nat_rec
# ==========================================================
nat_rec_cols <- c(numeric = "year", text = "state", text = "cod1", text = "desc1", 
                  text = "cod2", text = "desc2", text = "cod3", text = "desc3",
                  text = "cod4", text = "desc4", numeric = "value", numeric = "value_intra")
nat_rec <- read_excel("data-raw/siga-brasil/siga_brasil-nat_rec.xlsx",
                      skip = 1,
                      col_names = nat_rec_cols,
                      col_types = names(nat_rec_cols)) %>% as.data.table()


# ==========================================================
# nat_desp
# ==========================================================
nat_desp_cols <- c(numeric = "year", text = "state", text = "cod1", text = "desc1", 
                  text = "cod2", text = "desc2", text = "cod3", text = "desc3",
                  numeric = "value_emp", numeric = "value_liq", numeric = "value_rpnp",
                  numeric = "value_emp_intra", numeric = "value_liq_intra", numeric = "value_rpnp_intra",
                  numeric = "value_emp_refin", numeric = "value_liq_refin", numeric = "value_rpnp_refin")
nat_desp <- read_excel("data-raw/siga-brasil/siga_brasil-nat_desp.xlsx",
                      skip = 1,
                      col_names = nat_desp_cols,
                      col_types = names(nat_desp_cols)) %>% as.data.table()

# ==========================================================
# fun_desp
# ==========================================================
fun_desp_cols <- c(numeric = "year", text = "state", text = "cod1", text = "desc1", text = "cod2", text = "desc2",
                   numeric = "value_emp", numeric = "value_liq", numeric = "value_rpnp",
                   numeric = "value_emp_intra", numeric = "value_liq_intra", numeric = "value_rpnp_intra",
                   numeric = "value_emp_reserva", numeric = "value_liq_reserva", numeric = "value_rpnp_reserva")
fun_desp <- read_excel("data-raw/siga-brasil/siga_brasil-fun_desp.xlsx",
                       skip = 1,
                       col_names = fun_desp_cols,
                       col_types = names(fun_desp_cols)) %>% as.data.table()

# ==========================================================
# divida
# ==========================================================
divida_cols <- c(numeric = "year", text = "state", text = "desc1", text = "desc2", 
                   text = "desc3", numeric = "value")
divida <- read_excel("data-raw/siga-brasil/siga_brasil-divida.xlsx",
                       skip = 1,
                       col_names = divida_cols,
                       col_types = names(divida_cols)) %>% as.data.table()

# ==========================================================
# pessoal
# ==========================================================
pessoal_cols <- c(numeric = "year", text = "state", text = "desc1", text = "desc2", 
                  numeric = "value_liq", numeric = "value_rpnp", numeric = "value_emp")
pessoal <- read_excel("data-raw/siga-brasil/siga_brasil-pessoal.xlsx",
                     skip = 1,
                     col_names = pessoal_cols,
                     col_types = names(pessoal_cols)) %>% as.data.table()

# ==========================================================
# rcl
# ==========================================================
rcl_cols <- c(numeric = "year", text = "state", text = "desc",
              text = "cod1", text = "desc1", text = "cod2", text = "desc2", 
              text = "cod3", text = "desc3", text = "cod4", text = "desc4",
              text = "cod5", text = "desc5", text = "cod6", text = "desc6", 
              text = "cod7", text = "desc7", numeric = "value")
rcl <- read_excel("data-raw/siga-brasil/siga_brasil-rcl.xlsx",
                     skip = 1,
                     col_names = rcl_cols,
                     col_types = names(rcl_cols)) %>% as.data.table()

