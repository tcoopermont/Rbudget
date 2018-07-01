#! /usr/bin/env Rscript

library(dplyr)
library(readODS)
library(readr)
library(tidyr)

args = commandArgs(trailingOnly=TRUE)
if (length(args) != 1) {
  stop("new trans file be supplied.\n", call.=FALSE)
} else {
  source_file <- args[1]
}

source("../config.R")

budget <- read_ods(budget_file,col_types=cols(col_character(),
					      col_date(format='%Y-%m-%d'),
					      col_number(),
					      col_character(),
					      col_character(),
					      col_integer()))

#budget <- separate(budget,c("t1","t2","t3","t4","t5","t6"),",") %>%
#	mutate(Transaction.ID = unite(t1,t2,t3,t4,t5,sep=","))

str(budget)
#cat_lookups <- budget$lookup
#budget <- select(budget,-lookup)

new_trans <- read.csv(source_file)

#try and remove the last element of transaction id, hope it'll be enough
new_trans <- filter(new_trans,Transaction.Type == "Debit") %>%
	separate(Transaction.ID,c("t1","t2","t3","t4","t5","t6"),",") %>%
	unite(Transaction.ID,t1,t2,t3,t4,t5,sep=",") %>%
	select(Transaction.ID,Posting.Date,Amount,Description) %>%
	mutate(
	       #Transaction.ID = unite(t1,t2,t3,t4,t5,sep=","),
	       Posting.Date = as.Date(Posting.Date,format='%m/%d/%Y'),
	       category = "",period=0) 
	

head(new_trans)
new_trans_append <- filter(new_trans,! Transaction.ID %in% budget$Transaction.ID)
nrow(new_trans_append)
new_budget <- rbind(budget,new_trans_append)

write_ods(arrange(new_budget,Posting.Date),new_file)

file.remove(budget_file)
file.rename(new_file,budget_file)


