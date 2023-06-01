# note: adjust to dataset used
# Currently: 6374 x 39 -> 6374 x 26

suppressWarnings(data <- eq_read_data())

# print ("Tests for eq_read_data")
test_that("all data read",{
    expect_true(nrow(data) == 6374)  # rows
    expect_true(ncol(data) == 26)    # cols
})

# print (Tests for correct column names)
test_that("column names are correct",{
    expect_true(all(c("YEAR", "MONTH", "DAY",
                      "TSUNAMI", "VOLCANO","LOCATION"
                      ) %in% colnames(data)))
})

print ("Tests for eq_location_clean")
test_that("eq_location_clean() without arguments yields dim+1 col tibble",{
    suppressWarnings(temp <- eq_location_clean())
    expect_true(nrow(temp) == 6374)  # rows
    expect_true(ncol(temp) == 27)    # cols: location -> country + region
})

suppressWarnings(temp <- eq_location_clean(data))

test_that("eq_read_data(data) with argument yields dim+1 col tibble",{
    expect_true(nrow(temp)  == 6374)  # rows
    expect_true(ncol(temp)  == 27)    # cols: location -> country + region
})

suppressWarnings(temp <- tibble::tibble(LOCATION = c("PUERTO RICO:ARECIBO","MEXICO:")) %>%
                     eq_location_clean())

test_that("LOCATION split into COUNTRY and REGION columns and then removed",{
    expect_true(exists("temp"))
    expect_true("COUNTRY"   %in% colnames(temp))
    expect_true("REGION"    %in% colnames(temp))
    expect_false("LOCATION" %in% colnames(temp))
})

test_that("parses test data correctly",{
    expect_true(exists("temp"))
    expect_true(temp$COUNTRY[1] == "PUERTO RICO")
    expect_true(temp$COUNTRY[2] == "MEXICO")
    expect_true(temp$REGION[1]  == "ARECIBO")
    expect_true(is.na(temp$REGION[2]))
})


# print ("Tests for eq_clean_data")
suppressWarnings(temp <- eq_read_data() %>% tail(n = 10))

test_that("changing order of eq_clean_data and eq_location_clean does not change the result",{
    suppressWarnings(temp1 <- temp %>% eq_location_clean() %>% eq_clean_data())
    suppressWarnings(temp2 <- temp %>% eq_clean_data()     %>% eq_location_clean())
    expect_true(all.equal(temp1,temp2))
})

test_that("eq_clean_data() without arguments yields a tibble",{
    suppressWarnings(temp <- eq_clean_data())
    expect_true(nrow(temp) == 6374)
})
