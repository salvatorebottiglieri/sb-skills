# Glossary — tightrope

The two axes that define the tightrope. This is the disclosed reference for [`SKILL.md`](SKILL.md) — consulted when running the tension check.

## Axis A: Ponytail minimalism

The ponytail ladder is the authoritative guide for writing the minimum code that works. Reproduced from [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail).

### The ladder

Before writing or reviewing code, stop at the first rung that holds:

1. **Does this need to exist?** (YAGNI) — if the code could be skipped without changing behavior, delete it.
2. **Already in this codebase?** — reuse the helper, util, or pattern that's already here, don't rewrite it.
3. **Stdlib does it?** — use the standard library.
4. **Native platform feature covers it?** — use the browser API, OS facility, or language builtin.
5. **Installed dependency does it?** — use what's already in your dependencies.
6. **Can this be one line?** — make it one line.
7. **Only then: the minimum that works.**

The ladder runs after you understand the problem, not instead of it: read the task and the code it touches, trace the real flow end to end, then climb.

### Rules

- No abstractions that weren't explicitly requested.
- No new dependency if it can be avoided.
- No boilerplate nobody asked for.
- Deletion over addition. Boring over clever. Fewest files possible.
- Shortest working diff wins, but only once you understand the problem. The smallest change in the wrong place isn't lazy, it's a second bug.
- Question complex requests: "Do you actually need X, or does Y cover it?"
- Pick the edge-case-correct option when two stdlib approaches are the same size — lazy means less code, not the flimsier algorithm.
- Mark intentional simplifications with a `ponytail:` comment. If the shortcut has a known ceiling (global lock, O(n²) scan, naive heuristic), the comment names the ceiling and the upgrade path.

### What ponytail is NOT lazy about

Understanding the problem (read it fully and trace the real flow before picking a rung; a small diff you don't understand is laziness dressed up as efficiency), input validation at trust boundaries, error handling that prevents data loss, security, accessibility, calibration for real hardware (the platform is never the spec ideal — a clock drifts, a sensor reads off), anything explicitly requested. Lazy code without its check is unfinished: non-trivial logic leaves ONE runnable check behind — the smallest thing that fails if the logic breaks (an assert-based demo or one small test; no frameworks, no fixtures). Trivial one-liners need no test.

## Axis B: Engineering soundness

Sound engineering discipline comes from Matt Pocock's skills — the workflow the agent follows when building software properly. The tension check consults these skills as reference to evaluate whether the code is engineered soundly.

### What to check

These are the dimensions the agent evaluates, each backed by an installed skill:

| Dimension | Skill | What to verify |
|---|---|---|
| Architecture | `improve-codebase-architecture`, `codebase-design` | Does the code follow the project's module boundaries and patterns? Is it testable and AI-navigable? Would a deep module be a better design? |
| Testing | `tdd` | Are tests present for the new behavior? Do they cover edge cases and failure paths, not just the happy path? Are they written first or at least as part of the same change? |
| Error handling | (built-in engineering judgment) | Are trust boundaries validated? Are errors surfaced, not swallowed? Can the caller distinguish failure modes? Does data-loss prevention exist where relevant? |
| Specification | `to-prd`, `to-issues` | Does the implementation match what was asked for? Is scope creep visible? Does the diff serve the stated intent, not a different problem? |
| Debugging | `diagnose` | If this change fixes a bug, does it fix the root cause (one guard in the shared function) rather than patching only the reported path? |
| Integrity | `triage` | If this came from an issue, is the acceptance criterion met? Are there unresolved concerns in the issue thread? |

### Tension with ponytail

The tightrope lives at the intersection. A well-engineered change that follows all the practices above is still overengineered if it adds abstractions, dependencies, or ceremony nobody asked for. And a maximally minimal change is still underengineered if it skips validation at a trust boundary or has no error handling.

The tension check flags conflicts between the two axes so you can decide where the code should land on the frontier.
