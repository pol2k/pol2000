<script>
  /**
   * Étape 4, la règle des consignes (partie 3) : la variable dépendante doit
   * être ordinale, d'intervalle ou de ratio. Une VD nominale, dichotomique
   * ou autre, est refusée. Les trois niveaux et leurs formes reprennent
   * Niveaux.svelte (séance 1) : des boîtes éparses, des marches, une règle.
   * Trois temps :
   *
   *   0  les trois niveaux, avec un exemple de la CES chacun;
   *   1  le verdict pour Y : nominale refusée, les deux autres acceptées;
   *   2  « oui ou non » est nominal aussi; la règle vise Y seulement.
   *
   * Exemples : vote (le parti), les deux variables de la séance : scolarite
   * (cinq niveaux ordonnés, recodés de 0 à 1 : ordinale) et interet (un
   * curseur de 0 à 10 à écarts égaux, divisé par 10 : traité comme une
   * variable d'intervalle). Pas de chiffres.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel tm-vd" bind:this={hote}>
  <div class="tm-vd-cartes">
    <div class="tm-vd-niv tm-vd-non" class:tm-juge={e >= 1}>
      <svg viewBox="0 0 300 130" aria-hidden="true">
        <rect x="16" y="18" width="78" height="36" class="tm-vd-boite" /><text x="55" y="42" class="tm-vd-lib">PLC</text>
        <rect x="196" y="10" width="78" height="36" class="tm-vd-boite" /><text x="235" y="34" class="tm-vd-lib">PCC</text>
        <rect x="108" y="72" width="78" height="36" class="tm-vd-boite" /><text x="147" y="96" class="tm-vd-lib">NPD</text>
        <rect x="214" y="84" width="78" height="36" class="tm-vd-boite" /><text x="253" y="108" class="tm-vd-lib">BQ</text>
      </svg>
      <strong>Nominale</strong>
      <span>le parti du vote</span>
      <span class="tm-vd-oui" class:tm-on={e >= 2}>et aussi&#8239;: oui ou non</span>
      <span class="tm-vd-tampon">refusée</span>
    </div>
    <div class="tm-vd-niv tm-vd-ok" class:tm-juge={e >= 1}>
      <svg viewBox="0 0 300 130" aria-hidden="true">
        <path d="M 16 116 H 100 V 86 H 190 V 24 H 284" class="tm-vd-marche" />
      </svg>
      <strong>Ordinale</strong>
      <span>scolarite, en cinq niveaux</span>
      <span class="tm-vd-oui"></span>
      <span class="tm-vd-tampon">acceptée</span>
    </div>
    <div class="tm-vd-niv tm-vd-ok" class:tm-juge={e >= 1}>
      <svg viewBox="0 0 300 130" aria-hidden="true">
        <line x1="16" y1="80" x2="284" y2="80" class="tm-vd-regle" />
        {#each Array.from({ length: 11 }) as _, i}
          <line x1={16 + i * 26.8} y1={i % 5 === 0 ? 52 : 64} x2={16 + i * 26.8} y2="80" class="tm-vd-regle" />
        {/each}
      </svg>
      <strong>Intervalle · ratio</strong>
      <span>interet, le curseur de 0 à 10</span>
      <span class="tm-vd-oui"></span>
      <span class="tm-vd-tampon">acceptée</span>
    </div>
  </div>
  <p class="tm-vd-bas" class:tm-on={e >= 2}>La règle vise <b>Y</b>, la variable dépendante. Votre X peut être nominale.</p>
</div>

<style>
  .tm-vd { display: flex; flex-direction: column; gap: 1.1em; }
  .tm-vd-cartes { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.2em; }
  .tm-vd-niv { position: relative; display: flex; flex-direction: column; gap: 0.25em; border: 3px solid var(--dk-encre); padding: 0.9em 1em 1em; transition: opacity 0.4s, border-color 0.4s; animation: tm-vd-f 0.4s both; }
  .tm-vd-niv:nth-child(2) { animation-delay: 0.12s; }
  .tm-vd-niv:nth-child(3) { animation-delay: 0.24s; }
  .tm-vd-niv svg { width: 100%; height: auto; margin-bottom: 0.4em; }
  .tm-vd-niv strong { font-size: 1.35em; }
  .tm-vd-niv > span { font-size: 0.82em; color: var(--dk-gris); }
  .tm-vd-oui { min-height: 1.3em; font-weight: 600; opacity: 0; transition: opacity 0.4s; }
  .tm-vd-oui.tm-on { opacity: 1; color: var(--dk-accent) !important; }

  .tm-vd-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .tm-vd-lib { font-family: var(--dk-mono); font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tm-vd-marche { fill: none; stroke: var(--dk-encre); stroke-width: 5; }
  .tm-vd-regle { stroke: var(--dk-encre); stroke-width: 4; }

  .tm-vd-tampon { position: absolute; right: 0.8em; bottom: 0.9em; font-size: 0.9em !important; font-weight: 600; letter-spacing: 0.14em; text-transform: uppercase; padding: 0.15em 0.6em; border: 3px solid; opacity: 0; transform: scale(1.6) rotate(-8deg); transition: opacity 0.25s, transform 0.35s cubic-bezier(0.34, 1.6, 0.64, 1); }
  .tm-juge .tm-vd-tampon { opacity: 1; transform: rotate(-8deg); }
  .tm-vd-non .tm-vd-tampon { color: var(--dk-fond) !important; background: var(--dk-accent); border-color: var(--dk-accent); }
  .tm-vd-ok .tm-vd-tampon { color: var(--dk-encre) !important; background: var(--dk-fond); border-color: var(--dk-encre); }
  .tm-vd-non.tm-juge { border-color: var(--dk-accent); border-style: dashed; }
  .tm-vd-non.tm-juge svg, .tm-vd-non.tm-juge strong { opacity: 0.35; }
  .tm-vd-non.tm-juge strong { text-decoration: line-through; text-decoration-color: var(--dk-accent); text-decoration-thickness: 0.12em; }

  .tm-vd-bas { margin: 0; font-size: 1.05em; border-left: 0.34em solid var(--dk-accent); padding-left: 0.7em; opacity: 0; transition: opacity 0.4s; }
  .tm-vd-bas.tm-on { opacity: 1; }
  .tm-vd-bas b { color: var(--dk-accent); }
  @keyframes tm-vd-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .tm-vd-niv { animation: none; } .tm-vd-tampon, .tm-vd-oui, .tm-vd-bas { transition: none; } }
</style>
