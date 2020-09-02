#' Processes a single parsed IR file
#'
#' Creates a complete timeseries for a single parsed IR file and converts NAs
#' counts to zeros.
#'
#' @param df The dataframe of IR counts from a single device.
#'
#' @return A dataframe of IR count data with complete dates and any missing counts
#' converted to zeros.
#'
#' @export
#'
#' @examples
#' df <- tibble::tibble(
#' PlacementID = c(102, 102, 102, 102),
#' date = c("19-06-04", "19-06-07", "19-06-08", "19-06-10"),
#' time = c("14:00", "14:00", "13:01", "12:02"),
#' count = c(15, 13, 12, 50))
#' make_ir_table(df)
make_ir_table <- function(df) {
	# convert the date to date-time object
	df <- df %>%
		dplyr::mutate(date = lubridate::ymd(df$date))

	# create completed timeseries
	df <- make_complete_timeseries(df)

	# replace NA counts with zero
	df <- insert_zero_counts(df)

	return(df)

}
