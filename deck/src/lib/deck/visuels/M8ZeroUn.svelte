<script>
  /**
   * Un Y qui vaut 0 ou 1 : sa moyenne est une proportion, et le coefficient
   * d'une variable binaire est une différence de proportions. Le modèle
   * « catholique seul » (modele1) : la part qui vote libéral chez les
   * non-catholiques (la constante), puis chez les catholiques.
   *
   *   0  les deux barres, en pourcentage;
   *   1  l'écart entre les deux : le coefficient;
   *   2  × 100 : des points de pourcentage, comme l'« impact » de Blais.
   *
   * Tout vient de COEFS (src/lib/data/seance8.js, outils/seance8_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { COEFS } from '$lib/data/seance8.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 1) => v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const P = COEFS.parts;
  const B = COEFS.modele1.find((c) => c.terme === 'catho').b;
  const G = COEFS.n_groupes;
  const Y0 = 400, H = 330;
  const py = (v) => Y0 - v * H;
  const BARRES = [
    { x: 250, v: P.non, nom: 'non catholiques', n: G['0'] },
    { x: 520, v: P.catho, nom: 'catholiques', n: G['1'] }
  ];
</script>

<div class="visuel m8zu" bind:this={hote}>
  <svg viewBox="0 0 1000 470" role="img" aria-label="Ontario et Atlantique, CES 2025 : {f(P.non * 100)} % des non-catholiques et {f(P.catho * 100)} % des catholiques ont l'intention de voter libéral. L'écart, {f(B, 3)}, est le coefficient; fois 100, {f(B * 100)} point de pourcentage.">
    <line x1="170" y1={Y0} x2="760" y2={Y0} class="axe" />
    <line x1="170" y1={Y0} x2="170" y2={py(1)} class="axe" />
    {#each [0, 0.5, 1] as t}
      <text x="158" y={py(t) + 6} class="tick fin">{f(t * 100, 0)} %</text>
    {/each}
    <text x="170" y={py(1) - 14} class="titre-axe">vote libéral</text>
    {#each BARRES as b, i}
      <rect x={b.x} y={py(b.v)} width="170" height={Y0 - py(b.v)} class:rouge={i === 1} class="barre" />
      <text x={b.x + 85} y={py(b.v) - 14} class="val">{f(b.v * 100)} %</text>
      <text x={b.x + 85} y={Y0 + 30} class="nom">{b.nom}</text>
      <text x={b.x + 85} y={Y0 + 54} class="petit">{nb(b.n)} personnes</text>
    {/each}
    <g class="etape" class:vu={e >= 1}>
      <line x1="430" y1={py(P.non)} x2="760" y2={py(P.non)} class="tir" />
      <line x1="700" y1={py(P.catho)} x2="790" y2={py(P.catho)} class="tir" />
      <text x="800" y={py((P.non + P.catho) / 2) + 8} class="gros rouge">+{f(B, 3)}</text>
      <text x="800" y={py((P.non + P.catho) / 2) + 40} class="lab">le coefficient</text>
    </g>
  </svg>
  <p class="cent" class:vu={e >= 2}>{f(B, 3)} × 100 = <strong>{f(B * 100)} point de pourcentage</strong> de plus. Comme l’« impact » de Blais.</p>
</div>

<style>
  .m8zu { max-width: 60em; margin: 0 auto; display: flex; flex-direction: column; gap: 0.6em; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .tick { font-size: 18px; fill: var(--dk-gris); text-anchor: end; }
  .titre-axe { font-size: 18px; fill: var(--dk-gris); }
  .barre { fill: var(--dk-encre); }
  .barre.rouge { fill: var(--dk-accent); }
  .val { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .nom { font-size: 21px; text-anchor: middle; fill: var(--dk-encre); }
  .petit { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }
  .tir { stroke: var(--dk-gris); stroke-width: 2; stroke-dasharray: 6 5; }
  .gros { font-size: 34px; font-weight: 700; }
  .lab { font-size: 18px; fill: var(--dk-gris); }
  .rouge { fill: var(--dk-accent); }
  .etape { opacity: 0; transition: opacity 0.4s; }
  .etape.vu { opacity: 1; }
  .cent { margin: 0; padding: 0.6em 0.9em; background: var(--dk-encre); color: var(--dk-fond); font-size: 1.2em; opacity: 0; transition: opacity 0.4s; }
  .cent.vu { opacity: 1; }
  .cent strong { color: var(--dk-accent-clair); }
  @media (prefers-reduced-motion: reduce) { .etape, .cent { transition: none; } }
</style>
