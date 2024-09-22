library(tidyverse)
# library(tidycensus)
library(jsonlite)
library(dplyr)

census_url <- "https://api.census.gov/data/2022/acs/acs1/pums?get=SEX,PWGTP,MAR&SCHL=24"
census_raw <- httr::GET(census_url)
parsed_census <- as.data.frame(fromJSON(rawToChar(census_raw$content)))

# TASK: write a helper function to take what is return by GET() and turn it into a tibble
#     - first record are actually the column names
#     - all the rest are the data values

census_tbl <- as_tibble(parsed_census[-1,])
colnames(census_tbl) <- parsed_census[1,]

# API call examples
url_basic <- "https://api.census.gov/data/2022/acs/acs1/pums?get=WGTP,PWGTP,GRPIP,GASP,AGEP,HISPEED,HHL,FER,JWAP"

# API call: CA, NC, MA
url_states <- "https://api.census.gov/data/2022/acs/acs1/pums?get=WGTP,PWGTP,GRPIP,GASP,AGEP,HISPEED,HHL,FER,JWAP&ucgid=0400000US06,0400000US25,0400000US37"

# TASK: write a function that queries the API and allows changes to:
#     - year of survey (2022 default)
#     - 


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Census API Query Function
# KATY - take url all the way to tibble 
# (nice and neat and columns in correct format etc)
query_census_with_url <- function(url) {
  
  # retrieve data in list form from API
  census_raw <- httr::GET(url)
  
  # call helper function to turn API raw data into a raw tibble
  census_raw_tbl <- query_helper(census_raw)
  
  # a bunch of other stuff to clean tibble
  
  # return final clean tibble
  
}

# helper function for query_census_with_url: put json stuff into raw tibble (all char)
query_helper <- function(census_raw) {
  
  # convert JSON string raw data to data frame (first row are column names)
  parsed_census <- as.data.frame(fromJSON(rawToChar(census_raw$content)))
  
  # convert to a tibble, use 1st row from raw df as column names
  census_tbl <- as_tibble(parsed_census[-1,])
  colnames(census_tbl) <- parsed_census[1,]
  
  # return final tibble
  return(census_tbl)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Helper Function to Process and Clean Data 
# KATY
process_census_data <- function(raw_data, 
                                numeric_vars, 
                                categorical_vars) {
  # Parse JSON data
  
  # turn variables into numeric values or time values (use the middle of the 
  # time period) where appropriate.
  
  # Assign class for custom methods
  # class(your_tibble) <- c("census", class(your_tibble)
  
}
