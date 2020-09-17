df <- tibble::tibble(
	PlacementID = c(102, 102, 102, 102),
	date = c("19-06-04", "19-06-07", "19-06-08", "19-06-10"),
	time = c("14:00", "14:00", "13:01", "12:02"),
	count = c(15, 13, 12, 50))

df2 <- tibble::tibble(
	PlacementID = c(102, 102, 102, 102, 102, 102, 102),
	date = c("19-06-04", "19-06-05","19-06-06", "19-06-07", "19-06-08","19-06-09", "19-06-10"),
	time = c("14:00", NA, NA, "14:00", "13:01", NA, "12:02"),
	count = c(15, 0, 0, 13, 12, 0, 50))
df2 <- df2 %>%
	dplyr::mutate(date = lubridate::ymd(df2$date))

test_that("Dates and Counts should match.", {
  expect_equal(make_ir_table(df)$date, df2$date)
  expect_equal(make_ir_table(df)$count, df2$count)
})
