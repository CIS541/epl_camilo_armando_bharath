library (dplyr)
source ('clean_data.R')

# get most frequent score line of a match after n, sim time
nsim = 1000
get_score <- function (home, away, result, nsim){
  # try to get from history, pair
  subset <- hist_pair.pl[ which( hist_pair.pl$HomeTeam ==home | hist_pair.pl$AwayTeam ==away), ]
  # more efficient code, no need to retract back to dataframe many times
  ave_h_s = subset$ave_home_scored[1]
  ave_a_s = subset$ave_away_scored[1]
  
  t_ave_h_s = ave[ave$Team == home,]$ave_scored_h
  t_ave_a_c = ave[ave$Team == away,]$ave_conceded_a
  t_ave_h_c = ave[ave$Team == home,]$ave_conceded_h
  t_ave_a_s = ave[ave$Team == away,]$ave_scored_a
  score_line = character(length(nsim))
  # simulation idea similar to that of sim.R
  count = 0
  for (i in 1:nsim){
    if ((dim(subset)[1] == 1) & (subset$match[1] > 3)){
        h_scored = rpois(1, ave_h_s)
        a_scored = rpois(1, ave_a_s)
      
        if(h_scored > a_scored){
          result[count] = 'W'
          count = count + 1
        } else if(h_scored < a_scored){
          result[count] = 'L'
          count = count + 1
        } else if (h_scored == a_scored){
          result[count] = 'D'
          count = count + 1
        }
      } else {
      # take into account both attacking stat of home and defense stats of away
      h_scored = rpois(1, 1/2 * (t_ave_h_s + t_ave_a_c))
      a_scored = rpois(1, 1/2 * (t_ave_a_s + t_ave_h_c))
      print(h_scored)
      if(h_scored > a_scored){
        result[count] = 'W'
        count = count + 1
      } else if(h_scored < a_scored){
        result[count] = 'L'
        count = count + 1
      } else if(h_scored == a_scored){
        result[count] = 'D'
        count = count + 1
      }
    }
      score_line[i] = paste0(h_scored, '-', a_scored)
  }
  return(list(names(which.max(table(score_line))), max(table(score_line))))
}

get_result <- function (home, away, result, nsim){
  # try to get from history, pair
  subset <- hist_pair.pl[ which( hist_pair.pl$HomeTeam ==home | hist_pair.pl$AwayTeam ==away), ]
  # more efficient code, no need to retract back to dataframe many times
  ave_h_s = subset$ave_home_scored[1]
  ave_a_s = subset$ave_away_scored[1]
  
  t_ave_h_s = ave[ave$Team == home,]$ave_scored_h
  t_ave_a_c = ave[ave$Team == away,]$ave_conceded_a
  t_ave_h_c = ave[ave$Team == home,]$ave_conceded_h
  t_ave_a_s = ave[ave$Team == away,]$ave_scored_a
  score_line = character(length(nsim))
  result = character(length(nsim))
  # simulation idea similar to that of sim.R
  count = 0
  for (i in 1:nsim){
    if ((dim(subset)[1] == 1) & (subset$match[1] > 3)){
      h_scored = rpois(1, ave_h_s)
      a_scored = rpois(1, ave_a_s)
      
      if(h_scored > a_scored){
        result[count] = 'W'
        count = count + 1
      } else if(h_scored < a_scored){
        result[count] = 'L'
        count = count + 1
      } else if (h_scored == a_scored){
        result[count] = 'D'
        count = count + 1
      }
    } else {
      # take into account both attacking stat of home and defense stats of away
      h_scored = rpois(1, 1/2 * (t_ave_h_s + t_ave_a_c))
      a_scored = rpois(1, 1/2 * (t_ave_a_s + t_ave_h_c))
      print(h_scored)
      if(h_scored > a_scored){
        result[count] = 'W'
        count = count + 1
      } else if(h_scored < a_scored){
        result[count] = 'L'
        count = count + 1
      } else (h_scored == a_scored){
        result[count] = 'D'
        count = count + 1
      }
    }
    score_line[i] = paste0(h_scored, '-', a_scored)
  }
  return(list(names(which.max(table(result))), max(table(result))))
}

round_1 <- head(fixtures,20)
round_1$result <- ''
results <- mapply(get_result, round_1$HOME.TEAM, round_1$AWAY.TEAM, round_1$result, nsim, SIMPLIFY = FALSE)
round_1$result <- sapply(results, function(x) x[1])
matches <- mapply(get_score, round_1$HOME.TEAM, round_1$AWAY.TEAM, nsim, SIMPLIFY = FALSE)
round_1$score_line <- sapply(matches, function(x) x[1])

round_1
