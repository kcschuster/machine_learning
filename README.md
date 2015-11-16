# machine_learning
Scripts to demonstrate a variety of machine learning methods:
  - SVMs
  - Linear regression 
  - Logistic regression (coming soon)

Note:  These scripts are for educational purposes only.

**SVMs**
> **digit_classifier.R**

- Classifies handwritten digits 0-9 based on pixel information.
- Uses linear SVMs with 10-fold cross-validation to determine the optimal cost model parameter. 
- Sets aside portion of training data for validation, then classifies testing data.
- Uses a software package for SVM, but manually implements k-fold cross-validation.
- Currently, training and testing data assumed to be in a .mat file; can be modified to take .csv files (https://www.kaggle.com/c/digit-recognizer/data)

**Linear Regression**  
> **housing_values.R**

- Performs linear regression on housing data to predict home values.
- Data set found [here](http://lib.stat.cmu.edu/datasets/) ("houses.zip").


**Logistic Regression**
> **spam_filter.R**
