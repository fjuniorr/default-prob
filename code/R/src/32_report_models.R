library(stargazer)
#====================================================
# table of coeficients

labels_down <- c(capag_idc_zz_lag = "Gross debt / Net current revenue",
            capag_pc_zz_lag = "Current expenses / Current revenue",
            capag_il_zz_lag = "Current liabilities / Cash and cash equivalents",
            stn_sdrcl_zz_lag = "Debt service / Net current revenue",
            stn_rpsd_zz_lag = "Primary balance / Debt service",
            stn_dprcl_zz_lag = "Compensation of employees / Net current revenue",
            stn_pidt_zz_lag = "Gross investment in nonfinancial assets / Total expenditure",
            stn_pcrdp_zz_lag = "Social contributions / Social benefits",
            stn_rtdc_zz_lag = "Tax revenues / (Current expenses + Principal payments)")

stargazer(fit_full, fit_capag, fit_stn,
          title = "Regression results for binary dependent variable - Testing down",
          label = "tbl:model_coef_test_down",
          dep.var.caption = "",
          dep.var.labels.include = FALSE,
          covariate.labels = labels_down,
          align = TRUE,
          omit.table.layout = "n", # ommit notes
          out = "results/tables/model_coef_test_down.tex")


labels_up <- c(capag_idc_zz_lag = "Gross debt / Net current revenue",
                 capag_pc_zz_lag = "Current expenses / Current revenue",
                 capag_il_zz_lag = "Current liabilities / Cash and cash equivalents",
                 stn_sdrcl_zz_lag = "Debt service / Net current revenue",
                 stn_dprcl_zz_lag = "Compensation of employees / Net current revenue",
                 stn_pidt_zz_lag = "Gross investment in nonfinancial assets / Total expenditure")

stargazer(fit_capag, fit_capag_sdrcl, fit_capag_dprcl, fit_capag_pidt, fit_capag_dprcl_pidt,
          title = "Regression results for binary dependent variable - Testing up",
          label = "tbl:model_coef_test_up",
          dep.var.caption = "",
          dep.var.labels.include = FALSE,
          covariate.labels = labels_up,
          align = TRUE,
          omit.table.layout = "n", # ommit notes
          out = "results/tables/model_coef_test_up.tex")
