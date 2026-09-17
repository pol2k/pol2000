<script>
  /**
   * Quel centre pour quelle variable ? Trois vraies variables de l'Étude
   * électorale canadienne 2025 (src/lib/data/seance3.js), une par colonne :
   * nominale (l'intention de vote), ordinale (la satisfaction envers la
   * démocratie), numérique (l'âge). Sous les dessins, une grille à cocher.
   * Quatre temps.
   *
   *   0  Les trois dessins, la grille vide.
   *   1  MODE : il existe pour les trois. Libéral, Plutôt, 60 à 65 ans.
   *   2  MÉDIANE : pas pour une nominale (aucun ordre) ; Plutôt, 50 ans.
   *   3  MOYENNE : seulement pour la numérique. 49,7 ans.
   *
   * Tout est calculé ici à partir des effectifs exportés par R : le mode est
   * la barre la plus haute, la médiane ordinale est la catégorie où le
   * cumul franchit la moitié (code 5, « ne sait pas », écarté).
   */
  import { brancherTemps } from '../temps.js';
  import { AGE, AGE_DENSITE, AGE_HIST, DEMSAT, VOTE } from '$lib/data/seance3.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const W = 300, H = 206, B = 150, T = 30;

  // Nominale : les cinq partis.
  const PARTIS = ['LIB', 'CON', 'NPD', 'BQ', 'VERT'];
  const NOMS = ['Libéral', 'Conservateur', 'NPD', 'Bloc', 'Vert'];
  const COULEURS = ['#d71920', '#1a4782', '#f37021', '#33b2cc', '#3d9b35'];
  const vote = VOTE.effectifs.slice(0, 5);
  const vMax = Math.max(...vote);
  const vMode = vote.indexOf(vMax);
  const vPas = (W - 40) / 5;

  // Ordinale : quatre degrés de satisfaction.
  const DEGRES = ['Très', 'Plutôt', 'Peu', 'Pas du tout'];
  const sat = DEMSAT.effectifs.slice(0, 4);
  const sMax = Math.max(...sat);
  const sMode = sat.indexOf(sMax);
  const sTotal = sat.reduce((a, b) => a + b, 0);
  let cumul = 0;
  const sMed = sat.findIndex((n) => (cumul += n) >= sTotal / 2);
  const sPas = (W - 40) / 4;
  // La bande cumulée, sous les blocs : chaque degré à sa largeur.
  const bande = sat.map((n, k) => {
    const avant = sat.slice(0, k).reduce((a, b) => a + b, 0);
    return { x: 20 + (avant / sTotal) * (W - 40), w: (n / sTotal) * (W - 40) };
  });

  // Numérique : la silhouette de l'âge.
  const AX0 = 15, AX1 = 100;
  const ax = (v) => 20 + ((v - AX0) / (AX1 - AX0)) * (W - 40);
  const dMax = Math.max(...AGE_DENSITE.y);
  const ay = (d) => B - (d / dMax) * (B - T - 14);
  const silhouette = `M ${ax(AGE_DENSITE.x[0])} ${B} ` + AGE_DENSITE.x.map((v, k) => `L ${ax(v).toFixed(1)} ${ay(AGE_DENSITE.y[k]).toFixed(1)}`).join(' ') + ` L ${ax(AGE_DENSITE.x[AGE_DENSITE.x.length - 1])} ${B} Z`;
  const hMode = AGE_HIST.effectifs.indexOf(Math.max(...AGE_HIST.effectifs));
  const modeAge = `${AGE_HIST.debut[hMode]} à ${AGE_HIST.fin[hMode]}`;
  const un = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 1 });

  const LIGNES = [
    { et: 'MODE', t: 1, cases: [NOMS[vMode], DEGRES[sMode], modeAge + ' ans'] },
    { et: 'MÉDIANE', t: 2, cases: [null, DEGRES[sMed], un(AGE.mediane) + ' ans'] },
    { et: 'MOYENNE', t: 3, cases: [null, null, un(AGE.moyenne) + ' ans'] }
  ];
</script>

<div class="visuel quel-centre" bind:this={hote}>
  <div class="coin"></div>

  <!-- NOMINALE -->
  <div class="col">
    <span class="type">Nominale</span>
    <span class="var">intention de vote</span>
    <svg viewBox="0 0 {W} {H}" role="img" aria-label="Intention de vote pour les cinq grands partis : le Parti libéral est le plus fréquent.">
      <line x1="16" y1={B} x2={W - 16} y2={B} class="axe" />
      {#each vote as n, k}
        <rect x={20 + k * vPas + 6} y={B - (n / vMax) * (B - T)} width={vPas - 12} height={(n / vMax) * (B - T)} fill={COULEURS[k]} class="barre" class:eteint={e >= 1 && k !== vMode} style="animation-delay: {k * 70}ms" />
        <text x={20 + (k + 0.5) * vPas} y={B + 22} class="tick">{PARTIS[k]}</text>
      {/each}
      <g class="marque" class:vu={e >= 1}>
        <rect x={20 + vMode * vPas + 2} y={T - 6} width={vPas - 4} height={B - T + 6} class="cadre" />
        <text x={20 + vMode * vPas + vPas + 6} y={T + 10} class="m-t">mode</text>
      </g>
    </svg>
  </div>

  <!-- ORDINALE -->
  <div class="col">
    <span class="type">Ordinale</span>
    <span class="var">satisfaction · démocratie</span>
    <svg viewBox="0 0 {W} {H}" role="img" aria-label="Satisfaction envers la démocratie, de très à pas du tout satisfait : « plutôt satisfait » est à la fois le mode et la médiane.">
      <line x1="16" y1={B - 24} x2={W - 16} y2={B - 24} class="axe" />
      {#each sat as n, k}
        <rect x={20 + k * sPas + 6} y={B - 24 - (n / sMax) * (B - T - 34)} width={sPas - 12} height={(n / sMax) * (B - T - 34)} class="bloc" class:eteint={e === 1 && k !== sMode} style="animation-delay: {k * 70}ms" />
        <!-- « Pas du tout » est long : calé à droite pour ne pas toucher « Peu ». -->
        <text x={k === 3 ? W - 2 : 20 + (k + 0.5) * sPas} y={B - 8} class="tick" style={k === 3 ? 'text-anchor: end' : undefined}>{DEGRES[k]}</text>
      {/each}
      <g class="marque" class:vu={e === 1}>
        <rect x={20 + sMode * sPas + 2} y={T - 6} width={sPas - 4} height={B - T - 24} class="cadre" />
      </g>
      <!-- La médiane : la file entière, et la personne du milieu. -->
      <g class="file" class:vu={e >= 2}>
        {#each bande as b, k}
          <rect x={b.x} y={B + 6} width={b.w} height="18" class="seg" class:milieu={k === sMed} />
        {/each}
        <line x1={W / 2} y1={B + 2} x2={W / 2} y2={B + 30} class="cinquante" />
        <text x={W / 2} y={B + 44} class="m-t c">50 %</text>
      </g>
    </svg>
  </div>

  <!-- NUMÉRIQUE -->
  <div class="col">
    <span class="type">Numérique</span>
    <span class="var">âge</span>
    <svg viewBox="0 0 {W} {H}" role="img" aria-label="Distribution de l'âge, de 18 à 96 ans : moyenne 49,7 ans, médiane 50 ans.">
      <path d={silhouette} class="silh" />
      <line x1="16" y1={B} x2={W - 16} y2={B} class="axe" />
      {#each [20, 40, 60, 80, 100] as v}
        <text x={ax(v)} y={B + 22} class="tick">{v}</text>
      {/each}
      <g class="marque" class:vu={e === 1}>
        <rect x={ax(AGE_HIST.debut[hMode])} y={T - 6} width={ax(AGE_HIST.fin[hMode]) - ax(AGE_HIST.debut[hMode])} height={B - T + 6} class="bandeau" />
      </g>
      <g class="ligne-m" class:vu={e >= 2}>
        <line x1={ax(AGE.mediane)} y1={B} x2={ax(AGE.mediane)} y2={T - 8} class="med" />
        <text x={ax(AGE.mediane) + 6} y={T} class="m-t">méd.</text>
      </g>
      <g class="ligne-m" class:vu={e >= 3}>
        <line x1={ax(AGE.moyenne)} y1={B} x2={ax(AGE.moyenne)} y2={T - 8} class="moy" />
        <!-- 49,7 et 50 se touchent : « moy. » monte d'une ligne au-dessus de « méd. ». -->
        <text x={ax(AGE.moyenne) - 6} y={T - 16} class="m-t fin">moy.</text>
      </g>
    </svg>
  </div>

  {#each LIGNES as l}
    <div class="et" class:vu={e >= l.t}>{l.et}</div>
    {#each l.cases as c}
      <div class="case" class:vu={e >= l.t} class:non={c === null}>
        {#if e >= l.t}
          {#if c === null}
            <span class="tiret">×</span>
          {:else}
            <span class="coche">✓</span><span class="rep">{c}</span>
          {/if}
        {/if}
      </div>
    {/each}
  {/each}

  <p class="source">Étude électorale canadienne 2025</p>
</div>

<style>
  .quel-centre { display: grid; grid-template-columns: 7.2em repeat(3, 1fr); gap: 0 1em; align-items: stretch; }
  .col { display: flex; flex-direction: column; gap: 0.05em; min-width: 0; padding-bottom: 0.4em; }
  .type { font-size: 1em; font-weight: 600; color: var(--dk-encre); }
  .var { font-size: 0.62em; letter-spacing: 0.08em; color: var(--dk-gris); text-transform: uppercase; }
  svg { width: 100%; height: auto; max-height: 30vh; display: block; margin-top: 0.3em; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 14px; text-anchor: middle; fill: var(--dk-gris); }

  .barre, .bloc { transform-origin: bottom; transform-box: fill-box; animation: monte 0.55s cubic-bezier(0.34, 1.5, 0.64, 1) both; transition: opacity 0.35s; }
  .bloc { fill: var(--dk-gris-2); }
  .eteint { opacity: 0.25; }
  @keyframes monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }

  .marque { opacity: 0; transition: opacity 0.35s; }
  .marque.vu { opacity: 1; }
  .cadre { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .bandeau { fill: var(--dk-accent); opacity: 0.3; }
  .m-t { font-size: 15px; font-weight: 600; fill: var(--dk-accent); }
  .m-t.c { text-anchor: middle; }
  .m-t.fin { text-anchor: end; }

  .file { opacity: 0; transform: translateY(8px); transition: opacity 0.4s, transform 0.4s cubic-bezier(0.34, 1.6, 0.64, 1); }
  .file.vu { opacity: 1; transform: none; }
  .seg { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2; }
  .seg.milieu { fill: var(--dk-accent); }
  .cinquante { stroke: var(--dk-encre); stroke-width: 3; }

  .silh { fill: var(--dk-gris-2); opacity: 0.8; animation: fondu 0.6s both; }
  .ligne-m { opacity: 0; transition: opacity 0.4s; }
  .ligne-m.vu { opacity: 1; }
  .ligne-m line { stroke-width: 3.5; stroke-dasharray: 8 6; }
  .med { stroke: var(--dk-accent); }
  .moy { stroke: var(--dk-encre); }
  .ligne-m .fin { fill: var(--dk-encre); }

  .et { display: flex; align-items: center; font-size: 0.72em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris-2); border-top: 2px solid var(--dk-filet); padding: 0.45em 0; transition: color 0.3s; }
  .et.vu { color: var(--dk-accent); }
  .case { display: flex; align-items: center; gap: 0.45em; border-top: 2px solid var(--dk-filet); padding: 0.45em 0; min-height: 2.2em; }
  .coche { font-size: 1.4em; font-weight: 600; line-height: 1; color: var(--dk-accent); display: inline-block; animation: tampon 0.45s cubic-bezier(0.34, 1.9, 0.64, 1) both; }
  .rep { font-size: 0.95em; font-weight: 600; animation: fondu 0.4s 0.2s both; }
  .tiret { font-size: 1.4em; line-height: 1; color: var(--dk-gris-2); animation: tampon 0.45s cubic-bezier(0.34, 1.9, 0.64, 1) both; }
  .case:nth-of-type(3n) .coche, .case:nth-of-type(3n) .tiret { animation-delay: 0.1s; }
  @keyframes tampon { from { opacity: 0; transform: scale(2.6) rotate(-15deg); } to { opacity: 1; transform: none; } }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }

  .source { grid-column: 1 / -1; margin: 0.4em 0 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }

  @media (prefers-reduced-motion: reduce) {
    .barre, .bloc, .silh, .coche, .rep, .tiret { animation: none; }
    .file, .marque, .ligne-m { transition: none; }
  }
</style>
