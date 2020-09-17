df <- tibble::tibble(
	PlacementID = c(102, 102, 102, 102),
	date = c("19-06-04", "19-06-07", "19-06-08", "19-06-10"),
	time = c("14:00", "14:00", "13:01", "12:02"),
	count = c(15, 13, 12, 50))

df2 <- tibble::tibble(
	PlacementID = c(102, 102, 102, 102, 102, 102, 102),
	date = c("19-06-04", "19-06-05","19-06-06", "19-06-07", "19-06-08","19-06-09", "19-06-10"),
	time = c("14:00", NA, NA, "14:00", "13:01", NA, "12:02"),
	count = c(15, NA, NA, 13, 12, NA, 50))
df2 <- df2 %>%
	dplyr::mutate(date = lubridate::ymd(df2$date))


test_that("Date column has the correct series of dates", {

  expect_identical(make_complete_timeseries(df)$date, df2$date)
})

test_that("Correct number of new rows are inserted", {

	expect_identical(nrow(make_complete_timeseries(df)), nrow(df2))
})
