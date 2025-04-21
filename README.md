# DATA119 Labs

This repo contains data and .Rmd files for interactive Shiny labs to teach DATA119 concepts. 

## Lab Goals:

* Lab 1: Data Cleaning and Visualization
  + To refamiliarize yourself with Jupyter notebooks.
  + To practice data cleaning skills, including selecting columns, identifying and removing unusual values, and maintaining a tidy dataset.
  + To practice calculating summary statistics.
  + To practice making data visualizations, such as histograms and scatterplots.
* Lab 2: Correlation and Simple Linear Regression
  + To continue practicing making data visualizations.
  + To familiarize yourself with Pearson’s correlation coefficient $R$.
  + To practice writing functions.
  + To practice calculating linear regression estimates.
* Lab 3: Assumption Checking and Multiple Linear Regression
  + Address failed assumptions in linear regression.
  + Explore datasets with multiple variables for the purpose of multiple linear regression.
  + Find significant predictors for a response variable in multiple linear regression.
* Lab 3.5: Categorical Variables and VIF
  + Check for multicollinearity issues using the variance inflation factor. 
  + Learn to incorporate categorical variables in multiple linear regression.
* Lab 4
    + To learn EDA for categorical data, train test split, and how to run a logistic regression
    + To calculate confusion matrices and accuracy metrics
    + To calculate the AUC and ROC and use them to evaluate model quality
* Lab 5 (regularization and cross-validation)
    * Original
        + To implement leave-one-out and K-fold cross validation in a regression setting.
        + To carry out ridge regression on a dataset, including:
            * Choosing a tuning parameter,
            * Plotting the coefficients, and
            * Assessing model fit.
        + To carry out LASSO on the same dataset, including:
            * Choosing a tuning parameter,
            * Plotting the coefficients,
            * Selecting variables useful for prediction, and
            * Assessing model fit.
    * Mine
        + To practice EDA, data transformations, and train test split for model development
        + To learn how to use the implementation of LinearRegression from sklearn
        + To learn how to use both the regular and cross-validated implementations of Ridge Regression from sklearn
        + To learn how to use both the regular and cross-validated implementations of Lasso Regression from sklearn
        + To learn how to visualize the impact on of regularization on model coefficents
        + To practice model evaluation and comparision
* Lab 6 (kNN classification)
    * Original
        + Practice calculating different distance metrics.
        + Define a kNN classifier on a small dataset by hand.
        + Practice calculations on confusion matrices.
        + Implement kNN classification and regression.
        + Create a graph illustrating the effects of choosing k on training and test set accuracy.
    * Mine
        + To learn the theoretical underpinnings of the kNN classifier
        + To review distance metrics (Manhattan and Euclidean)
        + To practice calculations of accuracy and precision with confusion matrices
        + To learn how to implement kNN using sklearn
        + To practice making predictions and generating confusion matrices based off classifiers
        + To practice choosing the optimal k for kNN models
* Lab 7 (clustering)
    * Original
        + To practice basic data cleaning, such as removing columns, dropping rows with missing values, and accessing row names of a dataframe.
        + To implement K-means clustering, including selecting an appropriate value for K and interpreting the cluster output.
        + To implement hierarchical clustering, including creation of dendrograms.
    * Mine
        + To practice basic data cleaning including handling missing values and filtering dataframes
        + To learn the K-means algorithm
        + To practice working with dendrograms
        + To learn how to implement kMeans clustering using sklearn
        + To practice choosing a correct value of k for kMeans and interpreting the output
        + To learn how to implement hierarchical clustering using both sklearn and scipy
* Lab 8 (SQL)
    * Original
        + The goal of this lab is to practice SQL, including with joins.
    * Mine
        + To practice the basic framework of SQL queries (SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY)
        + To practice filtering datasets using WHERE including multiple conditions and the IN operator
        + To practice using aggregators (i.e. MAX) as part of SQL queries
        + To learn how and when to use different types of JOINS in a SQL query
* Lab 9 (Review)
    + To review how different featurizations and regularizations impact the coefficients and performance of linear regression 
    + To review how threshold selection impacts classification models and their different metrics of quality
    + To review the kMeans and Hiearchial clustering algorithms and see how different implementations of them change clusters
    + To practice implementing regularized and unregularized linear regression models
    + To practice model evaluation and selection in the context of linear regression
    + To practice implementing kNN and logistic regression classification
    + To practice using the AUC and ROC and confusion matrices to evaluate classification models
    + To practice implementing kMeans and Hierarchical clustering techniques
    + To practice model interpretation across different modeling tasks
* Lab 10: Hypothesis Testing Review
  * Original
    + Review hypothesis testing, complete with an example of a $t$-test.
  * Mine
    + To review the difference between population parameters and sample statistics
    + To review the classical Hypothesis Testing Framework including generation of null and alternative hypothesis, choosing test statistics, checking conditions for testing, calculation of p-value, and test interpretation
    + To review the relationship between Hypothesis Testing and confidence intervals
    + To review types of decision errors in the context of Hypothesis Testing 
    + To review the Central Limit Theorem and Sampling Distributions
    + To review carrying out a Hypothesis Test through an example t-test


    
 
## Lab Creation Workflow:

## Lab Publishing Workflow:

1. Make sure all necessary files are in the folder with the designated lab number including a `requirements.txt` file, a folder named `css` containing the css file, a folder named `images` with any image files, and a folder named `www` with any data files etc. 
2. Ensure the css file is indicated in the yaml header of the lab file.
3. Ensure necessary html for creating the lab header is included in the lab file after the setup chunk, the header title has been updated ('your header here' in the below code has been replaced):
  ```
    library(htmltools)
    tags$div(
      class = "topContainer",
      tags$div(
        class = "logoAndTitle",
        tags$img(
          src = "./images/dsi_logo.png",
          alt = "DSI Logo",
          class = "topLogo"
        ),
        tags$h1("your header here", class = "pageTitle")
      )
    )
  ```
4. Make sure all necessary Python modules are listed in the `requirements.txt` file along with version numbers
5. Navigate to the correct directory in R and then run `rsconnect::writeManifest()`
6. In the `manifest.json` file, add the following after `metadata` and before `packages`:
  ```
   "python": {
        "version": "3.9.21",
        "package_manager": {
          "name": "pip",
          "version": "21.2.4",
          "package_file": "requirements.txt"
        }
      },
  ```
8. On Posit Connect click `publish` then `Import from Git`. Provide the url to this repository as well as the correct branch (main for student-ready versions, otherwise a development branch) and the lab folder. If this is a student-ready lab, in the info tab of the settings bar, change the url to `/dataxxx-labx/` where the x's are replaced with the relevant course number and lab number.
9. Copy and paste the URL and provide it to students.

## Common Errors and their Fixes

* "Expected a python object, received a NULL" (commonly received while rendering):
* "An internal error occurred while setting up the exercise. Please try again or contact the tutorial author." (commonly received while running code chunks):

## Extra Resources:

* [`gradethis` Github](https://github.com/rstudio/gradethis/blob/main/README.md)
* [`learnr` Index](https://rstudio.github.io/learnr/index.html)
* [`learnr` Question Types](https://rstudio.github.io/learnr/reference/quiz.html)
* [Random Word Generator for secret words](https://randomwordgenerator.com/)
