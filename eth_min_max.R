#!/usr/bin/env Rscript
#eth_minmax.R - hourly min/max ETH price to MS Teams

#packages
suppressPackageStartupMessages({
  library(binancer)   
  library(httr)       
  library(jsonlite)   
  library(lubridate)  
})

#configuration
url  <- Sys.getenv("TEAMS_WEBHOOK")   
pair <- "ETHUSDT"

#time window
end   <- as.numeric(Sys.time()) * 1000           
start <- end 60*60*1000                       

#fetch data
k <- binance_klines(symbol = pair,
                    interval = "1m",
                    start_time = start,
                    end_time   = end)            
low  <- min(as.numeric(k$low_price))
high <- max(as.numeric(k$high_price))

#compose Teams card
body <- list(
  "@type"    = "MessageCard",
  "@context" = "http://schema.org/extensions",
  summary    = "ETH hourly stats",
  themeColor = "0078D7",
  title      = "Hourly ETH/USDT summary",
  text       = sprintf("**Min**: $%.2f\n**Max**: $%.2f", low, high)
)

#send
stop_for_status(
  POST(url, body = body, encode = "json")
)

cat("Posted to Teams:", format(now(tzone = "UTC")), "\n")
