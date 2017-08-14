library(tidyverse); library(data.table); library(broom); library(margins); library(lmtest); library(brglm)
#library(arm); library(margins); library(Zelig); library(modelr)

source("code/R/lib/model_results.R")

DT <- fread("data/analytic_data.csv")
DT <- DT[year > 2008]
# ==========================================================
# dependent variable
# ==========================================================
y <- formula(calamity ~ .)
# ==========================================================
# specification - testing down
# ==========================================================
spec_full <- add_term(y, "capag_idc_zz_lag + capag_pc_zz_lag + capag_il_zz_lag + stn_sdrcl_zz_lag + stn_rpsd_zz_lag + stn_dprcl_zz_lag + stn_pidt_zz_lag + stn_pcrdp_zz_lag + stn_rtdc_zz_lag")
fit_full <- brglm(spec_full, family=binomial(link='logit'), data = DT)

spec_capag <- add_term(y, "capag_idc_zz_lag + capag_pc_zz_lag + capag_il_zz_lag")
fit_capag <- brglm(spec_capag, family=binomial(link='logit'), data = DT)

spec_stn <- add_term(y, "capag_idc_zz_lag + capag_pc_zz_lag + stn_sdrcl_zz_lag + stn_rpsd_zz_lag + stn_dprcl_zz_lag + stn_pidt_zz_lag + stn_pcrdp_zz_lag + stn_rtdc_zz_lag")
fit_stn <- brglm(spec_stn, data = DT)
# ==========================================================
# specification - testing up
# ==========================================================
spec_sdrcl <- add_term(y, "stn_sdrcl_lag")
fit_sdrcl <- brglm(spec_sdrcl, data = DT)

spec_rpsd <- add_term(y, "stn_rpsd_zz_lag")
fit_rpsd <- brglm(spec_rpsd, data = DT)

spec_dprcl <- add_term(y, "stn_dprcl_zz_lag")
fit_dprcl <- brglm(spec_dprcl, data = DT)

spec_pidt <- add_term(y, "stn_pidt_zz_lag")
fit_pidt <- brglm(spec_pidt, data = DT)

spec_pcrdp <- add_term(y, "stn_pcrdp_lag")
fit_pcrdp <- brglm(spec_pcrdp, data = DT)

spec_rtdc <- add_term(y, "stn_rtdc_lag")
fit_rtdc <- brglm(spec_rtdc, data = DT)


spec_capag_sdrcl <- add_term(spec_capag, "+ stn_sdrcl_zz_lag")
fit_capag_sdrcl <- brglm(spec_capag_sdrcl, data = DT)

spec_capag_dprcl <- add_term(spec_capag, "+ stn_dprcl_zz_lag")
fit_capag_dprcl <- brglm(spec_capag_dprcl, data = DT)

spec_capag_pidt <- add_term(spec_capag, "+ stn_pidt_zz_lag")
fit_capag_pidt <- brglm(spec_capag_pidt, data = DT)

spec_capag_dprcl_pidt <- add_term(spec_capag, "+ stn_dprcl_zz_lag + stn_pidt_zz_lag")
fit_capag_dprcl_pidt <- brglm(spec_capag_dprcl_pidt, data = DT)
