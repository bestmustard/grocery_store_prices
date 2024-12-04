#### Preamble ####
# Purpose: Tests the structure and validity of the simulated U.S. political preferences dataset
# Author: Victor Ma
# Date: 3 December 2024
# Contact: victo.ma@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - The `tidyverse` package must be installed and loaded
# - The simulated dataset must be generated and saved to "data/00-simulated_data/simulated_data.csv"

#### Workspace setup ####
library(tidyverse)

simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")

#### Test if the dataset is loaded correctly ####
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data structure ####

# Check if the dataset has the correct number of rows
expected_rows <- 1000
if (nrow(simulated_data) == expected_rows) {
  message("Test Passed: The dataset has ", expected_rows, " rows.")
} else {
  stop("Test Failed: The dataset does not have ", expected_rows, " rows.")
}

# Check if the dataset has the correct number of columns
expected_columns <- 4
if (ncol(simulated_data) == expected_columns) {
  message("Test Passed: The dataset has ", expected_columns, " columns.")
} else {
  stop("Test Failed: The dataset does not have ", expected_columns, " columns.")
}

#### Test for column names ####
expected_columns <- c("employment", "income", "living", "supports_biden")
if (all(names(simulated_data) %in% expected_columns)) {
  message("Test Passed: All columns are correctly named.")
} else {
  stop("Test Failed: Column names are incorrect.")
}

#### Test for unique values ####

# Employment categories
valid_employment <- c(
  "Full-time", "Part-time", "Unemployed", "Temporarily laid off",
  "Retired", "Permanently disabled", "Homemaker", "Student"
)
if (all(simulated_data$employment %in% valid_employment)) {
  message("Test Passed: The 'employment' column contains only valid values.")
} else {
  stop("Test Failed: The 'employment' column contains invalid values.")
}

# Income categories
valid_income <- c("< 10k", "10-50k", "50-100k", "100-200k", "> 200k")
if (all(simulated_data$income %in% valid_income)) {
  message("Test Passed: The 'income' column contains only valid values.")
} else {
  stop("Test Failed: The 'income' column contains invalid values.")
}

# Living categories
valid_living <- c("City", "Suburb", "Town", "Rural area")
if (all(simulated_data$living %in% valid_living)) {
  message("Test Passed: The 'living' column contains only valid values.")
} else {
  stop("Test Failed: The 'living' column contains invalid values.")
}

#### Test for missing and invalid data ####

# Check for missing values
if (all(!is.na(simulated_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check for empty strings
if (all(simulated_data$employment != "" & simulated_data$income != "" & simulated_data$living != "")) {
  message("Test Passed: There are no empty strings in any columns.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

#### Test for sufficient variation ####

# Check that all columns have at least two unique values
columns_to_check <- c("employment", "income", "living")
for (col in columns_to_check) {
  if (n_distinct(simulated_data[[col]]) >= 2) {
    message("Test Passed: The '", col, "' column contains sufficient variation.")
  } else {
    stop("Test Failed: The '", col, "' column lacks sufficient variation.")
  }
}

#### Statistical Distribution Tests ####

# Test the distribution of employment categories
employment_distribution <- simulated_data %>%
  group_by(employment) %>%
  summarize(count = n())
message("Employment Distribution:")
print(employment_distribution)

# Test the distribution of income categories
income_distribution <- simulated_data %>%
  group_by(income) %>%
  summarize(count = n())
message("Income Distribution:")
print(income_distribution)

# Test the distribution of living categories
living_distribution <- simulated_data %>%
  group_by(living) %>%
  summarize(count = n())
message("Living Distribution:")
print(living_distribution)

#### Test for invalid probabilities ####

# Check if any simulated probabilities are outside [0, 1]
invalid_probabilities <- simulated_data %>%
  filter(support_prob < 0 | support_prob > 1)
if (nrow(invalid_probabilities) == 0) {
  message("Test Passed: No probabilities are outside the valid range.")
} else {
  stop("Test Failed: There are probabilities outside the valid range.")
}

#### Final summary ####
message("All tests completed.")
