# agent behaviors

Use @agent/rules/* as read-only rules for this project. Never write to these files, but always check them for guidelines.
Use @agent/runtime/state.json to track the runtime state of this session. Update every step and when a task is completed, purge.
Use @agent/runtime/trace.log to summarize the decisions and outcomes of each session. Append to this at the conclusion of task.
Use @agent/memory/facts.json to record important facts about this project that are either explictly stated or determined by interactions.

Create the directories `agent/rules`, `agent/runtime`, `agent/memory`, `agent/scripts` if they do not exist.

Sometimes it will be useful to create python scripts to facilitate different tasks. Use the local `uv` managed venv for the python instance and save any useful scripts to `agent/scripts`

