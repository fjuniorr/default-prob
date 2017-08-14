library(GGally)

DT[, idc := idc(capag_idc_lag)]
DT[, pc := pc(capag_pc_lag)]
DT[, il := il(capag_il_lag)]
DT[, capag := capag(idc, pc, il)]

DT$pd %>% summary()

DT[, .(id, state, year, pd, capag,
       capag_idc, capag_idc_lag, idc,
       capag_pc, capag_pc_lag, pc,
       capag_il, capag_il_lag, il)] %>% 
    write_csv("capag.csv")


ggplot(DT, aes(x = capag, y = pd)) + geom_jitter()

ggplot(DT, aes(x = capag_idc_lag, y = pd, color = capag)) + geom_point()
ggplot(DT, aes(x = capag_pc_lag, y = pd, color = capag)) + geom_point()
ggplot(DT, aes(x = capag_il_lag, y = pd, color = capag)) + geom_point()

pairs(DT[, .(pd, capag_idc_lag, capag_pc_lag, capag_il_lag)])

ggscatmat(DT, columns = c("pd", "capag_idc_lag", "capag_pc_lag", "capag_il_lag"))


idc <- function(x) {
    ifelse(x < 0.6, "A",
           ifelse(x > 1.5, "C",
                  ifelse(x > 0.6 & x < 1.5,"B",NA_character_)))
}

pc <- function(x) {
    ifelse(x < 0.9, "A",
           ifelse(x > 0.95, "C",
                  ifelse(x > 0.9 & x < 0.95,"B",NA_character_)))
}


il <- function(x) {
    ifelse(x < 1, "A",
           ifelse(x > 1, "C", NA_real_))
}

capag <- function(idc, pc, il) {
    mark <- paste0(idc, pc, il)
    rating <- c(AAA = "A", ABA = "B", ACA = "B", BAA = "B", BBA = "B", 
                BCA = "B", CAA = "C", CBA = "C", CCA = "C", AAC = "C", 
                ABC = "C", ACC = "C", BAC = "C", BBC = "C", BCC = "C", 
                CAC = "C", CBC = "C", CCC = "D")
    rating[mark]
}
