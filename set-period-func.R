#map2_dbl(amj$date,amj$period,set_period,start=as.Date('2018-5-8'),end=as.Date('2018-6-7')) 
set_period <- function(date,orig_period,period,start,end) {
	period <- as.POSIXlt(start)[['mon']] + 1	
	if((! is.na(date)) && date >= start && date <= end) {
	        period		
	} else {
		orig_period	
	}
}

