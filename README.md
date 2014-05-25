getdata_peerassess
==================

coursera getting and cleaning data peer assessment homework

# Project Structure
## run_analysis.R
This is the only R script needed to perform the analysis required in this assignment. It will download the datafile if not currently on-disk, it will subsequently unzip the data file and load the appropriate files.

This script also does some caching to improve run time as you tweak the script. If baseline data changes or the massaging being done to the data changes in the script you need to make the script aware of a need to reload.

Setting reload to any value should work just fine, the script will remove reload after it has reloaded the associated data.

```R
>reload <- 1
```

# Output
## average_data.txt
This contains the combination of the test and train data with all columns that are not related to mean or standard deviation removed. Data has been averaged per subject and per activity.
