#!/usr/bin/env bash
# Creates the PRIVATE GitHub repo, pushes this folder, then creates the
# "Milestone 1" milestone, labels and one issue per open task.
# Requires: git, GitHub CLI (gh) logged in (gh auth login).
set -euo pipefail

REPO="${1:-greenland-melt-sensor-placement-m1}"

gh repo create "$REPO" --private --source=. --remote=origin --push \
  --description "Milestone 1: climate-aware sensor placement for Greenland surface melt (private working repo)"

gh api "repos/{owner}/{repo}/milestones" \
  -f title="Milestone 1" \
  -f description="Paper and analysis for Milestone 1" >/dev/null

for l in "data:0E8A16" "emulator:1D76DB" "sensor-placement:5319E7" "paper:FBCA04" "task:C5DEF5"; do
  gh label create "${l%%:*}" --color "${l##*:}" --force >/dev/null
done

issue() { gh issue create --title "$1" --label "$2" --milestone "Milestone 1" --body "$3" >/dev/null; echo "created: $1"; }

issue "Confirm run metadata for CESM2 and EC-Earth3 HIRHAM5 runs" "data,task" "Start years, scenarios, output variables. Needed for docs/windows_schedule.md."
issue "Confirm plot units (RMSE/MAE/MBE) and melt-extent definition" "data,task" "Add units to results/evaluation_metrics.csv and the draft."
issue "Define fixed context station set" "sensor-placement,task" "Real station locations used as the fixed context in all windows."
issue "Train one ConvCNP per window and driving model" "emulator,task" "Follow docs/windows_schedule.md."
issue "Run at least five seeds per window; select on train/search years only" "emulator,task" "Never select on analysis years."
issue "Add 2015, 2059 and 2099 results and per-year reporting" "emulator,task" "Report each analysis year and its melt relative to the window average."
issue "Control: present-window model applied zero-shot to future windows" "emulator,task" "Shows degradation without retraining."
issue "Test one transferability improvement (surface-state inputs or fine-tuning)" "emulator,task" "Compare total-melt bias and relative error across seeds."
issue "Implement sensor placement search and analysis pipeline" "sensor-placement,task" "Following Andersson et al. (2023), supplement H."
issue "Implement acquisition functions and baselines" "sensor-placement,task" "Random, ContextDist and model-based criteria."
issue "Run Q1 and Q2; cross-window regret matrix" "sensor-placement,task" "No-regret vs future-only locations."
issue "Stability check of the one-year search" "sensor-placement,task" "First vs second half of melt season; top-10 overlap."
issue "Write abstract and introduction" "paper,task" "paper/draft.md"
issue "Write methods" "paper,task" "Emulator details and sensor placement design."
issue "Write sensor placement results" "paper,task" "After Q1 and Q2 runs."
issue "Discussion, limitations and conclusions" "paper,task" "paper/draft.md"
issue "Verify references and complete references.bib" "paper,task" "Check every entry against the source."
issue "Data and code availability statement" "paper,task" "paper/draft.md"

echo "Done: https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)"
