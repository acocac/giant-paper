# Model training / sensor placement schedule

Rule: Model training and sensor placement years never overlap.

| Window | Train | Sensor placement |
|---|---|---|---|---|
| Present | 1990-2014 (25 yr) | 2016 |
| Near future | 2035-2059 (25 yr) | 2060 |
| Long future | 2065 | 2075-2099 (25 yr) | 2100 |

## Rationale
- Same shape in each window (25 training years, 1 sensor placement year) so error growth is comparable.
- Present window training ends where the historical runs end.
- One model per window and per driving model: regime matters more than the driving GCM (see `literature_notes.md`).