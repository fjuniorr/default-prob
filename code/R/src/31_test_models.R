# http://www.talkstats.com/showthread.php/8796-Comparing-across-non-nested-binomial-logistic-regressions-(using-AIC-)

# ==========================================================
results(fit_full)
results(fit_capag)
results(fit_stn)

lrtest(fit_capag, fit_full) # do not reject the null (the restricted model capag)
lrtest(fit_stn, fit_full) # reject the null (the restricted model stn)

test1 <- 2*(glance(fit_full)[, "logLik"] - glance(fit_capag)[, "logLik"])
pchisq(test1, df = 6, lower.tail = FALSE)

test2 <- 2*(glance(fit_full)[, "logLik"] - glance(fit_stn)[, "logLik"])
pchisq(test2, df = 1, lower.tail = FALSE)


# ==========================================================

results(fit_rpsd) # exclude
results(fit_pcrdp) # exclude
results(fit_rtdc) # exclude

results(fit_sdrcl)
results(fit_dprcl)
results(fit_pidt)
# ==========================================================
results(fit_capag_sdrcl)
results(fit_capag)
lrtest(fit_capag, fit_capag_sdrcl) # exclude

results(fit_capag_dprcl)
results(fit_capag)
lrtest(fit_capag, fit_capag_dprcl) # exclude

results(fit_capag_pidt)
results(fit_capag)
lrtest(fit_capag, fit_capag_pidt) # keep


# ==========================================================
results(fit_capag_dprcl_pidt)
lrtest(fit_capag, fit_capag_dprcl_pidt)
test3 <- 2*(glance(fit_capag_dprcl_pidt)[, "logLik"] - glance(fit_capag)[, "logLik"])
pchisq(test3, df = 2, lower.tail = FALSE)

# 
# margins(fit_capag)
# margins(fit_capag_pidt)
# 
# DT[, pd_capag := formattable::accounting(predict(fit_capag, type = "response"))]
# DT[, pd_capag_pidt := formattable::accounting(predict(fit_capag_pidt, type = "response"))]
# 
# 
# 
# new_DT <- data.frame(id = c("mg2016", "mg2016 - more investment", "sample-avg", "sample-avg - more investment"),
#                      capag_idc_zz_lag = c(1.042323, 1.042323, mean(DT$capag_idc_zz), mean(DT$capag_idc_zz)), 
#                      capag_pc_zz_lag = c(1.155797, 1.155797, mean(DT$capag_pc_zz), mean(DT$capag_pc_zz)),
#                      capag_il_zz_lag = c(2.298733, 2.298733, mean(DT$capag_il_zz), mean(DT$capag_il_zz)),
#                      stn_pidt_zz_lag = c(-0.5813268, -0.5813268 + 0.5038836, mean(DT$stn_pidt_zz), mean(DT$stn_pidt_zz) + 1.5))
# 
# predict(fit_capag, newdata = new_DT, type = "response") %>% 
# predict(fit_capag_pidt, newdata = new_DT, type = "response") %>% formattable::accounting()
# 
# DT[id == "mg2016", .(pd_capag, pd_capag_pidt, capag_idc_zz_lag, capag_pc_zz_lag,capag_il_zz_lag,stn_pidt_zz_lag)]
# 
# DT[calamity == TRUE]
