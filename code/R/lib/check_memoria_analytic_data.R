check_memoria <- function(memoria, expr, .data) {
    ret <- NULL
                
    if(memoria != "NA") {
        
        cols <- memoria %>% 
            strsplit("-|\\+") %>% 
            unlist() %>% 
            gsub("\\s", "" , .)
        
        if(expr %in% names(.data)) {
            cols <- c(expr, cols)
            new_col <- paste0(expr, "_dv")
        } else {
            new_col <- expr
        }
        
       ret <- .data[, c("id", cols), with = F] 
       ret[, calculo := memoria]
       ret[, ans:=f(calculo,.SD), by=calculo, .SDcols=cols]
       setnames(ret, "ans", new_col)
       
       if(grepl("_dv$", new_col)) {
           ret$diff <- ret[[expr]] - ret[[new_col]]
       }
       
    }
    ret
}

f <- function(e, .SD) eval(parse(text=e[1]), envir=.SD)





