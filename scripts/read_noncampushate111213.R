#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

df <- read_csv("raw/noncampushate111213.csv")  
write_feather(df, "processed/noncampushate111213.feather")
