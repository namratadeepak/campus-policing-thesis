#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

df <- read_csv("raw/IPEDS data 2012.csv")  
write_feather(df, "processed/IPEDS_data_2012.feather")
