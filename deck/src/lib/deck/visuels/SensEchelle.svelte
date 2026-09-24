<script>
  /**
   * 1 = ce que dit le nom : le sens d'une échelle de 0 à 1. La satisfaction
   * envers la démocratie (cps25_demsat) est codée 1 = très satisfait …
   * 4 = pas du tout, 5 = ne sait pas. La nouvelle variable s'appelle
   * satisfaction : 1 doit donc vouloir dire satisfait.e. Deux axes qui
   * montent tous deux; les liens se croisent en X, et ce X, c'est
   * l'inversion. Reprend l'idée d'Inverser.svelte, en plus grand. Cinq
   * temps :
   *
   *   0  l'axe des codes : plus le code monte, moins on est satisfait;
   *   1  le nom de la nouvelle variable et l'axe de 0 à 1 : 1 = satisfait.e;
   *   2  les liens se croisent;
   *   3  le 5 (ne sait pas) part vers NA;
   *   4  la même règle pour une autre variable (exemple en texte seulement).
   *
   * Les valeurs 1, 0,67, 0,33 et 0 sont celles du case_when() de la diapo
   * suivante. Les codes : seance4.js (outils/seance4_data.R). Pas d'effectifs.
   */
  import { brancherTemps } from '../temps.js';
  import { SATISFACTION } from '$lib/data/seance4.js';

  let { nom = 'satisfaction_democratie' } = $props();

  const NOMS = ['Très satisfait', 'Plutôt satisfait', 'Peu satisfait', 'Pas du tout satisfait', 'Ne sait pas'];
  const CIBLE = [1, 0.67, 0.33, 0, null];
  const virg = (v) => String(v).replace('.', ',');

  const XG = 420, XD = 680;
  const YBAS = 390, YHAUT = 150;
  const yCode = (k) => YBAS - k * ((YBAS - YHAUT) / 3); // k = 0..3 : codes 1 à 4, 1 en bas
  const ySat = (v) => YBAS - v * (YBAS - YHAUT);
  const YNA = 462;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel sens-echelle" bind:this={hote}>
  <svg viewBox="0 0 1000 490" role="img" aria-label="À gauche, les codes 1 à 4 de la satisfaction envers la démocratie dans le sondage, 1 = très satisfait en bas, 4 = pas du tout satisfait en haut. À droite, la nouvelle variable {nom}, de 0 à 1, où 1 = satisfait.e. Les liens se croisent : le code 1 devient 1, le code 4 devient 0. Le code 5, ne sait pas, devient NA.">
    <!-- L'axe de gauche : le code du sondage. -->
    <text x={XG} y="112" class="tete">cps25_demsat</text>
    <line x1={XG} y1={YBAS + 14} x2={XG} y2={YHAUT - 22} class="axe" />
    <path d="M {XG - 9} {YHAUT - 12} L {XG} {YHAUT - 28} L {XG + 9} {YHAUT - 12}" class="pointe" />
    {#each [0, 1, 2, 3] as k}
      <line x1={XG - 9} y1={yCode(k)} x2={XG + 9} y2={yCode(k)} class="axe" />
      <text x={XG - 22} y={yCode(k) + 10} class="code">{SATISFACTION.codes[k]}</text>
      <text x={XG - 60} y={yCode(k) + 8} class="nom">{NOMS[k]}</text>
    {/each}
    <text x={XG - 22} y={YNA + 10} class="code" class:na={e >= 3}>{SATISFACTION.codes[4]}</text>
    <text x={XG - 60} y={YNA + 8} class="nom" class:na={e >= 3}>{NOMS[4]}</text>

    <!-- L'axe de droite : la nouvelle variable, de 0 à 1. -->
    <g class="droite" class:vu={e >= 1}>
      <text x={XD} y="76" class="var">{nom}</text>
      <line x1={XD} y1={YBAS + 14} x2={XD} y2={YHAUT - 22} class="axe g" />
      <path d="M {XD - 9} {YHAUT - 12} L {XD} {YHAUT - 28} L {XD + 9} {YHAUT - 12}" class="pointe g" />
      {#each CIBLE.slice(0, 4) as v}
        <line x1={XD - 9} y1={ySat(v)} x2={XD + 9} y2={ySat(v)} class="axe g" />
        <text x={XD + 24} y={ySat(v) + 10} class="val">{virg(v)}{#if v === 1}<tspan class="bout" dx="14">= satisfait.e</tspan>{:else if v === 0}<tspan class="bout gris" dx="14">= pas satisfait.e</tspan>{/if}</text>
      {/each}
    </g>
    <text x={XD + 24} y={YNA + 10} class="val na" class:vu={e >= 3}>NA</text>

    {#each CIBLE as v, k}
      {@const y1 = k === 4 ? YNA : yCode(k)}
      {@const y2 = v === null ? YNA : ySat(v)}
      <line x1={XG + 18} y1={y1} x2={XD - 18} y2={y2} class="fl" class:na={v === null} class:vu={v === null ? e >= 3 : e >= 2} style="transition-delay: {k * 90}ms" />
    {/each}
  </svg>

  {#key e}
    <p class="dit">
      {#if e === 0}Dans le sondage, plus le code monte, <b>moins</b> on est satisfait.
      {:else if e === 1}Le nom parle de satisfaction&#8239;: <b>1</b> doit vouloir dire satisfait.e.
      {:else if e === 2}Le code 1 devient 1, le code 4 devient 0&#8239;: on <b>inverse</b> l’échelle.
      {:else if e === 3}« Ne sait pas » n’est pas un degré de satisfaction&#8239;: <b>NA</b>.
      {:else}Même règle partout&#8239;: <code>appui_avortement</code>, <b>1</b> = appuie, <b>0</b> = n’appuie pas.{/if}
    </p>
  {/key}
</div>

<style>
  .sens-echelle { display: flex; flex-direction: column; gap: 0.5em; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .tete { font-size: 22px; font-weight: 600; fill: var(--dk-gris); text-anchor: middle; }
  .var { font-size: 34px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; }
  .axe { stroke: var(--dk-encre); stroke-width: 3; }
  .axe.g { stroke: var(--dk-accent); }
  .pointe { fill: var(--dk-encre); }
  .pointe.g { fill: var(--dk-accent); }
  .code { font-size: 28px; font-weight: 700; text-anchor: end; fill: var(--dk-encre); transition: fill 0.3s; }
  .nom { font-size: 22px; text-anchor: end; fill: var(--dk-encre); transition: fill 0.3s; }
  .code.na, .nom.na { fill: var(--dk-accent); }
  .droite { opacity: 0; transition: opacity 0.4s; }
  .droite.vu { opacity: 1; }
  .val { font-size: 28px; font-weight: 700; fill: var(--dk-accent); }
  .bout { font-size: 25px; fill: var(--dk-accent); }
  .bout.gris { fill: var(--dk-gris); }
  .val.na { opacity: 0; transition: opacity 0.4s 0.4s; }
  .val.na.vu { opacity: 1; }
  .fl { stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 500; stroke-dashoffset: 500; transition: stroke-dashoffset 0.7s; }
  .fl.na { stroke: var(--dk-accent); stroke-dasharray: 10 8; stroke-dashoffset: 0; opacity: 0; transition: opacity 0.4s; }
  .fl.vu { stroke-dashoffset: 0; }
  .fl.na.vu { opacity: 1; }
  .dit { margin: 0; font-size: 1.3em; animation: fondu 0.4s both; }
  .dit b { color: var(--dk-accent); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .dit { animation: none; } .fl, .val, .droite { transition: none; } }
</style>
