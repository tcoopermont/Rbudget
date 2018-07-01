
library(dplyr)
library(readODS)
library(readr)
library(tidyr)

new_trans <- read.csv("main-june.csv")

#try and remove the last element of transaction id, hope it'll be enough
new_trans <- filter(new_trans,Transaction.Type == "Debit") %>%
	separate(Transaction.ID,c("t1","t2","t3","t4","t5","t6"),",") %>%
	unite(Transaction.ID,t1,t2,t3,t4,t5,sep=",") %>%
	select(Transaction.ID,Posting.Date,Amount,Description) %>%
	mutate(
	       #Transaction.ID = unite(t1,t2,t3,t4,t5,sep=","),
	       Posting.Date = as.Date(Posting.Date,format='%m/%d/%Y'),
	       category = "",period=NA) 

write_ods(arrange(new_trans,Posting.Date),'budget-trans.ods')
