
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xsp2

<!-- badges: start -->

[![R-CMD-check](https://github.com/jaredstevens/xsp2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jaredstevens/xsp2/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/jaredstevens/xsp2/branch/main/graph/badge.svg)](https://app.codecov.io/gh/jaredstevens/xsp2)
[![Lifecycle: Stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![DOI](https://zenodo.org/badge/1028425222.svg)](https://doi.org/10.5281/zenodo.16575808)

<!-- badges: end -->

**xsp2** is an R package that computes chi-square periodograms to predict 
circadian periods and assess statistical significance of rhythmicity in 
time series data [(Sokolove & Bushell, 1978)](https://doi.org/10.1016/0022-5193(78)90022-X). This package builds upon and 
improves the original [xsp](https://CRAN.R-project.org/package=xsp) package by Hitoshi Iuchi & Rikuhiro G. Yamada (2017).

## Why xsp2?

While the original **xsp** package provides tools to compute chi-square 
periodograms for rhythmicity detection, **xsp2** offers important 
enhancements for improved flexibility:

- **Flexible Binning Support:**  
  Allows users to specify bin durations via the `bin_minutes` parameter,
  supporting a wider variety of datasets and sampling schemes.

- **Customizable Period Range:**  
  Users can define the range (`periodRange`) of test periods to tailor
  analyses to their experimental needs.

## Installation

Currently, `xsp2` can be installed directly from GitHub. Make sure you
have the `devtools` package installed:

``` r
install.packages("devtools")
library(devtools)
devtools::install_github("jaredstevens/xsp2")
```

## Usage Example

``` r
library(xsp2)

# Simulate 10 days of 1-minute binned activity with a 24h rhythm
bins_per_day <- 1440  # 1-min bins
n_days <- 10
t <- seq(0, n_days * 24, length.out = bins_per_day * n_days)
raw <- sin(2 * pi * t / 24) + rnorm(length(t), sd = 0.3)
counts <- round(pmax(raw, 0) * 10)
df <- data.frame(value = counts)

# Calculate chi-square periodogram
chiSqPeriodogram(df, periodRange = c(20, 28), res = 0.1, bin_minutes = 1)
```

## [License](LICENSE)

This package (`xsp2`) is released under the [MIT
License](https://cran.r-project.org/web/licenses/MIT).

The [`LICENSE`](LICENSE) file includes the full license text along with
copyright and year attribution for both:

- The original `xsp` package by Hitoshi Iuchi (2017), and

- The new additions by Jared Stevens (2025).

CRAN does **not** allow full license text in the `LICENSE` file for
MIT-licensed packages.

Instead, a **separate CRAN-specific `LICENSE` file** is used when
submitting to CRAN, containing **only** the required attribution lines:

YEAR: 2017, 2025

COPYRIGHT HOLDER: Hitoshi Iuchi, Jared Stevens

For the original `xsp` license text, see [the original xsp LICENSE
file](https://github.com/hiuchi/xsp/blob/master/LICENSE).
