library(arrow)
library(tidyverse)
library(readr)
library(tidyr)

civilytics_ed_sclea_ipeds <- read_feather("data/merges/Merged_Civilytics_Ed_SCLEA_IPEDS_2012.feather")
UCR <- read_feather("data/merges/Merged_UCR_2012.feather")

ucr_civilytics_ed_sclea_ipeds <- full_join(UCR, civilytics_ed_sclea_ipeds, by = "ORI_KEY")

arrow::write_feather(ucr_civilytics_ed_sclea_ipeds, "data/merges/Merged_UCR_Civilytics_Ed_SCLEA_IPEDS_2012.feather")
write.csv(ucr_civilytics_ed_sclea_ipeds, "data/merges/Merged_UCR_Civilytics_Ed_SCLEA_IPEDS.csv")
write.csv(ucr_civilytics_ed_sclea_ipeds, "data/merges/Merged_UCR_Civilytics_Ed_SCLEA_IPEDS.csv")
institution_list <- ucr_civilytics_ed_sclea_ipeds$INST_NAME
institution_list <- unique(institution_list)
write.csv(institution_list, "data/merges/institution_list.csv")
ORI_list <- ucr_civilytics_ed_sclea_ipeds$ORI_KEY
ORI_list

summary(ucr_civilytics_ed_sclea_ipeds)
