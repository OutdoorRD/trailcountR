#' Replaces NA counts with zeros.
#'
#' @param df A dataframe of IR counts.
#'
#' @return A dataframe of IR data with missing values filled in.
#' @export
#'
#' @examples
#' df <- tibble::tibble(
#' PlacementID = c(102, 103, 104, 105),
#' date = c("19-06-04", "19-06-04", "19-07-04", "19-07-06"),
#' time = c("14:00", "14:00", "13:01", "12:02"),
#' count = c(15, NA, 12, NA))
#' insert_zero_counts(df)
insert_zero_counts <- function(df) {

	## get the rows with NAs for the count
	zeros <- which(is.na(df$count))

	# replace the NA counts with zero
	df$count[zeros] <- 0

	return(df)
}
