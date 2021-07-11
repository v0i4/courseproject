#set auxiliar variables paths
folders_test <- list.dirs("UCI HAR Dataset/test" )

folder_name <- ""
file_name <- ""
file_to_bind <- ""
workdir <- getwd()

#STEP 1 START - MERGE DATASETS PROCESS
for (folder in folders_test) {
  folder_name <- folder
  files <- list.files(folder)
  
  for (file in files) {
    
    file_name <- paste(folder_name, file_name, "/")
    file_name <- paste(folder , file, sep = "/")
    file_name<- paste(workdir, "/", file_name, sep = "")
    file_name <- gsub("/", "\\\\", file_name )
    file_name <- trimws (file_name)
    
    
    file_to_bind <- gsub("test\\>", "train", file_name)
    
    
    if(grepl(".txt", file_name,  fixed = TRUE)) {
      
      df_test <- read.table(file_name, sep = "\t")  
      df_train <- read.table(file_to_bind, sep = "\t")
      
      df_merge <- rbind(df_test, df_train)
      
      output_file = gsub("test\\>", "merged", file)
      output_file <- paste0(output_file)
      
      if(!dir.exists("merged_files")) {
        dir.create("merged_files")  
      }
      
      write.table(df_merge, file = paste("merged_files\\", output_file) ,sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)
      
    } else {
      
      print("navigating folder:")
      print(file_name)
    }
    
  }
  
}

#END OF STEP 1 - DATA SETS ALREADY MERGED


#START OF STEP 2 - EXTRACT COLUMNS WITH 'MEAN' AND 'STD' IN THEIR NAMES

features_list_file <- paste(getwd(), "/", "UCI HAR Dataset", "/features.txt", sep = "")
features_list_file <- trimws(features_list_file)
features_list_file <- gsub("/", "\\\\", features_list_file)

columns_to_extract_list <- c()

df_features <- read.table(features_list_file)
linecounter <- 0

for (col_name in df_features[,2]) {
  linecounter <- linecounter + 1
  
  #retrieve the column index where column name matches with mean OR mean() OR std OR std()
  if(grepl("mean|mean()|std|std()", col_name, ignore.case = TRUE)){
    columns_to_extract_list <- append(columns_to_extract_list, linecounter)
  }
}

#resolve the path to merged files
x_sample_file <- paste(getwd(), "/", "merged_files", "/ X_merged.txt", sep = "")
x_sample_file <- trimws(x_sample_file)
x_sample_file <- gsub("/", "\\\\", x_sample_file)

df_x <- read.table(x_sample_file)


#extract subset of merged X.txt
df_exctracted_data <- df_x[, columns_to_extract_list]
#print(df_exctracted_data)

#END OF STEP 2 - df_exctracted_data contains only the measurements on the mean and standard deviation for each measurement. 

#START OF STEP 3 - ADD A COLUMN WITH ACTIVITY NAME, SUBJECT ID
y_sample_file <- paste(getwd(), "/", "merged_files", "/ y_merged.txt", sep = "")
y_sample_file <- trimws(y_sample_file)
y_sample_file <- gsub("/", "\\\\", y_sample_file)
df_activities <- read.table(y_sample_file)
df_exctracted_data$idActivity <- df_activities$V1


subject_file <- paste(getwd(), "/", "merged_files", "/ subject_merged.txt", sep = "")
subject_file <- trimws(subject_file)
subject_file <- gsub("/", "\\\\", subject_file)
df_subject <- read.table(subject_file)
df_exctracted_data$idSubject <- df_subject$V1

#activity_labels
label_file <- paste(getwd(), "/", "UCI HAR Dataset", "/activity_labels.txt", sep = "")
label_file <- trimws(label_file)
label_file <- gsub("/", "\\\\", label_file)
df_label <- read.table(label_file)

labels_col <- c()
for(id in df_exctracted_data$idActivity) {
  labels_col <- append(labels_col, df_label[id,]$V2)
}

df_exctracted_data$activity <- labels_col

#END OF STEP 3

#START OF STEP 4 replace the 'Vxxx' in the column name to descritive labels from the FEATURES file
descritive_col_names <- paste(getwd(), "/", "UCI HAR Dataset", "/features.txt", sep = "")
descritive_col_names <- trimws(descritive_col_names)
descritive_col_names <- gsub("/", "\\\\", descritive_col_names)

df_descritive_col_names <- read.table(descritive_col_names)
old_col_names <- colnames(df_exctracted_data)
new_col_names <- c()

for (colname in old_col_names) {
  
  if(grepl("^V", colname)) {
    id_col <- gsub("V", "", colname)
    new_col_names <- append(new_col_names, df_descritive_col_names[id_col,]$V2)
  }
  
}

#set descriptive_names
colnames(df_exctracted_data) <- c(new_col_names, "idactivity", "idsubject", "activityname")

#END OF STEP 4


#START OF STEP 5 - CREATE A TIDY DATASET

library(dplyr)
df_tidy <-  df_exctracted_data  %>%  
  group_by(idsubject, idactivity, activityname) %>% 
  summarise_each(funs(mean))

df_tidy_output_file <- "result.txt"
write.table(df_tidy, file = df_tidy_output_file , sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)
#END OF STEP 5