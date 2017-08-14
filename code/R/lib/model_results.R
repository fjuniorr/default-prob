add_term <- function(formula, term) {
    txt <- paste0(deparse(formula, width.cutoff = 500), " " ,term)
    txt <- stringr::str_replace(txt, "\\.", "")
    as.formula(txt, env = environment(formula))
}

results <- function(x, pretty = TRUE, digits = 3) {

    DF <- broom::tidy(x)
    
    if(pretty == TRUE) {
        DF$estimate <- formattable::comma(DF$estimate, digits)
        DF$std.error <- formattable::comma(DF$std.error, digits)
        DF$statistic <- formattable::comma(DF$statistic, digits)
        DF$p.value <- formattable::comma(DF$p.value, digits)
    }
    DF <- data.table::data.table(DF)
    
    DF[estimate > 0, sign := "+"]
    DF[estimate < 0, sign := "-"]
    DF[p.value < 0.01, signif := "***"]
    DF[is.na(signif) & p.value > 0.01 & p.value < 0.05, signif := "**"]
    DF[is.na(signif) & p.value > 0.05 & p.value < 0.1, signif := "*"]
    
    DF[, .(term, estimate, p.value, signif, sign, std.error, statistic)]
}

mfx <- function(fit, link = c("logit", "probit", "clogit"), terms = NULL){
    link <- match.arg(link)
    fun <- list(logit = dlogis, probit = dnorm)
    
    effect <- fun[[link]](predict(fit)) %*% t(coef(fit))
    avg_effect <- colMeans(effect)
    DF <- data.table::data.table(model = link,
                                 term = names(avg_effect),
                                 mfx = avg_effect)
    
    if(is.null(terms)) {
        DF
    } else {
        stopifnot(terms %in% names(coef(fit)))
        DF[term %in% terms]
    }
}