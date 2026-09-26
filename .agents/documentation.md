## Keep README.md scoped to what a human user needs

`README.md` is for a human deciding whether/how to use Tramway. Keep it to:

- What a feature is and why you'd use it.
- How to use it: the minimal helper/API calls, with a short example.
- The basic mental model of how it works (one or two sentences), only as far as a user needs to use it correctly.

### What does NOT belong in README.md

Implementation details that exist mainly so an AI coding tool (or a future contributor extending Tramway itself)
can reason about internals — not so a user can use the feature — do not belong in `README.md`. This includes things
like:

- Which internal classes/components/files implement a behavior (e.g. naming a specific `ViewComponent` class).
- Exact CSS utility classes, selectors, or markup structure used to achieve an effect.
- Step-by-step "why it works" mechanics (event ordering, DOM/CSS cascade reasoning, browser quirks worked around).
- Anything whose only audience is "someone about to modify this code," not "someone about to use this code."

### Where it goes instead

Move that content into a focused file under `docs/users/<topic>.md` (see `docs/users/tramway_navbar.md` and
`docs/users/tramway_grid.md` for the existing pattern). Keep `README.md`'s section on that topic short, and add a
one-line link to the `docs/users/<topic>.md` file for readers who want the deeper mechanics.

### How to apply this when doing other tasks

1. When a task changes or adds user-facing functionality, update `README.md` with only the user-relevant part
   (what/why/how to use).
2. If the change also introduces details that matter for future implementation/maintenance but not for usage, write
   those into `docs/users/<topic>.md` instead of `README.md`.
3. When reviewing or touching an existing `README.md` section, if it already contains implementation-detail content
   like the above, move it out to `docs/users/<topic>.md` as part of that task rather than leaving it in place.
