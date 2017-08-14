library(tidyverse); library(data.table)

# ==========================================================
# GENERAL DATA CLEANING
# ==========================================================
# source("code/R/munge/munge_calamity.R")
# source("code/R/munge/munge_population.R")
# source("code/R/munge/munge_sgdp.R")
# source("code/R/munge/munge_state_level_vars.R")
# source("code/R/munge/munge_year_level_vars.R")

# ==========================================================
# FISCAL DATA CLEANING
# ==========================================================
source("code/R/src/01_create_fiscal_variables.R")
source("code/R/src/02_create_derived_fiscal_variables.R")
source("code/R/src/03_create_fiscal_indicators.R")
source("code/R/src/04_create_dependent_variables.R")
source("code/R/src/05_join_variables.R")

# ==========================================================
# FISCAL DATA COLLECTION
# ==========================================================
# source("code/R/munge/munge_rgf.R")
# source("code/R/munge/munge_rreo.R")
# ==========================================================
# source("code/R/munge/munge_rec_finbra.R")
# source("code/R/munge/munge_nat_emp_finbra.R")
# source("code/R/munge/munge_fun_emp_finbra.R")
# source("code/R/munge/munge_bp_finbra.R")
# ==========================================================
# source("code/R/munge/munge_fisregp.R")
# source("code/R/munge/munge_tbl_disp_caixa.R")
# source("code/R/munge/munge_tbl_primario.R")
# source("code/R/munge/munge_siga_brasil.R")
