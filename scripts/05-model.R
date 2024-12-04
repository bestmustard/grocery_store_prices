#### Preamble ####
# Purpose: Creates a logistic regression model for political preferences
# Author: Victor Ma
# Date: 3 December 2024
# Contact: victo.ma@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
ces_data <- read_csv("data/02-analysis_data/analysis_data.csv")

# Ensure categorical variables are correctly encoded
ces_data$voted_for <- as_factor(ces_data$voted_for)
ces_data$employment <- factor(ces_data$employment, levels = c("Full-time", "Part-time", "Temporarily laid off", "Unemployed", "Retired", "Permanently disabled", "Homemaker", "Student"))
ces_data$income <- factor(ces_data$income, levels = c("< 10k", "10-50k", "50-100k", "100-200k", "200-500k", "> 500k"))
ces_data$living <- factor(ces_data$living, levels = c("City", "Suburb", "Town", "Rural area"))

#### Model data ####
set.seed(853)

# Reducing the dataset for computational manageability
ces_data_reduced <- ces_data |> 
  slice_sample(n = 3000)

# Specifying the logistic regression model
political_preferences <- stan_glm(
  voted_for ~ employment + income + living,
  data = ces_data_reduced,
  family = binomial(link = "logit"),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  seed = 853
)

# Saving the model for future use
saveRDS(political_preferences, file = "models/political_preferences.rds")
