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

## Prior work on station network design in polar regions (search of 2026-11-04)
Found by web search. Full texts were **not accessed**: notes come from abstracts, publisher records and search snippets. Bibliographic details were checked against Crossref or arXiv. TODO: read the key papers (hakim2020, tardif2022, eksen2025) before citing specific numbers.

### Greenland: how existing networks were sited
- No study optimising AWS placement on the Greenland Ice Sheet was found.
- PROMICE [@fausto2021]: sites were chosen to complement existing stations, within reach of heliports and airports. Older stations (GC-Net) lie mostly in the accumulation area, with few in the ablation area. Original 14 AWS in lower/upper pairs in seven regions (lower near the margin, upper near the ELA). Tripods sink with the melting surface. 18 of 26 stations have at least 85% surface-energy-balance coverage. (Read from the article web page.)
- PROMICE | GC-Net [@fausto2026] (read from the article web page; tables are images and were not extracted): GEUS took over GC-Net in 2021; 52 active and historical sites; all in "slow-moving regions considered relatively safe from crevasse formation" (ice-velocity map, Fig. 1). v3 tripods (one boom) in the ablation area, two-boom masts in the accumulation area (flown in by Twin Otter). pypromice processing L0-L3; L3 is per site (stations within 4 km merged), hourly/daily/monthly. Dataset doi:10.22008/FK2/IW73UU. Historical GC-Net reprocessed by @vandecrux2023.
- GrIOOS report [@grioos2019] lists "What is the optimal instrumentation and GrIOOS design?" as an open question.
- Wang et al. [-@wang2026_essd] (ESSD preprint, under review) compile Greenland station records from 1941 onwards and state that most of the northern interior is undocumented.

### Traditional: ensemble sensitivity (pick the site that most reduces total variance of a target field)
- Hakim et al. [-@hakim2020]: Antarctic AWS for surface temperature, using AMPS (WRF) ensembles. Two cases: a blank slate, and conditioning on existing stations that report at least 90% of the time. With the existing stations kept, the top regions were Wilkes Land–Adélie Coast, Ellsworth Land and interior Queen Maud Land.
- Tardif et al. [-@tardif2022]: checked those predictions with offline data assimilation, using random networks as the null baseline. Predicted and actual error reductions agree. Optimal networks beat random ones by up to about 50%, depending on network size and localisation distance. Interior East Antarctic Plateau stations matter most; coastal and Peninsula stations matter least.
- Kim and Kim [-@kim2024]: Arctic Ocean buoys for 2-m temperature, using GFS for July–October 2016–2019 and a 1600 km localisation cutoff. Ten optimal buoys cut analysis variance by about 60% but 24-h forecast error variance by only about 3%. Optimal sites coincide with large error variance.
- Relevance: the natural "traditional" baseline next to MI/variance criteria; also a precedent for checking placement predictions with an independent experiment.

### Traditional: OSSEs and quantitative network design
- Kaminski et al. [-@kaminski2015; -@kaminski2018]: quantitative network design with a variational assimilation system, applied to sea-ice thickness sampling (idealised IceBridge-style transects) and to satellite products for sea-ice forecasts.
- Masutani et al. [-@masutani2013]: argue for OSSEs to optimise the sparse Arctic surface and upper-air network, and stress realistic sea ice, albedo and cloud in the nature run. Guidance only; gives no optimised layout.
- Loose and Heimbach [-@loose2021]: adjoint plus Hessian uncertainty quantification to design ocean observing systems for chosen quantities of interest (North Atlantic examples; an Arctic application was planned but no publication was found).

### Traditional: representativeness / clustering
- Hoffman et al. [-@hoffman2013]: k-means ecoregions (present and future climate) to design an Alaska sampling network; notes that logistics often keep sites from the statistically ideal locations.
- Pallandt et al. [-@pallandt2022]: pan-Arctic eddy-covariance network. Siberia, parts of Canada and mountains are under-represented; adding sites in the least-represented regions beats unguided choices.

### Data-driven / machine learning
- Krause et al. [-@krause2008]: greedy mutual-information placement with GPs, guaranteed to reach at least 1 − 1/e (about 63%) of the optimal gain; MI often beats entropy.
- Andersson et al. [-@andersson2023] (see above). The NeurIPS 2022 workshop version ("Active learning with ConvGNPs...") is v1 of the same arXiv entry (2211.10381). It is still the only polar neural-process placement study found.
- Eksen et al. [-@eksen2025]: ConvCNP with a mixture-density output head; acquisition = expected reduction in *epistemic* uncertainty, which reduces model error more than acquisition on total uncertainty. No study region named in the abstract. Directly relevant to our ConvCNP set-up.
- Shaju et al. [-@shaju2025]: greedy placement of thermometers in ice boreholes (EPICA DML, GRIP) using heat-transfer simulations; up to 10× lower interpolation error than linear or exponential spacing. A vertical rather than spatial problem, but a polar Greenland precedent.
- Not polar-specific: reinforcement learning with a Transformer to improve placement heuristics [@wang2023]; GP column-subset selection versus POD-DEIM on sea surface temperature [@chen2026].

### Gaps this paper can address
1. No optimised AWS network design exists for the Greenland Ice Sheet.
2. Polar placement studies target temperature or sea ice, not surface melt or surface mass balance.
3. No study tests whether an optimal network stays optimal under climate change (our 2016 / 2060 / 2100 windows).
4. Ensemble sensitivity (hakim2020, tardif2022) is a natural traditional baseline alongside random and MI-based criteria.
