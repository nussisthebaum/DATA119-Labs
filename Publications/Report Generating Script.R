## Instructions from https://posit.ds.uchicago.edu/__docs__/cookbook/metrics/analyzing-most-active-content-users-and-publishers/
## API Key: XraWPYODS53ND3Y0Mw72coXKfnlQqmqj

## Most Used Content

library(connectapi)
library(dplyr)
library(ggplot2)
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

usage_non_shiny <- get_usage_static(client,
                                    from = report_from,
                                    to = as_of_date,
                                    limit = Inf
) |>
  rename(started = time) |>
  mutate(ended = started)

usage <- bind_rows(usage_shiny, usage_non_shiny) |>
  mutate(day = as.Date(started)) |>
  select(content_guid, user_guid, day) |>
  # filter out any content items that may have been deleted
  filter(content_guid %in% content_info$guid)

top_n_content <- usage |>
  group_by(content_guid) |>
  summarise(tot_usage = n()) |>
  arrange(desc(tot_usage)) |>
  head(top_n) |>
  left_join(content_info, by = c(content_guid = "guid")) |>
  # if title is NA then substitute with name
  mutate(title = coalesce(title, name))

## Plots

## Generate Plots

# Usage over Time

gg <- ggplot(usage_plot_data, aes(day, usage)) +
        geom_line(color = "#AE929F", linewidth = 1) +
        theme_minimal() +
        labs(
              y = NULL,
              x = NULL,
              title = glue::glue("Total usage for the {days_back} day period"),
         )

# Top n Content

gg <- ggplot(top_n_content, aes(x = reorder(title, tot_usage), y = tot_usage,
                                +                                 text=paste("owner username:",owner_username))) +
        geom_col(fill = "#16565A") +
        coord_flip() +
        theme_minimal() +
        labs(
              x = NULL,
              y = "content hits",
              title = glue::glue("Top {top_n} content items)")
          )

## Amy's Experiments

avg_usage_by_time <- bind_rows(usage_shiny, usage_non_shiny) |>
  mutate(time_spent = ymd_hms(ended) - ymd_hms(started)) |>
  filter(time_spent > 300) |>
  select(content_guid, user_guid, time_spent) |>
  # filter out any content items that may have been deleted
  filter(content_guid %in% content_info$guid) |>
  group_by(content_guid) |>
  summarize(avg_time = mean(time_spent)) |>
  arrange(desc(avg_time)) |>
  head(top_n) |>
  left_join(content_info, by = c(content_guid = "guid")) |>
  # if title is NA then substitute with name
  mutate(title = coalesce(title, name))

DATA119 <- c("Data 119 Lab 3.5 - VIF and Categorical Variables", "Data 119 Lab 7 - Clustering",                     
             "Data 119 Lab 4 - Logistic Regression", "Data 119 Lab 2 - Correlation and SLR",            
             "Data 119 Lab 3 - Assumption Checking and MLR", "Data 119 Lab 6 - kNN and Confusion Matrices",     
             "Data 119 Lab 1 - Data Wrangling", "Data 119 Lab 8 - SQL",                            
             "Data 119 Lab 5 - Regularization", "Data 119 Lab 9 - Review")

avg_usage_by_time_119 <- avg_usage_by_time |>
  filter(title %in% DATA119)

ggplot(avg_usage_by_time_119, aes(x = reorder(title, total_time), y = total_time,
                              text = paste("owner username:",owner_username))) +
  geom_col(fill = "#16565A") +
  coord_flip() +
  theme_minimal() +
  labs(
    x = NULL,
    y = "content hits",
    title = glue::glue("Top {top_n} content itemsby time spent)")
  )

lab3.5 <- avg_usage_by_time_119 |>
  bind_rows(usage_shiny, usage_non_shiny) |>
  mutate(time_spent = ymd_hms(ended) - ymd_hms(started)) |>
  filter(time_spent > 300) |>
  select(content_guid, user_guid, time_spent) |>
  # filter out any content items that may have been deleted
  filter(content_guid %in% content_info$guid) |>
  left_join(content_info, by = c(content_guid = "guid")) |>
  # if title is NA then substitute with name
  mutate(title = coalesce(title, name)) |>
  filter(title == "Data 119 Lab 3.5 - VIF and Categorical Variables") |>
  filter(time_spent < 20000) ## 24 hours to seconds

ggplot(lab3.5, aes(x = time_spent)) + 
  geom_histogram()

## Plots Final Versions

usage_119 <- bind_rows(usage_shiny, usage_non_shiny) |>
  mutate(quarter = ifelse(as.Date(started) < as.Date("03-15-2025", format = "%m-%d-%Y"), "Winter 2025", 
                          ifelse(as.Date(started) < as.Date("06-07-2025", format = "%m-%d-%Y"), "Spring 2025", 
                                 ifelse(as.Date(started) < as.Date("09-12-2025", format = "%m-%d-%Y"), "Sept. 2025", 
                                        ifelse(as.Date(started) < as.Date("12-13-2025", format = "%m-%d-%Y"), "Autumn 2025",
                                               ifelse(as.Date(started) < as.Date("03-14-2026", format = "%m-%d-%Y"), "Winter 2026", "Spring 2026"))))), 
         quarter_start = ifelse(as.Date(started) < as.Date("03-15-2025", format = "%m-%d-%Y"), as.Date("01-06-2025", format = "%m-%d-%Y"), 
                          ifelse(as.Date(started) < as.Date("06-07-2025", format = "%m-%d-%Y"), as.Date("03-24-2025", format = "%m-%d-%Y"), 
                                 ifelse(as.Date(started) < as.Date("09-12-2025", format = "%m-%d-%Y"), as.Date("08-25-2025", format = "%m-%d-%Y"), 
                                        ifelse(as.Date(started) < as.Date("12-13-2025", format = "%m-%d-%Y"), as.Date("09-29-2025", format = "%m-%d-%Y"),
                                               ifelse(as.Date(started) < as.Date("03-14-2026", format = "%m-%d-%Y"), as.Date("01-05-2026", format = "%m-%d-%Y"), 
                                                      as.Date("03-23-2026", format = "%m-%d-%Y"))))))) |>
  mutate(time_spent = (ymd_hms(ended) - ymd_hms(started))) |>
  mutate(quarter_day = as.Date(started) - as.Date(quarter_start)) |>
  filter(time_spent > 300) |>
  #select(content_guid, user_guid, time_spent) |>
  group_by(content_guid) |>
  mutate(avg_time = mean(time_spent), med_time = median(time_spent), 
         Q1 = quantile(time_spent, probs = c(0.25)), 
         Q3 = quantile(time_spent, probs = c(0.75))) |>
  mutate(IQR = Q3 - Q1) |>
  mutate(max_time = Q3 + 1.5*IQR) |>
  filter(time_spent < max_time) |>
  left_join(content_info, by = c(content_guid = "guid")) |>
  # if title is NA then substitute with name
  mutate(title = coalesce(title, name)) |>
  filter(title %in% DATA119)

ggplot(usage_119, aes(x = time_spent/60, y = title)) + 
  geom_boxplot(color = "#800000") + 
  geom_vline(xintercept = 50, color = "gray20") + 
  scale_x_continuous("Time Spent (minutes)", 
                     breaks = seq(from = 0, to = 150, by = 30)) + 
  scale_y_discrete("", labels = c("Lab 1", "Lab 2", "Lab 3", "Lab 3.5", "Lab 4",
                                  "Lab 5", "Lab 6", "Lab 7", "Lab 8", "Lab 9")) + 
  theme(axis.text.y = element_text(hjust = -0.14)) + 
  ggtitle("DATA119 Tutorial Usage by Time")

usage_119_byq <- usage_119 |>
  group_by(quarter, quarter_day, title) |>
  summarise(usage = n()) |>
  filter(quarter_day > 0) |> 
  mutate(quarter = factor(quarter, levels = c("Winter 2025", "Spring 2025", 
                                              "Sept. 2025", "Autumn 2025", 
                                              "Winter 2026", "Spring 2026"))) |>
  filter(quarter != "Sept. 2025")

ggplot(usage_119_byq, aes(x = quarter_day, y = usage, color = quarter)) +
  geom_line() +
  facet_wrap(vars(title), ncol = 2, dir = "v") + 
  scale_color_manual(name = "Quarter",
                     values = c("Winter 2025" = "#A4343A", "Spring 2025" = "#DE7C00",
                                #"Sept. 2025" = "#EAAA00", 
                                "Autumn 2025" = "#275D38", 
                                "Winter 2026" = "#007396", "Spring 2026" = "#59315F")) + 
  scale_x_continuous("Day of the Quarter") + 
  scale_y_continuous("Usage (meaningful hits)") + 
  theme(legend.position = "bottom") + 
  ggtitle("DATA119 Tutorial Usage over the Quarter")

usage_lab2 <- usage_119_byq |>
  filter(title == "Data 119 Lab 2 - Correlation and SLR")

ggplot(usage_lab2, aes(x = quarter_day, y = usage, color = quarter)) +
  geom_line() +
  scale_color_manual(name = "Quarter",
                     values = c("Winter 2025" = "#A4343A", "Spring 2025" = "#DE7C00",
                                #"Sept. 2025" = "#EAAA00", 
                                "Autumn 2025" = "#275D38", 
                                "Winter 2026" = "#007396", "Spring 2026" = "#59315F")) + 
  scale_x_continuous("Day of the Quarter") + 
  scale_y_continuous("Usage (meaningful hits)") + 
  theme(legend.position = "bottom") + 
  ggtitle("DATA119 Tutorial Usage over the Quarter")


ggplot(usage_119_byq, aes(x = quarter_day, y = usage, color = quarter)) +
  geom_line() +
  facet_wrap(vars(title), ncol = 2, dir = "v") + 
  scale_color_manual(name = "Quarter",
                     values = c("Winter 2025" = "#A4343A", "Spring 2025" = "#DE7C00",
                                "Sept. 2025" = "#EAAA00", "Autumn 2025" = "#275D38", 
                                "Winter 2026" = "#007396", "Spring 2026" = "#59315F")) + 
  scale_x_continuous("Day of the Quarter") + 
  scale_y_continuous("Usage (meaningful hits)") + 
  theme(legend.position = "bottom") + 
  ggtitle("DATA119 Tutorial Usage over the Quarter")



DATA120 <- c("Documentation Lab", "Debugging Lab", "Command Line Interface Lab",
             "Style Guide Lab", "Data 120 String Parsing Lab", "Sequences of Data Lab",
             "Functions and Raising Error Messages", "Trees Lab",                                       
             "Regular Expressions")

usage_120 <- bind_rows(usage_shiny, usage_non_shiny) |>
  mutate(time_spent = (ymd_hms(ended) - ymd_hms(started))) |>
  filter(time_spent > 300) |>
  select(content_guid, user_guid, time_spent) |>
  group_by(content_guid) |>
  mutate(avg_time = mean(time_spent), med_time = median(time_spent), 
         Q1 = quantile(time_spent, probs = c(0.25)), 
         Q3 = quantile(time_spent, probs = c(0.75))) |>
  mutate(IQR = Q3 - Q1) |>
  mutate(max_time = Q3 + 1.5*IQR) |>
  filter(time_spent < max_time) |>
  left_join(content_info, by = c(content_guid = "guid")) |>
  # if title is NA then substitute with name
  mutate(title = coalesce(title, name)) |>
  filter(title %in% DATA120) |>
  mutate(title = factor(title, levels = DATA120))

ggplot(usage_120, aes(x = time_spent/60, y = title)) + 
  geom_boxplot(color = c(rep("#275D38", 7), rep("#9CAF88", 2))) + 
  geom_vline(xintercept = 50, color = "gray20") + 
  scale_x_continuous("Time Spent (minutes)", 
                     breaks = seq(from = 0, to = 150, by = 30)) + 
  scale_y_discrete("", limits = rev, 
                   labels = c("Regular Expressions", "Trees", "Writing Functions",
                              "Sequences of Data", "String Parsing", "Style Guide", 
                              "Command Line Interface", "Debugging", "Documentation")) + 
  #theme(axis.text.y = element_text(hjust = -0.14)) + 
  ggtitle("DATA120 Tutorial Usage by Time")




  