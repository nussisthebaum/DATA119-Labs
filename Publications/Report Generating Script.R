## Instructions from https://posit.ds.uchicago.edu/__docs__/cookbook/metrics/analyzing-most-active-content-users-and-publishers/
## API Key: XraWPYODS53ND3Y0Mw72coXKfnlQqmqj

library(connectapi)
library(dplyr)
library(lubridate)
library(tidyr)

as_of_date <- today()
days_back <- 1000
top_n <- 30
report_from <- as_of_date - ddays(days_back)

client <- connect(server = "https://posit.ds.uchicago.edu/",
                  api_key = "XraWPYODS53ND3Y0Mw72coXKfnlQqmqj")

content_info <- connectapi::get_content(client) |>
  hoist(owner, owner_username = "username") |>
  select(guid, name, title, owner_username, dashboard_url)

usage_shiny <- get_usage_shiny(client,
                               from = report_from,
                               to = as_of_date,
                               limit = Inf
)