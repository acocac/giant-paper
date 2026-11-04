# Results

`evaluation_metrics.csv` collects the numbers printed on the evaluation plots in `figures/evaluation/`.

- `rmse`, `mae`, `mbe` are copied from the plots. **Their units are not labelled on the source plots**; add them once confirmed.
- `true_total_gt` / `predicted_total_gt` are the annual melt totals printed on the hexbin plots.
- `total_bias_*` and `melt_extent_bias_pct` are derived as (predicted - true) and (predicted - true) / true.
- Melt extent (`ME` on the maps) is assumed to be the area where melt occurs, in km2. Confirm.
- Residual maps are assumed to show predicted minus true (red = over-prediction), inferred from the MBE sign.
- The 2016 and 2100 EC-Earth3 rows use the re-run plots, not the first versions.
