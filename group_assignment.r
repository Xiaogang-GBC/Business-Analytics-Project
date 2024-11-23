# Load required libraries
library(tidyverse)
library(caret)
library(ggplot2)
library(randomForest)
library(xgboost)
library(scales)
library(gridExtra)

# 1. Data Loading and Initial Exploration
# Read the CSV file
raw_data <- read.csv("income_canada_data.csv", stringsAsFactors = FALSE)

# Display initial information about the dataset
print("Dataset Dimensions:")
print(dim(raw_data))
print("\nColumn Names:")
print(names(raw_data))
print("\nFirst few rows:")
print(head(raw_data))

# 1. Data Loading and Cleaning
load_and_clean_data <- function(data) {
  cleaned_data <- data %>%
    filter(
      `Income.source` == "Total income",
      Statistics == "Average income (excluding zeros)",
      UOM == "2022 constant dollars"
    ) %>%
    select(REF_DATE, GEO, Age.group, Sex, VALUE) %>%
    # Remove any rows with missing values
    na.omit() %>%
    # Convert year to numeric
    mutate(
      REF_DATE = as.numeric(REF_DATE),
      # Convert VALUE to numeric and scale to thousands
      VALUE = as.numeric(VALUE) / 1000
    )
  
  # Print summary of cleaned data
  print("Cleaned Dataset Summary:")
  print(summary(cleaned_data))
  print("\nNumber of observations after cleaning:")
  print(nrow(cleaned_data))
  
  return(cleaned_data)
}

# 2. Exploratory Data Analysis
perform_eda <- function(data) {
  # Summary statistics
  summary_stats <- summary(data)
  print("Summary Statistics:")
  print(summary_stats)
  
  # Additional data characteristics
  print("\nUnique values in each category:")
  print("Years covered:")
  print(sort(unique(data$REF_DATE)))
  print("\nGeographic regions:")
  print(unique(data$GEO))
  print("\nAge groups:")
  print(unique(data$Age.group))
  
  # Income distribution by year
  p1 <- ggplot(data, aes(x = as.factor(REF_DATE), y = VALUE)) +
    geom_boxplot(aes(group = REF_DATE)) +
    theme_minimal() +
    labs(title = "Income Distribution by Year",
         x = "Year",
         y = "Income (Thousands of 2022 CAD)") +
    theme(axis.text.x = element_text(angle = 45))
  
  # Income by age group and sex
  p2 <- ggplot(data, aes(x = Age.group, y = VALUE, fill = Sex)) +
    geom_boxplot() +
    theme_minimal() +
    labs(title = "Income Distribution by Age Group and Sex",
         x = "Age Group",
         y = "Income (Thousands of 2022 CAD)") +
    theme(axis.text.x = element_text(angle = 45))
  
  # Income trends by geography
  p3 <- ggplot(data, aes(x = REF_DATE, y = VALUE, color = GEO)) +
    geom_line() +
    theme_minimal() +
    labs(title = "Income Trends by Geography",
         x = "Year",
         y = "Income (Thousands of 2022 CAD)") +
    theme(legend.position = "bottom")
  
  # Save plots
  pdf("income_analysis_plots.pdf")
  print(p1)
  print(p2)
  print(p3)
  dev.off()
  
  return(list(summary_stats = summary_stats, plots = list(p1, p2, p3)))
}

# 3. Data Preparation for Modeling
prepare_data <- function(data) {
  # Convert categorical variables to factors
  prepared_data <- data %>%
    mutate(across(c(GEO, Age.group, Sex), as.factor))
  
  # Split data into training and testing sets
  set.seed(123)
  train_index <- createDataPartition(prepared_data$VALUE, p = 0.8, list = FALSE)
  train_data <- prepared_data[train_index, ]
  test_data <- prepared_data[-train_index, ]
  
  # Print dimensions of training and testing sets
  print("Training set dimensions:")
  print(dim(train_data))
  print("Testing set dimensions:")
  print(dim(test_data))
  
  return(list(train = train_data, test = test_data))
}

# 4. Model Training and Evaluation
train_and_evaluate_models <- function(train_data, test_data) {
  # Control parameters for cross-validation
  ctrl <- trainControl(method = "cv", 
                      number = 5,
                      verboseIter = TRUE)
  
  # Linear Regression
  print("Training Linear Regression Model...")
  lm_model <- train(
    VALUE ~ .,
    data = train_data,
    method = "lm",
    trControl = ctrl
  )
  print(summary(lm_model))
  
  # Random Forest
  print("Training Random Forest Model...")
  rf_model <- train(
    VALUE ~ .,
    data = train_data,
    method = "rf",
    trControl = ctrl,
    tuneGrid = expand.grid(mtry = c(2, 3, 4))
  )
  print(rf_model$bestTune)
  
  # XGBoost
  print("Training XGBoost Model...")
  xgb_model <- train(
    VALUE ~ .,
    data = train_data,
    method = "xgbTree",
    trControl = ctrl,
    tuneLength = 3
  )
  print(xgb_model$bestTune)
  
  # Model Predictions
  predictions <- list(
    lm = predict(lm_model, test_data),
    rf = predict(rf_model, test_data),
    xgb = predict(xgb_model, test_data)
  )
  
  # Calculate RMSE and R-squared for each model
  evaluate_model <- function(pred, actual) {
    rmse <- sqrt(mean((pred - actual)^2))
    rsq <- cor(pred, actual)^2
    return(c(RMSE = rmse, R_squared = rsq))
  }
  
  model_performance <- data.frame(
    Model = c("Linear Regression", "Random Forest", "XGBoost"),
    RMSE = sapply(predictions, function(x) evaluate_model(x, test_data$VALUE)[1]),
    R_squared = sapply(predictions, function(x) evaluate_model(x, test_data$VALUE)[2])
  )
  
  # Print model performance metrics
  print("Model Performance Metrics:")
  print(model_performance)
  
  # Save model performance to CSV
  write.csv(model_performance, "model_performance_metrics.csv", row.names = FALSE)
  
  return(list(
    models = list(lm = lm_model, rf = rf_model, xgb = xgb_model),
    performance = model_performance,
    predictions = predictions
  ))
}

# 5. Visualization of Model Results
plot_model_results <- function(test_data, predictions) {
  actual_vs_predicted <- data.frame(
    Actual = rep(test_data$VALUE, 3),
    Predicted = c(predictions$lm, predictions$rf, predictions$xgb),
    Model = factor(rep(c("Linear Regression", "Random Forest", "XGBoost"),
                      each = length(test_data$VALUE)))
  )
  
  prediction_plot <- ggplot(actual_vs_predicted, aes(x = Actual, y = Predicted)) +
    geom_point(alpha = 0.5) +
    geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
    facet_wrap(~Model) +
    theme_minimal() +
    labs(title = "Actual vs Predicted Income",
         x = "Actual Income (Thousands of 2022 CAD)",
         y = "Predicted Income (Thousands of 2022 CAD)")
  
  # Save plot
  ggsave("model_predictions_comparison.pdf", prediction_plot)
  
  return(prediction_plot)
}

# Main execution pipeline
main <- function() {
  # Load and clean data
  raw_data <- read.csv("Income_Data_Canada_01.csv", stringsAsFactors = FALSE)
  cleaned_data <- load_and_clean_data(raw_data)
  
  # Perform EDA
  eda_results <- perform_eda(cleaned_data)
  
  # Prepare data for modeling
  split_data <- prepare_data(cleaned_data)
  
  # Train and evaluate models
  model_results <- train_and_evaluate_models(split_data$train, split_data$test)
  
  # Plot results
  prediction_plot <- plot_model_results(split_data$test, model_results$predictions)
  
  # Return all results
  return(list(
    cleaned_data = cleaned_data,
    eda_results = eda_results,
    model_results = model_results,
    prediction_plot = prediction_plot
  ))
}

# Run the analysis
results <- main()

