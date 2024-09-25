
library(tidyverse)

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


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

valid_numerics <- as.factor(c("AGEP", "PWGTP", "GRPIP", "JWAP", "JWDP"))

numeric_subset <- valid_numerics[!valid_numerics %in% c("JWAP", "JWDP")]

for (f in valid_numerics) {
  print(f)
}

