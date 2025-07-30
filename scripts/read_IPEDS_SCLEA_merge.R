library(arrow)

# read in databases
sclea <- read_feather("processed/SCLEA_2012.feather") |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))
ipeds <- read_feather("processed/IPEDS_data_2012.feather") |>
  rename(IPEDS_ID = UNITID) |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))

library(dplyr)
library(readr)
library(stringr)
#install.packages("tidyr")
#install.packages("tidylog")
library("tidyr")
library("tidylog", warn.conflicts = FALSE)



# merge
ipeds_sclea <- ipeds_sclea |>
  full_join(sclea, ipeds, by = "IPEDS_ID")

# save merged file
write_feather(ipeds_sclea, "merges/merged_SCLEA_IPEDS.feather")
