## Adding or updating agent instructions

When the user asks to add, update, or create an instruction for Claude, Codex, Cursor, or any other AI agent, the instruction goes into the `.agents/` folder — not directly into `CLAUDE.md` or `AGENTS.md`.

### How to decide where it goes

- Find the existing `.agents/` file whose topic matches the instruction. Add the new rule there.
- If no existing file fits, create a new focused `.agents/<topic>.md` file and add it to the index in `AGENTS.md`.
- `CLAUDE.md` only contains `@`-imports of `.agents/` files. If you create a new `.agents/` file, add a corresponding `@.agents/<topic>.md` line to `CLAUDE.md` and a link entry to `AGENTS.md`.

### What NOT to do

- Do not write instructions directly into `CLAUDE.md` or `AGENTS.md` — they are entry points only.
- Do not create a new `.agents/` file for a topic that already has one — extend the existing file.
