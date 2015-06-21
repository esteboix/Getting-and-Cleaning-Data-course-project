# Getting and Cleaning Data: course project
This script will use the data from the Human Activity Recognition Using Smartphones Dataset to create a file with the averages of all the variables from the dataset that are a mean or a standard deviation from a measurement.

## Script usage
1. Download and unzip the [dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) in your working directory, by default it should be in a folder named "UCI HAR Dataset", if not change it's name to that one, please.
2. Install the dplyr library if you haven't already. You can use this code:
```R
install.packages("dplyr")
```
3. Run the script.
4. Profit!

## What does the script do
1. load the dplyr package
2. read the dataset and join it together
3. select the variables that we need
4. add a column with descriptive names for the different activities
5. change the variable names, so they are a little bit more readable
6. group the data by activity and subject
7. calculate the avwerage of each variable
8. write a txt with the final dataset

## Variable selection
The exercise asks us to select "only the measurements on the mean and standard deviation for each measurement", and this is the code that I used to extract those variables:
```R
selectedData <- Data %>%
                select(1:3,
                       contains("std", ignore.case = TRUE),
                       contains("mean", ignore.case = TRUE),
                       -contains("freq", ignore.case = TRUE),
                       -contains("angle", ignore.case = TRUE))
```
First of all it extracts the first three columns which are the activity id, the subject id and the set to which they belong (test or train). Then it extracts all the columns which have "std" in them (no, not that STD, it stands for Standard Deviation). And the last three lines extract the columns that are means of as measurement, to do that we have first of all select all the columns that contain "mean" in their names,  but we have to deselect some of them which are not directly means of a measurement, those include the weighted average of the frequency components (that's why we exclude "freq" from our selection) and the additional vectors created by averaging the signals in a signal window sample on the angle() variable (that's why we exlude "angle"from our selection). That leaves us with 69 variables: 3 descriptive ones, 33 standard deviations and 33 means.

**tl;dr** we select the three descriptive variables and the means and standard deviations calculated directly from each of the 33 measurements.
