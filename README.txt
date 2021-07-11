author: antonio vasconcellos
contact: anvasconcellos@gmail.com

IMPORTANT NOTES:
This script was wrote on Windows 10 with the following setup:
platform       x86_64-w64-mingw32          
arch           x86_64                      
os             mingw32                     
system         x86_64, mingw32             
status                                     
major          4                           
minor          1.0                         
year           2021                        
month          05                          
day            18                          
svn rev        80317                       
language       R                           
version.string R version 4.1.0 (2021-05-18)
nickname       Camp Pontanezen


The main script of this project is the run_analysis.R; it manipulate data from 'UCI HAR DATASET' folder (it also contains a README file with complete dataset documentation). 

run_analysis.R is based on 5 STEPS, each one aims to solve a step of final course project;

STEP 1:
The script reads the original data from 'UCI HAR DATASET' generating a 'merged_folder' with a merge of 'UCI HAR DATASET/test' and 'UCI HAR DATASET/train' files;

STEP 2:
The "UCI HAR Dataset/features.txt" represents the column names of X_test.txt, X_train.txt values and consequentely 'merged_files/X_merged.txt'; 
in this step, the script extracts all column names which contains "mean OR mean() OR std OR std() from "UCI HAR Dataset/features.txt"; 
the result columns will be the parameter to run a subset of 'merged_files/X_merged.txt' and generate a new dataset;

STEP 3:
To the dataset generated in STEP2, add columns 'id_activity', 'id_subject' and 'activity_name' which are availables from the files: 'UCI HAR DATASET/activity_labels.txt' and 'merged_files/subject_merged.txt'

STEP 4:
To the dataset generated in STEP3, set the column names a descriptive label from 'UCI HAR DATASET/features.txt'

STEP 5:
This step aims to generate a tidy dataset based on the dataset of STEP 4;
basically, using the dplyr library, the script group data by, 'idSubject', 'idActivity', 'activityName' and summarise each group using the mean function;
generating the 'result.txt' which contains a tidy dataset with 180 lines and 89 columns
