Getting and Cleaning Data Course Project
===================

This repository is the result of **Peer-graded Assignment: Getting and Cleaning Data Course Project**, and contains files listed below.

- readme.md | This file
- run_analysis.R | Code file, R script
- tidy_data.txt | Result data
- CodeBook.md | Description of tidy_data.txt

For details of the course, see: https://www.coursera.org/specializations/jhu-data-science

----------
About Project and Data
-------------------
- The goal of this project is to summarize a human activity data set measured and collected by using smartphone sensors. 
- The project averages the measured values in each test variable for each test participant with R script, and stores the results in a tiny data("tiny_data.txt"). 
- The source data is the result of a human activity recognition experiment which captured 3-axial linear acceleration and 3-axial angular velocity records out of performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING).
- The original data is created and provided by Center for Machine Learning and Intelligent Systems, UC, Irvine. (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
- For details of tiny data, you can read "CodeBook.md" 


About "run_analysis.R" 
-------------
The code performs the processes below:

- Checks whether the source data set exists and downloads if necessary.
- Reads each part of data set and its labels.
- Merges loaded data into one data set and keeps columns only of the mean and standard deviation for each measurement.
- Replaces the numeric activity values with descriptive texts and renames variables to make easier to understand.
- Groups data set by subjects and activities, and calculate means of variables of each group (using plyr::ddply function).
- Store the results into a tidy data, and save it to "tidy_data.txt"
     