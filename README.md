# machine_learning
Various machine learning methods applied to classification problems.  

**digit_classifier.R**

- Classifies handwritten digits 0-9 based on pixel information.
- Uses linear SVMs with 10-fold cross-validation to determine the optimal cost model parameter. 
- Sets aside portion of training data for validation, then classifies testing data.
- Currently, training and testing data assumed to be in a Matlab file; can be modified to take .csv files (https://www.kaggle.com/c/digit-recognizer/data)
