# GettingData
For the course getting and cleaning data

Explanation of run_analysis.R

*Steps

1. 
The code reads all files from the "working directory" and the underlying folders
"test" and "train" and renames them properly, based on the given information in the provided files.

2.
The code combines the read data, using cbind and rbind

3.
With the help of the grep command, all columns that contain either "std" or "mean" 
in their names are extracted. Then these columns are combined to a filtered dataset
with the vectors subject_number and activity_number.

4.
In the last step the reshape2 library is used, to first melt the dataset
and then to dcast it to it's final form, using mean as a function.
