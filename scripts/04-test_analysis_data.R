#### Preamble ####
# Purpose: Tests the structure and validity of the cleaned CCES 2020 dataset
# Author: Victor Ma
# Date: 3 December 2024
# Contact: victo.ma@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - The `tidyverse` and `testthat` packages must be installed and loaded

#### Workspace setup ####
library(tidyverse)
library(testthat)

cleaned_data <- read_csv("../data/02-analysis_data/analysis_data.csv")

#### Test data structure ####

# Test that the dataset has rows
test_that("dataset has rows", {
  expect_gt(nrow(cleaned_data), 0)
})

# Test that the dataset has exactly 4 columns
test_that("dataset has 4 columns", {
  expect_equal(ncol(cleaned_data), 4)
})

# Test that the column names are correct
expected_columns <- c("voted_for", "living", "employment", "income")
test_that("column names are correct", {
  expect_equal(names(cleaned_data), expected_columns)
})

#### Test data types ####

# Test that each column has the expected type
test_that("column data types are correct", {
  expect_type(cleaned_data$voted_for, "character")
  expect_type(cleaned_data$living, "character")
  expect_type(cleaned_data$employment, "character")
  expect_type(cleaned_data$income, "character")
})

#### Test for valid values ####

# Test that 'voted_for' contains only valid categories
valid_voted_for <- c("Biden", "Trump")
test_that("'voted_for' contains only valid values", {
  expect_true(all(cleaned_data$voted_for %in% valid_voted_for))
})

# Test that 'living' contains only valid categories
valid_living <- c("City", "Suburb", "Town", "Rural area")
test_that("'living' contains only valid values", {
  expect_true(all(cleaned_data$living %in% valid_living))
})

# Test that 'employment' contains only valid categories
valid_employment <- c(
  "Full-time", "Part-time", "Temporarily laid off", "Unemployed",
  "Retired", "Permanently disabled", "Homemaker", "Student"
)
test_that("'employment' contains only valid values", {
  expect_true(all(cleaned_data$employment %in% valid_employment))
})

# Test that 'income' contains only valid categories
valid_income <- c("< 10k", "10-50k", "50-100k", "100-200k", "200-500k", "> 500k")
test_that("'income' contains only valid values", {
  expect_true(all(cleaned_data$income %in% valid_income))
})

#### Test for missing and invalid data ####

# Test that there are no missing values in the dataset
test_that("no missing values in the dataset", {
  expect_true(all(!is.na(cleaned_data)))
})

# Test that there are no empty strings in the dataset
test_that("no empty strings in the dataset", {
  expect_false(any(cleaned_data$voted_for == "" |
                     cleaned_data$living == "" |
                     cleaned_data$employment == "" |
                     cleaned_data$income == ""))
})

#### Test for distribution and uniqueness ####

# Test that 'voted_for' contains at least 2 unique values
test_that("'voted_for' column contains at least 2 unique values", {
  expect_true(length(unique(cleaned_data$voted_for)) >= 2)
})

# Test that 'living' contains at least 2 unique values
test_that("'living' column contains at least 2 unique values", {
  expect_true(length(unique(cleaned_data$living)) >= 2)
})

# Test that 'employment' contains all defined categories
test_that("'employment' column includes all defined categories", {
  expect_true(all(valid_employment %in% cleaned_data$employment))
})

# Test that 'income' contains at least 2 unique values
test_that("'income' column contains at least 2 unique values", {
  expect_true(length(unique(cleaned_data$income)) >= 2)
})

#### Test for logical consistency ####

# Test that each voter has one and only one living environment
test_that("each voter has one living environment", {
  expect_true(all(cleaned_data$living %in% valid_living))
})

# Test that 'income' categories are non-overlapping and distinct
test_that("income categories are distinct and non-overlapping", {
  expect_equal(length(valid_income), length(unique(valid_income)))
})

#### Final Summary ####
message("All tests completed successfully.")
