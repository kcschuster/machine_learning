# machine_learning
Demonstrates a variety of machine learning methods:
  - SVMs
  - Linear regression (coming soon)
  - Logistic regression (coming soon)

Note:  These scripts are for educational purposes only; I cannot guarantee they are entirely correct.

**SVMs ---  digit_classifier.R**

- Classifies handwritten digits 0-9 based on pixel information.
- Uses linear SVMs with 10-fold cross-validation to determine the optimal cost model parameter. 
- Sets aside portion of training data for validation, then classifies testing data.
- Currently, training and testing data assumed to be in a Matlab file; can be modified to take .csv files (https://www.kaggle.com/c/digit-recognizer/data)
