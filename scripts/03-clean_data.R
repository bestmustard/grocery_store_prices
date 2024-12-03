#### Preamble ####
# Purpose: Cleans the raw 2020 CCES data recorded by Schaffner, Brian et.al 
# Author: Victor Ma
# Date: 03 December 2024
# Contact: victo.ma@mail.utoronto.ca

#### Workspace setup ####
library(tidyverse)
library(arrow) # Arrow is used for writing parquet

#### Clean data ####
raw_data <-
  read_csv("data/01-raw_data/raw_data.csv")

cleaned_data <-
  raw_data |>
  filter(votereg == 1, CC20_410 %in% c(1, 2)) |>
  mutate(
    voted_for = if_else(CC20_410 == 1, "Biden", "Trump"),
    voted_for = as_factor(voted_for),
    living = case_when(
      urbancity == 1 ~ "City",
      urbancity == 2 ~ "Suburb",
      urbancity == 3 ~ "Town",
      urbancity == 4~ "Rural area"
    ),
    living = factor(
      living,
      levels = c("City", "Suburb", "Town", "Rural area")
    ),
    employment = case_when(
      employ == 1 ~ "Full-time",
      employ == 2 ~ "Part-time",
      employ == 3 ~ "Temporarily laid off",
      employ == 4 ~ "Unemployed",
      employ == 5 ~ "Retired",
      employ == 6 ~ "Permanently disabled",
      employ == 7 ~ "Homemaker",
      employ == 8 ~ "Student"
    ),
    employment = factor(
      employment,
      levels = c("Full-time", "Part-time", "Temporarily laid off", "Unemployed", "Retired", "Permanently disabled", "Homemaker", "Student")
    ),
    income = case_when(
      faminc_new == 1 ~ "< 10k",
      faminc_new > 1 & faminc_new <= 5 ~ "10-50k",
      faminc_new > 5 & faminc_new <= 9 ~ "50-100k",
      faminc_new > 9 & faminc_new <= 12 ~ "100-200k",
      faminc_new > 12 & faminc_new <= 15 ~ "200-500k",
      faminc_new > 15 ~ "> 500k"
    ),
    income = factor(
      income,
      levels = c("< 10k", "10-50k", "50-100k", "100-200k", "200-500k", "> 500k")
    )
  ) |>
  select(voted_for, living, employment, income)

#### Save the data ####
write_csv(cleaned_data, "data/02-analysis_data/analysis_data.csv")
write_parquet(cleaned_data, "data/02-analysis_data/analysis_data.parquet")