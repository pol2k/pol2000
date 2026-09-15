<script>
  /**
   * Pis, le 68, 95, 99,7, ça sert à quoi ? La petite note au bas de chaque
   * sondage. Schéma, trois temps.
   *
   *   0  La note s'écrit : « Marge d'erreur : ±3 points, 19 fois sur 20 ».
   *      Dessous, la vraie valeur et une bande rouge de ±3 points.
   *   1  « 19 fois sur 20 » passe au rouge. Vingt sondages refaits tombent
   *      un à un : dix-neuf dans la bande, le dernier en dehors, qui grisonne.
   *   2  Un tampon « = 95 % » se pose sur la note.
   *
   * Aucun sondeur réel, aucune donnée : les vingt positions sont fixes et
   * servent seulement à montrer ce que « 19 fois sur 20 » veut dire.
   *
   * À dire en classe, parce que la couture est voulue : le 95 % de la
   * diapositive précédente décrit des valeurs autour d'une moyenne (une
   * cloche), celui-ci décrit des estimations qui retombent autour de la
   * vraie valeur quand on refait le sondage. Même chiffre, deux objets.
   * On les raccorde à la séance 5; ici, on montre seulement d'où sort le
   * « 19 fois sur 20 » imprimé au bas des sondages.
   */
  import { brancherTemps } from '../temps.js';
  import Pis from './Pis.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Écart de chaque sondage à la vraie valeur, en points. Le 20e est dehors.
  const ECARTS = [-0.4, 1.2, -1.8, 0.6, 2.3, -1.1, 0.1, -2.5, 1.7, -0.7, 0.9, -1.5, 2.6, -0.2, 1.4, -2.1, 0.4, -0.9, 1.9, 4.1];
  const MARGE = 3;
  const dedans = ECARTS.filter((d) => Math.abs(d) <= MARGE).length;
  if (dedans !== 19) throw new Error('PourquoiSondage : il faut 19 sondages sur 20 dans la marge.');

  const CX = 500, PT = 42;
  const x = (d) => CX + d * PT;
  const AXE = 330;
  const y = (i) => 196 + ((i * 7) % 5) * 24;
</script>

<Pis stat="68, 95, 99,7" reponse="« 19 fois sur 20 », c'est le 95 %. On y revient à la séance 5." vu={e >= 2} source="schéma · la note type au bas d'un sondage">
  {#snippet children()}
    <svg bind:this={hote} class="marge" viewBox="0 0 1000 380" role="img" aria-label="Schéma : la note « marge d'erreur de plus ou moins 3 points, 19 fois sur 20 ». Sur vingt sondages refaits, dix-neuf tombent à moins de 3 points de la vraie valeur et un tombe en dehors. 19 sur 20, c'est 95 %.">
      <!-- La note au bas du sondage, qui s'écrit. -->
      <g class="note">
        <rect x="170" y="20" width="660" height="72" class="carte" />
        <clipPath id="sondage-frappe">
          <rect x="190" y="30" height="52" class="frappe" />
        </clipPath>
        <text x="200" y="65" class="note-t" clip-path="url(#sondage-frappe)">Marge d'erreur&#8239;: ±3 points, <tspan class="vingt" class:rouge={e >= 1}>19 fois sur 20</tspan></text>
      </g>

      <!-- Le tampon. -->
      <g class="tampon" class:vu={e >= 2}>
        <rect x="790" y="4" width="170" height="64" />
        <text x="875" y="48">= 95 %</text>
      </g>

      <!-- La bande de ±3 points et la vraie valeur. -->
      <rect x={x(-MARGE)} y="170" width={x(MARGE) - x(-MARGE)} height={AXE - 170} class="bande" />
      <!-- Au-dessus de la bande : les sondages tombent dedans et passeraient par-dessus. -->
      <text x={x(-MARGE) + 8} y="162" class="bande-t">±3 points</text>
      <line x1={CX} y1="150" x2={CX} y2={AXE} class="vraie" />
      <text x={CX} y="140" class="vraie-t">la vraie valeur</text>

      <!-- Vingt sondages refaits. -->
      {#each ECARTS as d, i}
        {@const dehors = Math.abs(d) > MARGE}
        <circle cx={x(d)} cy={y(i)} r="10" class="sondage" class:tombe={e >= 1} class:dehors style="--d: {i * 60}ms" />
      {/each}
      <text x={x(ECARTS[19]) + 16} y={y(19) + 6} class="vingtieme" class:vu={e >= 1}>la 20e</text>

      <line x1="120" y1={AXE} x2="880" y2={AXE} class="axe" />
      {#each [-4, -3, -2, -1, 0, 1, 2, 3, 4] as t}
        <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 8} class="axe" />
      {/each}
      <text x={x(-MARGE)} y={AXE + 30} class="tick">−3</text>
      <text x={x(MARGE)} y={AXE + 30} class="tick">+3</text>
    </svg>
  {/snippet}
</Pis>

<style>
  .marge { width: 100%; height: 100%; max-height: 44vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .carte { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2.5; }
  .frappe { width: 0; animation: frappe 1.3s steps(42, end) 0.2s forwards; }
  .note-t { font-size: 22px; fill: var(--dk-encre); }
  .vingt { transition: fill 0.3s; }
  .vingt.rouge { fill: var(--dk-accent); font-weight: 600; }

  .tampon { opacity: 0; transform-box: fill-box; transform-origin: center; transform: rotate(-8deg) scale(2.2); transition: opacity 0.2s, transform 0.45s cubic-bezier(0.34, 1.6, 0.64, 1); }
  .tampon.vu { opacity: 1; transform: rotate(-8deg) scale(1); }
  .tampon rect { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 5; }
  .tampon text { font-size: 30px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .bande { fill: var(--dk-accent); fill-opacity: 0.12; animation: fondu 0.5s 0.4s both; }
  /* Halo couleur papier : les sondages qui tombent passent derrière l'étiquette. */
  .bande-t { font-size: 15px; font-weight: 600; fill: var(--dk-accent); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 7px; stroke-linejoin: round; }
  .vraie { stroke: var(--dk-encre); stroke-width: 4; }
  .vraie-t { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .sondage { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2.5; opacity: 0; transform: translateY(-80px); transition: opacity 0.2s, transform 0.5s cubic-bezier(0.34, 1.5, 0.64, 1), fill 0.4s; }
  .sondage.tombe { opacity: 1; transform: none; transition-delay: var(--d), var(--d), calc(var(--d) + 500ms); }
  .sondage.tombe.dehors { fill: var(--dk-gris-2); }
  .vingtieme { font-size: 15px; fill: var(--dk-gris); opacity: 0; transition: opacity 0.4s 1.7s; }
  .vingtieme.vu { opacity: 1; }

  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }

  @keyframes frappe { to { width: 640px; } }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }

  @media (prefers-reduced-motion: reduce) {
    .frappe { animation: none; width: 640px; }
    .bande { animation: none; }
    .tampon, .sondage, .vingtieme, .vingt { transition: none; }
  }
</style>
