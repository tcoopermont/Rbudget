#! /usr/bin/env Rscript

library(dplyr)
library(readODS)
library(readr)
library(purrr)

set_period <- function(date,orig_period,start,end) {
	period <- as.POSIXlt(start)[1,'mon'] + 1	
	if((! is.na(date)) && date >= start && date <= end) {
	        period		
	} else {
		orig_period	
	}
}
args = commandArgs(trailingOnly=TRUE)

if (length(args) != 2) {
  stop("start_date and end_date be supplied yyyy-mm-dd.\n", call.=FALSE)
} else {
  # default output file
  start_date <- as.Date(args[1])
  end_date <- as.Date(args[2])
}
print(start_date)


source("../config.R")

budget <- read_ods(budget_file,col_types=cols(col_character(),
					      col_date(format='%Y-%m-%d'),
					      col_number(),col_character(),
					      col_character(),
					      col_integer()))
str(budget)
#cat_lookups <- budget$lookup
#budget <- select(budget,-lookup)

#set_period(budget$Posting.Date[1],budget$period[0],start=start_date,end=end_date)
new_period <- map2_dbl(budget$Posting.Date,budget$period,set_period,start=start_date,end=end_date) 
new_budget <- mutate(budget,period = new_period)

write_ods(arrange(new_budget,Posting.Date),new_file)

file.remove(budget_file)
file.rename(new_file,budget_file)


