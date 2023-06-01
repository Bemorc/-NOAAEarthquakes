
<!-- README.md is generated from README.Rmd. Please edit that file -->

# README

<!-- badges: start -->
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/Bemorc/NOAAEarthquakes?svg=true)](https://ci.appveyor.com/api/projects/status/github/Bemorc/)
<!-- badges: end -->

# COURSERA: [Mastering Softwware Development in R Capstone](https://www.coursera.org/learn/r-capstone/)  
* [Week 4: Documentation, Packaging, and Testing](https://www.coursera.org/learn/r-capstone/home/week/4) Peer-graded Assignment  
* [Week 6: Package Evaluation](https://www.coursera.org/learn/r-capstone/home/week/6) Peer-graded Assignment  
Byron Mattingly   
MIT License 2023   

## Documentation, Packaging, Testing / Package Evaluation

Package: NOAAEarthquakes  
GitHub:  https://github.com/Bemorc/NOAAEarthquakes

## Purpose

The NOAA Earthquake package contains functions to read and clean the data, geoms to
visualize and label earthquakes on a timeline, and functions to display
and label earthquakes on a map.

## Data Source

This package contains NOAA data on significant earthquakes
from 2150 B.C. to the present (May2023) provided by the National Centers
For Environmental Information on <https://www.ngdc.noaa.gov>. The
tab-delimited data were downloaded as a TSV (tab separated value) file
(‘earthquakes.tsv’) from the [NCEI/WDS Global Significant Earthquake
Database](https://www.ngdc.noaa.gov/hazel/view/hazards/earthquake/search).

## Please note
* My understanding is that a mentor (when this course had one!) had posted earlier that AppVeyor would be equally accepted as Travis CI (which is no longer "free" for open source projects and now costs $64 / month for the "hobbyist" edition at the time this project was built!).
* While Travis is used for Continuous (CI) of Linux-based systems, AppVeyor is is used for CI of Windows-based systems and is still free to use for Open-source projects.
* Refer to "3.11 Continuous Integration" and "3.12 Cross Platform Development", pp. 230-240 in <em>Mastering Software Development in R (2017-08-15)</em> by Roger D. Peng, Sean Kross and Brooke Anderson for more on using Travis and AppVeyor.

## Review Criteria

For this assignment you'll submit a link to the [GitHub repository](https://github.com/Bemorc/NOAAEarthquakes) which contains
your package. This assessment will ask reviewers the following questions:

### Week 4: Documentation, Packaging, and Testing

* Does the package contain help files for each function (cf. [man/](https://github.com/Bemorc/NOAAEarthquakes/tree/master/man) directory)?

* Are there examples in the help files for each function (cf. [man/](https://github.com/Bemorc/NOAAEarthquakes/tree/master/man) directory)?

* Does the package have a [NAMESPACE](https://github.com/Bemorc/NOAAEarthquakes/blob/master/NAMESPACE) file?

* Is every function in the package tested (cf. [tests/](https://github.com/Bemorc/NOAAEarthquakes/tree/master/tests/testthat) directory)?

* Is every function in the package demonstrated in the vignette (cf. [vignette/](https://github.com/Bemorc/NOAAEarthquakes/blob/master/vignettes/NOAAEarthquakes.Rmd) directory)?


### Week 6: Package Evaluation

* Your package must be hosted on GitHub. You will be providing the [URL to your package on GitHub](https://github.com/Bemorc/NOAAEarthquakes) so that other students can evaluate your work.

* Your package must at least contain the following directories: 
[R/](https://github.com/Bemorc/NOAAEarthquakes/tree/master/R), 
[man/](https://github.com/Bemorc/NOAAEarthquakes/tree/master/man), 
[tests/](https://github.com/Bemorc/NOAAEarthquakes/tree/master/tests/testthat), 
[vignette/](https://github.com/Bemorc/NOAAEarthquakes/blob/master/vignettes/NOAAEarthquakes.Rmd).

* Your package must at least contain the following files: <s>.travis.yml</s>[appveyor.yml](https://github.com/Bemorc/NOAAEarthquakes/blob/master/appveyor.yml), 
[DESCRIPTION](https://github.com/Bemorc/NOAAEarthquakes/blob/master/DESCRIPTION), 
[LICENSE](https://github.com/Bemorc/NOAAEarthquakes/blob/master/LICENSE), 
[NAMESPACE](https://github.com/Bemorc/NOAAEarthquakes/blob/master/NAMESPACE), 
[README.md](https://github.com/Bemorc/NOAAEarthquakes/blob/master/README.md).

* Every function in your package must have a corresponding test (cf. [tests/](https://github.com/Bemorc/NOAAEarthquakes/tree/master/tests/testthat) directory).

* Every function in your package must have at least one example in its documentation (cf. [man/](https://github.com/Bemorc/NOAAEarthquakes/tree/master/man) directory).

* Your package must have a [vignette/](https://github.com/Bemorc/NOAAEarthquakes/blob/master/vignettes/NOAAEarthquakes.Rmd) which provides an explanation of the purpose for your package and how it could be used. The vignette should include examples for every function that is exported in the package's [NAMESPACE](https://github.com/Bemorc/NOAAEarthquakes/blob/master/NAMESPACE) file.

* <s>A Travis badge</s> An [AppVeyor badge](https://ci.appveyor.com/project/Bemorc/NOAAEarthquakes) that says "build passing" that is linked to your package's <s>Travis</s>[AppVeyor](https://ci.appveyor.com/project/Bemorc/NOAAEarthquakes) build should appear at the top of your [README.md](https://github.com/Bemorc/NOAAEarthquakes/blob/master/README.md) file on GitHub.

* Your package must be tested using <s>Travis</s>[AppVeyor](https://ci.appveyor.com/project/Bemorc/NOAAEarthquakes). There should be no errors, warnings, or notes at the end of your <s>Travis</s>AppVeyorbuild, and all of your tests should be run on <s>Travis</s>[AppVeyor](https://ci.appveyor.com/project/Bemorc/NOAAEarthquakes).


# Installation

You can install this R package from GitHub using devtools:

``` r
library(devtools)
install_github("Bemorc/NOAAEarthquakes")
```

# Usage

Packages relevant for these examples:

``` r
library(NOAAEarthquakes)
library(tidyverse)
library(leaflet)
```

## Included data

Data files included within the package are:

``` r
list.files(system.file("extdata", package = "NOAAEarthquakes"))
#> [1] "earthquakes.tsv"
```

## Reading/Cleaning Data

- eq_read_data() - reads a TSV data file into a data frame and formats
  some of the columns
- eq_location_clean() - splits the `LOCATION` column into `COUNTRY` and
  `REGION` columns
- eq_clean_data() - uses lubridate to form a `DATE` column from the
  `YEAR`,`MONTH`,`DAY` columns in the TSV data file

Viewing the 5 most deadly earthquakes since the year 2000:

``` r
data <- eq_clean_data() %>% 
    dplyr::filter(!is.na(TOTAL_DEATHS)) %>% 
    dplyr::select(DATE, YEAR, COUNTRY, REGION, LONGITUDE, LATITUDE, MAG, TOTAL_DEATHS) %>%
  tidyr::drop_na()
data %>% 
  dplyr::filter(YEAR > 1999) %>%
  dplyr::arrange(desc(TOTAL_DEATHS)) %>%
                   head(n = 5)
#> # A tibble: 5 x 8
#>   DATE       YEAR  COUNTRY   REGION        LONGITUDE LATITUDE   MAG TOTAL_DEATHS
#>   <date>     <chr> <chr>     <chr>             <dbl>    <dbl> <dbl>        <dbl>
#> 1 2010-01-12 2010  HAITI     PORT-AU-PRIN~     -72.5    18.5    7         316000
#> 2 2004-12-26 2004  INDONESIA SUMATRA:  AC~      95.9     3.32   9.1       227899
#> 3 2008-05-12 2008  CHINA     SICHUAN PROV~     103.     31.0    7.9        87652
#> 4 2005-10-08 2005  PAKISTAN  MUZAFFARABAD~      73.6    34.5    7.6        76213
#> 5 2003-12-26 2003  IRAN      SOUTHEASTERN~      58.3    29.0    6.6        31000
```

## Custom ggplot2 Layers

### Timeline

This package includes *geom_timeline()* which adds custom layers to
ggplot for visualizing Earthquakes on a timeline.

For example, here’s how to plot a timeline of deadly earthquakes in 3
different countries:

``` r
data %>% dplyr::filter(YEAR > 1999,
                       COUNTRY %in% c("JAPAN", "CHINA","NEPAL")) %>%
    ggplot2::ggplot() +
    geom_timeline(aes(x = DATE,
                      y = COUNTRY,
                      size = MAG,
                      color = TOTAL_DEATHS))
```
<img src="images/ReadMe_Timeline.png" width="100%" />

### Annotated Timeline

*geom_timeline_label()* can be used to draw labels with markers (line
segments) by adding layers to ggplot.

Labeling the 5 most deadly earthquakes in JAPAN since 1990 by Magnitude:

``` r
data %>% dplyr::filter(COUNTRY == "JAPAN", 
                              YEAR >= 1990) %>%
  ggplot2::ggplot(aes(x = DATE,
                      y = COUNTRY,
                      size = MAG,
                      color = TOTAL_DEATHS,
                      label = REGION,
                      mag = TOTAL_DEATHS)) +
  geom_timeline() +
  geom_timeline_label(aes(n_max = 5))
```
<img src="images/ReadMe_AnnotatedTimeline.png" width="100%" /> \##
Leaflet Maps

*eq_map()* uses the `leaflet` package to generate maps and takes one
argument `annot_col` that specifies the column to use for annotation (by
default `annot_col = DATE`) which is displayed as pop-up text over a
circle centered at each coordinate. For a dataframe with the columns
`LONGITUDE`, `LATITUDE`, `MAG`, `annot_col` displays this information in
the pop-up text instead.

Plot the epicenters on a leaflet map:

``` r
data %>% 
  dplyr::filter(COUNTRY == "MEXICO", 
                YEAR >= 2000) %>% 
  eq_map(annot_col = "DATE")
```

<img src="images/ReadMe_LeafletMap.png" width="100%" /> Used in
conjunction with *eq_map()*, *eq_create_label()* generates a fancier
HTML label.

``` r
data %>% 
  dplyr::filter(COUNTRY == "MEXICO",
                YEAR >= 2000) %>% 
  dplyr::mutate(popup_text = eq_create_label(.)) %>% 
  eq_map(annot_col = "popup_text")
```

<img src="images/ReadMe_FancyLeafletMap.png" width="100%" />

## Links:
* [8.3 Raw Data file](https://r-pkgs.org/data.html#sec-data-extdata) explains how to use inst/extdata.
* [Writing an R package from scratch](https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/)    
* [Github: roxygen2](https://github.com/klutometis/roxygen#roxygen2)   
* [Common `roxygen2` tags](https://bookdown.org/rdpeng/RProgDA/documentation.html#common-roxygen2-tags)
* [Text formatting reference sheet](https://cran.r-project.org/web/packages/roxygen2/vignettes/formatting.html)
* [Writing R Extensions](https://cran.r-project.org/doc/manuals/R-exts.html#Creating-R-packages)
* [Travis: Building R packages](https://docs.travis-ci.com/user/languages/r/)
* [Vignettes: long-form documentation](http://r-pkgs.had.co.nz/vignettes.html)
* [Package Development with devtools Cheat Sheet](https://www.rstudio.com/wp-content/uploads/2015/03/devtools-cheatsheet.pdf)
* [Customizing Package Build Options](https://support.rstudio.com/hc/en-us/articles/200486518-Customizing-Package-Build-Options)
* [Testing packages](http://r-pkgs.had.co.nz/tests.html)
