# pol2000.com remodel — design

Date: 2026-09-03. Issue: pol-zef. Decided with the instructor in session.

## Goal

Replace the inherited FAS1001 site chrome with a site in the visual language
of the séance 1 deck: IBM Plex Mono throughout, paper `#f6f6f3` with a faint
grain, ink `#0c0e0f`, Université Laval red `#c6102e` (gold `#ffc103` only on
ink), 2 px rules, square corners, no shadows or gradients, an uppercase
bandeau at the top, schematic self-drawing figures. Clean, visual, easy to
scan on a laptop and a phone.

## Decisions

- **One SvelteKit project.** The site's pages are routes in `deck/`, next to
  the decks. Tokens, fonts and visuals are shared. The build is exported to
  the repo root; Cloudflare Pages keeps running no build step.
- **Landing page only** plus a restyled `/syllabus/` page. No per-séance
  pages (instructor's choice). The decks keep their `slides/seance-N/` URLs.
- **Hero = self-drawing figure.** Points appear, a mean line, a regression
  line, then a second variable splits the cloud: the arc of the course.
  Deterministic, schematic, captioned as fictitious data.
- **Missing links (Slack, monPortail, Datacamp classroom) are placeholders**
  in the data file; the item shows without a link until filled.

## Layout

```
deck/src/lib/data/cours.js       single source: session info, 14 séances, evaluations, links, team
deck/src/lib/site/site.css       site tokens (derived from deck.css) + base typography
deck/src/lib/site/*.svelte       Bandeau (nav), Arc (hero figure), Semaine (this-week panel),
                                 Frise (session band), Evaluations, Outils, Datacamp, Equipe, Pied
deck/src/routes/+page.svelte     landing page
deck/src/routes/syllabus/        renders syllabus/plan-de-cours-A26.md with marked at prerender
deck/src/routes/slides/seance-N/ decks (moved from routes/seance-N so the export lands in slides/)
deck/outils/exporter.sh          build → repo root (index.html, _app/, img/, slides/, syllabus/index.html)
```

Deleted: `assets/`, `images/`, `course_config.json`, `slides/N_topic/`
(FAS1001 Quarto decks), `slides/_app/`, `tp_1/`, `tp_pdf/`, `grilles/`,
hand-written `index.html` and `syllabus/index.html`. `README.md` and
`AGENTS.md` rewritten for the new layout.

## Landing page, top to bottom

1. **Bandeau** (sticky): `POL-2000 · Méthodologie quantitative` left; anchors
   Séances, Évaluations, Outils, Datacamp, and Plan de cours in red, right.
2. **Masthead**: surtitre (Université Laval · science politique · A26), giant
   mono title, red filet, a three-line lead (décrire, relier, inférer,
   causer; R et Positron; no maths beyond secondary school), key facts in a
   mono strip (jeudi 15h30–18h20, DKN-3159, NRC 87892).
3. **Arc figure**: SVG, four phases auto-played once on load, each phase
   label clickable to replay. Respects `prefers-reduced-motion`.
4. **Cette semaine**: computed from today's date. The next séance (title,
   date, what to bring, deck link), any deadline within 21 days, and a
   session progress line. Prerendered at build time, refreshed on hydration.
5. **Séances**: the frise (14 cases + lecture week, three parts in ink /
   grey / red as in the deck) and the numbered list with description and
   deck link or "à venir". Past séances are marked; the current one is
   outlined in red. Horizontal scroll on narrow screens.
6. **Évaluations**: the weight bar from slide 16 (15/15/15 ink, 20/25 red,
   5/5 grey), then the seven dated items with a status derived from the
   date, the late policy and the AI rules in three columns.
7. **Outils**: four wire cards — R, Positron, Slack (placeholder), the book.
8. **Datacamp**: the embedded R exercise in an ink terminal frame, the two
   deadlines, and the eleven course links as a mono list.
9. **Équipe**: instructor with portrait and the three assistants, contact
   rule (courriel two weeks, then Slack).
10. **Pied**: pol2000.com · GitHub · Université Laval.

## Verification

- `npm run build`, serve `deck/build/`, screenshot at 1440 and 390 wide.
- `outils/deborde.mjs` on the séance 1 deck at 1920×1080 and 1280×720 to
  confirm the route move changed nothing.
- Check "Cette semaine" with a forced date around each evaluation.
- Export, serve the repo root, verify `/`, `/syllabus/`, `/slides/seance-1/`.
