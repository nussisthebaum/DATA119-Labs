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
* Lab 4: Logistic Regression and Confusion Matrices
  + To practice fitting logistic regression models.
  + To calculate model fit statistics.
  + To calculate confusion matrices.
  + To apply LASSO to datasets used for linear and logistic regression.
* Lab 5: Cross Validation and Regularization
  + To implement leave-one-out and $K$-fold cross validation in a regression setting.
  + To carry out ridge regression on a dataset, including:
    - Choosing a tuning parameter,
    - Plotting the coefficients, and
    - Assessing model fit.
  + To carry out LASSO on the same dataset, including:
    -   Choosing a tuning parameter,
    -   Plotting the coefficients,
    -   Selecting variables useful for prediction, and
    -   Assessing model fit.
* Lab 6: $k$ NN Classification
  + Practice calculating different distance metrics. 
  + Define a $k$ NN classifier on a small dataset by hand. 
  + Practice calculations on confusion matrices.
  + Implement $k$ NN classification and regression. 
  + Create a graph illustrating the effects of choosing $k$ on training and test set accuracy. 
* Lab 7: $K$-Means and Hierarchical Clustering
  + To practice basic data cleaning, such as removing columns, dropping rows with missing values, and accessing row names of a dataframe.
  + To implement $K$-means clustering, including selecting an appropriate value for $K$ and interpreting the cluster output.
  + To implement hierarchical clustering, including creation of dendrograms.
* Lab 8: SQL
  + The goal of this lab is to practice SQL, including with joins.
* Lab 9: DATA119 Review Lab
  + The goal of this lab is to help you review topics we've covered this quarter.
* Lab 10: Hypothesis Testing Review
  + Review hypothesis testing, complete with an example of a $t$-test. 
    
 
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

* "Expected a python object, received a NULL" (commonly received while rendering): Create an empty Python 'setup' chunk at the beginning of the lab
* "An internal error occurred while setting up the exercise. Please try again or contact the tutorial author." (commonly received while running code chunks at the beginning of the lab): We still have not learned why this occurs but it does not seem to break anything.
* "An error has occured. Application Failed to Start. Exit Status 1" (commonly received if students refresh the lab too many times in a row): Make a small change to the lab (adding spacing etc) and then update the lab on Posit. It will reload and the error should go away.
* "NameError: name ___ is not defined. Run `reticulate::py_last_error()` for details" (occurs when students run cells that are not properly chained): Check to make sure your cell is referring to the correct setup chunk that creates that object.

### Sample Ed Note for Students about Errors:
    If you are running into an issue on a lab. First please check the list of common errors below. If you do not find your answer or you are told to contact us, please post the issue here. Make sure you include which lab you are working on, what the problem is, and where in the lab we can find that problem.
    ---
    Common Lab Errors and What to Do
    
    1. If you see this:
    
    ![image](https://github.com/user-attachments/assets/71513187-7ffa-478b-803d-b34770d7621c)

    
        Do not panic, this means nothing useful. You can continue with the lab as normal.
    
    2. If you see this:
    
    ![image](https://github.com/user-attachments/assets/df396828-720c-46bf-800c-da61957d4b34)

    
         Someone likely refreshed the lab too many times too quickly. Tell us immediately so that we can redeploy the lab!! Also, please avoid refreshing multiple times in a row.
    
    
    3. If you see this but you are sure you just created the variable in the previous code cell:
    
    ![image](https://github.com/user-attachments/assets/86f171d6-fcd3-4c06-98ee-2f101437e26e)
    
    
         That code chunk has been specified incorrectly on our end. Tell us right away so that we can fix it!

## Extra Resources:

* [`gradethis` Github](https://github.com/rstudio/gradethis/blob/main/README.md)
* [`learnr` Index](https://rstudio.github.io/learnr/index.html)
* [`learnr` Question Types](https://rstudio.github.io/learnr/reference/quiz.html)
* [Random Word Generator for secret words](https://randomwordgenerator.com/)
* [Updating Posit Settings](https://docs.posit.co/connect/cookbook/content/updating-content-git-repository-settings/)
