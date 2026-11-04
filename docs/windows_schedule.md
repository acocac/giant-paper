# Train / search / analysis schedule

Rule: with 10-year-mean inputs, the first usable year is ten years after a run starts; those first years only feed the averages. Train, search and analysis years never overlap.

| Window | Runs start | Input-only years | Train | Search | Analysis |
|---|---|---|---|---|---|
| Present | 1980 | 1980-1989 | 1990-2013 (24 yr) | 2014 | 2015-2016 |
| Near future | 2025 | 2025-2034 | 2035-2057 (23 yr) | 2058 | 2059-2060 |
| Long future | 2065 | 2065-2074 | 2075-2097 (23 yr) | 2098 | 2099-2100 |

## Rationale
- Same shape in each window (23-24 training years, 1 search year, 2 analysis years) so error growth is comparable.
- Present window uses exactly the years the preprint assesses (1990-2016) and ends where the historical runs end.
- One model per window and per driving model: regime matters more than the driving GCM (see `literature_notes.md`).

## Checks still to do
- At least five seeds per window; choose the seed on training and search years only, never on analysis years.
- Report errors per analysis year, together with that year's melt relative to the window average (annual spread is large).
- One-year search is thin: compare the top-10 sensor sets from the first and second half of the melt season.
- Results for 2015, 2059 and 2099 are not yet in `results/`.
- State in the methods that the 10-year means for the analysis years include weather from training years (never target years).
