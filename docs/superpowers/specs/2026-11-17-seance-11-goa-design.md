# Séance 11 — Les graphes orientés acycliques (GOA): design

Date: 2026-11-17. Beads: `pol-5a0.12` (Deck: Les graphes orientes acycliques (GOA)).

**Schedule (instructor, 2026-11-17):** the strike cancelled the 12 November
class. The GOA deck is for **this Thursday, 19 November, 15h30–18h20**,
the whole slot with a break. **Examen 2 moves online** (details to come
from the instructor), so no exam in class. Séance 10 (the fundamental
problem) was not taught: the deck opens with a short bridge on it (my
call, see below), as the H24 GOA deck did. `cours.js`, the syllabus,
`Session.svelte` and `AvantS10` still show the old plan: updating them is
a separate, instructor-validated task (its own issue), not part of this
deck.

## Intent

Build the séance 11 deck in the SvelteKit engine (`deck/src/routes/slides/seance-11/`).
Students leave able to read and draw a GOA, tell an open path from a closed
one, and decide which variables to control and which to leave out. This is
the vocabulary they need for the GOA the **travail final** requires (five
variables, at least one in the CES, controls framed, the GOA dictates the
model). Séance 12 (26 Nov) is individual meetings where they bring that GOA.

## Sources (the foundation)

1. **The instructor's H24 deck**, `~/Projects/mfoisy.com/presentation_goa/index.qmd`
   (with Adrien Cloutier, Quarto/mermaid, ≈50 slides, drill images in
   `images/goa17–31*.png`). This is the skeleton and the order. Where it
   swapped the book's examples (seatbelt for the chain, sugar → diabetes,
   température → crème glacée + mercure), **keep the instructor's choices**.
2. **Arel-Bundock (2021), ch. 6 « Graphes orientés acycliques », pp. 115–136**
   (`books/arel_bundock_livre.pdf`). Authoritative for vocabulary and
   definitions: orienté, acyclique, chemin, ancêtre, descendant, effet causal
   vs information statistique, fourchette / chaîne / collision, ouvert /
   fermé, maillon central, encadrer = contrôler, condition 1 (ne pas
   contrôler les descendants de X), condition 2 (fermer les chemins par la
   porte arrière), figure 6.1, simulations 1–5, tableau 6.1.
3. Séance 8 already showed the two rules without graph vocabulary
   (`M8Intuition`, `M8DeuxRegles`, `Flux.svelte`). **Show them again**
   (instructor: no harm in repeating), redrawn with `Goa.svelte` and the
   book's examples, not by pasting the séance 8 slides back in.
4. **Séance 8 correction (my call, instructor may veto).** In séance 8
   (`M8Escalier`) students added *revenu* as a control to scolarité →
   intérêt. The book's éducation example says revenu individuel is a
   descendant of éducation and must not be controlled. One slide, right
   after the éducation answer, brings back the séance 8 staircase and asks
   « Avait-on le droit de contrôler le revenu ? »: no, it is a descendant,
   the GOA would have caught it.

Credit Adrien Cloutier and Arel-Bundock in the deck's header comment, as
séance 8 does.

## Goals, non-goals, anti-goals

- Goals: the H24 arc, rebuilt in the house style; every graph drawn by one
  component; real R output for every simulation; a clear visual difference
  between a causal effect (one way) and statistical information (both ways).
- Non-goals: d-separation theory, do-calculus, mediation (book ch. 18),
  the book's « Leçons » section beyond one line (séances 13 and 14 cover
  biases and experiments).
- Anti-goals: formulas or equations on slides (no `Y = β0 + …`, no « preuve
  mathématique »); text-heavy slides; hand-typed R output; data implied
  where none was measured; English on slides (no « backdoor »).

## Approach (chosen: 1)

1. **One reusable `Goa.svelte`** — each graph is a data definition; the
   component draws and animates it. **Chosen.**
2. Bespoke component per slide (séance 8 style) — rejected: 25 one-off
   figures drift apart and cannot be built by Thursday.
3. Reuse the H24 PNGs — rejected: clashes with the house style, no click
   states, cannot show information flowing.

Hands-on part: **the book's simulations in R** (instructor's pick, option A).
Not a CES application, not an in-class GOA workshop.

## `Goa.svelte` (in `deck/src/lib/deck/visuels/`)

- Input: nodes `{ id, label, x, y }` (label supports subscripts, e.g. Z₁ as
  a `<tspan>`), edges `[from, to, coef?]`, and click states (`temps`), each
  state saying which nodes/edges are visible, which nodes are **framed**
  (controlled), which path is highlighted, and an optional verdict.
- Style: Plex Mono, ink on paper, 2 px rules, square corners, red accent
  `#c6102e`, no shadows. Controlled variable = a square frame around the
  node (book's convention, already used in séance 8).
- **Open/closed is computed, never declared.** For a highlighted path, each
  interior node is classified from the edge directions (fourchette,
  chaîne, collision). A non-collision is open unless framed. A collision
  is closed unless it or one of its descendants is framed. The path is
  open iff every link is open. This makes a wrong drawing impossible (the
  H24 summary slide had one, see below).
- **Two visual signals.** Causal effect: `Flux.svelte` dots, cause → effect
  only (unchanged from séance 8). Statistical information: the whole path
  lights up in the accent at once, both ends together, when open; stays
  grey/dashed when closed. Where both appear on one slide, the legend names
  them once.
- Click driving through `brancherTemps` (`temps.js`). Deterministic, no
  `Math.random`. Schematic: no data, except coefficients on simulation
  arrows.
- Layout must hold at 1920×1080 and 1280×720 (`deborde.mjs`).

## Slide outline (≈60 slides; counts are targets, not contracts)

Time budget: about 80 min before the break (opening + parts 1–4), about
80 min after (parts 5–6 + closing). Target ≈65 slides.

Opening (≈7): title · `Session ici={11}` · Aujourd'hui (new `Aujourdhui11`) ·
**bridge, about 10 minutes**: the fundamental problem in Arel-Bundock's
vocabulary (ch. 7): two worlds, one person, we only ever see one, so an
effect is a comparison with a world we cannot see. Drawn, not written.
It ends on « on ne peut pas tout voir, donc on doit dire ce qu'on croit:
c'est le GOA ».

1. **Pourquoi, comment** (5). Les trois fonctions (révéler ses postulats,
   savoir si l'effet de la VI sur la VD est identifiable, choisir les
   contrôles). Produire un GOA: the four facts of the book's éducation →
   idéologie example appear one per click, then the GOA assembles arrow by
   arrow.
2. **La grammaire** (5). Orienté: A → B → C, ancêtre / descendant, « A cause
   C si et seulement s'il existe un chemin où toutes les flèches pointent
   vers C », A → B ← C (pas de cause). Acyclique: valid vs a cycle. Effet
   causal vs information statistique: température → crème glacée, →
   mercure (H24 choice).
3. **Trois types de chemins** (12). Overview: fourchette / chaîne /
   collision, ouvert / ouvert / fermé. Encadrer = contrôler. Seatbelt chain
   uncontrolled → controlled. One slide each: fourchette (température),
   chaîne (sucre → diabète → maladies cardiovasculaires), collision
   (performance, arbitre → victoire), each: open or closed, then what
   controlling the central link does. Summary 3×2 grid (computed by
   `Goa`). Combinaisons: open iff every link open (book's A…E chains).
4. **Les contrôles** (7). The two conditions. Condition 1: sexe →
   occupation → salaire (« sexe », not « genre », per the instructor's
   standing rule). Condition 2: santé mentale → éclatement familial →
   itinérance. Éducation example: question, then answer (frame « revenu des
   parents », not « revenu individuel »). Then the séance 8 correction
   slide (see Sources, 4).

Pause.

5. **Pratique: ouvert ou fermé?** (≈16). Recap card of the rules. The four
   H24 chains (goa17/19/21/23), question then click for the answer. The two
   « Rappelez-vous » (goa25/26). The five-question checklist, then the three
   exercise graphs (goa27, goa29, goa31 smoking), each: questions, then
   answers revealed one per click.
6. **Simulations dans R** (≈12). Why simulate: we built the data, so we know
   the true effect. Captioned « données simulées ». Sim 1 (X → Y, 1,7),
   sim 2 chaîne (3 × 0,5 = 1,5), sim 3 collision (with Z: biased), sim 4
   fourchette (control Z2, not Z1), sim 5 complex (the five questions, then
   the proof), then the 8 models (M1–M8) as a figure: X's coefficient per
   model against the true value 1.

Closing (3, plus Examen 2 online once the instructor gives the details): the travail final's GOA requirements (from
`travaux/pdf/travail-final-A26.tex`, part 2) · « Avant la prochaine
séance » (new visual, read from `cours.js` once its dates are updated:
next class, bring your GOA to the individual meetings, the Datacamp
chapter) · end slide. Nothing from the
H24 « Messages » slides (stale names, dates, exam scope).

## R simulations: reproducibility

- New `deck/outils/seance11_data.R` writes `deck/src/lib/data/seance11.js`.
- Each simulation is a **self-contained block shown on the slide as is**,
  with `set.seed(…)` and `n <- 100000` in it, so a student who types it in
  Positron gets the same numbers. The script runs exactly those blocks, in
  slide order, with `options(width = 100)`, and exports both code and
  output for `Console.svelte`. Only `lm()` and `coef()`, no equations.
- Code must be readable from the back (no `petit`); split a slide if needed.
- **Delivery (my call):** the instructor runs each block live in Positron;
  every code block has a `Copier` button so students can type along on
  their laptops and get the same numbers. No separate timed exercise.

## Errors in the H24 deck not to carry over

- « Trois fonctions » reversed VI and VD (« l'effet causal de la VD sur la
  VI »).
- The summary slide's « Fourchettes · Fermé » panel draws `x → [y] ← z` (a
  controlled collision). A controlled fork is `x ← [y] → z`.
- « Simulation Fourchette »: the output under `lm(Y ~ X)` reruns the
  collision data. Regenerate.
- Smoking graph (goa31) key says « contrôler Z3 ». Poids (Z2) also blocks
  `X ← Z3 → Z2 → Z1 → Y` and is not a descendant of X: the key becomes
  « Z3 ou Z2 ». Verify every drill key mechanically (dagitty, or a small
  path check in R) before writing it on a slide.
- « backdoors », « Admetton », « vrm », « preuve mathématique »: gone.

## House rules that apply

Student text in Québec French, no semicolons, no em dashes, U+202F before
`? : ! ;` in markup only. Bandeaux are CSS-uppercased: keep Z₁ / X / Y and
lone letters out of them. `const TOTAL` equals the number of `<Slide>`s.
Run `outils/verifier.sh seance-11 …` with
`CHROMIUM=/usr/sbin/google-chrome-stable`, both sizes, look at the PNGs.
Serve the repo root on port 8000 while iterating. Publish by adding
`deck: 'slides/seance-11/'` in `cours.js`. Commit source + export +
`.beads/issues.jsonl` together. **No push without the instructor's go-ahead.**

## Build order (Thursday deadline)

1. `Goa.svelte` + parts 1–4: a teachable first half early.
2. `seance11_data.R` + part 6 simulations.
3. Part 5 drill, closing slides, polish, overflow check.

## Calls made without the instructor (check these)

- A ≈10-minute séance 10 bridge at the opening (fundamental problem), not
  a full séance 10 deck.

- Séance 8 income correction slide (Sources, 4).
- Simulations run live by the instructor, `Copier` on every block.
- One slide in part 3 for « contrôler le descendant d'une collision ouvre le
  chemin » (book p. 123, not in the H24 deck).
- The book's « Leçons » (experiments, post-treatment bias) get one line at
  most: séances 13 and 14 cover them.
- Seeds, colours, exact node layouts, drill graph topologies (read from the
  H24 PNGs) are the builder's.
