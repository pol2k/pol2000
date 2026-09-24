<script>
  /**
   * Toujours vérifier, en 1993 : les onze codes de scolarité (cpso3) et les
   * NA, reliés aux trois catégories de ses_education plus NA. Les totaux des
   * groupes doivent retomber sur toutes les personnes de l'enquête.
   * Recodage.svelte fait la même chose pour 2025; il reste tel quel.
   * Quatre temps :
   *
   *   0  les codes, les NA et leurs effectifs;
   *   1  les liens se tracent vers les groupes;
   *   2  les totaux des groupes apparaissent;
   *   3  la vérification : la somme des groupes = toutes les personnes;
   *   4  d'où viennent autant de NA (panel de 1992, pas d'entrevue de
   *      campagne, ne sait pas ou refus).
   *
   * Tout vient d'EDUC93 dans seance4_plus.js (outils/seance4_plus.R). La
   * barre des NA est coupée (deux traits obliques) : à l'échelle, elle
   * sortirait de la figure.
   */
  import { brancherTemps } from '../temps.js';
  import { EDUC93 } from '$lib/data/seance4_plus.js';

  const NOMS = ['Aucune scolarité', 'Primaire commencé', 'Primaire terminé', 'Secondaire commencé', 'Secondaire terminé', 'Collégial commencé', 'Collégial terminé', 'Université commencée', 'Baccalauréat', 'Maîtrise', 'Professionnel, doctorat', 'NA'];
  const E = EDUC93.groupes.education;
  const LIGNES = [...EDUC93.codes.map((c, k) => ({ c, n: EDUC93.effectifs[k] })), { c: 'NA', n: EDUC93.na }];
  const GROUPES = [
    { val: 'secondaire_ou_moins', de: 0, a: 4, n: E.secondaire_ou_moins, teinte: 'encre' },
    { val: 'collegial', de: 5, a: 6, n: E.collegial, teinte: 'gris' },
    { val: 'universitaire', de: 7, a: 10, n: E.universitaire, teinte: 'rouge' },
    { val: 'NA', de: 11, a: 11, n: E.NA, teinte: 'na' }
  ];
  const groupeDe = (k) => GROUPES.find((g) => k >= g.de && k <= g.a);
  const fmt = (n) => n.toLocaleString('fr-CA');
  const somme = GROUPES.reduce((s, g) => s + g.n, 0);
  const tous = EDUC93.n;
  const POURQUOI = [
    { n: EDUC93.panel, txt: 'panel, interrogé.e.s en 1992' },
    { n: EDUC93.sansCampagne, txt: 'pas d’entrevue de campagne' },
    { n: EDUC93.nspRefus, txt: 'ne sait pas, refus' }
  ];
  const sommeNA = POURQUOI.reduce((s, p) => s + p.n, 0);

  const H = 34, Y0 = 22;
  // Un peu d'air entre le code 11 et la ligne des NA.
  const yCode = (k) => Y0 + k * H + (k === 11 ? 14 : 0);
  const MAXN = Math.max(...EDUC93.effectifs);
  const XC = 330, XB = 344, LB = 150;
  const larg = (n) => (n > MAXN ? LB + 40 : Math.max(2, (n / MAXN) * LB));
  const XL = 570, XLNA = 628, XG = 660, WG = 390;
  const yGroupe = (g) => (yCode(g.de) + yCode(g.a)) / 2;
  const hGroupe = (g) => g.a - g.de ? yCode(g.a) - yCode(g.de) + H - 8 : H - 6;
  const HAUT = yCode(11) + 22;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel recodage93" bind:this={hote}>
  <svg viewBox="0 0 1060 {HAUT}" role="img" aria-label="Les onze codes de scolarité de l'Étude électorale canadienne 1993 et les 2 537 NA, reliés à ses_education : secondaire_ou_moins (codes 1 à 5), collegial (6 et 7), universitaire (8 à 11), et NA.">
    {#each LIGNES as l, k}
      {@const y = yCode(k)}
      {@const g = groupeDe(k)}
      {@const w = larg(l.n)}
      <text x={XC - 34} y={y + 6} class="nom" class:na={l.c === 'NA'}>{NOMS[k]}</text>
      {#if l.c !== 'NA'}<text x={XC} y={y + 7} class="code">{l.c}</text>{/if}
      <rect x={XB} y={y - 11} width={w} height="22" class="barre {e >= 1 || l.c === 'NA' ? g.teinte : 'encre'}" style="animation-delay: {k * 40}ms" />
      {#if l.c === 'NA'}
        <path d="M {XB + LB - 4} {y + 15} l 10 -30 M {XB + LB + 8} {y + 15} l 10 -30" class="coupe" />
      {/if}
      <text x={XB + w + 8} y={y + 6} class="n" class:na={l.c === 'NA'}>{fmt(l.n)}</text>
      {@const x0 = l.c === 'NA' ? XLNA : XL}
      <path d="M {x0} {y} C {x0 + 40} {y}, {XG - 40} {yGroupe(g)}, {XG} {yGroupe(g)}" class="lien {g.teinte}" class:vu={e >= 1} style="transition-delay: {k * 45}ms" />
    {/each}

    {#each GROUPES as g}
      <g class="groupe {g.teinte}" class:vu={e >= 1}>
        <rect x={XG} y={yGroupe(g) - hGroupe(g) / 2} width={WG} height={hGroupe(g)} />
        <text x={XG + 14} y={yGroupe(g) + 7} class="gval">{g.val}</text>
        {#if e >= 2}<text x={XG + WG - 12} y={yGroupe(g) + 7} class="gn">{fmt(g.n)}</text>{/if}
      </g>
    {/each}
  </svg>

  <div class="bas">
    {#if e >= 3}
      <p class="verif">
        {#each GROUPES as g, i}<span class={g.teinte}>{fmt(g.n)}</span>{i < GROUPES.length - 1 ? ' + ' : ''}{/each}
        = <b>{fmt(somme)}</b>
        <span class="ok">{somme === tous ? '✓ toutes les personnes' : '✗'}</span>
      </p>
    {/if}
    {#if e >= 4}
      <div class="pourquoi">
        <p class="titre">Pourquoi {fmt(sommeNA)} NA<span class="nnbsp">&#8239;</span>?</p>
        <div class="bande">
          {#each POURQUOI as p, i}
            <span class="seg s{i}" style="flex: {p.n} 0 0"></span>
          {/each}
        </div>
        <ul>
          {#each POURQUOI as p, i}
            <li><i class="seg s{i}"></i><b>{fmt(p.n)}</b> {p.txt}</li>
          {/each}
        </ul>
      </div>
    {/if}
  </div>
</div>

<style>
  .recodage93 { display: flex; flex-direction: column; gap: 0.5em; }
  svg { width: 100%; height: auto; max-height: 52vh; display: block; }
  text { font-family: var(--dk-mono); }
  .nom { font-size: 18px; text-anchor: end; fill: var(--dk-gris); }
  .nom.na { fill: var(--dk-accent); font-weight: 600; font-size: 20px; }
  .code { font-size: 20px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .n { font-size: 17px; fill: var(--dk-gris); }
  .n.na { fill: var(--dk-accent); font-weight: 600; }
  .barre { animation: pousse 0.5s cubic-bezier(0.34, 1.4, 0.64, 1) both; transform-origin: left; transform-box: fill-box; transition: fill 0.4s; }
  .barre.encre { fill: var(--dk-encre); }
  .barre.gris { fill: var(--dk-gris-2); }
  .barre.rouge, .barre.na { fill: var(--dk-accent); }
  .coupe { stroke: var(--dk-fond); stroke-width: 5; fill: none; }

  .lien { fill: none; stroke-width: 2.5; stroke-dasharray: 400; stroke-dashoffset: 400; transition: stroke-dashoffset 0.6s; }
  .lien.encre { stroke: var(--dk-encre); }
  .lien.gris { stroke: var(--dk-gris-2); }
  .lien.rouge, .lien.na { stroke: var(--dk-accent); }
  .lien.na { stroke-dasharray: 6 6; stroke-dashoffset: 0; opacity: 0; transition: opacity 0.4s 0.5s; }
  .lien.na.vu { opacity: 1; }
  .lien.vu { stroke-dashoffset: 0; }

  .groupe { opacity: 0; transition: opacity 0.4s 0.4s; }
  .groupe.vu { opacity: 1; }
  .groupe rect { fill: #fff; stroke-width: 3; }
  .groupe.encre rect { stroke: var(--dk-encre); }
  .groupe.gris rect { stroke: var(--dk-gris-2); }
  .groupe.rouge rect { stroke: var(--dk-accent); fill: var(--dk-accent); }
  .groupe.na rect { stroke: var(--dk-accent); stroke-dasharray: 8 5; }
  .gval { font-size: 21px; font-weight: 600; fill: var(--dk-encre); }
  .gn { font-size: 22px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); font-variant-numeric: tabular-nums; animation: fondu 0.35s both; }
  .groupe.rouge .gval, .groupe.rouge .gn { fill: #fff; }
  .groupe.na .gval, .groupe.na .gn { fill: var(--dk-accent); }

  .bas { display: flex; justify-content: space-between; align-items: flex-start; gap: 1.2em; min-height: 1em; }
  .verif { margin: 0; font-size: 1em; font-variant-numeric: tabular-nums; border: 3px solid var(--dk-accent); padding: 0.3em 0.7em; animation: fondu 0.4s both; white-space: nowrap; }
  .verif .gris { color: var(--dk-gris); }
  .verif .rouge, .verif .na { color: var(--dk-accent); }
  .verif b { color: var(--dk-accent); }
  .verif .ok { font-weight: 600; color: var(--dk-accent); margin-left: 0.3em; }

  .pourquoi { flex: 1; max-width: 22em; display: flex; flex-direction: column; gap: 0.25em; animation: fondu 0.4s both; }
  .pourquoi .titre { font-size: 0.8em; font-weight: 600; color: var(--dk-accent); }
  .bande { display: flex; gap: 3px; height: 0.7em; }
  .seg { background: var(--dk-accent); min-width: 3px; }
  .seg.s1 { opacity: 0.55; }
  .seg.s2 { background: var(--dk-encre); }
  li .seg { display: inline-block; width: 0.7em; height: 0.7em; margin-right: 0.3em; vertical-align: -0.05em; }
  .pourquoi ul { list-style: none; padding: 0; margin: 0; }
  .pourquoi li { font-size: 0.72em; line-height: 1.4; margin: 0; }
  .pourquoi li b { display: inline-block; min-width: 3.4em; text-align: right; margin-right: 0.4em; font-variant-numeric: tabular-nums; }
  @keyframes pousse { from { transform: scaleX(0); } to { transform: scaleX(1); } }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.2em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .barre, .verif, .pourquoi, .gn { animation: none; } .lien, .groupe { transition: none; } }
</style>
