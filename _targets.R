library(crew)
library(targets)
library(tarchetypes)
library(tibble)

tar_option_set(
  packages = c("dplyr", "tibble"),
  
  # Locally:
  controller = crew::crew_controller_local(workers = 4)
  
  # On a cluster:
  # controller = crew.cluster::crew_controller_sge(
  #   seconds_launch = 60,
  #   workers = 50,
  #   sge_cores = 4,
  #   sge_memory_gigabytes_required = 2L,
  #   seconds_idle = 30,
  #   sge_log_output = "logs/",
  #   script_lines = paste0(
  #     "module load R/",
  #     getRversion()
  #   )
  # )
  
  # On AWS Batch:
  # controller = crew_controller_aws_batch(
  #   workers = 10L,
  #   seconds_idle = 120,
  #   seconds_launch = 1800,
  #   launch_max = 3L,
  #   processes = 4,
  #   aws_batch_job_definition = "YOUR_JOB_DEFINITION",
  #   aws_batch_job_queue = "YOUR_JOB_QUEUE"
  # ),

  # Storage on AWS:  
  # repository = "aws",
  # resources = tar_resources(
  #   aws = tar_resources_aws(
  #     bucket = "YOUR_BUCKET",
  #     prefix = "YOUR_PREFIX",
  #     region = "YOUR_REGION"
  #   )
  # ),
  # cue = tar_cue(file = FALSE)
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
    reps = 400, # 400 reps per dynamic target,
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
