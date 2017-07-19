library(tidyverse); library(data.table); library(margins); library(Zelig); library(broom)

DT <- fread("data/analytic_data.csv")

DT[id %in% c("rj2014", "rs2014", "mg2014"), default := 1]

fit <- glm(formula = default ~ I(primario / rec_primaria) + 
                               I(net_debt_bacen / gdp) + 
                               I(dbp / rcl),
              data = DT, 
              family=binomial(link='logit'))

summary(fit)

spec1 <- formula(default ~ stn_end + stn_sdrcl + stn_rpsd + stn_dprcl + stn_cgpp + stn_pidt + stn_pcrdp + stn_rtdc)

logit1 <- glm(formula = spec1,
              data = DT, 
              family=binomial(link='logit'))

summary(logit1)

spec2 <- formula(default ~ capag_idc + capag_pc + capag_il)

logit2 <- glm(formula = spec2,
              data = DT, 
              family=binomial(link='logit'))

summary(logit2)

mfx_logit <- margins(logit2)
mfx_logit <- as.data.frame(summary(mfx_logit))
mfx_logit <- mfx_logit[, c("factor", "AME", "SE", "z", "p")]
names(mfx_logit) <- c("term", "estimate", "std.error", "statistic", "p.value")
mfx_logit$model <- "logit"


logit3 <- zelig(spec2, model = "relogit", bias.correct = TRUE, data = DT)

summary(logit3)


bayes <- bayesglm(spec2, data=DT, family="binomial")
display(bayes)
summary(bayes)
