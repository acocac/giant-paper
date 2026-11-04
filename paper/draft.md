---
title: "Climate-aware sensor placement for Greenland Ice Sheet surface melt (working title)"
author: "TODO: authors and affiliations"
bibliography: references.bib
---

> Draft status: scaffold. Statements about the project design are taken from the planning document and the project discussions. `TODO` marks missing content. Numbers come from `results/evaluation_metrics.csv`.

## Abstract

TODO. Write last. Suggested structure: motivation (sparse, incrementally built in-situ network), approach (probabilistic ML emulator of HIRHAM5 melt used to rank sensor locations), main results (emulator skill under present and future climates; where placements change), implication.

## 1 Introduction

The Greenland Ice Sheet is losing mass, and surface melt is a major driver of that loss. TODO: cite. Existing in-situ networks such as PROMICE and GC-Net were built incrementally and are not optimised for detecting tipping-point early-warning signals. TODO: cite and confirm wording.

Probabilistic machine-learning models can suggest informative sensor placements by finding sites that most reduce prediction uncertainty. Andersson et al. [-@andersson2023] showed this for Antarctic surface air temperature with a convolutional Gaussian neural process, assessing placements with a simulated experiment that keeps the search period separate from the analysis period.

A placement that is optimal for today's climate need not remain so as the ice sheet warms. Machine-learning emulators trained on one climate regime degrade under another [@schlager_preprint], so a placement study across climate windows has to account for emulator transferability.

We address two questions:

- **Q1.** Where are the most informative sensor locations under present-day climate conditions?
- **Q2.** Where are they under future climate conditions, and which locations are no-regret (informative in both) versus future-only?

TODO: contributions paragraph.

## 2 Data

### 2.1 HIRHAM5 simulations

HIRHAM5 is a regional climate model from the Danish Meteorological Institute that combines HIRLAM dynamics with ECHAM5 physics on a 0.05 degree (about 5.5 km) rotated polar grid [@lucaspicher2012]. Its output forces an offline multilayer snow model for meltwater percolation, retention and refreezing [@langen2017]; see also @mottram2017. We use HIRHAM5 runs forced by ERA-Interim, CESM2 and EC-Earth3. TODO: period, scenario and variables of each run (the near-future runs in particular).

### 2.2 Climate windows and data split

We analyse three windows. Within each, train, search and analysis years do not overlap. The first ten years of every run only supply 10-year-mean inputs.

| Window | Runs start | Input-only years | Train | Search | Analysis |
|---|---|---|---|---|---|
| Present | 1980 | 1980-1989 | 1990-2013 | 2014 | 2015-2016 |
| Near future | 2025 | 2025-2034 | 2035-2057 | 2058 | 2059-2060 |
| Long future | 2065 | 2065-2074 | 2075-2097 | 2098 | 2099-2100 |

The present window matches the years assessed in @schlager_preprint (1990-2016). The 10-year means for analysis years include weather from training years but never target years. One model is trained per window and driving dataset because regime matters more than the driving model [@schlager_preprint].

## 3 Methods

### 3.1 Emulator

We use a convolutional conditional neural process (ConvCNP) [@gordon2020] to predict daily melt. TODO: inputs, architecture, loss, optimiser, number of seeds (planned: at least five per window), seed selection (training and search years only).

### 3.2 Sensor placement experiment

We follow the design of @andersson2023: context stations fixed at real station locations, a regular search grid, acquisition functions that rank candidate locations, and an analysis that adds the proposed stations in order and tracks model performance. TODO: station set, grid resolution, number of sensors K, acquisition functions, date sampling for search and analysis, the cross-window regret matrix for Q2.

### 3.3 Evaluation

We report RMSE, MAE and mean bias error (MBE) of daily melt, the annual melt total (Gt) and the melt extent (km^2), for each analysis year. TODO: units of RMSE, MAE and MBE (not labelled on the source plots), and per-year spread relative to the window average.

## 4 Results

### 4.1 Emulator evaluation

Table 1 gives the results for 2016, 2060 and 2100 (evaluation plots in `figures/evaluation/`). Percentages are derived as (predicted - true) / true.

| Year | Driving | RMSE | MAE | MBE | Total melt true -> predicted (Gt) | Total bias | Melt extent bias |
|---|---|---|---|---|---|---|---|
| 2016 | ERA-Interim | 1.53 | 0.33 | -0.23 | 757 -> 607 | -19.8% | -3.3% |
| 2016 | CESM2 | 1.61 | 0.41 | +0.21 | 863 -> 1003 | +16.2% | +28.4% |
| 2016 | EC-Earth3 | 1.38 | 0.35 | -0.02 | 899 -> 886 | -1.4% | +20.0% |
| 2060 | CESM2 | 2.38 | 0.82 | -0.13 | 1850 -> 1765 | -4.6% | +8.6% |
| 2060 | EC-Earth3 | 2.71 | 0.80 | -0.32 | 1663 -> 1450 | -12.8% | +17.0% |
| 2100 | CESM2 | 2.74 | 0.89 | -0.08 | 3424 -> 3372 | -1.5% | +3.5% |
| 2100 | EC-Earth3 | 3.20 | 1.01 | -0.50 | 2787 -> 2460 | -11.7% | +9.2% |

Table: Table 1. Emulator evaluation per year and driving dataset. 2060 and 2100 are only available for CESM2 and EC-Earth3.

Observations from Table 1 and the maps:

- Errors grow with the year for both driving datasets. RMSE rises from 1.61 (2016) to 2.38 (2060) and 2.74 (2100) for CESM2, and from 1.38 to 2.71 and 3.20 for EC-Earth3. TODO: check against melt magnitude, which also rises strongly (true totals of 863 Gt in 2016 and 3424 Gt in 2100 for CESM2).
- CESM2 has the lowest RMSE, bias and extent error in both future years; EC-Earth3's MAE is slightly lower in 2060.
- The EC-Earth3 residual maps show strong under-prediction along the western margin in 2060 and 2100 (visual reading).
- Single-year results are sensitive to how typical the year is. TODO: compare each analysis year with the window average melt.

### 4.2 Sensor placement results

TODO: Q1 (present window) and Q2 (near and long future; no-regret versus future-only locations).

## 5 Discussion

**Transferability.** The growth in error with warming is consistent with the finding that emulators transfer poorly across climate regimes [@schlager_preprint]. Options to improve transfer include richer surface-state inputs, fine-tuning with a small amount of target-regime data [@dheeshjith2024], climate-invariant transformations [@beucler2024], and confidence-aware fallback to the physical model [@heuer2025]. TODO: report which of these we test.

**Limitations.** The emulator is trained on and evaluated against a regional climate model, not observations, so skill reflects agreement with HIRHAM5 and inherits its biases. The analysis uses two years per window. The one-year search is short. TODO: add further limitations as the experiments mature.

## 6 Conclusions

TODO.

## Data and code availability

TODO.

## Acknowledgements

TODO.

## References

::: {#refs}
:::
