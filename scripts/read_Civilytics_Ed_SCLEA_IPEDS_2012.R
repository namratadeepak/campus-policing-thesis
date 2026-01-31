library(arrow)
library(tidyverse)
library(readr)
library(tidyr)

ed_sclea_ipeds <- read_feather("data/merges/Merged_Ed_SCLEA_IPEDS_2012.feather")
civilytics <- read_feather("data/processed/Civilytics_2016.feather")

# edit to match ed_sclea_ipeds data
civilytics <- civilytics |>
  rename(IPEDS_ID = IPEDS_KEY) |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))

ed_sclea_ipeds <- ed_sclea_ipeds |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))

# merge
civilytics_ed_sclea_ipeds <- full_join(civilytics, ed_sclea_ipeds, by = "IPEDS_ID", relationship = "many-to-many")

#
arrow::write_feather(civilytics_ed_sclea_ipeds, "data/merges/Merged_Civilytics_Ed_SCLEA_IPEDS_2012.feather")
