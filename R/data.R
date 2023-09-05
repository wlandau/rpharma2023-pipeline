#' @title Simulate patient data.
#' @description Simulate a virtual patient dataset of a clinical trial.
#' @return A single long tidy data frame of virtual patient responses.
#'   There is one row per patient and the following columns:
#'   * `patient_id`: the patient ID.
#'   * `study_arm`: the treatment group, or study arm of each patient:
#'     `"drug"` or `"placebo"`. Patients are randomized to either receive
#'     the real drug or the placebo.
#'   * `response`: the value of the primary endpoint of each patient.
#' @param mean_response_drug Numeric of length 1, assumed true mean response
#'   of a patient to the drug under the given simulation scenario.
#' @param sample_size Positive even integer of length 1,
#'   total number of patients in the trial for the given simulation scenario.
#' @examples
#' library(tibble)
#' simulate_dataset(
#'   mean_response_drug = 2,
#'   sample_size = 200
#' )
simulate_dataset <- function(
  mean_response_drug,
  sample_size
) {
  patient_id <- paste0(
    "patient_",
    sample.int(n = 1e9, size = sample_size, replace = FALSE)
  )
  study_arm <- rep(x = c("drug", "placebo"), each = sample_size / 2)
  response_drug <- rnorm(
    n = sample_size / 2,
    mean = mean_response_drug,
    sd = 4.25
  )
  response_placebo <- rnorm(n = sample_size / 2, mean = 1, sd = 4.25)
  tibble(
    patient_id = patient_id,
    study_arm = study_arm,
    response = c(response_drug, response_placebo)
  )
}
