<script>
  /**
   * Toujours vérifier : les douze codes de scolarité (cps25_education) et
   * les trois catégories plus NA qu'ils deviennent. Chaque code est relié à
   * son groupe; les totaux doivent retomber sur le nombre de personnes.
   * Trois temps :
   *
   *   0  les douze codes et leurs effectifs;
   *   1  les liens se tracent vers les groupes;
   *   2  les totaux des groupes apparaissent;
   *   3  la vérification : la somme des groupes = toutes les personnes.
   *
   * Effectifs et totaux : seance4.js (outils/seance4_data.R). Les étiquettes
   * françaises abrègent celles du codebook.
   */
  import { brancherTemps } from '../temps.js';
  import { SCOLARITE } from '$lib/data/seance4.js';

  const NOMS = ['Aucune scolarité', 'Primaire commencé', 'Primaire', 'Secondaire commencé', 'Secondaire', 'Cégep commencé', 'Cégep', 'Université commencée', 'Baccalauréat', 'Maîtrise', 'Doctorat, prof.', 'Ne sait pas'];
  const GROUPES = [
    { cle: 'Secondaire ou moins', de: 1, a: 5 },
    { cle: 'Collégial', de: 6, a: 7 },
    { cle: 'Universitaire', de: 8, a: 11 },
    { cle: 'NA', de: 12, a: 12 }
  ].map((g) => ({ ...g, n: SCOLARITE.groupes[g.cle] ?? 0 }));
  const groupeDe = (c) => GROUPES.findIndex((g) => c >= g.de && c <= g.a);
  const fmt = (n) => n.toLocaleString('fr-CA');
  const somme = GROUPES.reduce((s, g) => s + g.n, 0);
  const tous = SCOLARITE.effectifs.reduce((s, n) => s + n, 0);

  const H = 36, Y0 = 24;
  const yCode = (k) => Y0 + k * H;
  const MAXN = Math.max(...SCOLARITE.effectifs);
  const XB = 250, LB = 220;
  const larg = (n) => Math.max(2, (n / MAXN) * LB);
  const XG = 690, WG = 290;
  const yGroupe = (g) => (yCode(g.de - 1) + yCode(g.a - 1)) / 2;
  const hGroupe = (g) => Math.max(H - 6, (g.a - g.de) * H + H - 8);

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel recodage" bind:this={hote}>
  <svg viewBox="0 0 1000 {Y0 + 12 * H + 8}" role="img" aria-label="Les douze codes de scolarité de l'Étude électorale canadienne 2025, reliés à trois catégories : secondaire ou moins (codes 1 à 5), collégial (6 et 7), universitaire (8 à 11), et NA pour « ne sait pas » (12).">
    {#each SCOLARITE.codes as c, k}
      {@const y = yCode(k)}
      {@const g = GROUPES[groupeDe(c)]}
      <text x={XB - 44} y={y + 6} class="nom">{NOMS[k]}</text>
      <text x={XB - 12} y={y + 6} class="code">{c}</text>
      <rect x={XB} y={y - 11} width={larg(SCOLARITE.effectifs[k])} height="22" class="barre" class:na={c === 12} style="animation-delay: {k * 40}ms" />
      <text x={XB + larg(SCOLARITE.effectifs[k]) + 8} y={y + 6} class="n">{fmt(SCOLARITE.effectifs[k])}</text>
      <path d="M {XB + LB + 70} {y} C {XB + LB + 130} {y}, {XG - 60} {yGroupe(g)}, {XG} {yGroupe(g)}" class="lien" class:na={c === 12} class:vu={e >= 1} style="transition-delay: {k * 50}ms" />
    {/each}

    {#each GROUPES as g}
      <g class="groupe" class:vu={e >= 1} class:na={g.cle === 'NA'}>
        <rect x={XG} y={yGroupe(g) - hGroupe(g) / 2} width={WG} height={hGroupe(g)} />
        <text x={XG + 14} y={yGroupe(g) + (e >= 2 && g.cle !== 'NA' ? -2 : 6)} class="gnom">{g.cle}</text>
        {#if e >= 2}<text x={XG + WG - 14} y={yGroupe(g) + (g.cle === 'NA' ? 6 : 22)} class="gn">{fmt(g.n)}</text>{/if}
      </g>
    {/each}
  </svg>

  {#if e >= 3}
    <p class="verif">
      {#each GROUPES as g, i}{fmt(g.n)}{i < GROUPES.length - 1 ? ' + ' : ''}{/each}
      = <b>{fmt(somme)}</b> <span class:ok={somme === tous}>{somme === tous ? '✓ tout le monde' : '✗'}</span>
    </p>
  {/if}
</div>

<style>
  .recodage { display: flex; flex-direction: column; gap: 0.4em; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .nom { font-size: 16px; text-anchor: end; fill: var(--dk-gris); }
  .code { font-size: 17px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .n { font-size: 15px; fill: var(--dk-gris); }
  .barre { fill: var(--dk-encre); animation: pousse 0.5s cubic-bezier(0.34, 1.4, 0.64, 1) both; transform-origin: left; transform-box: fill-box; }
  .barre.na { fill: var(--dk-accent); }
  .lien { fill: none; stroke: var(--dk-gris-2); stroke-width: 2.5; stroke-dasharray: 600; stroke-dashoffset: 600; transition: stroke-dashoffset 0.6s; }
  .lien.na { stroke: var(--dk-accent); }
  .lien.vu { stroke-dashoffset: 0; }
  .groupe { opacity: 0; transition: opacity 0.4s 0.4s; }
  .groupe.vu { opacity: 1; }
  .groupe rect { fill: #fff; stroke: var(--dk-encre); stroke-width: 3; }
  .groupe.na rect { stroke: var(--dk-accent); }
  .gnom { font-size: 19px; font-weight: 600; fill: var(--dk-encre); }
  .groupe.na .gnom, .groupe.na .gn { fill: var(--dk-accent); }
  .gn { font-size: 22px; font-weight: 600; text-anchor: end; fill: var(--dk-accent); }
  .verif { margin: 0; align-self: flex-end; font-size: 1.1em; font-variant-numeric: tabular-nums; border: 3px solid var(--dk-accent); padding: 0.3em 0.7em; animation: fondu 0.4s both; }
  .verif b { color: var(--dk-accent); }
  .verif .ok { font-weight: 600; color: var(--dk-accent); }
  @keyframes pousse { from { transform: scaleX(0); } to { transform: scaleX(1); } }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .barre, .verif { animation: none; } .lien, .groupe { transition: none; } }
</style>
