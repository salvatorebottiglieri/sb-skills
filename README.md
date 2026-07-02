# pi-skills

My agent skills collection.

## Skills

### `implement-loop`

Process a batch of work items: implement each via a TDD subagent, review via a reviewer subagent, fix until clean, then create a PR. Issue-tracker-agnostic.

```
/skill:implement-loop
```

## Install

### Pi

```bash
pi install git:github.com/salvatorebottiglieri/pi-skills
```

Or symlink:

```bash
ln -s ~/path/to/pi-skills/* ~/.pi/agent/skills/
```

### Claude Code

Symlink the skills you want into `.claude/skills/`:

```bash
# In your project or globally
mkdir -p ~/.claude/skills
ln -s ~/path/to/pi-skills/* ~/.claude/skills/

# Or just copy
cp -r ~/path/to/pi-skills/* ~/.claude/skills/
```

Or reference them in `CLAUDE.md` / `CLAUDE_GLOBAL.md`:

```markdown
See skills in ~/pi-skills/ for reusable workflows.
```
