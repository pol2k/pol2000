# AGENTS.md — POL-2000

Working instructions for AI agents in this repository. Read this before
touching anything.

## What this is

The public course site for **POL-2000 — Méthodologie quantitative**,
Université Laval, Département de science politique. Undergraduate.
Instructor: Laurence-Olivier M. Foisy (mail@mfoisy.com).

- Live at **https://pol2000.com**
- Repository: `github.com/pol2k/pol2000`
- Hosted on **Cloudflare Pages**, git-connected to this repo. GitHub Pages
  has been disabled; the migration is complete.
- **Pushing to `main` triggers a Cloudflare build and publishes to the live
  site automatically.** There is no staging environment and no review gate.
- Served at `pol2000.com`, `www.pol2000.com` and `pol2000.pages.dev`.
- Cloudflare runs **no build command**; the output directory is the repo
  root. It publishes the committed tree exactly as it stands.
- Static site (HTML/CSS/JS) plus Quarto/reveal.js slide decks.

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
.beads/                   issue tracker database (not published)
```

## Search hygiene — important

This repo is ~250 MB of working tree and most of it is vendored
third-party assets. A naive `grep -r` or a subagent file sweep will drown
in minified JavaScript.

**Never read, grep, or open files under:**

- `slides/*/*_files/` — vendored reveal.js, one full copy per deck
- `assets/webfonts/`, `assets/css/`, `assets/js/*.min.js`, `assets/sass/`
- `.git/`, `.beads/`

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
- **Both MUST be committed.** Cloudflare Pages deploys the committed tree
  with **no build step** — nothing regenerates these files server-side.
  Adding them to `.gitignore` breaks the live site. This is the single
  most damaging mistake possible in this repo.
- Never hand-edit a rendered `.html`. Edit the `.qmd` and re-render.
- Verify a deck renders before committing it. A broken deck goes live
  within a minute or two of `git push`.

### Cloudflare Pages limits — check before committing large files

- **25 MB per file.** A larger file fails the deployment.
- **20,000 files per deployment.** Currently ~1,000, so headroom is fine,
  but each rendered deck adds a full vendored reveal.js copy.
- Keep raw teaching data sets small. If a data set is genuinely large,
  host it outside the repo rather than shipping it to the CDN.

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

## Deployment and git

- `main` is the published branch. Anything pushed there is public within
  minutes — there is no review gate between `git push` and students.
- Commit messages in English, imperative mood.
- Commit a rendered deck in the same commit as its `.qmd`, so source and
  published page never drift.
- Do not force-push. Do not rewrite published history.
- **Missing paths do not 404.** Cloudflare Pages falls back to
  `index.html` with HTTP 200 when a path is not found and no `404.html`
  exists at the root. A broken link therefore looks healthy to browsers
  and link checkers — verify page content, not status codes.
- **This GitHub repository is public, and Cloudflare Pages publishes the
  entire committed tree — dot-directories included.** Verified:
  `pol2000.com/.beads/issues.jsonl` is served with HTTP 200. `docs/`,
  `reference/` and `mockup.html` are likewise world-readable.
  **Never commit anything confidential** — exam keys, unreleased exam
  content, student data, grades or credentials. There is no private
  corner of this repo.
- Pages serves `.html` files at their extensionless path and 308-redirects
  the `.html` URL to it. Links ending in `.html` (as in `course_config.json`)
  still work; they just take one redirect.

## Issue tracking

Work is tracked with **beads** in `.beads/`. Issue prefix `pol`; IDs look
like `pol-a3f2dd`, not `pol-1`.

Conventions for this repo:

- **Start every session with `bd ready`.** It respects dependencies; a
  plain `bd list` does not.
- Issues are written in English, titled imperatively ("Rewrite the
  calendar for the current session").
- File new work as a new issue rather than expanding the scope of the
  current one. Use `--deps discovered-from:pol-xxxxx` when work surfaced
  while doing something else.
- Content decisions needing the instructor's judgement get the
  `needs-decision` label. Do not guess and commit to `main`.

## Things that will bite you

1. **Editing a rendered `.html` instead of the `.qmd`** — silently
   overwritten on the next render.
2. **Gitignoring `*_files/`** — breaks every deck on the live site, since
   Cloudflare runs no build step.
3. **Treating an inherited FAS1001 deck as course material** — see
   Provenance above.
4. **Opening `index.html` from disk** and concluding the calendar is
   broken — you need an HTTP server.
5. **Adding maths to explain a statistical concept** — the course
   explicitly forbids requiring it.
6. **Writing student-facing text in English** — the entire audience is
   francophone.
7. **Committing a file over 25 MB** — the Cloudflare deployment fails.

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

## Override to the beads session protocol above

The generic beads block mandates pushing at the end of every session. **In
this repository that rule is overridden**, because `main` deploys straight
to a live course site read by students:

- Commit freely. **Do not `git push` without the instructor's go-ahead**,
  unless the change is verified and clearly safe.
- Never push a slide deck you have not rendered and opened.
- **Ignore `bd dolt push`.** No Dolt remote is configured. The underlying
  Dolt database in `.beads/embeddeddolt/` is git-ignored and lives only on
  this machine.
- **The backlog survives in git only through `.beads/issues.jsonl`.**
  Whenever you create, edit or close issues, run:

  ```bash
  bd export -o .beads/issues.jsonl
  ```

  and commit the result alongside your other changes. `bd import` reads
  that file by default, so it is what restores the backlog in a fresh
  clone. Skipping this silently loses the work.
