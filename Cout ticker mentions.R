setwd('C:/Users/steef/Documents/NHH/FIE453 Big Data with Application to Finance/Reddit data')

load('investing_comm.RData')
load('investing_sub.RData')
t <- read.csv('names.csv')
library(stringr)
library(dplyr)
library(tictoc)

# CLEAN DATA
url_regex <- 'http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+' 

# Find mentions of stocks
tickers <- paste0(unique(t$TICKER), collapse = '|')

tickers <- unique(t$TICKER) %>%
  as_tibble() %>%
  filter(nchar(value) > 2)

investing_comm <-
  investing_comm %>%
  mutate(body = gsub(url_regex, '', body))

# ------------------------------------------------------------------------------

# Test line 

library(glue)
library(doParallel)

Cores <- detectCores() - 1

# Instantiate the cores:
cl <- makeCluster(Cores) # Prepare the number of cores for work

# Next we register the cluster..
registerDoParallel(cl) # Open connection between the package and the cluster

# Take the time as before:
tic()
res <-
  foreach( #doParallel function
    i = 1:20,
    .combine = 'cbind',
    # which packages are needed to do the calc in the loop
    .packages = c('dplyr') 
  ) %dopar%
  grepl(tickers$value[i], investing.comm$body)

# Now that we're done, we close off the clusters
stopCluster(cl)

toc()

# ------------------------------------------------------------------------------
