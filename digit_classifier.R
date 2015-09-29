# Load required packages
library(R.matlab)
library(e1071)
library(lattice)
library(ggplot2)
library(caret)

# =============================================================================
# Start script - set directory and read data
# =============================================================================

# Set working directory
setwd("~/")

# Read training data from Matlab file
train_file <- readMat("data/digit-dataset/train.mat")

# Storage for desired data (will print this at the end)
c_performance <- data.frame()

# =============================================================================
# Set desired number of samples to use and set # of pixels
# =============================================================================

numSamples <- 10000
crossValidSize <- numSamples/10
finalValidSize <- numSamples
kFold <- 10

pixelLength <- 28
numPixels <- pixelLength*pixelLength

# =============================================================================
# Preprocess data
# =============================================================================

# Extract pixel and label data from matlab file
train_labels <- (train_file[[2]])[,1]  
train_images <- train_file[[1]]

# Randomly select data to train on with 10-fold cross-validation
set.seed(200)
rand_vect <- sample(1:length(train_labels), size = (numSamples + finalValidSize), 
                    replace = FALSE)
final_valid_vect <- rand_vect[1:finalValidSize]
rand_vect <- setdiff(rand_vect, final_valid_vect)

# Take randomly selected subset
tot_labels <- train_labels[rand_vect]
tot_images <- train_images[ , , rand_vect]

# Put data frame in proper format (each row is sample, each column is pixel value)
# ** Next two lines transform 3D array into a matrix
tot_data <- aperm(tot_images, c(3, 1, 2))
dim(tot_data) <- c(length(tot_labels), numPixels)
colnames(tot_data) <- seq(from = 1, to = numPixels)
tot_data <- data.frame(x = tot_data, y = as.factor(tot_labels))

# =============================================================================
# 10-fold cross-validation 
# =============================================================================

# Values of the cost parameter we want to test
cVal <- c(1e-7, 5e-7, 1e-6, 5e-6, 1e-5)

# Loop through the values of cost param
for (c in cVal) {
  avg <- numeric(0)

  # Find average accuracy of different data partitions
  for (kVal in 1:kFold) {
  
    # Pull out validation set data and put rest in training set
    valid_vect <- ((kVal-1)*crossValidSize):(kVal*crossValidSize)
    valid_data <- tot_data[valid_vect, ]
    train_data <- tot_data[-valid_vect, ]
  
    # Make model with selected training set and cost parameter
    svmfit <- svm(y~., data = train_data, kernel = "linear", cost = c, scale = FALSE)
    
    # Make prediction on validation data set and compute accuracy
    pred <- predict(svmfit, valid_data)
    fraction_correct <- sum(pred == valid_data$y)/crossValidSize
    avg <- append(avg, fraction_correct)
  }
  # Get average accuracy for this value of C
  avg <- mean(avg)

  # Store performance data
  c_performance <- rbind(c_performance, c(c, avg))
}
# Set column names
colnames(c_performance) <- c("Cost", "Accuracy")
write.table(c_performance, file = "MNIST_crossValid.txt", sep = "\t")

# =============================================================================
# For best cost value, train model and report accuracy 
# =============================================================================

# Find cost value corresponding to highest accuracy
c_performance <- c_performance[c_performance$Accuracy == max(c_performance$Accuracy), ]
optimalC <- min(c_performance$Cost)

# Train new model with all available training data and optimal C value
train_data <- tot_data
svmfit <- svm(y~., data = train_data, kernel = "linear", cost = optimalC, scale = FALSE)

# Get data for validation set
valid_labels <- train_labels[final_valid_vect]
valid_images <- train_images[ , , final_valid_vect]

# Put valid data in proper format (each row is sample, each column is pixel value)
final_valid_data <- aperm(valid_images, c(3, 1, 2))
dim(final_valid_data) <- c(length(valid_labels), numPixels)
colnames(final_valid_data) <- seq(from = 1, to = numPixels)
final_valid_data <- data.frame(x = final_valid_data, y = as.factor(valid_labels))

# Make prediction with new validation set
pred <- predict(svmfit, final_valid_data)
fraction_correct <- sum(pred == final_valid_data$y)/finalValidSize
fraction_correct

# =============================================================================
# Run best classifier on the test set and print predictions in .csv file
# =============================================================================

# Read testing data from Matlab file
test_file <- readMat("data/digit-dataset/test.mat")

# Extract pixel and label data from matlab file
test_images <- test_file[[1]]
num_test_samples <- length(test_images[1, 1, ])

# Put test data in proper format (each row is sample, each column is pixel value)
test_data <- aperm(test_images, c(3, 1, 2))
dim(test_data) <- c(num_test_samples, numPixels)
colnames(test_data) <- seq(from = 1, to = numPixels)
test_data <- data.frame(x = test_data)

# Put data frame in proper format (each row is sample, each column is pixel value)
# ** Next two lines transform 3D array into a matrix
all_data <- aperm(train_images, c(3, 1, 2))
dim(all_data) <- c(length(train_labels), numPixels)
colnames(all_data) <- seq(from = 1, to = numPixels)
all_data <- data.frame(x = all_data, y = as.factor(train_labels))

# Make prediction based on previously determine SVM model
svmfit <- svm(y~., data = all_data, kernel = "linear", cost = optimalC, scale = FALSE)
pred <- predict(svmfit, test_data)
test_data$predict <- pred 

# Get data in correct format for submitting to class Kaggle competition
submit_predict <- data.frame("ID" = 1:nrow(test_data), "Category" = test_data$predict)
write.csv(submit_predict, file = "digit_prediction_all.csv", row.names = FALSE)
