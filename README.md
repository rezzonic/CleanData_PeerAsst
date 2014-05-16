Getting and cleaning data - Peer Assessment 1
=============================================

Acknowledgements, references
----------------------------

The dataset used in this assessment is issued by the following publication:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

For more detailed information about the dataset, please visit

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The uploaded tidy dataset (second tidy dataset)
-----------------------------------------------

The uploaded dataset consists in 180 rows and 68 columns representing the average of each variable (66 variables) for each activity (`activity`) and each subject (`subject.id`). The data format is CSV and can be read with read.csv (no options needed).

The dataset has been created with the `run_analysis.R` R script. It can be reproduced by running the following command:

```
R --no-save < run_analysis.R
```

which will create the `tidy2.csv` file.


In the following table, each line can represent more columns, for example

```
time.body.accelerometer.[mean|std].[xyz]                  
```

represents

```
time.body.accelerometer.mean.x               
time.body.accelerometer.mean.y                  
time.body.accelerometer.mean.z                  
time.body.accelerometer.std.x                 
time.body.accelerometer.std.y                  
time.body.accelerometer.std.z                  
```


The 180 entries consist in the following data:

```
activity                                                  
subject.id                                                
time.body.accelerometer.[mean|std].[xyz]                  
time.gravity.accelerometer.[mean|std].[xyz]               
time.body.accelerometer.jerk.[mean|std].[xyz]             
time.body.gyroscope.[mean|std].[xyz]                      
time.body.gyroscope.jerk.[mean|std].[xyz]                 
time.body.accelerometer.magnitude.[mean|std]              
time.gravity.accelerometer.magnitude.[mean|std]           
time.body.accelerometer.jerk.magnitude.[mean|std]         
time.body.gyroscope.magnitude.[mean|std]                  
time.body.gyroscope.jerk.magnitude.[mean|std]             
frequency.body.accelerometer.[mean|std].[xyz]             
frequency.body.accelerometer.jerk.[mean|std].[xyz]        
frequency.body.gyroscope.[mean|std].[xyz]                  
frequency.body.accelerometer.magnitude.[mean|std]         
frequency.body.body.accelerometer.jerk.magnitude.[mean|std]
frequency.body.body.gyroscope.magnitude.[mean|std]        
frequency.body.body.gyroscope.jerk.magnitude.[mean|std]   
```

For each measure, we keep the mean and the standard deviation. Some measures are along the 3 axis x,y,z, others are just magnitude measures.



The code
--------

The code is divided into 5 sections:

* Section 1: getting the column names in a format R likes

* Section 2: reading and merging data, selecting the demanded columns

* Section 3: further column names transformation

* Section 4: memory cleanup

* Section 5: creating the tidy dataset for upload

### Section 1: getting the column names in a format R likes

Column names are read from the `feature.txt` file. Unfortunately, they contain dashes, parentheses and commas, which R may not like. We replace all unwanted characters with dots, and remove the excess dots.

### Section 2: reading and merging data, selecting the demanded columns

The data from `test/X_test.txt` is read and matched to the column names. Then, we add a column with the subject id from `test/subject_test.txt`.

The activities are stored in `test/y_test.txt`, but we need to use to match the integers to the activity names stored in `activity_labels.txt`.

We merge the columns from data, subject ids and activities into a test dataset.

Moreover, we add a column called `set` containing the string test for all entries. This is not useful in the context of this assignment but I preferred to keep track of the origin of the data (`test`, `train`).

We repeat the same for the training data and we store the result into a train dataset.

To merge the two, we just use the `rbind` function.

Now, we have a dataset called `data`, which contains all the information we need. But it is not tidy enough, as it contains still too much information: we need to extract only the measurements on the mean and standard deviation for each measurement. 

The columns containing the demanded information are the ones whose name contains the strings `mean` or `std` but not meanFreq. We select only those columns. Our tidy dataset will have the following columns:

* activity

* subject.id

* anything with mean or std but not meanFreq

### Section 3: further column names transformation

Following the lectures and the discussion on the forums, I decided to apply the following best practices to the naming of the columns:

* no abbreviations

* no capital letters

* words separated by dots

At the end of this section, we have the first clean dataset as required by the assignment, that is:

* Merges the training and the test sets to create one data set.

* Extracts only the measurements on the mean and standard deviation for each measurement. 

* Uses descriptive activity names to name the activities in the data set

* Appropriately labels the data set with descriptive activity names

### Section 4: memory cleanup

It's time to clean up unused variables. I will only keep in memory the tidy dataset.

### Section 5: creating the tidy dataset for upload

We take the first tidy dataset and complying with the instructions, we create a second, independent tidy data set with the average of each variable for each activity and each subject.

The dataset is written to file with `write.csv`. It can be read again with `read.csv` (no argument needed).
