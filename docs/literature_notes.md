# Literature notes

Notes written from the sources named below. Items marked "not accessed" were not read.

## Andersson et al. (2023), Environmental Data Science 2, e32 (doi:10.1017/eds.2023.22)
Convolutional Gaussian neural process (ConvGNP) for environmental sensor placement, with Antarctic temperature anomaly as the example. Design points from the supplement (section H):
- Context stations fixed at real station locations; values interpolated from the gridded data.
- Search period = model validation period; analysis period = model test period.
- Search: dates 2014-2017 subsampled by 14 (105 tasks). Analysis: 243 dates in 2018-2019 (every 3rd day).
- Search grid one query per 100 km, ocean masked; S = Nt = 1,365 cells.
- 143,325 forward passes took about 3 h on a 32 GB V100.
- Criteria: JointMI, MarginalMI, DeltaVar (GP models), ContextDist, oracle criteria, Random baseline (5 random placements).
- Metrics versus number of stations: joint NLL, mean marginal NLL, RMSE.

## Melt-emulator transferability preprint (EarthArXiv 15294; not peer reviewed)
"Transferability of ML emulators for polar RCM surface melt under different forcings: Limitations and recommendations". Same HIRHAM5 runs as this project (ERA-Interim, CESM2, EC-Earth).
- Data: historical 1980-2016, SSP5-8.5 future 2065-2100; first ten years used only as 10-year-mean inputs, so errors are assessed for 1990-2016 and 2075-2100.
- Training: one emulator per dataset on all years but the last (loss monitoring), evaluated on all years; 20 retrainings; best run by multi-year MAE.
- Within a climate regime, transfer works reasonably (biases below inter-model spread, up to about 8%). Between historical and future it roughly doubles relative error (about 22%) with +11 to +13% bias forward and -9 to -15% backward.
- Albedo as an input removes most of the transfer error; pooled or extreme-only training and physics-informed loss terms did not help.
- Annual melt varies strongly (ERA-Interim run 621 +/- 141 Gt per year); evaluate on many years.
- Recommendations: stay in the same scenario and period; add multi-scale temporal context; test transferability sparingly.

## Approaches to improve transferability across regimes
- More state information as inputs (albedo, surface-state proxies, longer temporal context).
- Fine-tuning with a small amount of target-regime data (Dheeshjith et al. 2024, arXiv:2405.18585; Sun et al., arXiv:2311.17078).
- Climate-invariant input/output transformations (Beucler et al. 2024, Sci. Adv. 10, eadj7250).
- Latent or feature alignment between regimes (CERA, arXiv:2509.00010; FuXi-CMIPAlign, arXiv:2508.16396).
- Confidence-aware fallback to the physical model (Heuer et al., arXiv:2510.08107).
- Noise augmentation; causal or sparsity constraints (PICABU, arXiv:2506.09891).

## Spectral loss and transferability
AIES-D-25-0090.1 was **not accessed** (publisher blocked automated access). TODO: read it and add findings.

## SMBnet (Puggaard et al., preprint)
Physics-guided deep learning model of monthly SMB for Central West Greenland, 2002-2023, 0.25 degree grid, from satellite data and ERA5, trained against basin-integrated GRACE-based SMB. Not designed for future scenarios. Useful as an observation-based reference, not as a downscaler.
