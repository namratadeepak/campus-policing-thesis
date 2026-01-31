library(readr)
library(dplyr)
library(purrr)
library(stringr)

filenames <- c(
  "data/raw/residencehallhate212223.csv",
  "data/raw/residencehalldiscipline212223.csv",
  "data/raw/residencehallcrime212223.csv",
  "data/raw/residencehallarrest212223.csv",
  "data/raw/reportedhate212223.csv",
  "data/raw/reporteddiscipline212223.csv",
  "data/raw/reportedcrime212223.csv",
  "data/raw/reportedarrest212223.csv",
  "data/raw/publicpropertyhate212223.csv",
  "data/raw/publicpropertydiscipline212223.csv",
  "data/raw/publicpropertycrime212223.csv",
  "data/raw/publicpropertyarrest212223.csv",
  "data/raw/oncampushate212223.csv",
  "data/raw/oncampusdiscipline212223.csv",
  "data/raw/oncampuscrime212223.csv",
  "data/raw/oncampusarrest212223.csv",
  "data/raw/noncampushate212223.csv",
  "data/raw/noncampusdiscipline212223.csv",
  "data/raw/noncampuscrime212223.csv",
  "data/raw/noncampusarrest212223.csv"
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

ed_data <- ed_data |> select(which(keep_cols)) |>
  mutate(IPEDS_ID = substr(ed_data[[1]], 1, 6))


arrow::write_feather(ed_data, "data/merges/merged_Ed_Data_2023.feather")


civilytics <- read_feather("data/processed/Civilytics_2016.feather")

civilytics <- civilytics |>
  rename(IPEDS_ID = IPEDS_KEY) |>
  mutate(IPEDS_ID = as.character(IPEDS_ID))

ed_civilytics <- full_join(ed_data, civilytics, by = "IPEDS_ID")

institution_list <- ed_civilytics |>
  select(residencehallhate212223_INSTNM, residencehallhate212223_UNITID_P, residencehallhate212223_State, ORI_KEY) |>
  distinct(residencehallhate212223_INSTNM, .keep_all = TRUE)

write_csv(institution_list, "data/processed/institution_list_212223.csv")
