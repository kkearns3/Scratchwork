library(tidyverse)
# library(tidycensus)
library(jsonlite)
# library(dplyr)

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

url_nc <- "https://api.census.gov/data/2022/acs/acs1/pums?get=WGTP,PWGTP,GRPIP,GASP,AGEP,HISPEED,HHL,FER,JWAP&ucgid=0400000US37"

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

# append the year
census_nc_raw |>
  add_column(Year = 2010)

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

query_multiple_years <- function(years)
                                 ##REMOVED (testing only), 
                                 # numeric_vars = c("AGEP", "PWGTP"), 
                                 # categorical_vars = c("SEX"), 
                                 # geography = "All", 
                                 # subset = NULL) 
  {
  
  # create empty list
  census_multi_year_list <- list()
  
  # call the user interface for each year
  for (yr in years) {
    
    #  retrieve single year data tibble
    # census_single_yr <- get_data_tibble_from_api(yr,
    #                                              numeric_vars,
    #                                              categorical_vars,
    #                                              geography,
    #                                              subset)
    
    # generate url (testing)
    url <- create_url(yr)
    
    # find how many elements are already in the list
    elements <- length(census_multi_year_list)
    
    # single year tbl, add to list
    # census_multi_year_list[elements + 1] <- query_census_with_url(url)
    
    census_multi_year_list[[elements + 1]] <- tibble(my_url = url, Year = yr)
  }
  
  # union of all tibbles
  census_multi_year_tbl <- bind_rows(census_multi_year_list)
  
  # return the final tibble
  return(census_multi_year_tbl)
  
}

######## TESTING #######

create_url <- function(year) {
  
  url <- paste0("https://api.census.gov/data/", year, "/acs/acs1/pums?get=WGTP,PWGTP,GRPIP,GASP,AGEP,HISPEED,HHL,FER,JWAP&ucgid=0400000US37")
  
}
  

years <- 2020:2022

for (yr in years) {
  print(yr)
}

test_function <- function(years) {
  for (yr in years) {
    url <- create_url(yr)
    print(url)
  }
}
