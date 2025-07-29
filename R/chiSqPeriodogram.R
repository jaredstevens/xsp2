#' Chi-Square Periodogram
#'
#' Computes a chi-square periodogram (Qp) across a range of test periods
#' for binned activity data. Useful for detecting rhythmicity in time-series data.
#'
#' @description
#' This function calculates the chi-square Qp statistic for a range of test
#' periods using binned activity values. It returns both the Qp values and the
#' significance threshold at p = 0.01.
#'
#' @note Based on code from the \pkg{xsp} package by Hitoshi Iuchi (2017), MIT License.
#'
#' @param activityDF A data frame containing a numeric `value` column with regularly binned activity values.
#' @param periodRange A numeric vector of length 2 indicating the minimum and maximum test periods (in hours).
#' @param res Numeric. Resolution of test periods in hours. Defaults to 0.1.
#' @param bin_minutes Numeric. Duration of each time bin in minutes. Defaults to 1.
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{testPeriod}{The test period in hours.}
#'   \item{Qp.act}{The Qp statistic for each test period.}
#'   \item{Qp.sig}{The 0.99 significance threshold for each period.}
#' }
#'
#' @keywords circadian, rhythm, periodogram, time-series
#'
#' @importFrom purrr map_dbl
#' @importFrom stats qchisq
#'
#' @examples
#' # Simulate data with a 24-hour rhythm
#' bins_per_day <- 1440  # 1-min bins
#' n_days <- 10
#' t <- seq(0, n_days * 24, length.out = bins_per_day * n_days)
#' raw <- sin(2 * pi * t / 24) + rnorm(length(t), sd = 0.3)
#' counts <- round(pmax(raw, 0) * 10)
#' df <- data.frame(value = counts)
#' chiSqPeriodogram(df, periodRange = c(20, 28), res = 0.1, bin_minutes = 1)
#'
#' @export
chiSqPeriodogram <- function(activityDF, periodRange = c(5, 35), res = 0.1, bin_minutes = 1){
  bins_per_hour <- 60 / bin_minutes
  testPerVec <- seq(periodRange[1], periodRange[2], by = res)
  qpArray <- map_dbl(testPerVec, ~ calcQp(activityDF$value, .x, bins_per_hour))
  sigArray <- map_dbl(testPerVec, ~ qchisq(0.99^(1 / length(testPerVec)),
                                           round(.x * bins_per_hour)))
  data.frame(testPeriod = testPerVec, Qp.act = qpArray, Qp.sig = sigArray)
}

#' Calculate Qp Value
#'
#' Computes the Qp statistic for a single test period.
#'
#' @description
#' This internal function calculates the chi-square Qp value for a single test period by folding
#' the time-series into cycles of that period and comparing column-wise means to the overall mean.
#'
#' @param values A numeric vector of binned activity values.
#' @param varPer Numeric. Test period in hours.
#' @param bins_per_hour Numeric. Number of time bins per hour (e.g., 60 for 1-minute bins).
#'
#' @return The Qp statistic as a numeric value.
#'
#' @keywords internal
#' @noRd
calcQp <- function(values, varPer, bins_per_hour){
  colNum <- round(varPer * bins_per_hour)
  rowNum <- as.integer(length(values) / colNum)
  foldedValues <- matrix(values[1:(colNum * rowNum)], ncol = colNum, byrow = TRUE)
  avgAll <- mean(foldedValues)
  avgP <- colMeans(foldedValues)
  numerator <- sum((avgP - avgAll)^2)
  denom <- sum((foldedValues - avgAll)^2) / (rowNum * colNum * rowNum)
  qp <- numerator / denom
  return(qp)
}
