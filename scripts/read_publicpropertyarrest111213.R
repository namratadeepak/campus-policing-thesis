#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

df <- read_csv("raw/publicpropertyarrest111213.csv")  
write_feather(df, "processed/publicpropertyarrest111213.feather")
