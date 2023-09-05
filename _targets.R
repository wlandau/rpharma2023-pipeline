library(targets)
library(tarchetypes)
library(tibble)

tar_option_set(
  packages = c("dplyr", "tibble")
)

scenarios <- tribble(
  ~efficacy, ~mean_response_drug, ~sample_size,
  "strong",   2,                   700,
  "strong",   2,                   800,
  "null",     1,                   700,
  "null",     1,                   800
)

tar_source()

list(
  tar_map_rep(
    name = simulations,
    command = simulate_trial(
      mean_response_drug = mean_response_drug,
      sample_size = sample_size
    ),
    values = scenarios,
    batches = 25, # 25 dynamic targets per scenario
    reps = 40, # 40 reps per dynamic target,
    names = all_of(c("efficacy", "sample_size")),
    columns = all_of(c("efficacy", "sample_size"))
  ),

  tar_target(
    name = results,
    command = simulations %>%
      group_by(efficacy, sample_size) %>%
      summarize(success = mean(p_value < 0.05), .groups = "drop")
  ),

  tar_quarto(report, "report.qmd")
)
