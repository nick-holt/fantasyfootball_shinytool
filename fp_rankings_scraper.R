# FantasyPros Consensus Scraper for Shiny App

# libraries
library(XML)
library(RCurl)
library(tidyverse)
library(stringr)

# URL info

        # standard scoring
        qb_standard <- "https://www.fantasypros.com/nfl/rankings/qb.php"
        k_standard <- "https://www.fantasypros.com/nfl/rankings/k.php"
        dst_standard <- "https://www.fantasypros.com/nfl/rankings/dst.php"
        idp_standard <- "https://www.fantasypros.com/nfl/rankings/idp.php"
        dl_standard <- "https://www.fantasypros.com/nfl/rankings/dl.php"
        lb_standard <- "https://www.fantasypros.com/nfl/rankings/lb.php"
        db_standard <- "https://www.fantasypros.com/nfl/rankings/db.php"
        rb_standard <- "https://www.fantasypros.com/nfl/rankings/rb.php"
        wr_standard <- "https://www.fantasypros.com/nfl/rankings/wr.php"
        te_standard <- "https://www.fantasypros.com/nfl/rankings/te.php"
        flex_standard <- "https://www.fantasypros.com/nfl/rankings/flex.php"
        qb_flex_standard <- "https://www.fantasypros.com/nfl/rankings/qb-flex.php"
        
        # ppr
        rb_ppr <- "https://www.fantasypros.com/nfl/rankings/ppr-rb.php"
        wr_ppr <- "https://www.fantasypros.com/nfl/rankings/ppr-wr.php"
        te_ppr <- "https://www.fantasypros.com/nfl/rankings/ppr-te.php"
        flex_ppr <- "https://www.fantasypros.com/nfl/rankings/ppr-flex.php"
        qb_flex_ppr <- "https://www.fantasypros.com/nfl/rankings/ppr-qb-flex.php"
        
        # half-point per reception
        rb_half_ppr <- "https://www.fantasypros.com/nfl/rankings/half-point-ppr-rb.php"
        wr_half_ppr <- "https://www.fantasypros.com/nfl/rankings/half-point-ppr-wr.php"
        te_half_ppr <- "https://www.fantasypros.com/nfl/rankings/half-point-ppr-te.php"
        flex_half_ppr <- "https://www.fantasypros.com/nfl/rankings/half-point-ppr-flex.php"
        qb_flex_half_ppr <- "https://www.fantasypros.com/nfl/rankings/half-point-ppr-qb-flex.php"

# function to scrape and clean rankings data 
scrape_ranks <- function(type_url) {
        fp_data <- getURL(type_url)
        ranks <- readHTMLTable(fp_data, header = T, stringsAsFactors = F)
        ranks <- data.frame(ranks$`rank-data`)
        cols <- ncol(ranks)
        ranks <- ranks[,c(1,3,(cols-3):cols)]
        colnames(ranks) <- c("consensus_rank", "player", "min", "max", "average", "sd")
        ranks <- ranks %>%
                na.omit() %>%
                mutate(player = str_sub(player, 1, -4))
        return(ranks)
}
