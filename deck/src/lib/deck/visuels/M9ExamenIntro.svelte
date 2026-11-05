<script>
  /**
   * L'avant-scène de l'examen d'histoire : la feuille d'examen et la classe.
   * Les douze élèves de la diapo suivante (mêmes prénoms, mêmes moyennes),
   * placés sur une courbe en cloche selon leur moyenne en histoire. Au clic :
   *
   *   0  la feuille d'examen : quatre questions;
   *   1  la courbe se dessine, les élèves s'y posent un à un, du plus faible
   *      au plus fort;
   *   2  les deux bouts de la classe : les plus faibles, les plus forts.
   *
   * La courbe est un schéma (moyenne 72, écart-type 13). Données fictives.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const QUESTIONS = ['La fondation de Québec', 'La Conquête', 'La Révolution tranquille', 'Les Coupes Stanley du Canadien'];
  const ELEVES = [
    { nom: 'Samuel', moy: 51 }, { nom: 'Jade', moy: 55 }, { nom: 'Noah', moy: 58 }, { nom: 'Amira', moy: 62 },
    { nom: 'Thomas', moy: 65 }, { nom: 'Rosalie', moy: 69 }, { nom: 'William', moy: 72 }, { nom: 'Maya', moy: 76 },
    { nom: 'Olivier', moy: 80 }, { nom: 'Florence', moy: 84 }, { nom: 'Léa', moy: 89 }, { nom: 'Félix', moy: 93 }
  ];
  const W = 720, H = 360, X0 = 40, X1 = 690, BASE = 262, HAUT = 190;
  const MIN = 40, MAX = 100, MU = 72, SD = 13;
  const x = (m) => X0 + ((m - MIN) / (MAX - MIN)) * (X1 - X0);
  const g = (m) => Math.exp(-0.5 * ((m - MU) / SD) ** 2);
  const y = (m) => BASE - g(m) * HAUT;
  const COURBE = Array.from({ length: 121 }, (_, k) => MIN + k * 0.5).map((m, k) => `${k ? 'L' : 'M'} ${x(m).toFixed(1)} ${y(m).toFixed(1)}`).join(' ');
  const AIRE = `${COURBE} L ${x(MAX)} ${BASE} L ${x(MIN)} ${BASE} Z`;
  const TICKS = [40, 50, 60, 70, 80, 90, 100];
  const NOTES = [
    'Un examen d’histoire de quatre questions.',
    'La classe, rangée selon sa moyenne en histoire.',
    'Si l’examen mesure l’histoire, les forts devraient réussir, et les faibles rater.'
  ];
</script>

<div class="visuel m9ei" bind:this={hote}>
  <div class="m9ei-feuille">
    <span class="m9ei-ent">Examen · Histoire du Québec et du Canada</span>
    <span class="m9ei-ss">Secondaire 4 · Nom : ______________</span>
    <ol>
      {#each QUESTIONS as q, i}
        <li style="--i: {i}"><b>Q{i + 1}</b><span>{q}</span><i class="m9ei-ligne"></i></li>
      {/each}
    </ol>
  </div>

  <svg viewBox="0 0 {W} {H}" class="m9ei-svg" role="img" aria-label="Douze élèves placés sur une courbe en cloche selon leur moyenne en histoire, de Samuel (51) à Félix (93).">
    <rect x={X0} y={BASE - HAUT - 10} width={x(60) - X0} height={HAUT + 10} class="m9ei-zone" class:vu={e >= 2} />
    <rect x={x(84)} y={BASE - HAUT - 10} width={X1 - x(84)} height={HAUT + 10} class="m9ei-zone fort" class:vu={e >= 2} />
    <text x={(X0 + x(60)) / 2} y={BASE - HAUT + 8} class="m9ei-bout" class:vu={e >= 2}>les plus faibles</text>
    <text x={(x(84) + X1) / 2} y={BASE - HAUT + 8} class="m9ei-bout fort" class:vu={e >= 2}>les plus forts</text>

    <path d={AIRE} class="m9ei-aire" class:vu={e >= 1} />
    <path d={COURBE} class="m9ei-courbe" class:vu={e >= 1} pathLength="1" />
    <line x1={X0} y1={BASE} x2={X1} y2={BASE} class="m9ei-axe" />
    {#each TICKS as t}
      <line x1={x(t)} y1={BASE} x2={x(t)} y2={BASE + 8} class="m9ei-axe" />
      <text x={x(t)} y={BASE + 26} class="m9ei-t">{t}</text>
    {/each}
    <text x={X1} y={BASE + 50} class="m9ei-titre-axe">moyenne en histoire →</text>

    {#each ELEVES as el, i}
      <g class="m9ei-el" class:vu={e >= 1} style="--i: {i}; --x: {x(el.moy)}px; --y: {y(el.moy)}px">
        <g transform="translate({x(el.moy)} {y(el.moy) - 4})">
          <circle cx="0" cy="-26" r="7" class="m9ei-corps" />
          <path d="M -9 -2 Q -9 -18 0 -18 Q 9 -18 9 -2 Z" class="m9ei-corps" />
        </g>
        <text x={x(el.moy)} y={i % 2 ? BASE + 84 : BASE + 68} class="m9ei-nom">{el.nom}</text>
        <line x1={x(el.moy)} y1={BASE + 4} x2={x(el.moy)} y2={i % 2 ? BASE + 72 : BASE + 56} class="m9ei-fil" />
      </g>
    {/each}
  </svg>

  {#key e}
    <p class="m9ei-note">{NOTES[e]}</p>
  {/key}
</div>

<style>
  .m9ei { display: grid; grid-template-columns: 0.85fr 1.6fr; gap: 0.6em 1.8em; align-items: center; max-width: 64em; margin: 0.4em auto 0; }
  .m9ei-feuille { background: #fff; border: 3px solid var(--dk-encre); padding: 1em 1.1em 1.2em; display: flex; flex-direction: column; gap: 0.3em; animation: m9ei-entre 0.5s both; }
  .m9ei-ent { font-weight: 800; font-size: 0.95em; line-height: 1.25; }
  .m9ei-ss { font-size: 0.7em; color: var(--dk-gris); border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.5em; margin-bottom: 0.4em; }
  .m9ei-feuille ol { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.7em; }
  .m9ei-feuille li { display: grid; grid-template-columns: 2.2em 1fr; grid-template-rows: auto auto; gap: 0.15em 0.3em; font-size: 0.85em; animation: m9ei-entre 0.4s both; animation-delay: calc(0.3s + var(--i) * 0.18s); }
  .m9ei-feuille li b { color: var(--dk-accent); }
  .m9ei-ligne { grid-column: 2; display: block; height: 0; border-bottom: 2px dashed var(--dk-filet); margin-top: 0.4em; }
  .m9ei-svg { width: 100%; height: auto; max-height: 50vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9ei-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .m9ei-t { font-size: 17px; text-anchor: middle; fill: var(--dk-gris); }
  .m9ei-titre-axe { font-size: 15px; text-anchor: end; fill: var(--dk-gris); font-weight: 600; letter-spacing: 0.04em; }
  .m9ei-courbe { fill: none; stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 1.2s ease-out; }
  .m9ei-courbe.vu { stroke-dashoffset: 0; }
  .m9ei-aire { fill: var(--dk-fond-2); opacity: 0; transition: opacity 0.6s 0.6s; }
  .m9ei-aire.vu { opacity: 1; }
  .m9ei-el { opacity: 0; transform: translateY(-40px); transition: opacity 0.35s, transform 0.5s cubic-bezier(.3,1.5,.6,1); transition-delay: 0s; }
  .m9ei-el.vu { opacity: 1; transform: none; transition-delay: calc(0.9s + var(--i) * 0.12s); }
  .m9ei-corps { fill: var(--dk-encre); }
  .m9ei-nom { font-size: 14px; font-weight: 700; text-anchor: middle; }
  .m9ei-fil { stroke: var(--dk-filet); stroke-width: 1.5; }
  .m9ei-zone { fill: var(--dk-accent); opacity: 0; transition: opacity 0.5s; }
  .m9ei-zone.vu { opacity: 0.08; }
  .m9ei-zone.fort.vu { opacity: 0.12; fill: var(--dk-encre); }
  .m9ei-bout { font-size: 17px; font-weight: 800; text-anchor: middle; fill: var(--dk-accent); opacity: 0; transition: opacity 0.5s; }
  .m9ei-bout.fort { fill: var(--dk-encre); }
  .m9ei-bout.vu { opacity: 1; }
  .m9ei-note { grid-column: 1 / -1; margin: 0; text-align: center; font-size: 1.15em; font-weight: 700; animation: m9ei-entre 0.4s both; }
  @keyframes m9ei-entre { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9ei-courbe, .m9ei-aire, .m9ei-el, .m9ei-zone, .m9ei-bout { transition: none; } .m9ei-feuille, .m9ei-feuille li, .m9ei-note { animation: none; } }
</style>
