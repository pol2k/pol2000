<script>
  /**
   * Ce qu'on observe, ce qu'on n'observe pas. L'âge se lit sur une carte
   * d'identité : une question, un nombre. L'idéologie politique ne se lit
   * nulle part. Au clic :
   *
   *   0  les deux concepts, côte à côte;
   *   1  l'âge rend son nombre;
   *   2  l'idéologie ne rend qu'un point d'interrogation;
   *   3  la phrase : mettre un nombre sur ce qu'on ne peut pas observer.
   *
   * Un schéma : l'âge affiché est un exemple.
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

<div class="visuel m9v" bind:this={hote}>
  <div class="m9v-deux">
    <div class="m9v-col">
      <span class="m9v-tag">facile à mesurer</span>
      <svg viewBox="0 0 240 150" aria-hidden="true">
        <!-- une carte d'identité -->
        <rect x="30" y="20" width="180" height="110" rx="10" class="m9v-trait" />
        <rect x="46" y="40" width="54" height="66" class="m9v-trait" />
        <circle cx="73" cy="64" r="12" class="m9v-plein" />
        <path d="M 52 106 Q 73 78 94 106" class="m9v-plein" />
        <line x1="116" y1="50" x2="192" y2="50" class="m9v-ligne" />
        <line x1="116" y1="70" x2="176" y2="70" class="m9v-ligne" />
        <line x1="116" y1="90" x2="186" y2="90" class="m9v-ligne" />
      </svg>
      <strong class="m9v-nom">L’âge</strong>
      <span class="m9v-q">« Quel âge avez-vous ? »</span>
      <span class="m9v-nb" class:vu={e >= 1}>34 ans</span>
    </div>
    <div class="m9v-col m9v-invisible">
      <span class="m9v-tag rouge">impossible à observer</span>
      <svg viewBox="0 0 240 150" aria-hidden="true">
        <!-- une tête, et dedans, rien qu'on puisse lire -->
        <path d="M 80 132 L 80 112 Q 52 100 56 66 Q 62 22 116 20 Q 172 20 180 66 L 190 88 L 178 92 L 178 112 Q 160 118 146 112 L 146 132" class="m9v-trait" />
        <circle cx="118" cy="64" r="26" class="m9v-pointille" />
        <text x="118" y="74">?</text>
      </svg>
      <strong class="m9v-nom">L’idéologie politique</strong>
      <span class="m9v-q">Aucune carte. Aucune règle.</span>
      <span class="m9v-nb rouge" class:vu={e >= 2}>?</span>
    </div>
  </div>
  <p class="m9v-phrase" class:vu={e >= 3}>Le défi : mettre un <strong>nombre</strong> sur une chose qu’on ne peut pas <strong>observer</strong>.</p>
</div>

<style>
  .m9v { display: flex; flex-direction: column; gap: 1.4em; max-width: 52em; margin: 0.6em auto 0; }
  .m9v-deux { display: grid; grid-template-columns: 1fr 1fr; gap: 2.4em; }
  .m9v-col { border: 3px solid var(--dk-encre); padding: 1.1em 1.2em 1.3em; display: flex; flex-direction: column; align-items: center; gap: 0.35em; text-align: center; }
  .m9v-invisible { border-color: var(--dk-accent); border-style: dashed; }
  .m9v-tag { font-size: 0.7em; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; color: var(--dk-gris); }
  .m9v-tag.rouge, .m9v-nb.rouge { color: var(--dk-accent); }
  svg { width: 100%; max-height: 24vh; height: auto; display: block; }
  .m9v-trait { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .m9v-plein { fill: var(--dk-encre); }
  .m9v-ligne { stroke: var(--dk-gris); stroke-width: 6; stroke-linecap: round; }
  .m9v-pointille { fill: none; stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 7 6; }
  svg text { font-family: var(--dk-mono); font-size: 34px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .m9v-nom { font-size: 1.4em; }
  .m9v-q { font-size: 0.9em; color: var(--dk-gris); }
  .m9v-nb { font-size: 2.4em; font-weight: 700; line-height: 1.1; opacity: 0; transform: translateY(0.3em); transition: opacity 0.4s, transform 0.4s; }
  .m9v-nb.vu { opacity: 1; transform: none; }
  .m9v-phrase { margin: 0; text-align: center; font-size: 1.4em; line-height: 1.3; opacity: 0; transition: opacity 0.5s; }
  .m9v-phrase strong { color: var(--dk-accent); }
  .m9v-phrase.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) { .m9v-nb, .m9v-phrase { transition: none; } }
</style>
