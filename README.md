# getting-and-cleaning-data

This is a script that downloads wearable data and performs some simple analysis and transforms. The steps are as follows (annotated in comments in the script):

1. Download wearable data
2. Combines training and test sets of data for measurements, activity labels, and subject indices
3. Modifies activity labels to be human readable
4. Extracts the mean and standard deviation of each set of measurements
5. Summarizes the data by individual then by activity
6. Saves the analysis to a file and returns the resultant dataframe.
