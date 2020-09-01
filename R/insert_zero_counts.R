insert_zero_counts <- function(df) {

	## get the rows with NAs for the count
	zeros <- which(is.na(df$count))

	# replace the NA counts with zero
	df$count[zeros] <- 0

	return(df)
}
