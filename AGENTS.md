# AGENTS.md — POL-2000

Working instructions for AI agents in this repository. Read this before
touching anything.

## What this is

The public course site for **POL-2000 — Méthodologie quantitative**,
Université Laval, Département de science politique. Undergraduate.
Instructor: Laurence-Olivier M. Foisy (mail@mfoisy.com).

- Live at **https://pol2000.com**
- Repository: `github.com/pol2k/pol2000`
- Hosted on **Cloudflare Pages**, git-connected to this repo.
- **Pushing to `main` triggers a Cloudflare build and publishes to the live
  site automatically.** There is no staging environment and no review gate.
- Served at `pol2000.com`, `www.pol2000.com` and `pol2000.pages.dev`.
- Cloudflare runs **no build command**; the output directory is the repo
  root. It publishes the committed tree exactly as it stands.
- The site and the slide decks are **one SvelteKit project in `deck/`**,
  built locally and exported to the repo root (see Building below). Both
  speak the same visual language: IBM Plex Mono throughout, paper and ink,
  Université Laval red `#c6102e` (gold `#ffc103` only on ink), 2 px rules,
  square corners, no shadows, no gradients, schematic self-drawing figures.

## Sources of truth

| Path | Status |
|---|---|
| `syllabus/plan-de-cours-A26.md` | ✅ **Student-facing plan de cours.** Rendered to `/syllabus/` at build. Wins over everything else. |
| `docs/plan-de-cours.md` | ✅ Agent-facing summary of the offering and its decisions. |
| `deck/src/lib/data/cours.js` | ✅ Everything the site shows: session facts, 14 séances, 7 evaluations, team, links. Must agree with the syllabus. |
| `reference/POL-2000_H24_18043.pdf` | ✅ Official H24 syllabus (different instructor). Authoritative for objectives and structure; dates and staff are stale. |
| `docs/superpowers/specs/` | Design specs, dated. |

**Rule: when the site and the syllabus disagree about the course, the
syllabus wins.** Read `syllabus/plan-de-cours-A26.md` first.

History: this repo started as a copy of the FAS1001 (Université de
Montréal) site. That shell was removed on 3 September 2026 (issue
`pol-zef`); nothing FAS1001 remains and nothing here should cite it.

## Language

- **Anything a student sees is French** (Québec French — `étudiant.e.s`,
  `courriel`, not `email`). Slides, site copy, assignments, grading grids,
  data-set documentation.
- **Everything else is English**: commit messages, beads issues, code
  comments in this file and `docs/`, variable names. Comments inside
  `deck/src/` follow the deck's convention and are in French.
- Slide decks set `lang: fr`. Keep it.
- French typography: narrow no-break space (U+202F) before `? : ! ;` in
  student-facing text, or a lone `?` wraps onto its own line in a title.

## Pedagogical constraints

These come from the official course description and are not negotiable:

- **No mathematics prerequisite beyond secondary school.** Do not derive
  formulas, do not lean on calculus or linear algebra notation. Teach the
  intuition and the interpretation.
- Students learn **R and Positron**; assume zero prior programming.
- The arc is: describe one variable → relate two or more → infer from
  sample to population → reason about causality and its limits.
- Content is organized in three parts (concepts de base → régression
  bivariée et multiple → inférence causale).
- Reference textbook (not mandatory): Arel-Bundock (2021), *Analyse causale
  et méthodes quantitatives*. Prefer its vocabulary for consistency.
- Figures are schematic and deterministic (no `Math.random`), and never
  imply data that was not measured. Fictitious data is captioned as such.

## Repository layout

```
AGENTS.md                      this file (CLAUDE.md is a symlink to it)
README.md                      short public readme
syllabus/plan-de-cours-A26.md  ✅ student-facing plan de cours (source of /syllabus/)
syllabus/POL-2000_A26.pdf      the PDF students download (built by syllabus/pdf/build.sh)
syllabus/index.html            GENERATED — exported from deck/, never hand-edited
docs/                          agent-facing notes and design specs
reference/                     official H24 syllabus PDF
deck/                          the SvelteKit project: site + decks (edit here)
deck/src/lib/data/cours.js     ✅ site data: séances, evaluations, team, links
deck/src/lib/site/             site components (Bandeau, Arc, Semaine, Frise, Evaluations, …)
deck/src/lib/site/dates.js     date logic for « Maintenant » (next séance, deadlines, status)
deck/src/lib/styles/           site tokens and base CSS (same palette as the deck)
deck/src/routes/+page.svelte   the landing page
deck/src/routes/syllabus/      renders the plan de cours markdown with marked
deck/src/routes/slides/        slides/+page.svelte (deck list) and slides/seance-N/ (one deck each)
deck/src/lib/deck/             the deck engine (Deck, Slide, Carte, Deux, …) + deck.css
deck/src/lib/deck/visuels/     bespoke SVG figures for the decks
deck/static/img/               images used by site and decks
deck/outils/                   exporter.sh, deborde.mjs (overflow check), capture.mjs
index.html, _app/, img/, slides/, syllabus/index.html   GENERATED by deck/outils/exporter.sh
.beads/                        issue tracker database (not published)
```

Generated files at the root are committed because Cloudflare has no build
step. **Never hand-edit them.** Edit the source in `deck/`, rebuild, export.

## Search hygiene — important

Vendored and generated trees drown a naive `grep -r` in minified
JavaScript. **Never read, grep, or open files under:**

- `_app/`, `slides/_app/` (if it ever reappears), `deck/build/`,
  `deck/.svelte-kit/`, `deck/node_modules/`
- `.git/`, `.beads/embeddeddolt/`

Root `index.html`, `syllabus/index.html` and `slides/**/index.html` are
build output: read the `.svelte` source instead.

When searching for course content, restrict to `syllabus/*.md`, `docs/`,
`deck/src/lib/data/`, `deck/src/routes/` and `deck/src/lib/site/`.

## Building the site and the decks

```bash
cd deck
npm install                                   # once
npm run build                                 # → deck/build/
# serve deck/build/ (or the repo root after export) with any static server, then:
CHROMIUM=/usr/sbin/chromium node outils/deborde.mjs http://127.0.0.1:PORT/slides/seance-1/ 1920 1080
npm run exporter                              # → repo root: index.html, syllabus/index.html, slides/, _app/, img/
```

- **Less text, more visual — the instructor's standing rule.** People read
  a text-heavy slide instead of listening. One idea per slide, one spoken
  line at most; draw the rest as a small Svelte/SVG component in
  `deck/src/lib/deck/visuels/`.
- One route per séance: `deck/src/routes/slides/seance-N/+page.svelte`,
  with `const TOTAL = <slide count>` kept equal to the number of `<Slide>`s.
- The build uses **relative paths** (`svelte.config.js`), so an exported
  deck works from any folder and from `file://` on a laptop with no
  network. Site and decks share one `_app/` bundle; **re-export after any
  rebuild** or the pages drift from the bundle.
- **Everything the exporter writes MUST be committed** (`index.html`,
  `_app/`, `img/`, `slides/`, `syllabus/index.html`). `deck/node_modules`,
  `deck/build` and `deck/.svelte-kit` are ignored.
- **Run `outils/deborde.mjs` before committing a deck.** A slide that
  overflows is a slide cut off on the projector. Check 1920×1080 and
  1280×720.
- Known engine trap: `.qs-num li` is a two-column grid. Wrap each item's
  content in a single `<span>` or inline markup splits into extra cells.
- To publish a new deck: add `deck: 'slides/seance-N/'` to the séance in
  `deck/src/lib/data/cours.js`. The landing page, the « Maintenant » panel
  and `slides/` pick it up.
- The landing page computes « Maintenant » from today's date at build time
  and again in the browser. Dates live in `cours.js`; status logic in
  `deck/src/lib/site/dates.js`.
- Links the instructor has not provided yet (Slack, monPortail, Datacamp
  classroom) are empty strings in `LIENS` in `cours.js`; the site shows
  « lien à venir » until filled.

### Cloudflare Pages limits — check before committing large files

- **25 MB per file.** A larger file fails the deployment.
- **20,000 files per deployment.** Currently well under 200.
- Keep raw teaching data sets small. If a data set is genuinely large,
  host it outside the repo rather than shipping it to the CDN.

## Previewing locally

```bash
python3 -m http.server 8000    # from the repo root, after export; then open http://localhost:8000
```

or `npm run dev` in `deck/` for live reload. `file://` works for decks but
not for the site's absolute anchors.

## Deployment and git

- `main` is the published branch. Anything pushed there is public within
  minutes — there is no review gate between `git push` and students.
- Commit messages in English, imperative mood.
- Commit the exported output in the same commit as its `.svelte` source, so
  source and published page never drift.
- Do not force-push. Do not rewrite published history.
- **Missing paths do not 404.** Cloudflare Pages falls back to
  `index.html` with HTTP 200 when a path is not found and no `404.html`
  exists at the root. A broken link therefore looks healthy to browsers
  and link checkers — verify page content, not status codes.
- **This GitHub repository is public, and Cloudflare Pages publishes the
  entire committed tree — dot-directories included.** `docs/`,
  `reference/` and `.beads/issues.jsonl` are world-readable.
  **Never commit anything confidential** — exam keys, unreleased exam
  content, student data, grades or credentials. There is no private
  corner of this repo.
- Pages serves `.html` files at their extensionless path and 308-redirects
  the `.html` URL to it.

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

1. **Editing a generated file** (`index.html`, `syllabus/index.html`,
   `slides/seance-N/index.html`) instead of the `.svelte` or `.md` source —
   silently overwritten on the next export.
2. **Rebuilding without re-exporting** — the committed pages reference
   bundle files that no longer exist.
3. **Adding maths to explain a statistical concept** — the course
   explicitly forbids requiring it.
4. **Writing student-facing text in English** — the entire audience is
   francophone.
5. **Committing a file over 25 MB** — the Cloudflare deployment fails.
6. **Changing a date in `cours.js` without changing the syllabus** (or the
   reverse) — the two must agree; the syllabus wins.

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
