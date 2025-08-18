#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

civilytics <- read_csv("data/raw/Civilytics Campus Police Data (2016).csv")  
arrow::write_feather(civilytics, "data/processed/Civilytics_2016.feather")
