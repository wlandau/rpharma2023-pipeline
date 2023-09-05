#' @title One simulation of the trial.
#' @description Run one simulation of the trial and return
#'   the p-value from the hypothesis test.
#' @return A data frame with one row and a `"p_value"`
#'   column with the p-value from the hypothesis test.
#' @param mean_response_drug Numeric of length 1, assumed true mean response
#'   of a patient to the drug under the given simulation scenario.
#' @param sample_size Positive even integer of length 1,
#'   total number of patients in the trial for the given simulation scenario.
#' @examples
#' library(dplyr)
#' library(tibble)
#' simulate_trial(
#'   mean_response_drug = 2,
#'   sample_size = 200
#' )
#' # Trial simulations are random and independent.
#' simulate_trial(
#'   mean_response_drug = 2,
#'   sample_size = 200
#' )
simulate_trial <- function(
  mean_response_drug,
  sample_size
) {
  dataset <- simulate_dataset(
    mean_response_drug = mean_response_drug,
    sample_size = sample_size
  )
  analyze_dataset(dataset)
}
