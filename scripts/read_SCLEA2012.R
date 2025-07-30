#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

load("raw/SCLEA 2012.rda")
df <- da36217.0001
write_feather(df, "processed/SCLEA_2012.feather")
