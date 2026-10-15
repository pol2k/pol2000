<script>
  /**
   * Fin de la section : lisez les consignes, et remettez un PDF. Deux
   * fichiers : le PDF, accepté; le .docx, qu'une croix rouge vient rayer
   * (les consignes : « un fichier .docx ne sera pas accepté »). Puis ce
   * qu'on vérifie avant de remettre, tiré des consignes, et la remise.
   * Trois temps :
   *
   *   0  PDF accepté, .docx rayé;
   *   1  la liste à cocher avant de remettre (consignes, Contenu et Format);
   *   2  la remise : monPortail, le jour et l'heure (cours.js).
   */
  import { brancherTemps } from '../temps.js';
  import { EVALUATIONS } from '$lib/data/cours.js';

  const ms = EVALUATIONS.find((v) => v.id === 'misession');
  const jour = new Date(ms.date + 'T12:00:00').toLocaleDateString('fr-CA', { weekday: 'long', day: 'numeric', month: 'long' });

  const LISTE = ['2 pages sans compter la couverture et la bibliographie', '4 références scientifiques, au moins', 'H₁ et H₀', 'Pas de variables nominales', 'APA, auteur-date', 'Déclaration d’IA, à la fin'];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel tm-lisez" bind:this={hote}>
  <div class="tm-lz-fichiers">
    <figure class="tm-lz-f tm-lz-pdf">
      <svg viewBox="0 0 120 150" aria-hidden="true">
        <path d="M 6 6 H 84 L 114 36 V 144 H 6 Z" class="tm-lz-papier" />
        <path d="M 84 6 V 36 H 114" class="tm-lz-coin" />
        <rect x="6" y="84" width="108" height="38" class="tm-lz-bande" />
        <text x="60" y="112" class="tm-lz-ext">PDF</text>
      </svg>
      <figcaption>✓ accepté</figcaption>
    </figure>
    <figure class="tm-lz-f tm-lz-docx">
      <svg viewBox="0 0 120 150" aria-hidden="true">
        <path d="M 6 6 H 84 L 114 36 V 144 H 6 Z" class="tm-lz-papier" />
        <path d="M 84 6 V 36 H 114" class="tm-lz-coin" />
        <rect x="6" y="84" width="108" height="38" class="tm-lz-bande" />
        <text x="60" y="112" class="tm-lz-ext">.docx</text>
        <g class="tm-lz-x">
          <line x1="-6" y1="-4" x2="126" y2="154" pathLength="1" />
          <line x1="126" y1="-4" x2="-6" y2="154" pathLength="1" />
        </g>
      </svg>
      <figcaption><span class="tm-lz-ext-c">.docx</span> refusé</figcaption>
    </figure>
  </div>

  <div class="tm-lz-droite">
    <ul class="tm-lz-liste">
      {#each LISTE as l, i}
        <li class:tm-on={e >= 1} style="--i: {i}"><span class="tm-lz-case">✓</span>{l}</li>
      {/each}
    </ul>
    <div class="tm-lz-remise" class:tm-on={e >= 2}>
      <span class="tm-lz-et">SUR MONPORTAIL</span>
      <strong>{jour}</strong>
      <span class="tm-lz-h">{ms.heure}</span>
    </div>
  </div>
</div>

<style>
  .tm-lisez { display: grid; grid-template-columns: 1fr 1.05fr; gap: 2.4em; align-items: center; }
  .tm-lz-fichiers { display: grid; grid-template-columns: 1fr 1fr; gap: 1.6em; align-items: end; }
  .tm-lz-f { margin: 0; display: flex; flex-direction: column; align-items: center; gap: 0.5em; animation: tm-lz-f 0.5s both; }
  .tm-lz-docx { animation-delay: 0.2s; }
  .tm-lz-f svg { width: 100%; max-height: 40vh; height: auto; display: block; overflow: visible; }
  .tm-lz-papier { fill: #fff; stroke: var(--dk-encre); stroke-width: 5; stroke-linejoin: miter; }
  .tm-lz-coin { fill: none; stroke: var(--dk-encre); stroke-width: 5; }
  .tm-lz-bande { fill: var(--dk-accent); }
  .tm-lz-docx .tm-lz-bande { fill: var(--dk-gris-2); }
  .tm-lz-ext { font-family: var(--dk-mono); font-size: 28px; font-weight: 600; text-anchor: middle; fill: var(--dk-fond); }
  .tm-lz-docx .tm-lz-ext { font-size: 24px; }
  .tm-lz-docx .tm-lz-papier, .tm-lz-docx .tm-lz-coin { stroke: var(--dk-gris-2); }
  .tm-lz-x line { stroke: var(--dk-accent); stroke-width: 10; stroke-linecap: square; stroke-dasharray: 1; stroke-dashoffset: 1; animation: tm-lz-trace 0.35s ease-out forwards; }
  .tm-lz-x line:first-child { animation-delay: 0.9s; }
  .tm-lz-x line + line { animation-delay: 1.2s; }
  figcaption { font-size: 1.05em; font-weight: 600; }
  .tm-lz-pdf figcaption { color: var(--dk-accent); }
  .tm-lz-docx figcaption { color: var(--dk-accent); }
  .tm-lz-ext-c { color: var(--dk-gris); }

  .tm-lz-droite { display: flex; flex-direction: column; gap: 1em; }
  .tm-lz-liste { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 0.35em; }
  .tm-lz-liste li { margin: 0; display: flex; align-items: baseline; gap: 0.7em; font-size: 1.05em; line-height: 1.3; border-bottom: 2px solid var(--dk-filet); padding-bottom: 0.3em; opacity: 0.12; transition: opacity 0.35s; transition-delay: calc(var(--i) * 110ms); }
  .tm-lz-liste li.tm-on { opacity: 1; }
  .tm-lz-case { font-weight: 600; color: var(--dk-accent); }
  .tm-lz-remise { display: flex; align-items: baseline; flex-wrap: wrap; gap: 0.3em 0.9em; border: 4px solid var(--dk-accent); padding: 0.55em 0.9em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .tm-lz-remise.tm-on { opacity: 1; transform: none; }
  .tm-lz-et { flex-basis: 100%; font-size: 0.62em; font-weight: 600; letter-spacing: 0.16em; color: var(--dk-gris); }
  .tm-lz-remise strong { font-size: 1.25em; }
  .tm-lz-h { font-size: 1.25em; font-weight: 600; color: var(--dk-accent); }

  @keyframes tm-lz-f { from { opacity: 0; transform: translateY(0.6em); } to { opacity: 1; transform: none; } }
  @keyframes tm-lz-trace { to { stroke-dashoffset: 0; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-lz-f { animation: none; }
    .tm-lz-x line { animation: none; stroke-dashoffset: 0; }
    .tm-lz-liste li, .tm-lz-remise { transition: none; }
  }
</style>
