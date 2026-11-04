# Milestone 1: scope and plan (draft, edit as needed)

**Assumption:** Milestone 1 is the climate-aware sensor-placement work described in `planning_sensorplacement_short_M1.docx`, with surface melt emulated by a ConvCNP trained on HIRHAM5. Correct this file if the scope differs.

## Research questions
- **Q1.** Where are the most informative locations to measure the surface (mass) balance signal under present-day climate conditions?
- **Q2.** Where are they under future climate conditions, and which locations are "no-regret" (good under both) versus "future-only"?

## Planned outputs
- Ranked maps of sensor locations for present-day climate (Q1), with uncertainty.
- Ranked maps for selected future windows (Q2), separating no-regret from future-only locations.
- Open, reproducible pipeline and a short brief on cost-effective expansion of the observing network.
- This paper.

## Timeline (12 months, from the planning document)

| Months | Activities |
|---|---|
| 1-2 (Apr 2026 - May 2026) | Scoping and setup: compute access, datasets, tools |
| 2-4 (May 2026 - Jul 2026) | Data engineering: ingestion, preprocessing, quality control |
| 4-7 (Jul 2026 - Oct 2026) | Baseline emulator model on present-day data |
| 6-9 (Sep 2026 - Dec 2026) | Model extensions; downscaling benchmark; future-climate experiments |
| 8-10 (Nov 2026 - Jan 2027) | Q1: present-climate sensor-placement experiments and validation with partners |
| 9-11 (Dec 2026 - Feb 2027) | Q2: future-climate experiments; "no-regret" vs "future-only" analysis |
| 10-12 (Jan 2027 - Mar 2027) | Manuscript writing, code preparation, final reporting |

## Open questions
- Which exact scenario do the 2025-2060 (near-future) runs use? (The long-future runs follow the preprint: SSP5-8.5, 2065-2100.)
- Which stations define the fixed context set (real station locations)?
- Which units apply to RMSE / MAE / MBE on the evaluation plots?
