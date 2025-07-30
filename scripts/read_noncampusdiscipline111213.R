#install.packages("tidyverse")
#install.packages("readr")
# install.packages("arrow")
library(tidyverse)
library(readr)
library(arrow)

df <- read_csv("raw/noncampusdiscipline111213.csv")  
write_feather(df, "processed/noncampusdiscipline111213.feather")
