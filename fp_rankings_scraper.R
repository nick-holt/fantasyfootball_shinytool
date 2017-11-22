# FantasyPros Consensus Scraper for Shiny App

# libraries
library(XML)
library(RCurl)
library(tidyverse)
library(stringr)

# URL info

rank_urls <- list(
        # standard scoring
        qb_standard = "https://www.fantasypros.com/nfl/rankings/qb.php",
        k_standard = "https://www.fantasypros.com/nfl/rankings/k.php",
        dst_standard = "https://www.fantasypros.com/nfl/rankings/dst.php",
        idp_standard = "https://www.fantasypros.com/nfl/rankings/idp.php",
        dl_standard = "https://www.fantasypros.com/nfl/rankings/dl.php",
        lb_standard = "https://www.fantasypros.com/nfl/rankings/lb.php",
        db_standard = "https://www.fantasypros.com/nfl/rankings/db.php",
        rb_standard = "https://www.fantasypros.com/nfl/rankings/rb.php",
        wr_standard = "https://www.fantasypros.com/nfl/rankings/wr.php",
        te_standard = "https://www.fantasypros.com/nfl/rankings/te.php",
        flex_standard = "https://www.fantasypros.com/nfl/rankings/flex.php",
        qb_flex_standard = "https://www.fantasypros.com/nfl/rankings/qb-flex.php",
        
        # ppr
        rb_ppr = "https://www.fantasypros.com/nfl/rankings/ppr-rb.php",
        wr_ppr = "https://www.fantasypros.com/nfl/rankings/ppr-wr.php",
        te_ppr = "https://www.fantasypros.com/nfl/rankings/ppr-te.php",
        flex_ppr = "https://www.fantasypros.com/nfl/rankings/ppr-flex.php",
        qb_flex_ppr = "https://www.fantasypros.com/nfl/rankings/ppr-qb-flex.php",
        
        # half-point per reception
        rb_half_ppr = "https://www.fantasypros.com/nfl/rankings/half-point-ppr-rb.php",
        wr_half_ppr = "https://www.fantasypros.com/nfl/rankings/half-point-ppr-wr.php",
        te_half_ppr = "https://www.fantasypros.com/nfl/rankings/half-point-ppr-te.php",
        flex_half_ppr = "https://www.fantasypros.com/nfl/rankings/half-point-ppr-flex.php",
        qb_flex_half_ppr = "https://www.fantasypros.com/nfl/rankings/half-point-ppr-qb-flex.php"
)

proj_urls <- list(
        # standard scoring
        qb_standard = "https://www.fantasypros.com/nfl/projections/qb.php",
        k_standard = "https://www.fantasypros.com/nfl/projections/k.php",
        dst_standard = "https://www.fantasypros.com/nfl/projections/dst.php",
        rb_standard = "https://www.fantasypros.com/nfl/projections/rb.php",
        wr_standard = "https://www.fantasypros.com/nfl/projections/wr.php",
        te_standard = "https://www.fantasypros.com/nfl/projections/te.php",
        
        # ppr
        rb_ppr = "https://www.fantasypros.com/nfl/projections/rb.php?scoring=PPR",
        wr_ppr = "https://www.fantasypros.com/nfl/projections/wr.php?scoring=PPR",
        te_ppr = "https://www.fantasypros.com/nfl/projections/te.php?scoring=PPR",
        
        # half ppr
        rb_half_ppr = "https://www.fantasypros.com/nfl/projections/rb.php?scoring=HALF",
        wr_half_ppr = "https://www.fantasypros.com/nfl/projections/wr.php?scoring=HALF",
        te_half_ppr = "https://www.fantasypros.com/nfl/projections/te.php?scoring=HALF"
)

# function to scrape and clean rankings data 
scrape_ranks <- function(type_url) {
        fp_rank_data <- getURL(rank_urls[[type_url]])
        ranks <- readHTMLTable(fp_rank_data, header = T, stringsAsFactors = F)
        ranks <- data.frame(ranks$`rank-data`)
        cols <- ncol(ranks)
        ranks <- ranks[,c(1,3,(cols-3):cols)]
        colnames(ranks) <- c("consensus_rank", "player", "min", "max", "average", "sd")
        ranks <- ranks %>%
                na.omit() %>%
                mutate(player = str_sub(player, 1, -4))
        return(ranks)
}

# function to scrape and clean projections data 
scrape_projections <- function(type_url) {
        fp_proj_data <- getURL(proj_urls[[type_url]])
        projs <- readHTMLTable(fp_proj_data, header = T, stringsAsFactors = F)
        projs <- data.frame(projs$data)
        cols <- ncol(projs)
        projs <- projs[,c(1, cols)]
        colnames(projs) <- c("player", "proj_points")
        projs <- projs %>%
                na.omit() %>%
                mutate(player = str_sub(player, 1, -4))
        return(projs)
}

# function to combine scraped ranks and projections
scrape_rank_proj <- function(type_url) {
        ranks <- scrape_ranks(type_url = type_url)
        projs <- scrape_projections(type_url = type_url)
        data <- left_join(ranks, projs)
        return(data)
}