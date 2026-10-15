<script>
  /**
   * 95 %, 99 %, 99,9 % : le même graphique des coefficients (le modèle à
   * plusieurs variables de notre sondage, 877 cas complets), avec des
   * moustaches de plus en plus sûres, donc de plus en plus longues. Une
   * seule couleur : l'épaisseur dit le niveau (95 % la plus épaisse, 99 %
   * moyenne, 99,9 % la plus fine). Trois traits simples qui partent du
   * point, sans embouts. Une moustache qui touche 0 passe au rouge. À
   * droite, trois colonnes : une étoile quand la moustache de ce niveau
   * évite 0. L'en-tête de chaque colonne montre l'épaisseur de son niveau
   * (c'est la légende).
   *
   *   0  95 % seulement (19 fois sur 20). Colonne 95 % : une étoile pour
   *      tout sauf Québec.
   *   1  99 % pousse (99 fois sur 100). Revenu évite encore 0 de justesse.
   *   2  99,9 % pousse (999 fois sur 1 000). Revenu touche 0 : pas de
   *      troisième étoile. Québec touche 0 partout.
   *   3  La morale : les étoiles du tableau, ce sont les moustaches. La
   *      rangée Revenu (** dans le tableau) est encadrée.
   *
   * Les bornes viennent de NIVEAUX (src/lib/data/seance7_h.js, généré par
   * outils/seance7_h.R : confint(m2, level = 0.95, 0.99, 0.999)). Le script
   * vérifie que le nombre de moustaches qui évitent 0 est égal au nombre
   * d'étoiles de R, pour chaque variable.
   */
  import { brancherTemps } from '../temps.js';
  import { NIVEAUX } from '$lib/data/seance7_h.js';
  import { VARS } from '$lib/data/seance7.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 1) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');

  const NOMS = {
    scolarite: [VARS.x.court, ''],
    age: ['Âge', ''],
    femme: ['Femme', ''],
    revenu: ['Revenu', ''],
    quebec: ['Québec', '']
  };
  const RANGS = NIVEAUX.coefs.map((c) => ({
    ...c,
    nom: NOMS[c.terme],
    // évite[k] : la moustache du niveau k ne touche pas 0.
    evite: c.bas.map((b, k) => b > 0 || c.haut[k] < 0)
  }));
  const COLONNES = ['95 %', '99 %', '99,9 %'];
  const PHRASES = [
    '95 % : la méthode attrape la vraie valeur 19 fois sur 20',
    '99 % : la méthode attrape la vraie valeur 99 fois sur 100',
    '99,9 % : la méthode attrape la vraie valeur 999 fois sur 1 000'
  ];

  const V0 = -0.2, V1 = 0.5, XL = 290, XR = 770;
  const x = (v) => XL + ((v - V0) / (V1 - V0)) * (XR - XL);
  const ticks = [-0.2, 0, 0.2, 0.4];
  const Y1 = 128, PAS = 60, AXE = Y1 + 4 * PAS + 44;
  const y = (i) => Y1 + i * PAS;
  const XC = [830, 895, 965]; // centres des trois colonnes d'étoiles
  const EP = [12, 6, 2.5]; // épaisseur des moustaches 95, 99, 99,9
  const REVENU = RANGS.findIndex((r) => r.terme === 'revenu');
</script>

<div class="visuel coef-niv" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Le modèle à plusieurs variables, avec des intervalles de confiance à 95, 99 et 99,9&#8239;%. Plus on veut être sûr, plus la moustache est longue. {RANGS.map((r) => `${r.nom[0]} : ${r.evite.filter(Boolean).length} moustache(s) sur 3 évitent 0.`).join(' ')} Les étoiles du tableau, ce sont les moustaches.">

    <!-- Ce que veut dire le niveau affiché. -->
    <text x="20" y="34" class="cn-niveau">{PHRASES[Math.min(e, 2)]}</text>

    <!-- Les en-têtes des trois colonnes d'étoiles, avec l'épaisseur du niveau : la légende. -->
    {#each COLONNES as c, k}
      <g class="cn-etape" class:cn-vu={e >= k}>
        <line x1={XC[k] - 24} y1="64" x2={XC[k] + 24} y2="64" style="stroke-width: {EP[k]}px" class="cn-legende" />
        <text x={XC[k]} y="96" class="cn-tete">{c}</text>
      </g>
    {/each}

    <!-- 3 : la rangée Revenu, encadrée. -->
    <rect x="12" y={y(REVENU) - 27} width="980" height="54" class="cn-cadre cn-etape" class:cn-vu={e >= 3} />

    <!-- La ligne à 0, puis l'axe. -->
    <line x1={x(0)} y1="104" x2={x(0)} y2={AXE} class="cn-zero" />
    <line x1={XL} y1={AXE} x2={XR} y2={AXE} class="cn-axe" />
    {#each ticks as t}
      <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 9} class="cn-axe" />
      <text x={x(t)} y={AXE + 32} class="cn-tick">{t === 0 ? '0' : f(t, 1)}</text>
    {/each}
    <text x={(XL + XR) / 2} y={AXE + 64} class="cn-titre-axe">effet sur l’intérêt (de 0 à 1)</text>

    {#each RANGS as r, i}
      <text x="266" y={y(i) + 8} class="cn-lab" class:cn-lab-r={e >= 3 && i === REVENU}>{r.nom[0]}</text>
      <!-- Les moustaches, de la plus sûre (derrière) à 95 % (devant). Chacune pousse depuis le point. -->
      {#each [2, 1, 0] as k}
        <g class="cn-moust" class:cn-pousse={e >= k} class:cn-rouge={!r.evite[k]}>
          <line x1={x(r.b)} y1={y(i)} x2={x(r.bas[k])} y2={y(i)} pathLength="1" style="stroke-width: {EP[k]}px" class="cn-trait" />
          <line x1={x(r.b)} y1={y(i)} x2={x(r.haut[k])} y2={y(i)} pathLength="1" style="stroke-width: {EP[k]}px" class="cn-trait" />
        </g>
      {/each}
      <circle cx={x(r.b)} cy={y(i)} r="11" class="cn-point" />

      <!-- Une étoile par moustache qui évite 0. -->
      {#each [0, 1, 2] as k}
        {#if r.evite[k]}
          <text x={XC[k]} y={y(i) + 12} class="cn-etoile cn-etape" class:cn-vu={e >= k}>*</text>
        {/if}
      {/each}
    {/each}
  </svg>
  <p class="cn-phrase" class:cn-cache={e === 0} class:cn-morale={e >= 3}>
    {#if e >= 3}Les étoiles du tableau, ce sont les moustaches.{:else}Plus on veut être sûr, plus la moustache est longue.{/if}
  </p>
</div>

<style>
  .coef-niv { display: flex; flex-direction: column; align-items: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .cn-niveau { font-size: 21px; font-weight: 600; fill: var(--dk-accent); }
  .cn-tete { font-size: 19px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); }
  .cn-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 2; }
  .cn-zero { stroke: var(--dk-encre); stroke-width: 2; stroke-dasharray: 7 6; }
  .cn-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .cn-tick { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .cn-titre-axe { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .cn-lab { font-size: 22px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); transition: fill 0.4s; }
  .cn-lab.cn-lab-r { fill: var(--dk-accent); }
  .cn-trait { stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.7s ease-out; }
  .cn-pousse .cn-trait { stroke-dashoffset: 0; }
  .cn-trait { stroke: var(--dk-encre); stroke-linecap: butt; }
  .cn-rouge .cn-trait { stroke: var(--dk-accent); }
  .cn-legende { stroke: var(--dk-encre); }
  .cn-point { fill: var(--dk-encre); }
  .cn-etoile { font-size: 34px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .cn-phrase { margin: 0.3em 0 0; font-size: 1em; font-weight: 600; color: var(--dk-encre); text-align: center; transition: color 0.4s; }
  .cn-phrase.cn-cache { visibility: hidden; }
  .cn-phrase.cn-morale { color: var(--dk-accent); }
  .cn-etape { opacity: 0; transition: opacity 0.3s; }
  .cn-etape.cn-vu { opacity: 1; transition: opacity 0.5s 0.4s; }
  @media (prefers-reduced-motion: reduce) {
    .cn-trait, .cn-etape, .cn-etape.cn-vu, .cn-lab, .cn-phrase { transition: none; }
  }
</style>
