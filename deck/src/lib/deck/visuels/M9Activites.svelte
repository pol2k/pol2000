<script>
  /**
   * L'électricité de quelques usages du numérique, en Wh, sur une échelle
   * linéaire qui zoome (ACTIVITES, $lib/data/ia_environnement.js). Ce qui
   * dépasse le cadre est coupé, avec sa valeur. En rouge : l'IA, centre de
   * données seulement. En gris : la vidéo en ligne, écran et réseau compris.
   *
   *   0  de 0 à 1 000 Wh;
   *   1  de 0 à 20 Wh;
   *   2  de 0 à 1 Wh.
   */
  import { brancherTemps } from '../temps.js';
  import { ACTIVITES as A } from '$lib/data/ia_environnement.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const ECHELLES = [{ max: 1000, pas: 250 }, { max: 20, pas: 5 }, { max: 1, pas: 0.25 }];
  const E = $derived(ECHELLES[e]);
  const W = 1000, X0 = 380, LX = 470, PAS = 42, Y0 = 34;
  const x = (v) => X0 + (Math.min(v, E.max) / E.max) * LX;
  const f = (v) => (v < 1 ? v.toFixed(2) : v < 10 ? v.toFixed(1) : Math.round(v).toLocaleString('fr-CA').replace(/\s/g, ' ')).replace('.', ',');
  const traits = $derived(Array.from({ length: E.max / E.pas + 1 }, (_, k) => k * E.pas));
  const H = Y0 + A.length * PAS + 10;
</script>

<div class="visuel m9a" bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" role="img" aria-label="Électricité en wattheures : {A.map((a) => `${a.nom} ${f(a.wh)}`).join(', ')}.">
    {#each traits as t (t)}
      <line x1={x(t)} y1={Y0 - 8} x2={x(t)} y2={H - 6} class="m9a-trait" />
      <text x={x(t)} y={Y0 - 14} class="m9a-t">{f(t)}</text>
    {/each}
    <text x={X0 + LX + 46} y={Y0 - 14} class="m9a-t gauche">Wh</text>
    {#each A as a, i}
      {@const coupe = a.wh > E.max}
      <g class:ia={a.ia}>
        <text x={X0 - 18} y={Y0 + i * PAS + 22} class="m9a-nom">{a.nom}</text>
        <rect x={X0} y={Y0 + i * PAS + 6} width={Math.max(x(a.wh) - X0, 2)} height="24" class="m9a-barre" />
        {#if coupe}<path d="M {X0 + LX - 6} {Y0 + i * PAS + 2} l 12 0 l -6 32 l -12 0 Z" class="m9a-coupe" />{/if}
        <text x={x(a.wh) + 14} y={Y0 + i * PAS + 24} class="m9a-v">{coupe ? '→ ' : ''}{f(a.wh)}</text>
      </g>
    {/each}
  </svg>
  <p class="m9a-pied"><b class="rouge">IA</b> : centre de données seulement. <b>Vidéo</b> : surtout l’écran et le réseau (le centre de données ≈ 5 %).</p>
  <p class="credits">Google (2025, médiane), Epoch AI (2025, estimation), OpenAI (2025, méthode non publiée), Microsoft Research (2026, requête 15 fois plus longue, modélisé); image et vidéo générées : mesures de labo, MIT Technology Review (2025). Vidéo : AIE (2020), moyenne de 2019.</p>
</div>

<style>
  .m9a { display: flex; flex-direction: column; gap: 0.3em; max-width: 62em; margin: 0.2em auto 0; }
  svg { width: 100%; height: auto; max-height: 52vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9a-trait { stroke: var(--dk-filet); stroke-width: 2; }
  .m9a-t { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .m9a-t.gauche { text-anchor: start; }
  .m9a-nom { font-size: 18px; font-weight: 700; text-anchor: end; }
  .m9a-barre { fill: var(--dk-gris); transition: width 0.7s; }
  .ia .m9a-barre { fill: var(--dk-accent); }
  .ia .m9a-nom, .ia .m9a-v { fill: var(--dk-accent); }
  .m9a-coupe { fill: var(--dk-fond); }
  .m9a-v { font-size: 18px; font-weight: 700; }
  .m9a-pied { margin: 0; font-size: 0.85em; text-align: center; }
  .m9a-pied .rouge { color: var(--dk-accent); }
  @media (prefers-reduced-motion: reduce) { .m9a-barre { transition: none; } }
</style>
