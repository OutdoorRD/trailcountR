trailcountR
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

## Package Description

<!-- badges: start -->

<!-- badges: end -->

The goal of **trailcountR** is to make it easier to process visitor
count data collected in the field. Land managers use a variety of
methods to gather visitor traffic counts at the trail or forest level.
These methods may include deploying infrared counters at trail heads
(TRAFx), magnetic vehicle counters, in-person parking lot counts,
cameras and others. These raw formats with instantaneous or hourly
counts must be transformed into daily counts and combined to be used in
downstream analyses.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("OutdoorRD/trailcountR")
```

## Code Usage Examples

### Example 1

Once you have parsed IR data for a specific device, the days included
will only be dates that the device logged a count. If the site had no
visitors for a day or the device was broken, then no counts are logged
for that day and thus that date will not be included in the data. To
create a complete timeseries for IR data, use the
`make_complete_timeseries()` function. Any dates where the counter was
not triggered will have an NA count.

``` r
library(trailcountR)
library(magrittr)

# create a complete timeseries for IR data
df <- tibble::tibble(
    PlacementID = c(102, 102, 102, 102),
    date = c("19-06-04", "19-06-07", "19-06-08", "19-06-10"),
    time = c("14:00", "14:00", "13:01", "12:02"),
    count = c(15, 13, 12, 50))
df %>% 
    kableExtra::kbl() %>% 
    kableExtra::kable_material_dark(lightable_options = "striped")
```

<table class=" lightable-material-dark lightable-striped" style="font-family: &quot;Source Sans Pro&quot;, helvetica, sans-serif; margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:right;">

PlacementID

</th>

<th style="text-align:left;">

date

</th>

<th style="text-align:left;">

time

</th>

<th style="text-align:right;">

count

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

19-06-04

</td>

<td style="text-align:left;">

14:00

</td>

<td style="text-align:right;">

15

</td>

</tr>

<tr>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

19-06-07

</td>

<td style="text-align:left;">

14:00

</td>

<td style="text-align:right;">

13

</td>

</tr>

<tr>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

19-06-08

</td>

<td style="text-align:left;">

13:01

</td>

<td style="text-align:right;">

12

</td>

</tr>

<tr>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

19-06-10

</td>

<td style="text-align:left;">

12:02

</td>

<td style="text-align:right;">

50

</td>

</tr>

</tbody>

</table>

``` r
# make the complete timeseries
df2 <- make_complete_timeseries(df)
df2 %>% 
    kableExtra::kbl() %>% 
    kableExtra::kable_material_dark(lightable_options = "striped")
```

<table class=" lightable-material-dark lightable-striped" style="font-family: &quot;Source Sans Pro&quot;, helvetica, sans-serif; margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

date

</th>

<th style="text-align:right;">

PlacementID

</th>

<th style="text-align:left;">

time

</th>

<th style="text-align:right;">

count

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

2019-06-04

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

14:00

</td>

<td style="text-align:right;">

15

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-05

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-06

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-07

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

14:00

</td>

<td style="text-align:right;">

13

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-08

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

13:01

</td>

<td style="text-align:right;">

12

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-09

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-10

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

12:02

</td>

<td style="text-align:right;">

50

</td>

</tr>

</tbody>

</table>

### Example 2

Once a complete timeseries has been generated for an IR counter, there
might be certain days which have missing counts. This could occur when
no visitors triggered the counter for that day or when the counter has
stopped working. For downstream analyses, these missing counts should be
replaced with a count of zero. The `insert_zero_counts()` function makes
this happen.

``` r
library(trailcountR)
library(magrittr)

## Make toy IR counter data
df <- tibble::tibble(
    PlacementID = c(102, 102, 102, 102),
    date = c("19-06-04", "19-06-07", "19-06-08", "19-06-10"),
    time = c("14:00", "14:00", "13:01", "12:02"),
    count = c(15, 13, 12, 50))

# complete the timeseries
df2 <- make_complete_timeseries(df)

df2 %>% 
    kableExtra::kbl() %>% 
    kableExtra::kable_material_dark(lightable_options = "striped")
```

<table class=" lightable-material-dark lightable-striped" style="font-family: &quot;Source Sans Pro&quot;, helvetica, sans-serif; margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

date

</th>

<th style="text-align:right;">

PlacementID

</th>

<th style="text-align:left;">

time

</th>

<th style="text-align:right;">

count

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

2019-06-04

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

14:00

</td>

<td style="text-align:right;">

15

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-05

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-06

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-07

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

14:00

</td>

<td style="text-align:right;">

13

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-08

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

13:01

</td>

<td style="text-align:right;">

12

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-09

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-10

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

12:02

</td>

<td style="text-align:right;">

50

</td>

</tr>

</tbody>

</table>

``` r
# replace the missing counts with zeros 
df3 <- insert_zero_counts(df2)
df3 %>% 
    kableExtra::kbl() %>% 
    kableExtra::kable_material_dark(lightable_options = "striped")
```

<table class=" lightable-material-dark lightable-striped" style="font-family: &quot;Source Sans Pro&quot;, helvetica, sans-serif; margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

date

</th>

<th style="text-align:right;">

PlacementID

</th>

<th style="text-align:left;">

time

</th>

<th style="text-align:right;">

count

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

2019-06-04

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

14:00

</td>

<td style="text-align:right;">

15

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-05

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-06

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-07

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

14:00

</td>

<td style="text-align:right;">

13

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-08

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

13:01

</td>

<td style="text-align:right;">

12

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-09

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

0

</td>

</tr>

<tr>

<td style="text-align:left;">

2019-06-10

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:left;">

12:02

</td>

<td style="text-align:right;">

50

</td>

</tr>

</tbody>

</table>
