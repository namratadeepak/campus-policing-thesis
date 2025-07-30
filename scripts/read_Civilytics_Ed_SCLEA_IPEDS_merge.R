library(arrow)
library(dplyr)
civilytics <- read_feather("processed/Civilytics_2016.feather")

# edit to match ed_sclea_ipeds data
civilytics <- civilytics |>
  rename(IPEDS_ID = IPEDS_KEY) |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))

ed_sclea_ipeds <- ed_sclea_ipeds |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))

# merge
civilytics_ed_sclea_ipeds <- full_join(civilytics, ed_sclea_ipeds, by = "IPEDS_ID") 

#
write_feather(civilytics_ed_sclea_ipeds, "merges/Merged_Civilytics_Ed_SCLEA_IPEDS.feather")
