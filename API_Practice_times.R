library(tidyverse)
library(jsonlite)
library(httr)

# possible url's for this helper function
#   https://api.census.gov/data/2022/acs/acs1/pums/variables/JWDP.json
#   
get_time_refs <- function(url) {
  
# retrieve data in list form from API, then bind rows to put in 1 by x tibble,
# then transpose the data to get key-value pair in columns
times_ref <- 
  fromJSON(url)$values |>
  bind_rows() |>
  pivot_longer(cols = everything(), 
               names_to = "time_code", 
               values_to = "time_range")

# return final clean ref table
return(times_ref)

}
