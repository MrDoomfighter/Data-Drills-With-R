# load libraries
library(readr)
library(dplyr)

# read data
hotelBookings = read_csv("./11 Booking Breakdown/hotel_bookings.csv")

# set globals
CAPACITY = 200

# aggregate data
hotelBookingsCount = hotelBookings |>
  filter(is_canceled == 0) |>
  inner_join(
    data.frame(date = min(hotelBookings$checkin_date) : (max(hotelBookings$checkout_date) - 1) |> as.Date()),
    by = join_by(checkin_date <= date, checkout_date > date),
    relationship = 'many-to-many'
  ) |>
  summarise(
    bookings = n(),
    .by = date
  )

# Occupancy Rate in July 2016
hotelBookingsCount |>
  filter(date >= '2016-07-01' & date <= '2016-07-31') |>
  summarise(
    bookings = sum(bookings),
    occupancyRate = sum(bookings) / (n() * CAPACITY) # n() should be equal to 31
  )
