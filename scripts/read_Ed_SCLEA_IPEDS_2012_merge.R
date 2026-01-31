library(tidyverse)
library(arrow)
library(readr)
library(tidyr)

ed_data <- read_feather("data/merges/merged_Ed_Data_2012.feather")
ipeds_sclea <- read_feather("data/merges/merged_SCLEA_IPEDS_2012.feather")


# prep ipeds_sclea for merge
ipeds_sclea <- ipeds_sclea |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))

# merge
ed_sclea_ipeds <- full_join(ipeds_sclea, ed_data, by = "IPEDS_ID")

# save
arrow::write_feather(ed_sclea_ipeds, "data/merges/Merged_Ed_SCLEA_IPEDS_2012.feather")

