<script>
  /**
   * Opérationnaliser : les mêmes onze codes de scolarité (cpso3, Étude
   * électorale canadienne 1993) deviennent trois variables possibles, une
   * par clic. Les codes ne bougent pas; seuls les liens et les groupes
   * changent. Quatre temps :
   *
   *   0  les onze codes et leurs effectifs;
   *   1  ses_universitaire : deux valeurs, 0 et 1 (codes 8 à 11 → 1);
   *   2  ses_education : trois valeurs (1–5, 6–7, 8–11);
   *   3  ses_education_detail : onze valeurs, chaque réponse gardée;
   *   4  le mot : opérationnalisation.
   *
   * Effectifs et totaux : EDUC93 dans seance4_plus.js (outils/seance4_plus.R).
   * Les étiquettes françaises de gauche abrègent celles du codebook; à
   * droite, au temps 3, ce sont les valeurs que R donne (as_factor).
   * Les NA (2 537) sont traités à la diapo suivante.
   */
  import { brancherTemps } from '../temps.js';
  import { EDUC93 } from '$lib/data/seance4_plus.js';

  const NOMS = ['Aucune scolarité', 'Primaire commencé', 'Primaire terminé', 'Secondaire commencé', 'Secondaire terminé', 'Collégial commencé', 'Collégial terminé', 'Université commencée', 'Baccalauréat', 'Maîtrise', 'Professionnel, doctorat'];
  const fmt = (n) => n.toLocaleString('fr-CA');

  // Trois façons de coder. `teinte` : l'université reste rouge d'une façon
  // à l'autre; le détail est tout à l'encre, rien n'y est regroupé.
  const U = EDUC93.groupes.universitaire;
  const E = EDUC93.groupes.education;
  const FACONS = [
    {
      nom: 'ses_universitaire',
      groupes: [
        { val: '0', de: 1, a: 7, n: U['0'], teinte: 'encre' },
        { val: '1', de: 8, a: 11, n: U['1'], teinte: 'rouge' }
      ]
    },
    {
      nom: 'ses_education',
      groupes: [
        { val: 'secondaire_ou_moins', de: 1, a: 5, n: E.secondaire_ou_moins, teinte: 'encre' },
        { val: 'collegial', de: 6, a: 7, n: E.collegial, teinte: 'gris' },
        { val: 'universitaire', de: 8, a: 11, n: E.universitaire, teinte: 'rouge' }
      ]
    },
    {
      nom: 'ses_education_detail',
      groupes: EDUC93.codes.map((c, k) => ({ val: EDUC93.etiquettes[k], de: c, a: c, n: EDUC93.effectifs[k], teinte: 'encre' }))
    }
  ];

  const H = 38, Y0 = 72;
  const yCode = (k) => Y0 + k * H;
  const MAXN = Math.max(...EDUC93.effectifs);
  const XC = 330, XB = 344, LB = 150;
  const larg = (n) => Math.max(2, (n / MAXN) * LB);
  const XL = 550, XG = 640, WG = 400;
  const yGroupe = (g) => (yCode(g.de - 1) + yCode(g.a - 1)) / 2;
  const hGroupe = (g) => (g.a - g.de) * H + H - 8;
  const HAUT = Y0 + 10 * H + 26;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  // La façon affichée : 1, 2, 3 selon le temps; le temps 4 garde la dernière.
  const f = $derived(e === 0 ? -1 : Math.min(e, 3) - 1);
  const teinteDe = (c) => (f < 0 ? 'encre' : FACONS[f].groupes.find((g) => c >= g.de && c <= g.a).teinte);
</script>

<div class="visuel operationnaliser" bind:this={hote}>
  <svg viewBox="0 0 1060 {HAUT}" role="img" aria-label="Les onze codes de scolarité de l'Étude électorale canadienne 1993 (cpso3) codés de trois façons : ses_universitaire en deux valeurs (0 pour les codes 1 à 7, 1 pour les codes 8 à 11), ses_education en trois valeurs (secondaire_ou_moins, collegial, universitaire), ses_education_detail en onze valeurs, une par réponse.">
    <text x={XC} y="30" class="tete">cpso3 <tspan class="nb">· 11 codes</tspan></text>
    {#if f >= 0}
      {#key f}
        <text x={XG} y="30" class="tete var">{FACONS[f].nom}</text>
        <text x={XG + WG} y="30" class="nb fin">{FACONS[f].groupes.length} valeurs</text>
      {/key}
    {/if}

    {#each EDUC93.codes as c, k}
      {@const y = yCode(k)}
      <text x={XC - 34} y={y + 6} class="nom">{NOMS[k]}</text>
      <text x={XC} y={y + 7} class="code">{c}</text>
      <rect x={XB} y={y - 12} width={larg(EDUC93.effectifs[k])} height="24" class="barre {teinteDe(c)}" style="animation-delay: {k * 40}ms" />
      <text x={XB + larg(EDUC93.effectifs[k]) + 8} y={y + 6} class="n">{fmt(EDUC93.effectifs[k])}</text>
    {/each}

    {#each FACONS as F, i}
      <g class="facon" class:vu={f === i}>
        {#each EDUC93.codes as c, k}
          {@const y = yCode(k)}
          {@const g = F.groupes.find((g) => c >= g.de && c <= g.a)}
          <path d="M {XL} {y} C {XL + 45} {y}, {XG - 45} {yGroupe(g)}, {XG} {yGroupe(g)}" class="lien {g.teinte}" style="transition-delay: {f === i ? 150 + k * 35 : 0}ms" />
        {/each}
        {#each F.groupes as g}
          <g class="groupe {g.teinte}" class:serre={F.groupes.length > 3}>
            <rect x={XG} y={yGroupe(g) - hGroupe(g) / 2} width={WG} height={hGroupe(g)} />
            <text x={XG + 14} y={yGroupe(g) + 7} class="gval">{g.val}</text>
            <text x={XG + WG - 12} y={yGroupe(g) + 7} class="gn">{fmt(g.n)}</text>
          </g>
        {/each}
      </g>
    {/each}
  </svg>

  {#if e >= 4}
    <p class="mot">
      <b>opérationnalisation</b>
      <span>Choisir comment un concept devient une variable. Le choix vous revient, selon la littérature et votre question.</span>
    </p>
  {/if}
</div>

<style>
  .operationnaliser { display: flex; flex-direction: column; gap: 0.5em; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .tete { font-size: 22px; font-weight: 600; fill: var(--dk-encre); text-anchor: end; }
  .tete.var { text-anchor: start; fill: var(--dk-accent); animation: fondu 0.35s both; }
  .nb { font-size: 17px; font-weight: 400; fill: var(--dk-gris); }
  .nb.fin { text-anchor: end; animation: fondu 0.35s both; }
  .nom { font-size: 18px; text-anchor: end; fill: var(--dk-gris); }
  .code { font-size: 20px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); }
  .n { font-size: 17px; fill: var(--dk-gris); }
  .barre { animation: pousse 0.5s cubic-bezier(0.34, 1.4, 0.64, 1) both; transform-origin: left; transform-box: fill-box; transition: fill 0.4s; }
  .barre.encre { fill: var(--dk-encre); }
  .barre.gris { fill: var(--dk-gris-2); }
  .barre.rouge { fill: var(--dk-accent); }

  .lien { fill: none; stroke-width: 2.5; stroke-dasharray: 400; stroke-dashoffset: 400; transition: stroke-dashoffset 0.5s; }
  .lien.encre { stroke: var(--dk-encre); }
  .lien.gris { stroke: var(--dk-gris-2); }
  .lien.rouge { stroke: var(--dk-accent); }
  .facon.vu .lien { stroke-dashoffset: 0; }
  .facon .lien { transition-duration: 0.2s; }
  .facon.vu .lien { transition-duration: 0.5s; }

  .groupe { opacity: 0; transition: opacity 0.2s; }
  .facon.vu .groupe { opacity: 1; transition: opacity 0.4s 0.45s; }
  .groupe rect { fill: #fff; stroke-width: 3; }
  .groupe.encre rect { stroke: var(--dk-encre); }
  .groupe.gris rect { stroke: var(--dk-gris-2); }
  .groupe.rouge rect { stroke: var(--dk-accent); fill: var(--dk-accent); }
  .gval { font-size: 21px; font-weight: 600; fill: var(--dk-encre); }
  .gn { font-size: 21px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); font-variant-numeric: tabular-nums; }
  .groupe.rouge .gval, .groupe.rouge .gn { fill: #fff; }
  .groupe.serre .gval { font-size: 17px; font-weight: 400; }
  .groupe.serre .gn { font-size: 17px; }
  .groupe.serre rect { stroke-width: 2; }

  .mot { margin: 0; display: flex; align-items: baseline; gap: 0.9em; border-top: 2px solid var(--dk-encre); padding-top: 0.45em; animation: fondu 0.4s both; }
  .mot b { font-size: 1.45em; font-weight: 600; color: var(--dk-accent); letter-spacing: -0.02em; white-space: nowrap; }
  .mot span { font-size: 0.9em; line-height: 1.4; }
  @keyframes pousse { from { transform: scaleX(0); } to { transform: scaleX(1); } }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) { .barre, .mot, .tete.var, .nb.fin { animation: none; } .lien, .groupe { transition: none; } }
</style>
