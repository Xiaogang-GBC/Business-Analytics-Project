# Install required libraries if not already installed
install.packages(c("tidyverse", "caret", "xgboost", "gridExtra", "ggplot2"))

# Load libraries
library(tidyverse)
library(caret)
library(xgboost)
library(gridExtra)
library(dplyr)

#------------------------#
# Load data
#------------------------#
data <- read.csv("Income_Data_Canada_01.csv")

# View first few rows and structure
head(data)
str(data)

#------------------------#
# Data Cleaning
#------------------------#
# Filter columns relevant for analysis
cleaned_data <- data %>%
  select(REF_DATE, GEO, `Age.group`, Sex, `Income.source`, VALUE) %>%
  rename(
    Year = REF_DATE,
    Location = GEO,
    AgeGroup = `Age.group`,
    Gender = Sex,
    IncomeSource = `Income.source`,
    Income = VALUE
  )

# Convert data types
cleaned_data <- cleaned_data %>%
  mutate(
    Year = as.integer(Year),
    Income = as.numeric(Income),
    AgeGroup = factor(AgeGroup),
    Gender = factor(Gender),
    Location = factor(Location)
  )

# Remove rows with missing or invalid values
cleaned_data <- cleaned_data %>%
  filter(!is.na(Income), Income > 0)

# Check summary
summary(cleaned_data)

#------------------------#
# Exploratory Data Analysis
#------------------------#
# Summary statistics
cleaned_data %>%
  group_by(AgeGroup, Gender) %>%
  summarise(AverageIncome = mean(Income, na.rm = TRUE)) %>%
  arrange(desc(AverageIncome))

# Visualizations
p1 <- ggplot(cleaned_data, aes(x = AgeGroup, y = Income, fill = Gender)) +
  geom_boxplot() +
  labs(title = "Income by Age Group and Gender", x = "Age Group", y = "Income") +
  theme_minimal()

p2 <- ggplot(cleaned_data, aes(x = Location, y = Income, fill = Gender)) +
  geom_boxplot() +
  coord_flip() +
  labs(title = "Income by Location and Gender", x = "Location", y = "Income") +
  theme_minimal()

grid.arrange(p1, p2, ncol = 2)

#------------------------#
# Build model and predict
#------------------------#
# Split the dataset into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(cleaned_data$Income, p = 0.7, list = FALSE)
train_data <- cleaned_data[trainIndex, ]
test_data <- cleaned_data[-trainIndex, ]

# Prepare data for modeling
train_matrix <- model.matrix(Income ~ AgeGroup + Gender + Location, train_data)[, -1]
test_matrix <- model.matrix(Income ~ AgeGroup + Gender + Location, test_data)[, -1]
train_labels <- train_data$Income
test_labels <- test_data$Income

# Train a Random Forest model
rf_model <- train(
  x = train_matrix,
  y = train_labels,
  method = "rf",
  trControl = trainControl(method = "cv", number = 5),
  tuneLength = 3
)

# Train an XGBoost model
xgb_model <- train(
  x = train_matrix,
  y = train_labels,
  method = "xgbTree",
  trControl = trainControl(method = "cv", number = 5),
  tuneLength = 3
)

# Compare models
results <- resamples(list(RandomForest = rf_model, XGBoost = xgb_model))
summary(results)

# Best model predictions
best_model <- ifelse(mean(rf_model$results$RMSE) < mean(xgb_model$results$RMSE), rf_model, xgb_model)
predictions <- predict(best_model, test_matrix)

# Evaluate performance
performance <- postResample(pred = predictions, obs = test_labels)
print(performance)
