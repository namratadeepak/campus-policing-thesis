library(arrow)
setwd("/Users/namratadeepak/Desktop/campus_policing_thesis/data")
# read in databases
residence_hall_hate <- read_feather("processed/residencehallhate111213.feather")

residence_hall_discipline <- read_feather("processed/residencehalldiscipline111213.feather")

residence_hall_crime <- read_feather("processed/residencehallcrime111213.feather")

residence_hall_arrest <- read_feather("processed/residencehallarrest111213.feather")

reported_hate <- read_feather("processed/reportedhate111213.feather")

reported_discipline <- read_feather("processed/reporteddiscipline111213.feather")

reported_crime <- read_feather("processed/reportedcrime111213.feather")

reported_arrest <- read_feather("processed/reportedarrest111213.feather")

public_property_hate <- read_feather("processed/publicpropertyhate111213.feather")

public_property_discipline <- read_feather("processed/publicpropertydiscipline111213.feather")

public_property_crime <- read_feather("processed/publicpropertycrime111213.feather")

public_property_arrest <- read_feather("processed/publicpropertyarrest111213.feather")

oncampus_hate <- read_feather("processed/oncampushate111213.feather")

oncampus_discipline <- read_feather("processed/oncampusdiscipline111213.feather")

oncampus_crime <- read_feather("processed/oncampuscrime111213.feather")

oncampus_arrest <- read_feather("processed/oncampusarrest111213.feather")

noncampus_hate <- read_feather("processed/noncampushate111213.feather")

noncampus_discipline <- read_feather("processed/noncampusdiscipline111213.feather")

noncampus_crime <- read_feather("processed/noncampuscrime111213.feather")

noncampus_arrest <- read_feather("processed/noncampusarrest111213.feather")

# rename columns to prevent overlap
residence_hall_hate <- residence_hall_hate |>
  rename_with(~ paste0("residence_hall_hate_", .), -1)

residence_hall_discipline <- residence_hall_discipline |>
  rename_with(~ paste0("residence_hall_discipline_", .), -1)

residence_hall_crime <- residence_hall_crime |>
  rename_with(~ paste0("residence_hall_crime_", .), -1)

residence_hall_arrest <- residence_hall_arrest |>
  rename_with(~ paste0("residence_hall_arrest_", .), -1)

reported_hate <- reported_hate |>
  rename_with(~ paste0("reported_hate_", .), -1)

reported_discipline <- reported_discipline |>
  rename_with(~ paste0("reported_discipline_", .), -1)

reported_crime <- reported_crime |>
  rename_with(~ paste0("reported_crime_", .), -1)

reported_arrest <- reported_arrest |>
  rename_with(~ paste0("reported_arrest_", .), -1)

public_property_hate <- public_property_hate |>
  rename_with(~ paste0("public_property_hate_", .), -1)

public_property_discipline <- public_property_discipline |>
  rename_with(~ paste0("public_property_discipline_", .), -1)

public_property_crime <- public_property_crime |>
  rename_with(~ paste0("public_property_crime_", .), -1)


ed_data <- residence_hall_hate |>
  full_join(residence_hall_discipline, by = "UNITID_P") |>
  full_join(residence_hall_crime, by = "UNITID_P") |>
  full_join(residence_hall_arrest, by = "UNITID_P") |>
  full_join(reported_hate, by = "UNITID_P") |>
  full_join(reported_discipline, by = "UNITID_P") |>
  full_join(reported_crime, by = "UNITID_P") |>
  full_join(reported_arrest, by = "UNITID_P") |>
  full_join(public_property_hate, by = "UNITID_P") |>
  full_join(public_property_discipline, by = "UNITID_P") |>
  full_join(public_property_crime, by = "UNITID_P") |>
  full_join(public_property_arrest, by = "UNITID_P") |>
  full_join(oncampus_hate, by = "UNITID_P") |>
  full_join(oncampus_discipline, by = "UNITID_P") |>
  full_join(oncampus_crime, by = "UNITID_P") |>
  full_join(oncampus_arrest, by = "UNITID_P") |>
  full_join(noncampus_hate, by = "UNITID_P") |>
  full_join(noncampus_discipline, by = "UNITID_P") |>
  full_join(noncampus_crime, by = "UNITID_P") |>
  full_join(noncampus_arrest, by = "UNITID_P") |>
  rename(IPEDS_ID = UNITID_P)

# clean up data
ed_data <- ed_data |>
  mutate(
    residence_hall_hate_INSTNM = residence_hall_crime_INSTNM,
    residence_hall_hate_BRANCH = residence_hall_crime_BRANCH,
    residence_hall_hate_Address = residence_hall_crime_Address,
    residence_hall_hate_City = residence_hall_crime_City,
    residence_hall_hate_State = residence_hall_discipline_State,
    residence_hall_hate_ZIP = residence_hall_discipline_ZIP
  )

# remove duplicate columns
are_cols_equal <- function(col1, col2) {
  all(is.na(col1) == is.na(col2)) && all(col1 == col2, na.rm = TRUE)
}

keep_cols <- rep(TRUE, ncol(ed_data))
for (i in seq_along(ed_data)) {
  for (j in seq_len(i - 1)) {
    if (keep_cols[j] && are_cols_equal(ed_data[[i]], ed_data[[j]])) {
      keep_cols[i] <- FALSE
      break
    }
  }
}
ed_data <- ed_data |> select(which(keep_cols))

# save merged file
write_feather(ipeds_sclea, "merges/merged_Ed_Data_2012.feather")
