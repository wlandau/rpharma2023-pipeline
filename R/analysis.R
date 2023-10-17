#' @title Analyze a simulated dataset.
#' @description Conduct the hypothesis test and report the p-value.
#' @return A data frame with the p-value from the hypothesis test.
#' @param dataset Data frame with the dataset to analyze.
#'   Generate one with `simulate_dataset()`.
#' @examples
#' library(tibble)
#' dataset <- simulate_dataset(
#'   mean_response_drug = 2,
#'   sample_size = 200
#' )
#' dataset
#' library(dplyr)
#' analyze_dataset(dataset)
analyze_dataset <- function(dataset) {
  dataset %>%
    mutate(
      study_arm = factor(
        study_arm,
        levels = c("placebo", "drug")
      )
    ) %>%
    lm(formula = response ~ study_arm) %>%
    summary() %>%
    coefficients() %>%
    as.data.frame() %>%
    filter(grepl("^study_arm", rownames(.))) %>%
    mutate(
      p_value = pt(
        q = `t value`,
        df = 5,
        lower.tail = FALSE
      )
    ) %>%
    pull(p_value) %>%
    tibble(p_value = .)
}
