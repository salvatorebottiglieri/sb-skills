# pi-skills

Agent skills for [Pi](https://github.com/earendil-works/pi-coding-agent).

## Skills

### `implement-loop`

Process a batch of work items: implement each via a TDD subagent, review via a reviewer subagent, fix until clean, then create a PR. Issue-tracker-agnostic — works with GitHub Issues, GitLab, Linear, or local files.

```
/skill:implement-loop
```

### `issue-pipeline`

Process `ready-for-agent` GitHub issues through a TDD → no-mistakes → CI loop. Each issue is implemented by a subagent using test-driven development, validated through no-mistakes (without its broken CI monitoring), and monitored manually via `gh pr checks`.

```sh
# Install
git clone git@github.com:salvatorebottiglieri/pi-skills.git ~/.pi/agent/skills/pi-skills

# Or symlink
ln -s ~/path/to/pi-skills/* ~/.pi/agent/skills/
```

## Adding to Pi

Add to `~/.pi/settings.json`:
```json
{
  "skills": ["~/.pi/agent/skills/pi-skills"]
}
```

Or copy individual skills into `~/.pi/agent/skills/`.
