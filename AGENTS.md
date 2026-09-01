# AGENTS.md — POL-2000

Working instructions for AI agents in this repository. Read this before
touching anything.

## What this is

The public course site for **POL-2000 — Méthodologie quantitative**,
Université Laval, Département de science politique. Undergraduate.
Instructor: Laurence-Olivier M. Foisy (mail@mfoisy.com).

- Live at **https://pol2000.com** — GitHub Pages, served from `main` of
  `github.com/pol2k/pol2k.github.io`.
- Static site (HTML/CSS/JS) plus Quarto/reveal.js slide decks.
- Pushing to `main` publishes immediately. There is no staging environment.

## ⚠️ Provenance — read this before editing any content

This repo was created by **copying the site of a different course
(FAS1001, Université de Montréal)** purely as a fast way to get a working
site skeleton. It was never a content starting point.

**Everything under `slides/` is a foreign shell, not POL-2000 material.**
The existing decks teach mégadonnées, web scraping, LLMs, analyse
textuelle and analyse d'images. POL-2000 teaches none of that. Do not
"improve", translate or extend those decks as if they were course content.
Do not cite them as evidence of what the course covers.

| Path | Status |
|---|---|
| `docs/plan-de-cours.md` | ✅ **Source of truth for course content.** |
| `reference/POL-2000_H24_18043.pdf` | ✅ Official syllabus (H24 offering, different instructor). Authoritative for objectives and structure; its dates and staff are stale. |
| `slides/**` | ❌ Inherited FAS1001 decks. Placeholder shell. To be replaced. |
| `course_config.json` | ❌ Inherited calendar (Jan 2026 dates), stale GitHub Classroom links, FAS1001 topic titles. |
| `README.md` | ❌ Still says "Site du cours fas1001". |
| `images/cours_*.png`, `images/fas1001_logo.svg` | ❌ FAS1001 deck thumbnails and logo. |
| `tp_1/`, `tp_pdf/`, `grilles/` | ❌ FAS1001 assignments and grading grids. |
| `index.html`, `assets/**` | ⚠️ Reusable site chrome. Structure is fine; the *text* still describes FAS1001. |

**Rule: when the site and the syllabus disagree about the course, the
syllabus wins.** Read `docs/plan-de-cours.md` first.

## Language

- **Anything a student sees is French** (Québec French — `étudiant.e.s`,
  `courriel`, not `email`). Slides, site copy, assignments, grading grids,
  data-set documentation.
- **Everything else is English**: commit messages, beads issues, code
  comments, this file, `docs/`, variable names.
- Slide decks set `lang: fr` in their YAML header. Keep it.

## Pedagogical constraints

These come from the official course description and are not negotiable:

- **No mathematics prerequisite beyond secondary school.** Do not derive
  formulas, do not lean on calculus or linear algebra notation. Teach the
  intuition and the interpretation.
- Students learn **R and RStudio**; assume zero prior programming.
- The arc is: describe one variable → relate two or more → infer from
  sample to population → reason about causality and its limits.
- Content is organized in three parts (concepts de base → régression
  bivariée et multiple → inférence causale). See `docs/plan-de-cours.md`.
- Required textbook: Arel-Bundock (2021), *Analyse causale et méthodes
  quantitatives*. Prefer its vocabulary and notation for consistency.

## Repository layout

```
AGENTS.md                 this file (CLAUDE.md is a symlink to it)
docs/plan-de-cours.md     ✅ course content source of truth
reference/                official syllabus PDF and other source documents
course_config.json        site control plane — see below
index.html                landing page; chrome is static, calendar is injected
assets/js/course_logic.js reads course_config.json and builds the DOM
assets/{css,sass,webfonts,js}  vendored theme — do not read or edit
slides/N_topic/*.qmd      deck source (edit this)
slides/N_topic/*.html     rendered output (committed, never hand-edited)
slides/N_topic/*_files/   vendored reveal.js per deck — do not read
images/                   deck thumbnails and logos
grilles/, tp_1/, tp_pdf/  assignments and grading grids
.beads/                   issue tracker database
```

## Search hygiene — important

This repo is ~460 MB and most of it is vendored third-party assets. A naive
`grep -r` or a subagent file sweep will drown in minified JavaScript.

**Never read, grep, or open files under:**

- `slides/*/*_files/` — vendored reveal.js, one full copy per deck
- `assets/webfonts/`, `assets/css/`, `assets/js/*.min.js`, `assets/sass/`
- `.git/`

**Exception:** `assets/js/course_logic.js` and `assets/js/app.js` are
first-party and worth reading.

When searching for course content, restrict to `*.qmd`, `*.md`,
`course_config.json`, and `index.html`. The `.qmd` is always the source of
truth; the rendered `.html` is a build artifact.

## Building slides

Each deck is a standalone Quarto reveal.js document. There is currently
**no `_quarto.yml`** — every deck repeats its own YAML header, and those
headers still say `institute: Université de Montréal` with a UdeM logo.
Treat that as a known defect, tracked in beads.

```bash
quarto render slides/1_introduction/cours_1_intro.qmd
```

- Rendering writes `<name>.html` and `<name>_files/` beside the source.
- **Both MUST be committed.** GitHub Pages has `.nojekyll` and serves these
  files directly. Adding them to `.gitignore` breaks the live site. This is
  the single most damaging mistake possible in this repo.
- Never hand-edit a rendered `.html`. Edit the `.qmd` and re-render.
- Verify a deck renders before committing it. A broken deck is live within
  a minute of `git push`.

## Previewing the site locally

`course_logic.js` fetches `course_config.json` over HTTP, so opening
`index.html` via `file://` shows an error box instead of the calendar.

```bash
python3 -m http.server 8000    # then open http://localhost:8000
```

## course_config.json — the site control plane

`index.html` contains no calendar markup. `assets/js/course_logic.js`
fetches this JSON at page load and builds the schedule, the evaluation
badges and the slide grid. **Edit the JSON, not the HTML**, for anything
week- or evaluation-related.

| Key | Purpose |
|---|---|
| `slides` | Per-deck boolean — whether the deck appears in the grid |
| `slide_links` | Deck id → path of the rendered `.html` |
| `exercises` | Per-exercise boolean visibility |
| `evaluations` | Per-evaluation `status` (`pending` / `active` / `completed`) and optional `url` |
| `rencontres.link` | Google Calendar appointment booking URL |
| `schedule` | Array of week objects: `week`, `date` (ISO), `title`, `description`, `type`, optional `slide`, `tags`, `anchor` |

`type` values in use: `lecture`, `break`, `important-eval`.

Every value in this file is currently inherited from FAS1001 and wrong for
POL-2000.

## Issue tracking — beads

Work is tracked with [beads](https://github.com/steveyegge/beads) in
`.beads/`. Issue prefix: `pol-`.

```bash
bd ready                 # what is unblocked and claimable right now
bd list --status open    # everything open
bd show pol-1            # full detail on one issue
bd create "Title" -t task -p 1 -d "Description"
bd update pol-1 --status in_progress
bd close pol-1
bd dep add pol-2 pol-1   # pol-2 depends on pol-1
```

Conventions:

- **Start every session with `bd ready`.** It reflects dependencies; a
  plain `bd list` does not.
- Issues are written in English, titled imperatively ("Rewrite the calendar
  for the current session").
- Mark an issue `in_progress` when you start and close it when the work is
  actually verified, not when it looks done.
- File new work as issues rather than expanding the scope of the current
  one. Use `--deps discovered-from:pol-N` when the work surfaced while
  doing something else.
- Content decisions that need the instructor's judgement belong in an issue
  with the `needs-decision` label, not in a guess committed to `main`.

## Git conventions

- Commit messages in English, imperative mood.
- `main` is the published branch. Anything merged there is public
  immediately — check rendered decks before pushing.
- Do not force-push. Do not rewrite published history.
- Large rendered artifacts belong in the same commit as their `.qmd`, so
  the source and the published page never drift.

## Things that will bite you

1. **Editing a rendered `.html` instead of the `.qmd`** — silently
   overwritten on the next render.
2. **Gitignoring `*_files/`** — breaks every deck on the live site.
3. **Treating an inherited FAS1001 deck as course material** — see
   Provenance above.
4. **Opening `index.html` from disk** and concluding the calendar is
   broken — you need an HTTP server.
5. **Adding maths to explain a statistical concept** — the course
   explicitly forbids requiring it.
6. **Writing student-facing text in English** — the entire audience is
   francophone.

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->
