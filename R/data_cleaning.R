# Define global variables

utils::globalVariables(c("YEAR","Year", "MONTH", "Mo", "DAY","Dy",
                         "HOUR", "Hr", "MINUTE", "Mn", "SECOND","Sec",
                         "TSUNAMI","Tsu","VOLCANO","Vol",
                         "LOCATION", "COUNTRY", "REGION",
                         "OFFSET"))


#' Reads in tab-separated value (TSV) raw data taken from the NOAA database
#' Renames Year, Mo, Dy, Hr, Mn, Sec, Tsu, Vol, and "Location Name" for clarity
#' Converts column names to uppercase
#' Drops columns irrelevant to this project
#'
#' @return dataframe
#'
#' @param filename: A character string containing the path and filename of the TSV file
#'
#' @importFrom readr    read_tsv
#' @importFrom magrittr %>%
#' @importFrom dplyr  rename select slice n
#'
#' @examples
#'
#' \dontrun{
#'
#' # Retrieve earthquake data from 2017
#' data <- eq_read_data() %>%
#'            dplyr::filter(YEAR == 2017) %>%
#'            dplyr::select(DATE, YEAR, COUNTRY, REGION, LONGITUDE, LATITUDE, MAG, TOTAL_DEATHS) %>%
#'            tidyr::drop_na()
#' }
#'
#' @export

eq_read_data <- function(filename = system.file("extdata",
                                                "earthquakes.tsv",
                                                package = "NOAAEarthquakes")){
    data <- readr::read_tsv(filename, show_col_types = FALSE) %>%
        dplyr::slice(2:dplyr::n()) %>%     # Remove Search Parameters row
        dplyr::rename(Year     = Year,     # Rename columns for clarity
                      Month    = Mo,
                      Day      = Dy,
                      Hour     = Hr,
                      Minute   = Mn,
                      Second   = Sec,
                      Tsunami  = Tsu,
                      Volcano  = Vol,
                      Location = "Location Name")
    colnames(data) <- gsub(" ", "_", toupper(colnames(data)))
    data <- data %>% dplyr::select(-dplyr::contains("DESCRIPTION"))

    # Remove Search Parameters column
    data <- data[, -1]
}

#' Splits the LOCATION \code{"COUNTRY: REGION"} column into COUNTRY and REGION
#' columns and eliminates it
#' @return dataframe
#'
#' @param data a dataframe or tibble with a LOCATION column
#'
#' @importFrom stringr  str_locate str_split
#' @importFrom magrittr %>%
#' @importFrom dplyr    as_tibble mutate select if_else
#'
#' @examples
#'
#' \dontrun{
#'
#' # Retrieve all earthquake data for Mexico since 2000
#' data <- eq_read_data() %>%
#'            filter(COUNTRY == "MEXICO", YEAR >= 2000) %>%
#'            dplyr::filter(!is.na(TOTAL_DEATHS)) %>%
#'            dplyr::select(DATE, YEAR, COUNTRY, REGION, LONGITUDE, LATITUDE, MAG, TOTAL_DEATHS) %>%
#'            tidyr::drop_na()
#' }
#'
#' @export

eq_location_clean <- function(data = NULL){
    if(is.null(data)){
        data <- eq_read_data()

        # Meta-information location correction of the Cape Farewell Earthquake in Cook
        # Strait, New Zealand (40 12 00.0 S 173 00 00.0 E) on 18Oct1868/19Oct1868 (GMT+12)
        # (cf. https://en.wikipedia.org/wiki/List_of_earthquakes_in_New_Zealand)
        data[2070, 9] <- "NEW ZEALAND:  COOK STRAIT"
        # print(data[2070,9])
    }

    # Split LOCATION into COUNTRY and REGION
    temp <- stringr::str_split(data$LOCATION, ":", n = 2, simplify = TRUE) %>%
        dplyr::as_tibble(.name_repair = 'minimal') # override warning
    colnames(temp) <- c("COUNTRY","REGION")
    temp <- temp %>%
        dplyr::mutate(COUNTRY = trimws(COUNTRY),
                      REGION = trimws(REGION)) %>%
        dplyr::mutate(COUNTRY = dplyr::if_else(COUNTRY == "", NA_character_, COUNTRY),
                      REGION  = dplyr::if_else(REGION  == "", NA_character_, REGION))
    data <- data %>%
        dplyr::mutate(COUNTRY = temp$COUNTRY,
                      REGION  = temp$REGION,
                      .before = LOCATION) %>%
        dplyr::select(-LOCATION)
}


#' Cleans NA dates/times, TSUNAMI, and VOLCANO in "raw" data processed by
#' \code{\link{eq_location_clean}}
#'
#' @param rawdata optional, dataframe outputted from \code{\link{eq_read_data}} or \code{\link{eq_location_clean}}
#'
#' @importFrom dplyr     rename mutate transmute if_else
#' @importFrom lubridate ymd years
#' @importFrom magrittr  %>%
#' @importFrom tidyr     replace_na
#' @importFrom stringr   str_pad
#'
#' @examples
#'
#' \dontrun{
#'
#' # Clean data and filter out entries with no TOTAL_DEATHS data
#' data <- eq_clean_data() %>%
#'     dplyr::filter(!is.na(TOTAL_DEATHS)) %>%
#'     dplyr::select(DATE, YEAR, COUNTRY, REGION, LONGITUDE, LATITUDE, MAG, TOTAL_DEATHS) %>%
#'     tidyr::drop_na()
#' }
#'
#'
#' @export

eq_clean_data <- function(rawdata = NULL){
    if(is.null(rawdata)){
        rawdata <- eq_location_clean()
    }
    rawdata <- rawdata %>%
        dplyr::mutate(MONTH   = tidyr::replace_na(MONTH,1), # Set NA months = 1
                      DAY     = tidyr::replace_na(DAY,  1), # Set NA days   = 1
                      TSUNAMI = dplyr::if_else(is.na(TSUNAMI), FALSE, TRUE),
                      VOLCANO = dplyr::if_else(is.na(VOLCANO), FALSE, TRUE)) %>%

        dplyr::mutate(OFFSET = dplyr::if_else(YEAR < 0, abs(YEAR), 0),
                      .before = YEAR) %>%

        dplyr::mutate(YEAR   = stringr::str_pad(dplyr::if_else(YEAR < 0, 0, YEAR), 4, pad = "0"),
                      MONTH  = stringr::str_pad(MONTH,  2, pad = "0"),
                      DAY    = stringr::str_pad(DAY,    2, pad = "0"),
                      HOUR   = stringr::str_pad(HOUR,   2, pad = "0"),
                      MINUTE = stringr::str_pad(MINUTE, 2, pad = "0"),
                      SECOND = stringr::str_pad(SECOND, 2, pad = "0")) %>%

        dplyr::mutate(DATE = lubridate::ymd(paste(YEAR,MONTH,DAY,sep = "-"))
                      - lubridate::years(OFFSET), .before = OFFSET)
}
