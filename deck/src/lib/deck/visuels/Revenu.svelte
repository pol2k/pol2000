<script>
  /**
   * « Le revenu influence-t-il le vote ? » — en quatre temps.
   *
   *   0  huit tranches de revenu attendent sous un axe gauche-droite;
   *   1  l'hypothèse la plus répandue: plus on gagne, plus on va à droite;
   *   2  l'hypothèse inverse;
   *   3  on ne sait pas — tout le monde sur le point d'interrogation.
   *
   * Les positions des temps 1 et 2 sont des HYPOTHÈSES, dessinées comme
   * telles (pointillé). La réponse réelle vient trois diapos plus loin, avec
   * les données. Rien ici n'est une mesure.
   */
  import { brancherTemps } from '../temps.js';

  const LEG = [
    'Huit tranches de revenu. Combien votent conservateur, dans chacune ?',
    'Hypothèse : plus on gagne, plus on vote conservateur.',
    'Ou l’inverse : les plus riches, moins conservateurs ?',
    'On ne le sait pas. Comment le saurait-on ?'
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: LEG.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  const X0 = 90, X1 = 870;            // axe, de 0 à 10
  const x = (v) => X0 + (v / 10) * (X1 - X0);
  const TR = 8;                        // tranches
  // position sur l'axe selon le temps: parking (sous l'axe), montée, inverse, « ? »
  function pos(i) {
    if (e === 1) return { x: x(1.5 + (i / (TR - 1)) * 7), y: 118 };
    if (e === 2) return { x: x(8.5 - (i / (TR - 1)) * 7), y: 118 };
    if (e === 3) return { x: x(5) + (i - 3.5) * 24, y: 118 };
    return { x: 130 + i * 100, y: 345 };
  }
</script>

<div class="visuel revenu" bind:this={hote}>
  <svg viewBox="0 0 960 395" role="img" aria-label="Un axe de 0 à 100 % de vote conservateur; huit tranches de revenu qui se placent selon l'hypothèse choisie, puis toutes sur un point d'interrogation.">
    <!-- axe -->
    <line x1={X0} y1="150" x2={X1} y2="150" class="axe" />
    {#each Array.from({ length: 11 }) as _, i}
      <line x1={x(i)} y1="142" x2={x(i)} y2="158" class="axe" />
      <text x={x(i)} y="182" class="tick">{i * 10}</text>
    {/each}
    <text x={X0} y="212" class="pole">0 % VOTENT CONSERVATEUR</text>
    <text x={X1} y="212" class="pole fin">100 %</text>

    <!-- le « ? » au centre, temps 3 -->
    <text x={x(5)} y="330" class="q" class:vu={e === 3}>?</text>

    <!-- hypothèse: droite pointillée -->
    <line x1={x(1.5)} y1="126" x2={x(8.5)} y2="126" class="hyp" class:vu={e === 1 || e === 2} />

    <!-- huit tranches: une liasse qui grossit avec le revenu -->
    {#each Array.from({ length: TR }) as _, i}
      {@const p = pos(i)}
      <g class="tranche" style="transform: translate({p.x}px, {p.y}px)">
        {#each Array.from({ length: 1 + Math.floor(i / 2) }) as _, k}
          <rect x={-22} y={-14 - k * 9} width="44" height="12" class="billet" />
        {/each}
        <text y={-24 - Math.floor(i / 2) * 9} class="lib">{i + 1}</text>
      </g>
    {/each}

    <text x="480" y="385" class="legende">{LEG[e]}</text>
  </svg>
</div>

<style>
  .revenu { width: 100%; }
  svg { width: 100%; height: auto; max-height: 70vh; display: block; }
  .axe { stroke: var(--dk-encre); stroke-width: 3; }
  .tick { font-family: var(--dk-mono); font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .pole { font-family: var(--dk-mono); font-size: 19px; letter-spacing: 0.16em; font-weight: 600; fill: var(--dk-encre); }
  .pole.fin { text-anchor: end; }
  .tranche { transition: transform 0.9s cubic-bezier(0.65, 0, 0.25, 1); }
  .billet { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2.5; }
  .lib { font-family: var(--dk-mono); font-size: 15px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .hyp { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 10 8; opacity: 0; transition: opacity 0.5s; }
  .hyp.vu { opacity: 1; }
  .q { font-family: var(--dk-mono); font-size: 96px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); opacity: 0; transition: opacity 0.6s 0.4s; }
  .q.vu { opacity: 1; }
  .legende { font-family: var(--dk-mono); font-size: 24px; text-anchor: middle; fill: var(--dk-encre); }
</style>
