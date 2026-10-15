<script>
  /**
   * L'équation, puis en mots, puis dans la CES. Trois rangées alignées sur
   * les mêmes colonnes : chaque terme garde sa place et sa couleur d'une
   * rangée à l'autre.
   *
   *   rouge          ce qu'on explique (y, l'intérêt pour la politique);
   *   encadré        les deux nombres que R trouve (β0, β1);
   *   encre          ce qu'on connaît de chaque personne (x, la scolarité);
   *   gris           tout le reste (ε, l'erreur) : dans la CES, l'âge, le
   *                  genre et tout ce qu'on n'a pas mis dans l'équation.
   *
   *   0  y = β0 + β1x + ε, en grand.
   *   1  Les mots descendent sous chaque symbole, de gauche à droite.
   *   2  La CES : intérêt = 0,56 + 0,17 × scolarité + âge + genre + …
   *      La pente est positive : la case de β1 porte 0,17 et le « + »
   *      reste. (Si une pente était négative, le signe moins irait dans la
   *      case et le « + » tomberait : le code le fait seul.) Sous ε, au lieu
   *      du mot « erreur », ce qui s'y cache : des variables qui poussent à
   *      la fois la scolarité et l'intérêt. L'âge est celle de la section sur
   *      la variable confondante (TIERS); le genre est dans la régression
   *      multiple (MULTIPLE). Le « … » : tout le reste.
   *
   * Vocabulaire : Arel-Bundock (2021, ch. 5) dit « constante » ou
   * « ordonnée à l'origine » pour β0; le prof veut « ordonnée à l'origine »
   * (revue du 15 octobre). Les nombres sont ceux de la population
   * d'exercice (POP : lm sur les 20 180 de la CES 2025, 19 736 cas complets,
   * outils/seance7_data.R). Les deux variables vont de 0 à 1.
   */
  import { brancherTemps } from '../temps.js';
  import { POP } from '$lib/data/seance7.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const virgule = (v, d) => (v < 0 ? '−' : '') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
</script>

<div class="visuel rem" bind:this={hote}
  aria-label="y égale bêta zéro plus bêta un fois x plus epsilon. En mots : variable dépendante égale ordonnée à l’origine plus pente fois variable indépendante plus erreur. Dans la CES : intérêt égale {virgule(POP.b0, 2)} plus {virgule(POP.b1, 2)} fois scolarité plus âge plus genre plus tout le reste.">
  <div class="grille">
    <!-- Rangée 1 : les symboles. -->
    <span class="c sym y" style="--k: 0">y</span>
    <span class="c sym op">=</span>
    <span class="c sym b" style="--k: 1"><span>β<sub>0</sub></span></span>
    <span class="c sym op">+</span>
    <span class="c sym b" style="--k: 2"><span>β<sub>1</sub></span></span>
    <span class="c sym op mul">×</span>
    <span class="c sym x" style="--k: 3">x</span>
    <span class="c sym op">+</span>
    <span class="c sym eps" style="--k: 4">ε</span>

    <!-- Rangée 2 : les mots. -->
    <span class="c mot y" class:vu={e >= 1} style="--k: 0">variable dépendante</span>
    <span class="c mot op" class:vu={e >= 1} style="--k: 0">=</span>
    <span class="c mot b" class:vu={e >= 1} style="--k: 1">ordonnée à l’origine</span>
    <span class="c mot op" class:vu={e >= 1} style="--k: 1">+</span>
    <span class="c mot b" class:vu={e >= 1} style="--k: 2">pente</span>
    <span class="c mot op" class:vu={e >= 1} style="--k: 2">×</span>
    <span class="c mot x" class:vu={e >= 1} style="--k: 3">variable indépendante</span>
    <span class="c mot op" class:vu={e >= 1} style="--k: 3">+</span>
    <span class="c mot eps" class:vu={e >= 1} style="--k: 4">erreur</span>

    <!-- Rangée 3 : la CES. -->
    <span class="c ces y" class:vu={e >= 2} style="--k: 0">intérêt</span>
    <span class="c ces op" class:vu={e >= 2} style="--k: 0">=</span>
    <span class="c ces b" class:vu={e >= 2} style="--k: 1"><span class="case">{virgule(POP.b0, 2)}</span></span>
    <span class="c ces op" class:vu={e >= 2} style="--k: 1">{POP.b1 < 0 ? '' : '+'}</span>
    <span class="c ces b" class:vu={e >= 2} style="--k: 2"><span class="case">{virgule(POP.b1, 2)}</span></span>
    <span class="c ces op" class:vu={e >= 2} style="--k: 2">×</span>
    <span class="c ces x" class:vu={e >= 2} style="--k: 3">scolarité</span>
    <span class="c ces op" class:vu={e >= 2} style="--k: 3">+</span>
    <span class="c ces eps" class:vu={e >= 2} style="--k: 4"><span class="cache">âge + genre + …</span></span>
  </div>
  <p class="source" class:vu={e >= 2}>CES 2025 · 19 736 des 20 180 répondant.e.s · tout de 0 à 1</p>
</div>

<style>
  .rem { display: flex; flex-direction: column; align-items: center; gap: 1.4em; padding-top: 1.2em; }
  .grille {
    display: grid;
    grid-template-columns: 1.1fr auto 1.1fr auto 0.8fr auto 1.25fr auto 1.45fr;
    grid-template-rows: auto auto auto;
    column-gap: 0.5em;
    row-gap: 0.45em;
    width: 100%;
    align-items: center;
    text-align: center;
    font-variant-numeric: tabular-nums;
  }
  .c { display: flex; align-items: center; justify-content: center; min-height: 2.6em; padding: 0.35em 0.2em; }

  .sym { font-size: 3.4em; font-weight: 500; line-height: 1; min-height: 0; padding: 0 0.05em 0.12em; }
  .sym sub { font-size: 0.45em; line-height: 0; vertical-align: -0.3em; margin-left: 0.05em; }
  .sym.op { color: var(--dk-gris-2); font-weight: 400; }
  .sym.y, .sym.x { font-style: italic; }

  /* Sous chaque symbole, un trait de sa couleur : la colonne du terme. */
  .sym.y, .sym.b, .sym.x, .sym.eps { border-bottom: 3px solid currentColor; }
  .sym.b { color: var(--dk-encre); }

  .mot, .ces { opacity: 0; transform: translateY(-0.9em); transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.4, 0.64, 1); transition-delay: calc(var(--k) * 140ms); }
  .mot.vu, .ces.vu { opacity: 1; transform: none; }
  .mot { font-size: 1em; line-height: 1.25; }
  .ces { font-size: 1.15em; line-height: 1.2; font-weight: 600; }
  .op { color: var(--dk-gris-2); }

  .y { color: var(--dk-accent); }
  .eps { color: var(--dk-gris); }
  .mot.b { font-weight: 600; }

  .cache { font-weight: 600; }
  .case { display: inline-block; border: 3px solid var(--dk-encre); padding: 0.1em 0.35em; font-size: 1.15em; }

  .source { margin: 0; font-size: 0.7em; letter-spacing: 0.1em; color: var(--dk-gris); opacity: 0; transition: opacity 0.4s 0.8s; }
  .source.vu { opacity: 1; }

  @media (prefers-reduced-motion: reduce) {
    .mot, .ces, .source { transition: none; }
  }
</style>
