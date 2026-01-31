library(tidyverse)
library(arrow)
library(readr)
library(tidyr)

# read in databases
sclea <- read_feather("data/processed/SCLEA_2012.feather") |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))
ipeds <- read_feather("data/processed/IPEDS_data_2012.feather") |>
  rename(IPEDS_ID = UNITID) |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))

library(dplyr)
library(stringr)
#install.packages("tidyr")
#install.packages("tidylog")
library("tidyr")
library("tidylog", warn.conflicts = FALSE)



# merge
ipeds_sclea <- full_join(sclea, ipeds, by = "IPEDS_ID")

# save merged file
arrow::write_feather(ipeds_sclea, "data/merges/merged_SCLEA_IPEDS_2012.feather")
