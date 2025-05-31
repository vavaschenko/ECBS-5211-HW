#!/usr/bin/env Rscript
#eth_min_max.R - hourly min/max ETH price to MS Teams

#packages
suppressPackageStartupMessages({
  library(binancer)
  library(teamr)
})

#configuration
url  <- Sys.getenv("TEAMS_WEBHOOK")   
pair <- "ETHUSDT"

#time window
end   <- as.numeric(Sys.time()) * 1000
start <- end - 60*60*1000                    

#fetch data
k <- binance_klines(symbol = pair,
                    interval = "1m",
                    start_time = start,
                    end_time   = end)  

low  <- min(as.numeric(k$low))
high <- max(as.numeric(k$high))

cc <- connector_card$new(hookurl = url)
cc$title("vashchenko_vasilisa@student.ceu.edu")
cc$text(sprintf("**Min**: $%.2f\n**Max**: $%.2f", low, high))
cc$send()

cat("Posted to Teams:", format(now(tzone = "UTC")), "\n")
