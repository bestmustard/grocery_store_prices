#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

political_preferences <- readRDS(file ="models/political_preferences.rds")
# Train-test split
set.seed(853)
train_indices <- sample(1:nrow(ces_data_reduced), 0.7 * nrow(ces_data_reduced))
train_data <- ces_data_reduced[train_indices, ]
test_data <- ces_data_reduced[-train_indices, ]

# Predictions on test data
test_predictions <- posterior_predict(political_preferences, newdata = test_data)
