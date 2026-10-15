<script>
  /**
   * Étape 3 du travail : une hypothèse dérivée de la littérature, et son
   * hypothèse nulle (les consignes exigent les deux). À gauche, la mauvaise
   * façon : H₁ sort d'un chapeau de magicien, et on la raye. À droite, la
   * bonne : la revue de littérature (la carte de l'étape 2, en petit, le
   * camp choisi en rouge), donc H₁, et en face H₀. Exemple fil rouge de la
   * séance : « Plus on est scolarisé, plus on s'intéresse à la politique ? »
   * (interet selon scolarite). La théorie se dit de vive voix, pas à l'écran
   * (demande de l'enseignant, 15 octobre). H₀ porte déjà son nom de
   * régression, β₁ = 0, qu'on retrouve plus loin aujourd'hui. Quatre temps :
   *
   *   0  le chapeau, H₁ en sort;
   *   1  on raye : « Une hypothèse ne sort pas d'un chapeau. »;
   *   2  la revue de littérature, donc H₁, avec sa droite qui monte
   *      (schéma, pas des données);
   *   3  H₀, la droite plate, et β₁ = 0.
   *
   * La phrase de l'enseignant était plus crue; l'idée est la même.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel tm-hyp" bind:this={hote}>
  <div class="tm-hyp-g">
    <svg viewBox="0 0 260 260" role="img" aria-label="Un chapeau de magicien d'où sort H₁, rayé d'une croix rouge.">
      <!-- H₁ qui sort du chapeau -->
      <g class="tm-hyp-sort">
        <rect x="92" y="34" width="76" height="56" class="tm-hyp-carte" />
        <text x="130" y="72" class="tm-hyp-h1">H₁</text>
      </g>
      <!-- le chapeau -->
      <rect x="70" y="104" width="120" height="110" class="tm-hyp-chap" />
      <rect x="40" y="96" width="180" height="16" class="tm-hyp-chap" />
      <rect x="70" y="180" width="120" height="14" class="tm-hyp-ruban" />
      <!-- la croix -->
      <g class="tm-hyp-x" class:tm-on={e >= 1}>
        <line x1="22" y1="22" x2="238" y2="238" pathLength="1" />
        <line x1="238" y1="22" x2="22" y2="238" pathLength="1" />
      </g>
    </svg>
    <p class="tm-hyp-punch" class:tm-on={e >= 1}>Une hypothèse ne sort pas d’un chapeau.</p>
  </div>

  <div class="tm-hyp-d">
    <div class="tm-hyp-lit" class:tm-on={e >= 2}>
      <!-- La carte de l'étape 2, en petit : le camp choisi est en rouge. -->
      <svg viewBox="0 0 200 120" aria-hidden="true">
        <polygon points="10,10 80,6 92,44 70,70 14,62" class="tm-hyp-t tm-choisi" />
        <polygon points="92,44 80,6 160,10 192,30 176,66 124,62" class="tm-hyp-t" />
        <polygon points="14,62 70,70 124,62 176,66 150,114 30,110" class="tm-hyp-t tm-hach" />
        <polygon points="70,70 92,44 124,62" class="tm-hyp-q" />
      </svg>
      <span class="tm-hyp-et">VOTRE REVUE DE LITTÉRATURE · le camp choisi</span>
    </div>
    <div class="tm-hyp-donc" class:tm-on={e >= 2}>donc</div>
    <div class="tm-hyp-hh">
      <div class="tm-hyp-b tm-hyp-h1b" class:tm-on={e >= 2} style="--d: 0.3s">
        <span class="tm-hyp-et tm-rouge">H₁ · L’HYPOTHÈSE</span>
        <p>Plus on est scolarisé, plus on s’intéresse à la politique.</p>
        <svg viewBox="0 0 160 70" class="tm-hyp-mini" aria-hidden="true">
          <line x1="10" y1="62" x2="150" y2="62" class="tm-hyp-axe" /><line x1="10" y1="62" x2="10" y2="6" class="tm-hyp-axe" />
          <line x1="16" y1="52" x2="146" y2="14" class="tm-hyp-droite" />
        </svg>
      </div>
      <div class="tm-hyp-b tm-hyp-h0b" class:tm-on={e >= 3}>
        <span class="tm-hyp-et">H₀ · L’HYPOTHÈSE NULLE</span>
        <p>La scolarité ne change rien à l’intérêt.</p>
        <svg viewBox="0 0 160 70" class="tm-hyp-mini" aria-hidden="true">
          <line x1="10" y1="62" x2="150" y2="62" class="tm-hyp-axe" /><line x1="10" y1="62" x2="10" y2="6" class="tm-hyp-axe" />
          <line x1="16" y1="33" x2="146" y2="33" class="tm-hyp-droite tm-plate" />
        </svg>
        <span class="tm-hyp-beta">dans la régression&#8239;: <b>β₁ = 0</b></span>
      </div>
    </div>
  </div>
</div>

<style>
  .tm-hyp { display: grid; grid-template-columns: 0.8fr 1.6fr; gap: 2.2em; align-items: center; }
  .tm-hyp-g { display: flex; flex-direction: column; align-items: center; gap: 0.6em; }
  .tm-hyp-g svg { width: 100%; max-height: 42vh; height: auto; display: block; overflow: visible; }
  .tm-hyp-chap { fill: var(--dk-encre); }
  .tm-hyp-ruban { fill: var(--dk-accent); }
  .tm-hyp-carte { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .tm-hyp-h1 { font-family: var(--dk-mono); font-size: 34px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tm-hyp-sort { animation: tm-hyp-sort 1.6s cubic-bezier(0.34, 1.5, 0.64, 1) 0.3s both; }
  .tm-hyp-x line { stroke: var(--dk-accent); stroke-width: 14; stroke-linecap: square; stroke-dasharray: 1; stroke-dashoffset: 1; }
  .tm-hyp-x.tm-on line { animation: tm-hyp-trace 0.35s ease-out forwards; }
  .tm-hyp-x.tm-on line + line { animation-delay: 0.3s; }
  .tm-hyp-punch { margin: 0; font-size: 1.25em; font-weight: 600; line-height: 1.3; text-align: center; color: var(--dk-accent); opacity: 0; transition: opacity 0.5s 0.6s; }

  .tm-hyp-d { display: flex; flex-direction: column; gap: 0.5em; }
  .tm-hyp-b { display: flex; flex-direction: column; gap: 0.2em; border-left: 5px solid var(--dk-encre); padding: 0.3em 0 0.3em 0.8em; opacity: 0; transform: translateX(0.6em); transition: opacity 0.45s, transform 0.45s; transition-delay: var(--d, 0s); }
  .tm-hyp-lit { display: flex; align-items: center; gap: 1em; opacity: 0; transform: translateX(0.6em); transition: opacity 0.45s, transform 0.45s; }
  .tm-hyp-lit svg { width: 9em; height: auto; flex: none; }
  .tm-hyp-t { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 3; }
  .tm-hyp-t.tm-choisi { fill: var(--dk-accent); }
  .tm-hyp-t.tm-hach { fill: var(--dk-gris-2); }
  .tm-hyp-q { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2; }
  .tm-hyp-b p { margin: 0; font-size: 1em; line-height: 1.35; }
  .tm-hyp-et { font-size: 0.6em; font-weight: 600; letter-spacing: 0.14em; color: var(--dk-gris); }
  .tm-hyp-et.tm-rouge { color: var(--dk-accent); }
  .tm-hyp-donc { align-self: flex-start; font-size: 0.85em; font-weight: 600; color: var(--dk-fond); background: var(--dk-accent); padding: 0.1em 0.6em; opacity: 0; transition: opacity 0.3s; }
  .tm-hyp-hh { display: grid; grid-template-columns: 1fr 1fr; gap: 1em; }
  .tm-hyp-h1b, .tm-hyp-h0b { border: 3px solid var(--dk-accent); padding: 0.5em 0.8em 0.6em; }
  .tm-hyp-h0b { border: 3px dashed var(--dk-gris); }
  .tm-hyp-mini { width: 42%; height: auto; display: block; margin-top: 0.3em; }
  .tm-hyp-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .tm-hyp-droite { stroke: var(--dk-accent); stroke-width: 5; }
  .tm-hyp-droite.tm-plate { stroke: var(--dk-gris); }
  .tm-hyp-beta { margin-top: 0.2em; font-size: 0.8em; color: var(--dk-gris); }
  .tm-hyp-beta b { font-size: 1.25em; color: var(--dk-encre); }

  .tm-on { opacity: 1 !important; transform: none !important; }
  @keyframes tm-hyp-sort { 0% { transform: translateY(80px); opacity: 0; } 30% { opacity: 1; } 100% { transform: none; opacity: 1; } }
  @keyframes tm-hyp-trace { to { stroke-dashoffset: 0; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-hyp-sort { animation: none; }
    .tm-hyp-x.tm-on line { animation: none; stroke-dashoffset: 0; }
    .tm-hyp-punch, .tm-hyp-b, .tm-hyp-donc, .tm-hyp-lit { transition: none; }
  }
</style>
