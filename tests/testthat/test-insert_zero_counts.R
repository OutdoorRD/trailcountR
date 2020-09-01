test_that("Zero counts are added correctly", {
	df_missing <- df_complete <- tibble::tibble(
		PlacementID = c(102, 103, 104, 105),
		date = c("19-06-04", "19-06-04", "19-07-04", "19-07-06"),
		time = c("14:00", "14:00", "13:01", "12:02"),
		count = c(15, NA, 12, NA))

	df_complete <- tibble::tibble(
		PlacementID = c(102, 103, 104, 105),
		date = c("19-06-04", "19-06-04", "19-07-04", "19-07-06"),
		time = c("14:00", "14:00", "13:01", "12:02"),
		count = c(15, 0, 12, 0))

  expect_equal(insert_zero_counts(df_missing), df_complete)
})
