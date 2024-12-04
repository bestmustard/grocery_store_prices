#### Preamble ####
# Purpose: Simulates the 2020 presidential election results by employment, income, and living environment
# Author: Victor Ma
# Date: 3 December 2024
# Contact: victo.ma@mail.utoronto.ca
# In this simulation I use code from Rohan Alexander

#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
set.seed(853)

num_obs <- 1000

us_political_preferences <- tibble( # simulate an example election
  employment = sample(0:7, size = num_obs, replace = TRUE), # employment categories
  income = sample(0:4, size = num_obs, replace = TRUE),     # income levels
  living = sample(0:3, size = num_obs, replace = TRUE),     # living environments
  support_prob = ((employment + income + living) / 12),    # simplified probability model
) |>
  mutate(
    supports_biden = if_else(runif(n = num_obs) < support_prob, "yes", "no"),
    employment = case_when(
      employment == 0 ~ "Full-time",
      employment == 1 ~ "Part-time",
      employment == 2 ~ "Unemployed",
      employment == 3 ~ "Temporarily laid off",
      employment == 4 ~ "Retired",
      employment == 5 ~ "Permanently disabled",
      employment == 6 ~ "Homemaker",
      employment == 7 ~ "Student"
    ),
    income = case_when(
      income == 0 ~ "< 10k",
      income == 1 ~ "10-50k",
      income == 2 ~ "50-100k",
      income == 3 ~ "100-200k",
      income == 4 ~ "> 200k"
    ),
    living = case_when(
      living == 0 ~ "City",
      living == 1 ~ "Suburb",
      living == 2 ~ "Town",
      living == 3 ~ "Rural area"
    )
  ) |>
  select(-support_prob, supports_biden, employment, income, living)

#### Save simulated data to CSV ####
write_csv(us_political_preferences, "data/00-simulated_data/simulated_data.csv")
