library(readr)
library(dplyr)
library(purrr)
library(stringr)

filenames <- c(
  "raw/residencehallhate111213.csv",
  "raw/residencehalldiscipline111213.csv",
  "raw/residencehallcrime111213.csv",
  "raw/residencehallarrest111213.csv",
  "raw/reportedhate111213.csv",
  "raw/reporteddiscipline111213.csv",
  "raw/reportedcrime111213.csv",
  "raw/reportedarrest111213.csv",
  "raw/publicpropertyhate111213.csv",
  "raw/publicpropertydiscipline111213.csv",
  "raw/publicpropertycrime111213.csv",
  "raw/publicpropertyarrest111213.csv",
  "raw/oncampushate111213.csv",
  "raw/oncampusdiscipline111213.csv",
  "raw/oncampuscrime111213.csv",
  "raw/oncampusarrest111213.csv",
  "raw/noncampushate111213.csv",
  "raw/noncampusdiscipline111213.csv",
  "raw/noncampuscrime111213.csv",
  "raw/noncampusarrest111213.csv"
)

ed_data <- map(filenames, ~ {
  label <- tools::file_path_sans_ext(basename(.x))
  
  read_csv(.x, show_col_types = FALSE) |>
    rename_with(~ paste0(label, "_", .x))
})

ed_data <- bind_cols(ed_data)

are_cols_equal <- function(col1, col2) {
  all(is.na(col1) == is.na(col2)) && all(col1 == col2, na.rm = TRUE)
}

strip_prefix <- function(name) sub("^[^_]+_", "", name)

keep_cols <- rep(TRUE, ncol(ed_data))

for (i in seq_along(ed_data)) {
  for (j in seq_len(i - 1)) {
    same_name <- strip_prefix(names(ed_data)[i]) == strip_prefix(names(ed_data)[j])
    if (keep_cols[j] && same_name && are_cols_equal(ed_data[[i]], ed_data[[j]])) {
      keep_cols[i] <- FALSE
      break
    }
  }
}
ed_data <- ed_data |> select(which(keep_cols))
write_feather(ipeds_sclea, "merges/merged_Ed_Data_2012.feather")
