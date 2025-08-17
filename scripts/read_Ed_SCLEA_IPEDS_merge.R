library(tidyverse)
library(arrow)
library(readr)
library(tidyr)

ed_data <- read_feather("data/merges/merged_Ed_Data_2012.feather")
ipeds_sclea <- read_feather("data/merges/merged_SCLEA_IPEDS.feather")

# prep ed for merge (auto-detect UNITID_P col)
unitid_cols <- grep("UNITID", colnames(ed_data), value = TRUE)
print(unitid_cols)  # helpful debugging

if ("UNITID" %in% unitid_cols) {
  # Simple case: column is just UNITID
  ed_data <- ed_data |>
    rename(IPEDS_ID = UNITID)
  
} else if (any(grepl("UNITID_P$", unitid_cols))) {
  # Case: has *_UNITID_P style
  unitid_col <- grep("UNITID_P$", unitid_cols, value = TRUE)
  ed_data <- ed_data |>
    rename(IPEDS_ID_Suffix = !!sym(unitid_col)) |>
    mutate(IPEDS_ID = substr(IPEDS_ID_Suffix, 1, 6))
  
} else {
  stop("No recognizable UNITID column found in ed_data")
}

# prep ipeds_sclea for merge
ipeds_sclea <- ipeds_sclea |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))

# merge
ed_sclea_ipeds <- full_join(ipeds_sclea, ed_data, by = "IPEDS_ID")

# save
arrow::write_feather(ed_sclea_ipeds, "data/merges/Merged_Ed_SCLEA_IPEDS.feather")

