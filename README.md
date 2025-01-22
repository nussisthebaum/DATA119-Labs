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
 
## Lab Creation Workflow:

## Lab Publishing Workflow:
1. Make sure all necessary files are in the folder with the designated lab number including a `requirements.txt` file and a folder named `www` containing the css file, and any image or data files.
2. Ensure the css file is indicated in the yaml header of the lab file.
3. Ensure necessary html for creating the lab header is included in the lab file after the setup chunk, the header title has been updated ('your header here' in the below code has been replaced), and the url to the logo has been updated to reflect this lab's url (the x's in the url below have been changed to the relevant course and lab number):
  ```
    library(htmltools)
    tags$div(
      class = "topContainer",
      tags$div(
        class = "logoAndTitle",
        tags$img(
          src = "http://posit.ds.uchicago.edu/dataxxx-labx/www/dsi_logo.png",
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

## Extra Resources:

* [`gradethis` Github](https://github.com/rstudio/gradethis/blob/main/README.md)
* [`learnr` Index](https://rstudio.github.io/learnr/index.html)
* [`learnr` Question Types](https://rstudio.github.io/learnr/reference/quiz.html)
* [Random Word Generator for secret words](https://randomwordgenerator.com/)
