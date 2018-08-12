---
title: Data Classification Exercise
author: "Junyoung Kim"
date: "August, 10, 2018"
output: 
  html_document: 
    toc: yes
    keep_md: true
---



<br>
<br>

## Introduction

This paper is written as an assignment of Johns Hopkins University Machine Learning Class. It takes a set of accelerometer data which is recorded during 6 participants' barbell lift performances and examines it using different machine learning models. The goals of this study are to predict the manner in which they did the exercise and to determine
which model is the best classifier based on their predictions.  



<br>
<br>

## About Data

The data used in this study is Human Activity Recognition Dataset provided by http://groupware.les.inf.puc-rio.br/har. Using wearable devices on the belt, fore arm, arm and dumbell, the data quantifies the movements of 6 participants doing barbell lifts in correct and incorrect ways.The data is composed of two parts: [pml-training](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv), a large dataset which we mainly use in this machine training, and [pml-testing](https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv), a small dataset will be used for prediction later. 

<br>
<br>

## Preprocessing Data
The pml-training data is a large one with 19622 observations and 160 variables. One of them is the variable "classe" which we need to predict with other variables. "classe" has 5 different classes from A to E.  


```
## [1] "dimension of pml-training"
```

```
## [1] 19622   160
```


```
## [1] "classe"
```

```
##  Factor w/ 5 levels "A","B","C","D",..: 1 1 1 1 1 1 1 1 1 1 ...
```

<br>

- Variable removal

We may not need all of 159 predictors. Before training with models, it would be better to optimize the dataset by getting rid of unrelated variables, so that we can save some computing costs. First, we've got to remove NA variables. 


```
## [1] "NA variables"
```

```
##  Named int [1:100] 12 13 14 15 16 17 18 19 20 21 ...
##  - attr(*, "names")= chr [1:100] "kurtosis_roll_belt" "kurtosis_picth_belt" "kurtosis_yaw_belt" "skewness_roll_belt" ...
```

There are total 100 NA variables. And there are also some useless variables like index, time, user name, etc. Time data is not an important factor here since all observations are chosen regardless of time order. By removing all unimportant variables, we can cut down the data and make it one with 53 variables including one dependent variable($classe).  



<br>

- Standardization, splitting data, and dimensionality reduction 

Another good way of saving computing costs is standardizing the data and reducing dimensions with PCA. In order to preserve as much information as possible, The following PCA process keeps 99% of the variance of the initial data. In advance of reducing dimensions, we also need to split data into training, cross-validation, and testing sets, because the same reduction process applied to the training set should be applied to the rests. Here the process splits the data with 3:1:1 ratio.




```
## [1] "PCA: training set"
```

```
## [1] 11776    38
```

Keeping 99% of initial variance, we got three datasets of 37 predictors and 1 dependent variable. 

<br>
<br>

## Strategy
The main strategy of model choice in this study has two steps

- Step 1: Comparing single methods and choose the best one 
- Step 2: Run ensemble method with weak classifiers and compare with the Step 1 result 

There are numerous methods of training data. Considering data type of the 5 classes, this study chose 12 training models: 

- Linear Discriminant Analysis (method = 'lda')
- Quadratic Discriminant Analysis (method = 'qda') 
- Multi-Layer Perceptron (method = 'mlp')
- Support Vector Machines with Linear Kernel (method = 'svmLinear') 
- Support Vector Machines with Gaussian Kernel (method = 'svmRadial') 
- Decision Tree (method = 'rpart)
- Decision Tree with Bagging (method = 'treebag')
- Decision Tree with Boosting (method = 'bstTree')
- Random Forest (method = 'rf')
- Multinomial Logistic Regression (method = 'multinom')
- Stochastic Gradient Boosting (method = 'gbm')
- Naive Bayes (method = 'nb)



<br>

#### Step 1: Single Model Comparison

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>Model Accuracy</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> lda </th>
   <th style="text-align:right;"> qda </th>
   <th style="text-align:right;"> mlp </th>
   <th style="text-align:right;"> svmLinear </th>
   <th style="text-align:right;"> svmRadial </th>
   <th style="text-align:right;"> rpart </th>
   <th style="text-align:right;"> treebag </th>
   <th style="text-align:right;"> bstTree </th>
   <th style="text-align:right;"> rf </th>
   <th style="text-align:right;"> multinom </th>
   <th style="text-align:right;"> gbm </th>
   <th style="text-align:right;"> nb </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Training </td>
   <td style="text-align:right;"> 0.595 </td>
   <td style="text-align:right;"> 0.843 </td>
   <td style="text-align:right;"> 0.713 </td>
   <td style="text-align:right;"> 0.663 </td>
   <td style="text-align:right;"> 0.945 </td>
   <td style="text-align:right;"> 0.380 </td>
   <td style="text-align:right;"> 1.000 </td>
   <td style="text-align:right;"> 0.333 </td>
   <td style="text-align:right;"> 1.000 </td>
   <td style="text-align:right;"> 0.610 </td>
   <td style="text-align:right;"> 0.885 </td>
   <td style="text-align:right;"> 0.714 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Crossvalidation </td>
   <td style="text-align:right;"> 0.596 </td>
   <td style="text-align:right;"> 0.838 </td>
   <td style="text-align:right;"> 0.700 </td>
   <td style="text-align:right;"> 0.661 </td>
   <td style="text-align:right;"> 0.934 </td>
   <td style="text-align:right;"> 0.383 </td>
   <td style="text-align:right;"> 0.948 </td>
   <td style="text-align:right;"> 0.330 </td>
   <td style="text-align:right;"> 0.979 </td>
   <td style="text-align:right;"> 0.613 </td>
   <td style="text-align:right;"> 0.849 </td>
   <td style="text-align:right;"> 0.696 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Elapsed Time(sec) </td>
   <td style="text-align:right;"> 5.420 </td>
   <td style="text-align:right;"> 4.720 </td>
   <td style="text-align:right;"> 256.520 </td>
   <td style="text-align:right;"> 533.800 </td>
   <td style="text-align:right;"> 2072.890 </td>
   <td style="text-align:right;"> 12.610 </td>
   <td style="text-align:right;"> 292.050 </td>
   <td style="text-align:right;"> 1000.380 </td>
   <td style="text-align:right;"> 2505.260 </td>
   <td style="text-align:right;"> 312.730 </td>
   <td style="text-align:right;"> 1123.420 </td>
   <td style="text-align:right;"> 767.970 </td>
  </tr>
</tbody>
</table>



<img src="barplot1.png" width="100%" />

Among all 12 models, Random Forest shows the best performance with crossvalidation set (accuracy: 0.979). Tree with Bagging also shows good performance (accuracy:0.948) with much faster computing time than Random Forest (292 < 2505). This can possibly be a good choice in practical uses where computing speed is also important, but here, the standard what we should regard is the accuracy only, so in Step 1, this study chose Random Forest as the best classifier.  

<br>

#### Step 2: Ensemble
In Step 1, we can find some weak classifiers (> 0.5). This study chose 5 methods as a source(qda, mlp, multinom, gbm, nb). Since Adaboost doesn't work with multinomial data, this study tries to emsemble them with Generalized Additive Model (method='gam') and Multinomial Regression (method='multinom'). Elapsed times of 5 methods add up to 2465.36 seconds, which is a little shorter than Random Forest (2505.26 sec), so we can compare the performance of two methods fairly if the ensembling process doesn't take so much time.  



<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<caption>Ensemble Model Accuracy</caption>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> gam </th>
   <th style="text-align:right;"> multinom </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Training </td>
   <td style="text-align:right;"> 0.438 </td>
   <td style="text-align:right;"> 0.852 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Crossvalidation </td>
   <td style="text-align:right;"> 0.433 </td>
   <td style="text-align:right;"> 0.819 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Total Elapsed Time Taken with Base Models and Ensemble(sec) </td>
   <td style="text-align:right;"> 2476.440 </td>
   <td style="text-align:right;"> 2533.700 </td>
  </tr>
</tbody>
</table>

As interesting result has come out that multinomial regression recorded almost twice better accuracy in both training and crossvalidation sets. However, both of them are still worse than Random Forest alone, even than Tree with Bagging or SVM with Gaussian Kernel, and similar with Quadratic Discriminant Analysis which only takes 4.72 seconds alone.   



<img src="barplot2.png" width="100%" />

<br>
<br>

## Test Result
To sum up, **Random Forest** is the best classifier. The performance of Random Forest with Test set is about **0.978**


```
## [1] "Random Forest Accuracy with Test Set"
```

```
##  Accuracy 
## 0.9775682
```

```
## [1] "In-sample Error"
```

```
## [1] 0
```

```
## [1] "Out-of-sample Error"
```

```
##   Accuracy 
## 0.02243181
```

<br>
<br>

## Prediction: Applying to pml-testing Data
Ater taking the same preprocessing with the training set, we can try to classify pml-testing dataset.

```
## [1] "pml-testing Data Class Prediction with Random Forest"
```

```
##  [1] B A C A A E D B A A B C B A E E A B B B
## Levels: A B C D E
```
