# prep ed for merge
ed_data <- ed_data |>
  rename(IPEDS_ID_Suffix = IPEDS_ID) |>
  mutate(IPEDS_ID = substr(IPEDS_ID_Suffix, 1, 6)) 

# prep ipeds_sclea for merge
ipeds_sclea <- ipeds_sclea |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))

# merge
ed_sclea_ipeds <- ed_sclea_ipeds |>
  full_join(ipeds_sclea, ed_data, by = "IPEDS_ID")

# save
write_feather(ed_sclea_ipeds, "merges/Merged_Ed_SCLEA_IPEDS.feather")