#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

df <- read_csv("data/raw/IPEDS data 2012.csv")  
arrow::write_feather(df, "data/processed/IPEDS_data_2012.feather")
