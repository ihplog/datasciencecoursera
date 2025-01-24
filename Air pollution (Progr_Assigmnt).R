install.packages("tidyverse")
library("tidyverse")

#### PART 1. Proposed function
pollutantmean <- function(directory, pollutant, id = 1:332) {
  # Create file paths for the specified IDs
  file_paths <- file.path(directory, sprintf("%03d.csv", id))
  
  # Read only the selected files using map_df
  selected_data <- map_df(file_paths, read_csv)
  
  # Extract the correct pollutant column and remove NAs
  pollutant_data <- selected_data[[pollutant]]
  pollutant_data <- pollutant_data[!is.na(pollutant_data)]
  
  # Calculate and return the mean
  mean(pollutant_data)
}

pollutantmean("specdata", "sulfate", 1:10)
  #4.064128

pollutantmean("specdata", "nitrate", 70:72)
  #1.706047

pollutantmean("specdata", "nitrate", 23)
  #1.280833

#### PART 2. Proposed function
complete <- function(directory, id = 1:332) {
  
  # Create an empty data frame to store the results
  results <- data.frame(id = numeric(), nobs = numeric())
  
  # Loop through the specified monitor IDs
  for (i in id) {
    # Format the file name
    file_name <- sprintf("%03d.csv", i)
    file_path <- file.path(directory, file_name)
    
    # Read the CSV file
    data <- read.csv(file_path)
    
    # Count the number of complete cases (rows with no NAs in any column)
    nobs <- sum(complete.cases(data))
    
    # Add the result to the data frame
    results <- rbind(results, data.frame(id = i, nobs = nobs))
  }
  
  return(results)
}

complete("specdata", 1)
#  id nobs
#   1   10

complete("specdata", c(2, 4, 8, 10, 12))
#  id nobs
#   2 1041
#   4  474
#   8  192
#  10  148
#  12   96

complete("specdata", 30:25)
#  id nobs
#  30  932
#  29  711
#  28  475
#  27  338
#  26  586
#  25  463

complete("specdata", 3)
#  id nobs
#   3  243

#### PART 3. Proposed function
corr <- function(directory, threshold = 0) {
  # Get a list of all CSV files in the directory
  file_list <- list.files(directory, pattern = "*.csv", full.names = TRUE)
  num_files <- length(file_list)
  
  # Initialize an empty vector to store correlations
  correlations <- c() 
  
  # Loop through the specified files
  for (i in 1:num_files) {
    file_path <- file_list[i]
    data <- read.csv(file_path)
    
    # Count complete cases
    nobs <- sum(complete.cases(data))
    
    # Check if the threshold is met
    if (nobs > threshold) {
      # Extract sulfate and nitrate data for complete cases
      sulfate <- data$sulfate[complete.cases(data)]
      nitrate <- data$nitrate[complete.cases(data)]
      
      # Calculate the correlation and add it to the vector
      correlation <- cor(sulfate, nitrate)
      correlations <- c(correlations, correlation)
    }
  }

  # If no monitors meet the threshold, return a numeric vector of length 0
  if (length(correlations) == 0) {
    return(numeric(0))
  } else {
    return(correlations)
  }
}

cr <- corr("specdata", 150)
head(cr)
#-0.01895754 -0.14051254 -0.04389737 -0.06815956 -0.12350667 -0.07588814

summary(cr)
#    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#-0.21057 -0.04999  0.09463  0.12525  0.26844  0.76313 

cr <- corr("specdata", 400)
head(cr)
#-0.01895754 -0.04389737 -0.06815956 -0.07588814  0.76312884 -0.15782860

summary(cr)
#    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#-0.17623 -0.03109  0.10021  0.13969  0.26849  0.76313

cr <- corr("specdata", 5000)
summary(cr)
#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#

length(cr)
#0

cr <- corr("specdata")
summary(cr)
#    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#-1.00000 -0.05147  0.10718  0.13766  0.27831  1.00000 

length(cr)
#323