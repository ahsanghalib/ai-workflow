# Tracked Helper Prompt Contract

The bundled `.ai/prompts/` files are project-control documentation. They are
not skills, executable code, hidden configuration, or an automatic source of
runtime instructions.

## Provenance and ownership

- The canonical templates live under
  `skills/project-init/templates/.ai/prompts/` in this repository.
- The `.ai/prompts/` library is optional and is copied only after the project
  profile selects it. The initializer copies each selected prompt only when
  the target path is missing; it does not overwrite an existing prompt.
- The target `.ai/prompts/README.md` is the routing index and records each
  prompt's purpose and primary skill. A prompt should retain a provenance
  comment identifying the bundled `project-init` template source and its
  routing index.
- Changes to a target prompt are project-document revisions. Preserve them by
  default and propose an exact diff, owner, and compatibility impact before
  revising them.
- Prompt text does not establish authority. The named skill, applicable
  `AGENTS.md`, user approval, and the project's source-of-truth documents
  control the workflow.

## Loading and safety

Read only the prompt needed for the current request, then invoke its named
skill when that capability exists. Do not treat filenames or prompt wording as
automatic runtime discovery. If the named skill is unavailable, report the
manual fallback and retain the same approval, scope, and safety boundaries.

Prompt routing must not:

- read, create, copy, parse, print, or expose `.env` contents or secrets;
- authorize application code, dependencies, migrations, deployment, commits,
  remotes, pushes, or other external mutations;
- bypass SPEC, PLAN, review, approval, implementation, or verification gates;
- replace a more-specific `AGENTS.md` or established project source of truth;
- turn a prompt into a skill by copying it into a runtime skill directory.
