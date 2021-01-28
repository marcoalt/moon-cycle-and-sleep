rm(list = ls()) 
library(ggplot2)
library(stringr)
library(ggthemes)
library(rjson)
# moon phases
library(suncalc)

# change code below based on your settings
files_path_root <- paste("~/Dropbox/R workspace/github/oura moonphase/", sep = "")
source(paste(files_path_root, "multiplot.R", sep = ""))

# function to compute moving average
mav <- function(x,n){filter(x,rep(1/n,n), sides=1)} 

# plotting colors
col_lightblue <-rgb(52/256, 176/256, 227/256, 1)
col_yellow <-rgb(251/256, 207/256, 48/256, 1)
col_gray <-rgb(151/256, 151/256, 151/256, 1)

output_to_pdf <- TRUE

files_path_data <- paste(files_path_root, "/data/", sep = "")
files_path_figures <- paste(files_path_root, "/figures/", sep = "")

ourajson <- fromJSON(file = paste(files_path_data, "/oura.json", sep = ""), simplify=TRUE)
sleep <- ourajson$sleep

df_sleep_summaries <- data.frame()
for(index_night in 1:length(sleep)) {
  
  curr_night <- sleep[[index_night]]
  hour_bedtime <- as.numeric(substr(curr_night$bedtime_start, 12, 13)) + as.numeric(substr(curr_night$bedtime_start, 15, 16))/60
  if(hour_bedtime > 24) {
    hour_bedtime <- hour_bedtime - 24
  }
  
  moonlight <- getMoonIllumination(curr_night$summary_date)
  
  curr_summary <- data.frame(  index_night,
                               bedtime_start = hour_bedtime,
                               date = curr_night$summary_date,
                               moonlightfraction = moonlight$fraction,
                               moonlightphase = moonlight$phase)

  df_sleep_summaries <- rbind(df_sleep_summaries, curr_summary)
}

df_sleep_summaries$date <- as.Date(df_sleep_summaries$date)
df_sleep_summaries <- df_sleep_summaries[df_sleep_summaries$bedtime_start > 2, ]
df_sleep_summaries$bedtime_start_mav = mav(df_sleep_summaries$bedtime_start, 5)

p1 <- ggplot(df_sleep_summaries, aes(date, bedtime_start, col=col_yellow)) +
  geom_line() +
  geom_line(aes(date, bedtime_start_mav, col=col_lightblue)) +
  geom_point() +
  ggtitle("Bedtime start, blue line = 5 days moving average") +
  theme_minimal() +
  scale_colour_manual(values = c(col_lightblue, col_yellow)) +
  theme(panel.background = element_rect(fill = 'white', colour = 'white')) +
  scale_y_continuous("Bedtime start") +
  theme(legend.position="none")
p2 <- ggplot(df_sleep_summaries, aes(date, moonlightfraction)) +
  geom_line() +
  geom_point() +
  ggtitle("Moon fraction, 0 = new moon, 1 = full moon") +
  theme_minimal() +
  scale_colour_manual(values = c(col_lightblue, col_yellow)) +
  theme(panel.background = element_rect(fill = 'white', colour = 'white')) +
  scale_y_continuous("Moonlight fraction") +
  theme(legend.position="none")
if(output_to_pdf)
{
  pdf(paste(files_path_figures, "/bedtimestart_moon_long.pdf", sep=""), width=20, height=10)
}
multiplot(p1, p2)
if(output_to_pdf)
{
  dev.off()
}

df_sleep_summaries[, "Moon_phase"] <- "Other"
df_sleep_summaries[df_sleep_summaries$moonlightfraction < 0.25, "Moon_phase"] <- "New moon"
df_sleep_summaries[df_sleep_summaries$moonlightfraction > 0.75, "Moon_phase"] <- "Full moon"

p3 <- ggplot(df_sleep_summaries, aes(Moon_phase, bedtime_start, fill = Moon_phase)) +
  geom_boxplot() +
  ggtitle("Bedtime start vs moon phase") +
  theme_minimal() +
  scale_colour_manual(values = c(col_lightblue, col_yellow, col_gray, col_gray, 'black')) +
  scale_fill_manual(values = c(col_lightblue, col_yellow, col_gray, col_gray, 'black')) +
  theme(panel.background = element_rect(fill = 'white', colour = 'white')) +
  scale_x_discrete("") +
  scale_y_continuous("Bedtime start") +
  labs(fill = 'Moon phase')
if(output_to_pdf)
{
  pdf(paste(files_path_figures, "/bedtimestart_moon_box.pdf", sep=""), width=8, height=10)
}
multiplot(p3, cols = 1)
if(output_to_pdf)
{
  dev.off()
}

