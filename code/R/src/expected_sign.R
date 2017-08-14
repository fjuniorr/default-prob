brglm(calamity ~ capag_idc_zz_lag , data = DT) %>%
    summary()
lm(capag_idc_lag ~ calamity, data = DT) %>%
    summary()


brglm(calamity ~ capag_pc_zz_lag , data = DT) %>%
    summary()
lm(capag_pc_lag ~ calamity, data = DT) %>%
    summary()


brglm(calamity ~ capag_il_zz_lag , data = DT) %>%
    summary()
lm(capag_il_lag ~ calamity, data = DT) %>%
    summary()


brglm(calamity ~ stn_sdrcl_zz_lag , data = DT) %>%
    summary()
lm(stn_sdrcl_lag ~ calamity, data = DT) %>%
    summary()


brglm(calamity ~ stn_rpsd_zz_lag , data = DT) %>%
    summary()
lm(stn_rpsd_lag ~ calamity, data = DT) %>%
    summary()


brglm(calamity ~ stn_dprcl_zz_lag , data = DT) %>%
    summary()
lm(stn_dprcl_lag ~ calamity, data = DT) %>%
    summary()


brglm(calamity ~ stn_pidt_zz_lag , data = DT) %>%
    summary()
lm(stn_pidt_lag ~ calamity, data = DT) %>%
    summary()


brglm(calamity ~ stn_pcrdp_zz_lag , data = DT) %>%
    summary()
lm(stn_pcrdp_lag ~ calamity, data = DT) %>%
    summary()


brglm(calamity ~ stn_rtdc_zz_lag, data = DT) %>%
    summary()
lm(stn_rtdc_lag~ calamity, data = DT) %>%
    summary()

