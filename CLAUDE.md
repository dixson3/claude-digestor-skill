# Development Setup

This repository is the source for the `digestor` Claude skill. For development, the skill is symlinked globally so it can be tested in any Claude Code session:

```bash
ln -sfn /Users/james/workspace/tools/digestor ~/.claude/skills/digestor
```

This allows live development - changes to SKILL.md and templates/ are immediately available without reinstalling. Claude Code ignores the extra development files (CLAUDE.md, agent/, scripts/).

To invoke the skill: `/digestor` or ask Claude to analyze a codebase.

---

# Agent Behaviors

Use @agent/rules/* as read-only rules for this project. Never write to these files, but always check them for guidelines.
Use @agent/runtime/state.json to track the runtime state of this session. Update every step and when a task is completed, purge.
Use @agent/runtime/trace.log to summarize the decisions and outcomes of each session. Append to this at the conclusion of task.
Use @agent/memory/facts.json to record important facts about this project that are either explictly stated or determined by interactions.

Create the directories `agent/rules`, `agent/runtime`, `agent/memory`, `agent/scripts` if they do not exist.

Sometimes it will be useful to create python scripts to facilitate different tasks. Use the local `uv` managed venv for the python instance and save any useful scripts to `agent/scripts`

