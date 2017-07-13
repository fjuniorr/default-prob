misc::p(DT$ativos, "M")

DT %>% 
    filter(state == "mg") %>% 
    ggplot(aes(x = primario_bacen, y = primario)) + geom_point()

