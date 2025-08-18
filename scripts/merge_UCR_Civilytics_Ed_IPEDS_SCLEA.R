library(arrow)
library(tidyverse)
library(readr)
library(tidyr)

civilytics_ed_sclea_ipeds <- read_feather("data/merges/Merged_Civilytics_Ed_SCLEA_IPEDS.feather")
UCR <- read_feather("data/merges/Merged_UCR_2012.feather")

ucr_civilytics_ed_sclea_ipeds <- full_join(UCR, civilytics_ed_sclea_ipeds, by = "ORI_KEY")

arrow::write_feather(ucr_civilytics_ed_sclea_ipeds, "data/merges/Merged_UCR_Civilytics_Ed_SCLEA_IPEDS.feather")