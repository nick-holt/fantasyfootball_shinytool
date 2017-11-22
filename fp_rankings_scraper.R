# FantasyPros Consensus Scraper for Shiny App

# libraries
library(XML)
library(RCurl)
library(tidyverse)
library(stringr)

# URL info
        qb <- "https://www.fantasypros.com/nfl/rankings/qb.php"
        k <- "https://www.fantasypros.com/nfl/rankings/k.php"
        dst <- "https://www.fantasypros.com/nfl/rankings/dst.php"
        idp <- "https://www.fantasypros.com/nfl/rankings/idp.php"
        dl <- "https://www.fantasypros.com/nfl/rankings/dl.php"
        lb <- "https://www.fantasypros.com/nfl/rankings/lb.php"
        db <- "https://www.fantasypros.com/nfl/rankings/db.php"

        # standard scoring
        rb <- "https://www.fantasypros.com/nfl/rankings/rb.php"
        wr <- "https://www.fantasypros.com/nfl/rankings/wr.php"
        te <- "https://www.fantasypros.com/nfl/rankings/te.php"
        flex <- "https://www.fantasypros.com/nfl/rankings/flex.php"
        qbflex <- "https://www.fantasypros.com/nfl/rankings/qb-flex.php"
        
        # ppr
        rbppr <- "https://www.fantasypros.com/nfl/rankings/ppr-rb.php"
        wrppr <- "https://www.fantasypros.com/nfl/rankings/ppr-wr.php"
        teppr <- "https://www.fantasypros.com/nfl/rankings/ppr-te.php"
        flexppr <- "https://www.fantasypros.com/nfl/rankings/ppr-flex.php"
        qbflexppr <- "https://www.fantasypros.com/nfl/rankings/ppr-qb-flex.php"
        
        # half-point per reception
        rbhalf <- "https://www.fantasypros.com/nfl/rankings/half-point-ppr-rb.php"
        wrhalf <- "https://www.fantasypros.com/nfl/rankings/half-point-ppr-wr.php"
        tehalf <- "https://www.fantasypros.com/nfl/rankings/half-point-ppr-te.php"
        flexhalf <- "https://www.fantasypros.com/nfl/rankings/half-point-ppr-flex.php"
        qbflexhalf <- "https://www.fantasypros.com/nfl/rankings/half-point-ppr-qb-flex.php"

# function to scrape and clean rankings data 
scrape_ranks <- function(type_url = qb) {
        fp_data <- getURL(type_url)
        ranks <- readHTMLTable(fp_data, header = T, stringsAsFactors = F)
        ranks <- data.frame(ranks$`rank-data`)
        cols <- ncol(ranks)
        ranks <- ranks[,c(1,3,(cols-3):cols)]
        colnames(ranks) <- c("consensus_rank", "player", "min", "max", "average", "sd")
        ranks <- ranks %>%
                na.omit() %>%
                mutate(player = str_sub(player, 1, -4))
}
