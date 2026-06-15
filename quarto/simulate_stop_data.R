simulate_stop_data <- function(num_pairs) {
  set.seed(1)
  
  # --- Route Scale Simulation ---
  # Reuses your existing route_occupancy function defined earlier in your script
  route_oc_small <- route_occupancy(num_pairs = num_pairs)
  
  # Generate identical standardized environmental covariates for 30 pairs
  X_res_div_small   <- rnorm(num_pairs, mean = 0, sd = 1) 
  X_hab_pref_small  <- rnorm(num_pairs, mean = 0, sd = 1) 
  X_prod_small      <- rnorm(num_pairs, mean = 0, sd = 1) 
  
  # Generate Sympatry Range overlap via Beta distribution bounded at 5% to 100%
  raw_beta_small <- rbeta(num_pairs, shape1 = 2, shape2 = 3)
  sym_min  <- 5 
  symp_max <- 100 
  sympatry_small   <- sym_min + (raw_beta_small - min(raw_beta_small)) * (symp_max - sym_min) / (max(raw_beta_small) - min(raw_beta_small))
  X_sympatry_small <- (sympatry_small - mean(sympatry_small)) / sd(sympatry_small)
  
  # True parameter benchmarks (Identical to your main text universe rules)
  beta_0        <- 0.5
  beta_res_div  <- -0.7
  beta_hab_pref <- 0.6
  beta_sympatry <- 0.8
  beta_prod     <- 0.3
  
  # Synthesize true latent log-odds ratios and odds ratios
  log_alpha_small <- beta_0 + 
    beta_res_div  * X_res_div_small + 
    beta_hab_pref * X_hab_pref_small + 
    beta_sympatry * X_sympatry_small + 
    beta_prod     * X_prod_small
  alpha_small     <- exp(log_alpha_small)
  
  # Realize route-scale co-occurrences using Fisher's Noncentral Hypergeometric
  m1_small <- route_oc_small$m1
  m2_small <- route_oc_small$m2
  k_small  <- integer(num_pairs)
  
  for(i in 1:num_pairs) {
    if(m1_small[i] == 0 || m2_small[i] == 0) {
      k_small[i] <- 0
    } else {
      k_small[i] <- rFNCHypergeo(1, route_oc_small$m1[i], route_oc_small$N[i] - route_oc_small$m1[i], route_oc_small$m2[i], alpha_small[i])
    }
  }
  
  # Compile into a data frame
  route_data_small <- data.frame(
    N = route_oc_small$N, m1 = m1_small, m2 = m2_small, k = k_small,
    res_div = X_res_div_small, hab_pref = X_hab_pref_small,
    prod = X_prod_small, sympatry = X_sympatry_small,
    pair_id = 1:num_pairs, OR = alpha_small, log_OR = log_alpha_small
  )
  
  # --- Stop Scale Simulation ---
  # Filter out pairs where route co-occurrence (k) is at least 1 
  valid_route_small <- route_data_small[route_data_small$k >= 1, ]
  
  datalist_small <- list()
  counter_small  <- 1
  
  for (row_idx in 1:nrow(valid_route_small)) {
    current_pair <- valid_route_small$pair_id[row_idx]
    num_routes   <- valid_route_small$k[row_idx]
    local_alpha  <- valid_route_small$OR[row_idx] 
    
    rate_A <- valid_route_small$m1[row_idx] / valid_route_small$N[row_idx]
    rate_B <- valid_route_small$m2[row_idx] / valid_route_small$N[row_idx]
    
    for (t in 1:num_routes) {
      S_total <- 50
      
      local_prob_A <- rbeta(1, shape1 = rate_A * 5, shape2 = (1 - rate_A) * 5)
      local_prob_B <- rbeta(1, shape1 = rate_B * 5, shape2 = (1 - rate_B) * 5)
      
      local_prob_A <- max(0.01, min(0.99, local_prob_A))
      local_prob_B <- max(0.01, min(0.99, local_prob_B))
      
      s_m1 <- rbinom(1, size = S_total, prob = local_prob_A)
      s_m2 <- rbinom(1, size = S_total, prob = local_prob_B)
      
      s_m1 <- max(1, s_m1)
      s_m2 <- max(1, s_m2)
      
      s_k <- rFNCHypergeo(1, s_m1, S_total - s_m1, s_m2, local_alpha)
      
      datalist_small[[counter_small]] <- data.frame(
        route_id = paste0("Pair_", current_pair, "_Route_", t),
        pair_id  = current_pair,
        S_total  = S_total,
        m1_stops = s_m1,
        m2_stops = s_m2,
        k_stops  = s_k
      )
      counter_small <- counter_small + 1
    }
  }
  
  stop_data_raw_small <- do.call(rbind, datalist_small)
  
  # Left-join to map environmental covariates back to stops
  stop_data_small <- stop_data_raw_small %>%
    select(pair_id, route_id, S_total, m1_stops, m2_stops, k_stops) %>% 
    left_join(
      route_data_small %>% select(pair_id, res_div, hab_pref, prod, sympatry), 
      by = "pair_id"
    )
  
  # Create the clean sequential index for Stan
  stop_data_small$route_index <- as.integer(as.factor(stop_data_small$route_id))
  
  # Return the data pre-formatted as an ulam-ready list
  return(list(
    k_stops     = stop_data_small$k_stops,
    m1_stops    = stop_data_small$m1_stops,
    m2_stops    = stop_data_small$m2_stops,
    S_total     = stop_data_small$S_total,
    res_div     = stop_data_small$res_div,
    hab_pref    = stop_data_small$hab_pref,
    prod        = stop_data_small$prod,
    sympatry    = stop_data_small$sympatry,
    route_index = stop_data_small$route_index
  ))
}
