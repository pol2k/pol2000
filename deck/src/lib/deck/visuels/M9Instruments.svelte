<script>
  /**
   * Mesurer, ça veut dire quoi ? Trois instruments que tout le monde
   * connaît : une règle, un pèse-personne, un thermomètre. Chacun prend une chose
   * (une longueur, un poids, une température) et rend un nombre. Au clic :
   *
   *   0  les trois instruments et la chose qu'ils mesurent;
   *   1  le nombre que chacun rend, en rouge;
   *   2  la phrase : mesurer, c'est mettre un nombre sur une chose, pour
   *      pouvoir calculer.
   *
   * Un schéma, sans donnée.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const I = [
    { chose: 'une longueur', nombre: '14 cm' },
    { chose: 'un poids', nombre: '68 kg' },
    { chose: 'une température', nombre: '21 °C' }
  ];
</script>

<div class="visuel m9in" bind:this={hote}>
  <div class="m9in-trois">
    {#each I as it, i}
      <div class="m9in-un" style="--i: {i}">
        <svg viewBox="0 0 240 150" role="img" aria-label="{it.chose} : {it.nombre}">
          {#if i === 0}
            <!-- la règle, et le crayon qu'on mesure -->
            <rect x="20" y="70" width="200" height="32" class="m9in-tr" />
            {#each Array.from({ length: 21 }, (_, k) => k) as k}
              <line x1={20 + k * 10} y1="70" x2={20 + k * 10} y2={k % 5 === 0 ? 90 : 80} class="m9in-tick" />
            {/each}
            {#each [0, 5, 10, 15, 20] as n}
              <text x={20 + n * 10} y="122" class="m9in-num">{n}</text>
            {/each}
            <rect x="20" y="36" width="140" height="16" class="m9in-objet" />
            <polygon points="160,36 176,44 160,52" class="m9in-objet" />
            <line x1="20" y1="28" x2="20" y2="60" class="m9in-mes" class:vu={e >= 1} />
            <line x1="160" y1="28" x2="160" y2="60" class="m9in-mes" class:vu={e >= 1} />
          {:else if i === 1}
            <!-- le pèse-personne, vu de haut : un cadran, deux pieds -->
            <rect x="62" y="6" width="116" height="138" rx="20" class="m9in-tr" />
            <rect x="86" y="16" width="68" height="38" rx="6" class="m9in-fen" />
            {#each [-50, -25, 0, 25, 50] as a}
              <line x1={120 + 22 * Math.sin((a * Math.PI) / 180)} y1={50 - 22 * Math.cos((a * Math.PI) / 180)} x2={120 + 28 * Math.sin((a * Math.PI) / 180)} y2={50 - 28 * Math.cos((a * Math.PI) / 180)} class="m9in-tick" />
            {/each}
            <line x1="120" y1="50" x2={120 + 24 * Math.sin((-50 * Math.PI) / 180)} y2={50 - 24 * Math.cos((-50 * Math.PI) / 180)} class="m9in-repos" class:cache={e >= 1} />
            <line x1="120" y1="50" x2={120 + 24 * Math.sin((22 * Math.PI) / 180)} y2={50 - 24 * Math.cos((22 * Math.PI) / 180)} class="m9in-aig" class:vu={e >= 1} />
            <ellipse cx="100" cy="102" rx="13" ry="25" class="m9in-objet" />
            <ellipse cx="140" cy="102" rx="13" ry="25" class="m9in-objet" />
          {:else}
            <!-- le thermomètre : un tube, une colonne, une boule -->
            <rect x="108" y="14" width="24" height="96" rx="12" class="m9in-tr" />
            {#each [0, 1, 2, 3, 4, 5, 6] as k}
              <line x1="134" y1={26 + k * 13} x2={k % 2 === 0 ? 150 : 144} y2={26 + k * 13} class="m9in-tick" />
            {/each}
            {#each [[0, 40], [2, 30], [4, 20], [6, 10]] as [k, n]}
              <text x="158" y={30 + k * 13} class="m9in-num m9in-gauche">{n}</text>
            {/each}
            <rect x="116" y="62" width="8" height="52" class="m9in-col" class:vu={e >= 1} />
            <circle cx="120" cy="122" r="16" class="m9in-boule" />
          {/if}
        </svg>
        <span class="m9in-chose">{it.chose}</span>
        <span class="m9in-nombre" class:vu={e >= 1}>{it.nombre}</span>
      </div>
    {/each}
  </div>
  <p class="m9in-phrase" class:vu={e >= 2}>Mesurer, c’est mettre un <strong>nombre</strong> sur une chose. Pour pouvoir <strong>calculer</strong>.</p>
</div>

<style>
  .m9in { display: flex; flex-direction: column; gap: 1.2em; max-width: 60em; margin: 0.8em auto 0; }
  .m9in-trois { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2em; }
  .m9in-un { display: flex; flex-direction: column; align-items: center; gap: 0.3em; animation: m9in-fondu 0.5s both; animation-delay: calc(var(--i) * 0.2s); }
  svg { width: 100%; height: auto; max-height: 32vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-gris); font-size: 13px; text-anchor: middle; }
  .m9in-gauche { text-anchor: start; }
  .m9in-tr { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3; }
  .m9in-tick { stroke: var(--dk-encre); stroke-width: 2; }
  .m9in-fen { fill: #fff; stroke: var(--dk-encre); stroke-width: 3; }
  .m9in-repos { stroke: var(--dk-gris); stroke-width: 3; stroke-linecap: round; transition: opacity 0.3s; }
  .m9in-repos.cache { opacity: 0; }
  .m9in-objet { fill: var(--dk-encre); }
  .m9in-boule { fill: var(--dk-accent); stroke: var(--dk-encre); stroke-width: 3; }
  .m9in-mes { stroke: var(--dk-accent); stroke-width: 4; opacity: 0; transition: opacity 0.4s; }
  .m9in-aig { stroke: var(--dk-accent); stroke-width: 4; stroke-linecap: round; transform-box: fill-box; transform-origin: 0 0; opacity: 0; transition: opacity 0.4s; }
  .m9in-col { fill: var(--dk-accent); transform-box: fill-box; transform-origin: bottom; transform: scaleY(0); transition: transform 0.6s; }
  .m9in-col.vu { transform: none; }
  .m9in-mes.vu, .m9in-aig.vu { opacity: 1; }
  .m9in-chose { font-size: 1.05em; font-weight: 600; }
  .m9in-nombre { font-size: 2em; font-weight: 700; line-height: 1; color: var(--dk-accent); opacity: 0; transform: translateY(0.3em); transition: opacity 0.4s, transform 0.4s; }
  .m9in-nombre.vu { opacity: 1; transform: none; }
  .m9in-phrase { margin: 0; text-align: center; font-size: 1.5em; line-height: 1.3; opacity: 0; transition: opacity 0.5s; }
  .m9in-phrase strong { color: var(--dk-accent); }
  .m9in-phrase.vu { opacity: 1; }
  @keyframes m9in-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m9in-un { animation: none; } .m9in-mes, .m9in-aig, .m9in-col, .m9in-nombre, .m9in-phrase { transition: none; } }
</style>
