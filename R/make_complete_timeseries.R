#' Creates complete timeseries of IR data.
#'
#' Inserts new rows into timeseries for dates that are inside days of operation.
#'
#' @param df A dataframe of IR counter data.
#'
#' @return A dataframe with any missing dates inserted.
#'
#' @import magrittr
#'
#' @export
#'
#' @examples
#' df <- tibble::tibble(
#' PlacementID = c(102, 102, 102, 102),
#' date = c("19-06-04", "19-06-07", "19-06-08", "19-06-10"),
#' time = c("14:00", "14:00", "13:01", "12:02"),
#' count = c(15, 13, 12, 50))
#' make_complete_timeseries(df)
make_complete_timeseries <- function(df) {

	# ensure dates are a date object
	df$date <- lubridate::ymd(df$date)

	# Sometimes a trafx file prints an incorrect date-time
	# at the time of download. Have to check for that last date is after first
	# date in timeseries before creating the series of days of operation,
	# which uses it for an end date.

	start_date <- df$date[1]
	stop_date <- df$date[nrow(df)]

	if (stop_date >= start_date) {
		dayseries <- seq(from = start_date, to = stop_date, by = "days")

	} else {
		dayseries <- seq(from = start_date, to = df[nrow(df) - 1,"date"]$date, by = "days")
		print(df)
		print("WARNING: device improperly recorded download time,
          so final date of operation is taken from the last positive count instead.")
	}

	# create new df with full sequence of dates
	dfdays <- tibble::tibble(date = dayseries)

	# join the full timeseries to the data
	newdat <- dplyr::full_join(dfdays, df, by = "date")

	## get the rows with NAs for the placementId
	zeros <- which(is.na(newdat$PlacementID))

	# add a placement id for the new inserted rows
	newdat$PlacementID[zeros] <- df$PlacementID[1]

	return(newdat)


}
