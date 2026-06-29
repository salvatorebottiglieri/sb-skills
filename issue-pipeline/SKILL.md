---
name: issue-pipeline
description: Process `ready-for-agent` GitHub issues through a TDD → no-mistakes → CI loop. Use when the user wants to implement multiple issues, batch bugs, clear the ready-for-agent queue, or says "implement the issues", "lancia pipeline", "processa le issue", "ready-for-agent".
---

# Issue Pipeline

Implement `ready-for-agent` issues one at a time: subagent does TDD, you drive no-mistakes (skipping its CI), then monitor CI yourself.

## Before you start

- Confirm with the user which issues to process (all `ready-for-agent`, a specific list, or the top N).
- Run `gh issue list --label ready-for-agent --state open --json number,title` to scope the work.
- Announce the plan: how many issues, and the order.

## Pipeline loop

For each issue **in ascending number order**:

### 1. Scope

Read the full issue (`gh issue view <N> --comments`). The **spec lives in the first comment** — extract the Problem, Solution, Implementation Decisions, and Testing Decisions sections. Check if the spec is complete (no "TBD" or unanswered questions). If not, ask the user before proceeding.

### 2. Subagent

Spawn a **worker** subagent with `skill: ["tdd"]`, `context: "fork"`. The task string must include:

- The full spec (Problem, Solution, Implementation, Testing sections)
- The branch name: `fix/issue-<N>-<kebab-title>`
- `Use uv for all Python commands. Do NOT run no-mistakes. Commit and report back.`

Do not start the subagent until the previous PR has been merged (step 5).

### 3. Verify

When the subagent reports back:
- Checkout the branch and verify tests pass (`uv run pytest tests/unit/ -x`)
- Run `uv run mypy` on changed files
- If anything fails, fix it yourself before proceeding

### 4. no-mistakes

Run the pipeline **without CI monitoring** (it has a bug with `gh pr checks`):

```sh
no-mistakes axi run --skip=ci --yes \
  --intent "<what the user set out to accomplish — capture decisions, tradeoffs, and constraints>"
```

If the pipeline fails (test, lint, etc.), fix the issue and retry. If it blocks at a gate with `ask-user` findings, **stop and escalate to the user**.

### 5. CI monitor

After no-mistakes creates the PR:
```sh
./scripts/monitor-ci.sh <PR-N>
```

On success: report the PR URL and CI status to the user. On failure (CI red or timeout): stop and escalate.

### 6. Wait for merge

Tell the user the PR is ready. **Wait for the user to confirm the PR is merged** before proceeding — do not poll or assume. Once confirmed:

```sh
git checkout master && git pull origin master
```

Then loop to the next issue.

## Completion

After the last issue, report a final table:

```
| # | Issue | PR | Status |
|---|---|---|---|
| ✅ N | Title | #PR | Merged |
```

If any issue failed (blocked, CI red, insufficient spec), list it separately so the user knows what's left.

## Scripts

`scripts/monitor-ci.sh <pr-number> [timeout]` — polls `gh pr checks` every 10s until all pass or timeout (default 300s). Exits 0 on all-green, 1 on failure or timeout.
