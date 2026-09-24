<script>
  /**
   * Toutes les variables de 0 à 1 : pourquoi on ramène une échelle de
   * Likert, une échelle de 0 à 10 et un oui ou non sur la même règle.
   * Trois règles posées sur une même droite de nombres bruts, puis étirées
   * jusqu'à couvrir la même largeur. Cinq temps :
   *
   *   0  trois variables, trois étendues : 1 à 5, 0 à 10, oui ou non;
   *   1  les étiquettes d'origine s'effacent, les règles s'étirent sur la
   *      même largeur (on ne dit pas encore quel bout est lequel : c'est
   *      la diapo suivante, le sens de l'échelle);
   *   2  l'axe commun : 0 = le minimum, 1 = le maximum;
   *   3  ce que vaut chaque cran : l'ancienne valeur revient en gris
   *      au-dessus, la nouvelle s'écrit en rouge dessous (0 · 0,25 · … · 1,
   *      0 · 0,1 · … · 1, et 0 · 1 pour le oui ou non);
   *   4  le milieu : 3 sur l'échelle de 1 à 5 et 5 sur celle de 0 à 10
   *      tombent tous les deux à 0,5.
   *
   * Aucune donnée : des échelles schématiques. La satisfaction de 1 à 5
   * n'est pas cps25_demsat (4 crans, voir SensEchelle.svelte) : c'est une
   * Likert générique, sans nom aux bouts, pour ne pas devancer le sens de
   * l'échelle. Pas d'effectifs.
   */
  import { brancherTemps } from '../temps.js';

  // Droite brute : une unité = U px, 0 en X0. Cible commune : X0 → X1.
  const X0 = 330, X1 = 930, U = 54;
  const brut = (v) => X0 + v * U;

  const REGLES = [
    { nom: 'satisfaction', sous: 'Likert, 1 à 5', y: 70, valeurs: [1, 2, 3, 4, 5], etiq: null, milieu: 3 },
    { nom: 'gauche-droite', sous: '0 à 10', y: 180, valeurs: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10], etiq: null, milieu: 5 },
    // Le oui ou non ne rappelle pas ses étiquettes au temps 3 : lequel vaut 1,
    // c'est la diapo suivante.
    { nom: 'né.e au Canada', sous: 'oui ou non', y: 290, valeurs: [1, 2], etiq: ['oui', 'non'], cache: true }
  ].map((r) => {
    const min = r.valeurs[0], max = r.valeurs[r.valeurs.length - 1];
    return { ...r, min, max, etiq: r.etiq ?? r.valeurs.map(String) };
  });
  // Position d'un cran : sur la droite brute, ou sur la règle commune.
  // Valeur d'un cran une fois ramené entre 0 et 1, avec la virgule décimale.
  const zu = (r, v) => String(Math.round(((v - r.min) / (r.max - r.min)) * 100) / 100).replace('.', ',');
  const pos = (r, v, commun) => (commun ? X0 + ((v - r.min) / (r.max - r.min)) * (X1 - X0) : brut(v));

  const YAXE = 370;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel zero-un" bind:this={hote}>
  <svg viewBox="0 0 1000 440" role="img" aria-label="Trois variables aux échelles différentes : une satisfaction de 1 à 5 (échelle de Likert), une échelle gauche-droite de 0 à 10 et un oui ou non. Elles sont toutes étirées sur la même règle, de 0 à 1 : 0 est le minimum, 1 le maximum. La satisfaction devient 0, 0,25, 0,5, 0,75 et 1; la gauche-droite 0, 0,1, 0,2 et ainsi de suite jusqu'à 1; le oui ou non 0 et 1. Le milieu, 3 sur 5 ou 5 sur 10, vaut 0,5.">
    <!-- Les repères communs, au dernier temps. -->
    <g class="commun" class:vu={e >= 2}>
      <line x1={X0} y1="30" x2={X0} y2={YAXE} class="guide" />
      <line x1={X1} y1="30" x2={X1} y2={YAXE} class="guide" />
      <line x1={X0} y1={YAXE} x2={X1} y2={YAXE} class="axe-commun" />
      <text x={X0} y={YAXE + 40} class="borne">0</text>
      <text x={X1} y={YAXE + 40} class="borne">1</text>
      <text x={X0} y={YAXE + 64} class="sens">minimum</text>
      <text x={X1} y={YAXE + 64} class="sens">maximum</text>
    </g>

    <!-- Le milieu, au dernier temps : 0,5 sur les deux échelles. -->
    <g class="milieu" class:vu={e >= 4}>
      <line x1={(X0 + X1) / 2} y1="30" x2={(X0 + X1) / 2} y2={YAXE} class="guide" />
      <text x={(X0 + X1) / 2} y={YAXE + 40} class="borne">0,5</text>
    </g>

    {#each REGLES as r, i}
      <g transform="translate(0 {r.y})">
        <text x="290" y="0" class="nom">{r.nom}</text>
        <text x="290" y="26" class="sous">{r.sous}</text>
        <!-- La règle : un rectangle d'une unité, déplacé puis étiré. -->
        <rect x="0" y="-2" width="1" height="4" class="regle" style="transform: translateX({pos(r, r.min, e >= 1)}px) scaleX({pos(r, r.max, e >= 1) - pos(r, r.min, e >= 1)}); transition-delay: {e >= 1 ? 250 + i * 120 : 0}ms" />
        {#each r.valeurs as v, k}
          <g class="cran" style="transform: translateX({pos(r, v, e >= 1)}px); transition-delay: {e >= 1 ? 250 + i * 120 : 0}ms">
            <line x1="0" y1="-12" x2="0" y2="12" />
            <text x="0" y="-22" class="cr" class:efface={e >= 1 && (e < 3 || r.cache)} class:avant={e >= 3} class:terne={e >= 4 && v !== r.milieu && !r.cache} class:fort={e >= 4 && v === r.milieu}>{r.etiq[k]}</text>
            <text x="0" y="44" class="apres" class:vu={e >= 3} class:terne={e >= 4 && v !== r.milieu} class:fort={e >= 4 && v === r.milieu}>{zu(r, v)}</text>
          </g>
        {/each}
      </g>
    {/each}
  </svg>

  {#key e}
    <p class="dit">
      {#if e === 0}Trois variables, trois étendues différentes.
      {:else if e === 1}On les met toutes sur la <b>même échelle</b>, de 0 à 1.
      {:else if e === 2}Même échelle&#8239;: on <b>compare</b> nos variables et on lit mieux nos résultats.
      {:else if e === 3}Chaque cran prend une <b>nouvelle valeur</b> entre 0 et 1.
      {:else}Le milieu de chaque échelle vaut <b>0,5</b>.{/if}
    </p>
  {/key}
</div>

<style>
  .zero-un { display: flex; flex-direction: column; gap: 0.5em; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .nom { font-size: 24px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .sous { font-size: 18px; text-anchor: end; fill: var(--dk-gris); }
  .regle { fill: var(--dk-encre); transform-origin: 0 0; transition: transform 0.9s ease-in-out; }
  .cran { transition: transform 0.9s ease-in-out; }
  .cran line { stroke: var(--dk-encre); stroke-width: 3; }
  .cr { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: opacity 0.25s, fill-opacity 0.4s; }
  /* Un halo couleur papier : les pointillés passent sous les chiffres. */
  .cr, .apres, .borne { paint-order: stroke; stroke: var(--dk-fond); stroke-width: 8px; stroke-linejoin: round; }
  .cr.efface { opacity: 0; }
  .cr.avant { fill: var(--dk-gris); font-weight: 500; }
  .apres { font-size: 23px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s, fill-opacity 0.4s, font-size 0.3s; }
  .apres.vu { opacity: 1; }
  /* On pâlit le chiffre, pas son halo : les pointillés restent cachés. */
  .cr.terne, .apres.terne { fill-opacity: 0.3; }
  .apres.fort { font-size: 30px; }
  .cr.fort { fill: var(--dk-encre); font-weight: 700; }
  .milieu { opacity: 0; transition: opacity 0.5s; }
  .milieu.vu { opacity: 1; }
  .commun { opacity: 0; transition: opacity 0.5s; }
  .commun.vu { opacity: 1; }
  .guide { stroke: var(--dk-accent); stroke-width: 2; stroke-dasharray: 8 7; }
  .axe-commun { stroke: var(--dk-accent); stroke-width: 4; }
  .borne { font-size: 34px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .sens { font-size: 19px; text-anchor: middle; fill: var(--dk-accent); }
  .dit { margin: 0; font-size: 1.3em; animation: fondu 0.4s both; }
  .dit b { color: var(--dk-accent); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .dit { animation: none; } .regle, .cran, .cr, .commun, .apres, .milieu { transition: none; } }
</style>
