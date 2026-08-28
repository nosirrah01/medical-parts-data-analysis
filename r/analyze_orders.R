setwd("C:/Users/Jeremy/source/repos/nosirrah01/medical-parts-data-analysis")
getwd()
file.exists("data/orders_raw.csv")
orders <- read.csv("data/orders_raw.csv")

head(orders)
str(orders)
summary(orders)

orders$Revenue <- orders$Quantity * orders$UnitPrice

orders$ShippingStatus <- ifelse(
  orders$ShippingDays > orders$ExpectedShippingDays,
  "Late",
  "On Time"
)

head(orders)

aggregate(
  Revenue ~ PartCategory,
  data = orders,
  FUN = sum
)

install.packages("tidyverse")

library(tidyverse)

orders <- read_csv("data/orders_raw.csv")

orders <- orders %>%
  mutate(
    Revenue = Quantity * UnitPrice,
    ShippingStatus = if_else(
      ShippingDays > ExpectedShippingDays,
      "Late",
      "On Time"
    )
  )

orders %>%
  group_by(PartCategory) %>%
  summarise(
    TotalOrders = n(),
    TotalRevenue = sum(Revenue),
    AvgShippingDays = mean(ShippingDays)
  )