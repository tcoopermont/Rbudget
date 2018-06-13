#! /usr/bin/env Rscript

library(dplyr)
library(readODS)
library(readr)

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop("new trans file be supplied.\n", call.=FALSE)
} else {
  source_file <- args[1]
}

source("./config.R")

budget <- read_ods(budget_file,col_types=cols(col_character(),
					      col_date(format='%Y-%m-%d'),
					      col_number(),
					      col_character(),
					      col_character(),
					      col_integer()))
budget <- mutate(budget,key =  paste(Posting.Date,Amount,Description,sep="|"))
str(budget)
#cat_lookups <- budget$lookup
#budget <- select(budget,-lookup)

new_trans <- read.csv(source_file)

new_trans <- filter(new_trans,Transaction.Type == "Debit") %>%
	select(Transaction.ID,Posting.Date,Amount,Description) %>%
	mutate(key = paste(Posting.Date,Amount,Description,sep="|")
              Posting.Date = as.Date(Posting.Date,format='%m/%d/%Y'),
	       category = "",
	       period=NA)

head(new_trans)
new_trans_append <- filter(new_trans,! key %in% budget$key)
nrow(new_trans_append)
new_budget <- rbind(budget,new_trans_append)

new_buget <- select(new_budget,-key)
write_ods(arrange(new_budget,Posting.Date),new_file)

file.remove(budget_file)
file.rename(new_file,budget_file)


