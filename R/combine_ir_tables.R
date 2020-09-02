#' Makes a single IR table from multiple IR devices
#'
#' Combines a directory of multiple parsed IR files into a single df with
#' a complete timeseries and NAs counts converted to zeros.
#'
#' @param path_to_parsed_ir Full path to the directory containing
#' parsed IR csv files.
#'
#' @return A dataframe of IR counter data.
#'
#' @export
#'
combine_ir_tables <- function(path_to_parsed_ir) {
	# get list of file names
	ir_files <- list.files(path_to_parsed_ir, pattern = ".csv$")

	# initialize the single main dataframe
	main_df <- data.frame()

	# process each file one by one
	for (file in ir_files) {
		# read in a single IR file
		df <- suppressWarnings(readr::read_csv(paste0(path_to_parsed_ir, file),
											   col_types =
											   	cols(
											   		PlacementID = col_character(),
											   		date = col_character(),
											   		time = col_time(format = ""),
											   		count = col_double(),
											   		c1 = col_skip(),
											   		c2 = col_skip(),
											   		c3 = col_skip()
											   	)))
		# process a single df
		df <- make_ir_table(df)

		# add the processed df to the main df
		main_df <- dplyr::bind_rows(main_df, df)
	}

	return(main_df)
}
