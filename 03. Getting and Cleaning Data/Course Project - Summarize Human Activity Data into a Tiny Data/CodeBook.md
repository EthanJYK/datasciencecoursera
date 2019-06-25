Code Book
===================

### **I. Overview**
- The results in "tidy_data.txt" contains 3 identifier variables and 66 feature variables.
- The original experiments have been carried out with a group of 30 volunteers.
- Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
-  Using  accelerometer and gyroscope, the experiments captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
- The obtained data set has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

### **II. Identifier Variables**
- **Group**: (Bivariate) Indicates which group each subject belongs to. 
-- 0: Training data group, total 21 subjects.
-- 1: Test data group, total 9 subjects.

- **Subjects**: (Discrete) Numbers identifying each subject (from 1 to 30)

- **Activity**: (Discrete) 6 types of activities performed by each subject
-- WALKING: values captured while the subject was walking
-- WALKING_UPSTAIRS:  values captured while the subject was walking up stairs
-- WALKING_DOWNSTAIRS: values captured while the subject was walking down stairs
-- SITTING: values captured while the subject was sitting down
-- STANDING: values captured while the subject was standing up
-- LAYING: values captured while the subject was laying down

### **III. Averaged Feature Variables** 

- All feature values stored in "tiny_data.txt" are **averages of the activity measurements** of each subject recorded in the original data. 
- All feature variables are **(1) continuous, (2) float, and (3) ranges between -1 to 1.**  
- The acceleration signal was separated into body and gravity acceleration signals (Times.Body.Accel...XYZ and Times.Gravity.Accel...XYZ).


- Prefix:
>- **Times**: Time Domain Signal Features. Captured at a constant rate of 50 Hz and filtered to remove noise. 
>- **Frequency**: Frequency of Signals produced by applying A Fast Fourier Transform (FFT) to Times data.

- Middle:
>- **Body.Accel**: linear acceleration signals of body movements 
>- **Body.Gyro**:  angular velocity signals of body movements
>- **Gravity.Accel**: linear gravity acceleration signals
>- **Gravity.Gyro**: gravity angular velocity signals
>- **.Jerk**: derivation of the acceleration in time
>- **.Magnitude**:  the magnitude of three-dimensional signals calculated using the Euclidean norm

- Suffix:
>- **.mean** indicates **means(averages)**.
>- **.std** indicates **standard deviations**. 
>- **.XYZ** is used to denote 3-axial signals in the X, Y and Z directions.


#### **i. List of Time Domain Signal Features**
>- Times.Body.Accel.mean (X,Y,Z) 
- Times.Body.Accel.std (X,Y,Z) 
- Times.Gravity.Accel.mean (X,Y,Z) 
- Times.Gravity.Accel.std (X,Y,Z)
- Times.Body.Accel.Jerk.mean (X,Y,Z)
- Times.Body.Accel.Jerk.std (X,Y,Z)
- Times.Body.Gyro.mean (X,Y,Z)
- Times.Body.Gyro.std (X,Y,Z)
- Times.Body.Gyro.Jerk.mean (X,Y,Z)
- Times.Body.Gyro.Jerk.std (X,Y,Z)
- Times.Body.Accel.Magnitude.mean
- Times.Body.Accel.Magnitude.std
- Times.Gravity.Accel.Magnitude.mean
- Times.Gravity.Accel.Magnitude.std
- Times.Body.Accel.Jerk.Magnitude.mean
- Times.Body.Accel.Jerk.Magnitude.std
- Times.Body.Gyro.Magnitude.mean
- Times.Body.Gyro.Magnitude.std
- Times.Body.Gyro.Jerk.Magnitude.mean
- Times.Body.Gyro.Jerk.Magnitude.std

#### **ii. List of Frequency Signal Features**
>- Frequency.Body.Accel.mean (X,Y,Z)
- Frequency.Body.Accel.std (X,Y,Z)
- Frequency.Body.Accel.Jerk.mean (X,Y,Z)
- Frequency.Body.Accel.Jerk.std (X,Y,Z)
- Frequency.Body.Gyro.mean (X,Y,Z)
- Frequency.Body.Gyro.std (X,Y,Z)
- Frequency.Body.Accel.Magnitude.mean
- Frequency.Body.Accel.Magnitude.std
- Frequency.Body.Accel.Jerk.Magnitude.mean
- Frequency.Body.Accel.Jerk.Magnitude.std
- Frequency.Body.Gyro.Magnitude.mean
- Frequency.Body.Gyro.Magnitude.std
- Frequency.Body.Gyro.Jerk.Magnitude.mean
- Frequency.Body.Gyro.Jerk.Magnitude.std
