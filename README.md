# Greenland melt sensor placement: Milestone 1

Private working repository to track and draft the paper for **Milestone 1** (climate-aware sensor placement for Greenland Ice Sheet surface melt, using a ConvCNP emulator trained on HIRHAM5 runs).

> Status: scaffold. The paper draft (`paper/draft.md`) contains the framing, data, methods and the emulator evaluation results obtained so far. Sections marked `TODO` need your input.

## What is here

| Path | Purpose |
|---|---|
| `paper/draft.md` | Working draft (Markdown, pandoc-style citations) |
| `paper/references.bib` | BibTeX references |
| `docs/milestone1_plan.md` | Scope, research questions, deliverables, timeline |
| `docs/windows_schedule.md` | Train / search / analysis schedule per climate window |
| `docs/literature_notes.md` | Notes on the papers the design relies on |
| `docs/TASKS.md` | Task checklist (mirrored as GitHub issues by `scripts/setup_github.sh`) |
| `results/evaluation_metrics.csv` | Metrics copied from the evaluation plots (2016, 2060, 2100) |
| `figures/evaluation/` | The 14 evaluation plots (hexbin + map per year and driving dataset) |
| `scripts/setup_github.sh` | Creates the private repo, the milestone, labels and issues with the `gh` CLI |

## Create the private repository

This folder is already a git repository with one commit. With the [GitHub CLI](https://cli.github.com/) installed and `gh auth login` done:

```bash
cd greenland-melt-sensor-placement-m1
bash scripts/setup_github.sh                 # default name: greenland-melt-sensor-placement-m1
# or: bash scripts/setup_github.sh my-repo-name
# under an organisation: bash scripts/setup_github.sh my-org/my-repo-name
```

Without the CLI: create an empty **private** repository on github.com (no README, no licence), then

```bash
git remote add origin git@github.com:<owner>/<repo>.git
git push -u origin main
```

Then add collaborators under Settings > Collaborators.

## Working conventions (suggested)

- `main` is the shared draft; use short-lived branches and pull requests for large edits.
- One GitHub issue per task, all in the **Milestone 1** milestone.
- Results go in `results/` (CSV) and `figures/`; large data and weights stay out of git (see `.gitignore`).
- Every number in the draft should come from a file in `results/`.
- No licence file is included; add one before the repository is made public.
