# *****************************************************************************
# Title:        housing_values.R
# Description:  Performs linear regression on housing data set to predict 
#               home values.
# Author:       Kelsey Schuster
# *****************************************************************************

# Load required libraries
require(R.matlab)

# Set working directory
setwd("")

# *****************************************************************************
# Read data file and separate into training and validation sets
# *****************************************************************************

# Read training data from Matlab file
train_data <- readMat("data/housing_data.mat")

# Separate training data set, add extra column to x data for bias
x_train <- train_data$Xtrain
x_train <- cbind(x_train, 1)
y_train <- train_data$Ytrain

# *****************************************************************************
# Perform linear regression
# *****************************************************************************

# Find unique solution of weights \hat{w} = (X^TX)^{-1}X^Ty
w_vect <- t(x_train)%*%y_train
w_vect <- (solve(t(x_train)%*%x_train))%*%w_vect

# Separated validation data set, add extra column to x data for bias
x_valid <- train_data$Xvalidate
x_valid <- cbind(x_valid, 1)
y_valid <- train_data$Yvalidate

# Find predicted outputs \hat{y} = X\hat{\beta}
predicted_y <- x_valid%*%w_vect
diff_y <- predicted_y - y_valid
variance <- sum((predicted_y - y_valid)^2)/(nrow(y_valid - ncol(x_train) - 1))

# Calculate residuals and make histogram
RSS <- t(y_valid - x_valid%*%w_vect)%*%(y_valid - x_valid%*%w_vect)
hist((y_valid - predicted_y), ylab = "Frequency", xlab = "f(x) - y", 
     main = "Histogram of Residuals", xlim = c(-4e5, 4e5), col = "light blue")

# Make plot of regression coefficients vs. index
plot(x = 1:length(w_vect), y = w_vect, xlim = c(1, 8), 
     ylim = c(min(w_vect[1:8]), max(w_vect[1:8])), col = "blue",
     cex = 1.3, xlab = "Coefficient Index", ylab = "Regression Coefficient",
     main = "Linear Regression Coefficients")