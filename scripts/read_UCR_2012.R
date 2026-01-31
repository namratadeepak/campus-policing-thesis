library(arrow)
library(tidyverse)
library(readr)
library(tidyr)
library(stringr)

load("data/raw/LEOKA 2012.rda", verbose = TRUE)
load("data/raw/UCR Property 2012.rda")
load("data/raw/UCR Hate Crime 2012.rda")
load("data/raw/UCR Arrests 2012.rda")


leoka <- da35020.0001
UCR_property <- da35022.0001
UCR_hate_crime <- da35086.0002
UCR_arrests <- da35018.0001
civilytics_ed_sclea_ipeds <- read_feather("data/merges/Merged_Civilytics_Ed_SCLEA_IPEDS.feather")

# leoka clean up
colnames(leoka) <- attr(leoka, "variable.labels")
leoka <- leoka |>
  rename(ORI_KEY = `ORI CODE`) |>
  semi_join(civilytics_ed_sclea_ipeds, by = "ORI_KEY")

# UCR Property clean up

colnames(UCR_property) <- attr(UCR_property, "variable.labels")

  # make column names unique
  names(UCR_property) <- make.unique(names(UCR_property))
  base_names <- str_replace(names(UCR_property), "\\.\\d+$", "")

  # identify duplicates
  dup_names <- base_names[duplicated(base_names)] |> unique()
  merged <- dup_names |>
    setNames(dup_names) |>
    lapply(function(name) {
      cols <- UCR_property[, base_names == name, drop = FALSE]
      
      # Convert only these columns to numeric
      cols_numeric <- cols |> mutate(across(everything(), ~ as.numeric(as.character(.))))
      
      rowSums(cols_numeric, na.rm = TRUE)
    }) |>
    as_tibble()
  
  #keep non-duplicated columns non-numeric
  non_dup <- UCR_property[, !base_names %in% dup_names]
  
  #combine
  UCR_property_clean <- bind_cols(non_dup, merged)


UCR_property <- UCR_property |>
  rename(ORI_KEY = `ORI CODE ORIGINATING AGENCY IDENTIFIER`) |>
  semi_join(civilytics_ed_sclea_ipeds, by = "ORI_KEY")

# UCR hate crime clean up
UCR_hate_crime <- UCR_hate_crime |>
  mutate(ORI_KEY = substr(ORI, 1, 7)) |>
  semi_join(civilytics_ed_sclea_ipeds, by = "ORI_KEY")

# UCR arrests clean up
UCR_arrests <- UCR_arrests |>
  rename(ORI_KEY = ORI) |>
  semi_join(civilytics_ed_sclea_ipeds, by = "ORI_KEY")


leoka_property <- full_join(leoka, UCR_property, by = "ORI_KEY")
leoka_property_hatecrime <- full_join(leoka_property, UCR_hate_crime, by = "ORI_KEY")
UCR_combined <- full_join(leoka_property_hatecrime, UCR_arrests, by = "ORI_KEY")

#check for duplicates
are_cols_equal <- function(col1, col2) {
  all(is.na(col1) == is.na(col2)) && all(col1 == col2, na.rm = TRUE)
}


keep_cols <- rep(TRUE, ncol(UCR_combined))

for (i in seq_along(UCR_combined)) {
  for (j in seq_len(i - 1)) {
    same_name <- names(UCR_combined)[i] == names(UCR_combined)[j]
    if (keep_cols[j] && same_name && are_cols_equal(UCR_combined[[i]], UCR_combined[[j]])) {
      keep_cols[i] <- FALSE
      break
    }
  }
}

UCR_combined <- UCR_combined |> select(which(keep_cols))

# save
arrow::write_feather(UCR_combined, "data/merges/Merged_UCR_2012.feather")

