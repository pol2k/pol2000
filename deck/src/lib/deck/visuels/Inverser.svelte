<script>
  /**
   * Inverser une échelle : la satisfaction envers la démocratie
   * (cps25_demsat) est codée 1 = très satisfait … 4 = pas du tout, 5 = ne
   * sait pas. Deux axes qui montent tous deux vers le haut : à gauche le
   * code du sondage, à droite la satisfaction de 0 à 1. Les liens se
   * croisent en X; ce X, c'est l'inversion. Trois temps :
   *
   *   0  l'axe des codes : plus le code monte, moins on est satisfait;
   *   1  les liens se croisent vers l'axe de 0 à 1;
   *   2  le 5 (ne sait pas) part vers NA.
   *
   * Effectifs : seance4.js (outils/seance4_data.R). Les valeurs 1, 0,67,
   * 0,33 et 0 sont celles du case_when() de la diapo suivante.
   */
  import { brancherTemps } from '../temps.js';
  import { SATISFACTION } from '$lib/data/seance4.js';

  const NOMS = ['Très satisfait', 'Plutôt satisfait', 'Peu satisfait', 'Pas du tout satisfait', 'Ne sait pas'];
  const CIBLE = [1, 0.67, 0.33, 0, null];
  const fmt = (n) => n.toLocaleString('fr-CA');
  const virg = (v) => String(v).replace('.', ',');

  const XG = 400, XD = 720;
  const YBAS = 300, YHAUT = 60;
  const yCode = (k) => YBAS - k * ((YBAS - YHAUT) / 3); // k = 0..3 : codes 1 à 4, 1 en bas
  const ySat = (v) => YBAS - v * (YBAS - YHAUT);
  const YNA = 372;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel inverser" bind:this={hote}>
  <svg viewBox="0 0 1000 400" role="img" aria-label="Deux axes qui montent. À gauche, les codes 1 à 4 de la satisfaction envers la démocratie, 1 = très satisfait en bas. À droite, la satisfaction de 0 à 1. Les liens se croisent : le code 1 devient 1, le code 4 devient 0. Le code 5, ne sait pas, devient NA.">
    <!-- L'axe de gauche : le code du sondage. -->
    <text x={XG} y="26" class="tete">code dans le sondage</text>
    <line x1={XG} y1={YBAS + 12} x2={XG} y2={YHAUT - 18} class="axe" />
    <path d="M {XG - 8} {YHAUT - 10} L {XG} {YHAUT - 24} L {XG + 8} {YHAUT - 10}" class="pointe" />
    {#each [0, 1, 2, 3] as k}
      <line x1={XG - 8} y1={yCode(k)} x2={XG + 8} y2={yCode(k)} class="axe" />
      <text x={XG - 18} y={yCode(k) + 8} class="code">{SATISFACTION.codes[k]}</text>
      <text x={XG - 52} y={yCode(k) + 6} class="nom">{NOMS[k]}</text>
      <text x={XG - 52} y={yCode(k) + 26} class="n">{fmt(SATISFACTION.effectifs[k])}</text>
    {/each}
    <text x={XG - 18} y={YNA + 8} class="code" class:na={e >= 2}>{SATISFACTION.codes[4]}</text>
    <text x={XG - 52} y={YNA + 6} class="nom" class:na={e >= 2}>{NOMS[4]}</text>

    <!-- L'axe de droite : la satisfaction, de 0 à 1. -->
    <g class="droite" class:vu={e >= 1}>
      <text x={XD} y="26" class="tete g">satisfaction</text>
      <line x1={XD} y1={YBAS + 12} x2={XD} y2={YHAUT - 18} class="axe" />
      <path d="M {XD - 8} {YHAUT - 10} L {XD} {YHAUT - 24} L {XD + 8} {YHAUT - 10}" class="pointe" />
      {#each CIBLE.slice(0, 4) as v}
        <line x1={XD - 8} y1={ySat(v)} x2={XD + 8} y2={ySat(v)} class="axe" />
        <text x={XD + 20} y={ySat(v) + 8} class="val">{virg(v)}</text>
      {/each}
    </g>
    <text x={XD + 20} y={YNA + 8} class="val na" class:vu={e >= 2}>NA</text>

    {#each CIBLE as v, k}
      {@const y1 = k === 4 ? YNA : yCode(k)}
      {@const y2 = v === null ? YNA : ySat(v)}
      <line x1={XG + 16} y1={y1} x2={XD - 16} y2={y2} class="fl" class:na={v === null} class:vu={v === null ? e >= 2 : e >= 1} style="transition-delay: {k * 90}ms" />
    {/each}
  </svg>

  {#key e}
    <p class="dit">
      {#if e === 0}Plus le code monte, <b>moins</b> on est satisfait.
      {:else if e === 1}Plus la satisfaction monte, <b>plus</b> on est satisfait.
      {:else}« Ne sait pas » n’est pas un degré de satisfaction : <b>NA</b>.{/if}
    </p>
  {/key}
</div>

<style>
  .inverser { display: flex; flex-direction: column; gap: 0.5em; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .tete { font-size: 17px; font-weight: 600; letter-spacing: 0.06em; fill: var(--dk-gris); text-anchor: middle; }
  .tete.g { fill: var(--dk-accent); }
  .axe { stroke: var(--dk-encre); stroke-width: 3; }
  .pointe { fill: var(--dk-encre); }
  .code { font-size: 24px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); transition: fill 0.3s; }
  .nom { font-size: 18px; text-anchor: end; fill: var(--dk-encre); transition: fill 0.3s; }
  .n { font-size: 14px; text-anchor: end; fill: var(--dk-gris); }
  .code.na, .nom.na { fill: var(--dk-accent); }
  .droite { opacity: 0; transition: opacity 0.4s; }
  .droite.vu { opacity: 1; }
  .val { font-size: 24px; font-weight: 600; fill: var(--dk-accent); }
  .val.na { opacity: 0; transition: opacity 0.4s 0.4s; }
  .val.na.vu { opacity: 1; }
  .fl { stroke: var(--dk-encre); stroke-width: 3.5; stroke-dasharray: 500; stroke-dashoffset: 500; transition: stroke-dashoffset 0.7s; }
  .fl.na { stroke: var(--dk-accent); stroke-dasharray: 10 8; stroke-dashoffset: 0; opacity: 0; transition: opacity 0.4s; }
  .fl.vu { stroke-dashoffset: 0; }
  .fl.na.vu { opacity: 1; }
  .dit { margin: 0; font-size: 1.3em; animation: fondu 0.4s both; }
  .dit b { color: var(--dk-accent); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .dit { animation: none; } .fl, .val, .droite { transition: none; } }
</style>
