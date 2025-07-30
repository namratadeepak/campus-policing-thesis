#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

df <- read_csv("raw/Civilytics Campus Police Data (2016).csv")  
write_feather(df, "processed/Civilytics_2016.feather")
