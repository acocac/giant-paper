# Task list (Milestone 1)

## Data and setup
- [ ] Confirm run metadata: start years, scenarios and output variables for the CESM2 and EC-Earth3 HIRHAM5 runs
- [ ] Confirm units for RMSE / MAE / MBE and the definition of melt extent (ME) on the evaluation plots
- [ ] Define the fixed context station set (real station locations)
  - [ ] Filter station locations to those over the ice mask
  - [ ] Filter station locations to the train split

## Emulator
- [ ] Train one ConvCNP per window and driving model on the agreed schedule (docs/windows_schedule.md)
- [ ] At least five seeds per window; select on training and search years only
- [ ] Add 2013-2015, 2058-2060 and 2098-2100 evaluation results and per-year reporting
- [ ] Control: present-window model applied zero-shot to the future windows
- [ ] Test one transferability improvement (surface-state inputs or fine-tuning) and compare bias and relative error

## Sensor placement
- [ ] Implement the search and analysis pipeline following Andersson et al. (2023), supplement H
- [ ] Implement acquisition functions and the Random / ContextDist baselines
- [ ] Run Q1 (present) and Q2 (near and long future); compute the cross-window regret matrix
- [ ] Stability check of the one-year search (first vs second half of the melt season, top-10 overlap)

## Paper
- [ ] Write abstract and introduction (paper/draft.md)
- [ ] Write methods (emulator details, sensor placement design)
- [ ] Write results for the sensor placement experiments
- [ ] Discussion and limitations; conclusions
- [ ] Verify all references and complete references.bib
- [ ] Data and code availability statement
