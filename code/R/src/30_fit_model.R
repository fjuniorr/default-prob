library(tidyverse); library(data.table); library(margins); library(Zelig)

DT <- fread("data/analytic_data.csv")

spec1 <- formula(default ~ stn_end + stn_rpsd + stn_dprcl + stn_cgpp + stn_pidt)

logit1 <- glm(formula = spec1,
              data = DT, 
              family=binomial(link='logit'))

summary(logit1)

spec2 <- formula(default ~ capag_idc + capag_pc)

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
