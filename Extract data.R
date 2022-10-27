# Set where to save the data
setwd('C:/Users/steef/Documents/NHH/FIE453 Big Data with Application to Finance/Reddit data')

library(pushshiftR) # API package
library(dplyr)

# Set the sample period
'2015-01-01 00:00:00 CET' %>%
  as.POSIXct() %>%
  as.numeric() -> after 

'2021-06-01 00:00:00 CET' %>%
  as.POSIXct() %>%
  as.numeric() -> before

## r/investing data ------------------------------------------------------------

# SUBMISSIONS

getPushshiftDataRecursive(postType = 'submission', # submission / comment
                          size = 200, # How much to download in one request
                          after = after, # time span 
                          before = before, # time span 
                          subreddit = 'investing', # subreddit name
                          nest_level = 1, # Relevant for comments
                          delay = 1 # Set to 1 to not be kicked out
                          ) -> investing.sub

save(investing.sub, file = 'investing.sub.RData') # Save the data

# COMMENTS

# If already downloaded part of the sample, reset the after 
# to the last observation in the downloaded sample
max(investing.comm$created_utc) -> after

getPushshiftDataRecursive(postType = 'comment',
                          size = 200,
                          after = after, # time span 
                          before = before, # time span 
                          subreddit = 'investing',
                          nest_level = 10,
                          delay = 1) -> investing.comm2

save(investing.comm2, file = 'investing_comm2.RData')




