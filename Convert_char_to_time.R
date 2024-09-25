
# Convert char columns to time
library(tidyverse)
library(jsonlite)

# test URL:
test_url <- "https://api.census.gov/data/2022/acs/acs1/pums?get=SEX,PWGTP,MAR,AGEP,JWAP,JWDP&SCHL=24"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Census API Query Function
# KATY - take url all the way to tibble 
# (nice and neat and columns in correct format etc)
query_census_with_url <- function(url) {
  
  # retrieve data in list form from API
  census_raw <- httr::GET(url)
  
  # call helper function to turn API raw data into a raw tibble
  census_raw_tbl <- json_to_raw_tbl_helper(census_raw)
  
  # call helper function to clean tibble
  census_clean_tbl <- process_census_data(census_raw_tbl)
  
  # return final clean tibble
  return(census_clean_tbl)
  
}

# helper function for query_census_with_url: put json stuff into raw tibble (all char)
json_to_raw_tbl_helper <- function(census_raw) {
  
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
process_census_data <- function(census_data_tbl) {
  
  # retrieve valid numeric vars as factor, keeping only the ones that exist in 
  # the input raw data, but exclude JWAP and JWDP (they will be handled separately)
  num_vars <- 
    as.factor(get_valid_numeric_vars()) |>
    intersect(names(census_data_tbl)) |>
    setdiff(c("JWAP", "JWDP"))
  
  # turn vars into numeric values in the tibble 
  for (var in num_vars){
    census_data_tbl[[var]] <- as.numeric(census_data_tbl[[var]])
  } 
  
  # check if there are time variables to convert
  time_vars <- 
    as.factor(c("JWAP", "JWDP")) |>
    intersect(names(census_data_tbl))
  
  # call helper function over loop with items in time_vars
  for (time_code in time_vars){
    census_data_tbl <- convert_char_to_time(time_code)
  }
  
  # Assign class for custom methods
  class(census_clean_tbl) <- c("census", class(census_clean_tbl))
  
  # return clean tibble
  return(census_clean_tbl)
  
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# helper function to convert char columns to time

# get time references from API`
times_JWAP <- get_time_refs("JWAP")
times_JWDP <- get_time_refs("JWDP")

# rename current JWAP/JWDP columns (JWAP_char/JWDP_char) 
if "JWAP" 
test_raw_census <- test_raw_census |>
  rename("JWAP_code" = "JWAP", "JWDP_code" = "JWDP")

# join new JWAP/JWDP to table with proper times

# return cleaned tbl

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# helper function to get clean reference tibble for converting JWDP/JWAP to time
#   possible url's:
#     https://api.census.gov/data/2022/acs/acs1/pums/variables/JWDP.json
#     https://api.census.gov/data/2022/acs/acs1/pums/variables/JWAP.json

get_time_refs <- function(time_var) {
  
  # construct url from the time_var (JWDP or JWAP)
  time_url <- paste0("https://api.census.gov/data/2022/acs/acs1/pums/variables/",
                     time_var, ".json")
  
  # retrieve data in list form from API, then bind rows to put in 1 by x tibble,
  # then transpose the data to get key-value pair in columns
  times_ref <- 
    fromJSON(time_url)$values |>
    bind_rows() |>
    pivot_longer(cols = everything(), 
                 names_to = "time_code", 
                 values_to = "time_range")
  
  # get substring: isolate beginning of time interval (up to 2nd space), 
  # convert to time, add 2 minutes (mid-interval)
  
  # add a numerical column to times_ref with correct time for each level
  
  
  # return final clean ref table
  return(times_ref)
  
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

get_valid_numeric_vars <- function() {
  c("AGEP", "PWGTP", "GASP", "GRPIP", "JWAP", "JWDP", "JWMNP")
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Testing

test_raw_census <- query_census_with_url(test_url)

test_raw_census |>
  left_join(times_JWAP, join_by(JWAP == "time_code"))
