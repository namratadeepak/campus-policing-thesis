#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

df <- read_csv("raw/publicpropertycrime111213.csv")  
write_feather(df, "processed/publicpropertycrime111213.feather")
