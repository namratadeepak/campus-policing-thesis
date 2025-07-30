#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

df <- read_csv("raw/residencehallcrime111213.csv")  
write_feather(df, "processed/residencehallcrime111213.feather")
