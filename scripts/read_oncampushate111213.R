#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

df <- read_csv("raw/oncampushate111213.csv")  
write_feather(df, "processed/oncampushate111213.feather")
