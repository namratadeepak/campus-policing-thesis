#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

load("data/raw/SCLEA 2012.rda")
df <- da36217.0001
arrow::write_feather(df, "data/processed/SCLEA_2012.feather")
