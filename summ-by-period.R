#! /usr/bin/env Rscript

library(dplyr)
library(readODS)
library(readr)

args = commandArgs(trailingOnly=TRUE)


if (length(args) != 0) {
  stop("start_date and end_date be supplied yyyy-mm-dd.\n", call.=FALSE)
} else {
  # default output file
  start_date <- as.Date(args[1])
  end_date <- as.Date(args[2])
}


source("../config.R")

budget <- read_ods(budget_file,col_types=cols(col_character(),
					      col_date(format='%Y-%m-%d'),
					      col_number(),col_character(),
					      col_character(),
					      col_integer()))
str(budget)

group_by(budget,period) %>% summarize(n(),sum(Amount))

