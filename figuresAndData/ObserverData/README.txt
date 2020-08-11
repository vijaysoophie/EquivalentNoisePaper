This folder has two files
1. proportionComparisonChosen.csv
2. subjectThreshold.csv

1. proportionComparisonChosen.csv contain the response data for each observer.
The data is arranged according the name of the observer.
For each observer we provide the number of times the observer chose the 
comparison image to have the target with the higher lightness. 
The first column gives the lightness level of the comparison target in LRF.
The standard target was at 0.4 LRF.

The data was collected three times at each covariance scalar.

2. subjectThreshold.csv contains the threshold for each subject. 
The thresholds were obtained by fitting the proportion comparison chosen
data with a cumulative gaussian using the palamedes toolbox.
The first column gives the value of the covariance scalar.
Each row gives the subject threshold these values of the covariance scalar.
The three thresholds at each covariance scalar are for the three acquisitions.



