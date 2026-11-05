<script>
  /**
   * Se placer soi-même de 0 à 10 : la question de la CES 2025. Mais un 3
   * veut-il dire la même chose pour tout le monde ? Les vrais chiffres
   * (GAUCHE, outils/seance9_data.R) : où les gens qui se placent à gauche
   * et ceux qui se placent à droite mettent le PLC et le PCC. Au clic :
   *
   *   0  la question et la règle de 0 à 10;
   *   1  la question qui dérange;
   *   2  les deux camps placent les deux partis;
   *   3  des guides relient le même parti d'un camp à l'autre.
   */
  import { brancherTemps } from '../temps.js';
  import { GAUCHE as G } from '$lib/data/seance9.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  const X0 = 210, U = 70;
  const x = (v) => X0 + v * U;
  const f = (v) => v.toFixed(1).replace('.', ',');
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const CAMPS = [
    { cle: 'gauche', t: 'À gauche', s: 'se place de 0 à 2', y: 62, haut: true },
    { cle: 'droite', t: 'À droite', s: 'se place de 8 à 10', y: 172, haut: false }
  ];
  const PARTIS = [{ cle: 'lib', t: 'PLC', cl: 'plc' }, { cle: 'con', t: 'PCC', cl: 'pcc' }];
</script>

<div class="visuel m9g" bind:this={hote}>
  <p class="m9g-q">« En politique, on parle parfois de gauche et de droite. Où vous placeriez-vous sur une échelle de 0 à 10 ? »</p>
  <svg viewBox="0 0 1000 70" class="m9g-regle" aria-hidden="true">
    <line x1={x(0)} y1="30" x2={x(10)} y2="30" class="m9g-axe" />
    {#each Array.from({ length: 11 }, (_, k) => k) as k}
      <line x1={x(k)} y1="22" x2={x(k)} y2="38" class="m9g-tick" />
      <text x={x(k)} y="62" class="m9g-n">{k}</text>
    {/each}
    <text x={x(0) - 22} y="36" class="m9g-bout fin">gauche</text>
    <text x={x(10) + 22} y="36" class="m9g-bout">droite</text>
  </svg>
  <p class="m9g-doute" class:vu={e >= 1}>Mais un 3, est-ce le même 3 pour tout le monde ?</p>
  <svg viewBox="0 0 1000 222" class="m9g-data" class:vu={e >= 2} role="img" aria-label="Les gens qui se placent à gauche mettent le PLC à {f(G.gauche.lib)} et le PCC à {f(G.gauche.con)}. Ceux qui se placent à droite mettent le PLC à {f(G.droite.lib)} et le PCC à {f(G.droite.con)}.">
    {#each PARTIS as p}
      <line x1={x(G.gauche[p.cle])} y1={CAMPS[0].y + 16} x2={x(G.droite[p.cle])} y2={CAMPS[1].y - 16} class="m9g-guide {p.cl}" class:vu={e >= 3} />
    {/each}
    {#each CAMPS as c}
      <text x="0" y={c.y - 2} class="m9g-camp">{c.t}</text>
      <text x="0" y={c.y + 24} class="m9g-camp-s">{c.s}</text>
      <line x1={x(0)} y1={c.y} x2={x(10)} y2={c.y} class="m9g-axe pale" />
      {#each Array.from({ length: 11 }, (_, k) => k) as k}
        <line x1={x(k)} y1={c.y - 6} x2={x(k)} y2={c.y + 6} class="m9g-tick pale" />
      {/each}
      {#each PARTIS as p}
        <circle cx={x(G[c.cle][p.cle])} cy={c.y} r="13" class="m9g-pt {p.cl}" />
        <text x={x(G[c.cle][p.cle])} y={c.haut ? c.y - 24 : c.y + 42} class="m9g-v {p.cl}">{p.t} {f(G[c.cle][p.cle])}</text>
      {/each}
    {/each}
  </svg>
  <p class="m9g-dit" class:vu={e >= 3}>Le même parti, un autre nombre, selon qui répond.</p>
  <p class="credits m9g-src">CES 2025, sondage de campagne, pondéré. Moyennes de 0 à 10, n = {nb(G.gauche.n)} à gauche et {nb(G.droite.n)} à droite. « Pas certain.e » exclu.</p>
</div>

<style>
  .m9g { display: flex; flex-direction: column; gap: 0.4em; max-width: 58em; margin: 0.2em auto 0; }
  .m9g-q { margin: 0; font-size: 1.05em; line-height: 1.35; border-left: 4px solid var(--dk-encre); padding-left: 0.8em; }
  svg { width: 100%; height: auto; display: block; }
  .m9g-regle { max-height: 9vh; }
  .m9g-data { max-height: 30vh; opacity: 0; transition: opacity 0.5s; }
  .m9g-data.vu { opacity: 1; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9g-axe { stroke: var(--dk-encre); stroke-width: 4; }
  .m9g-tick { stroke: var(--dk-encre); stroke-width: 3; }
  .m9g-axe.pale, .m9g-tick.pale { stroke: var(--dk-gris); stroke-width: 2; }
  .m9g-n { font-size: 22px; text-anchor: middle; font-weight: 600; }
  .m9g-bout { font-size: 20px; fill: var(--dk-gris); font-weight: 600; }
  .m9g-bout.fin { text-anchor: end; }
  .m9g-doute { margin: 0.2em 0 0; font-size: 1.35em; font-weight: 700; text-align: center; opacity: 0; transition: opacity 0.4s; }
  .m9g-doute.vu { opacity: 1; }
  .m9g-camp { font-size: 24px; font-weight: 700; }
  .m9g-camp-s { font-size: 17px; fill: var(--dk-gris); }
  .m9g-pt.plc { fill: var(--dk-accent); }
  .m9g-pt.pcc { fill: var(--dk-encre); }
  .m9g-v { font-size: 22px; font-weight: 700; text-anchor: middle; }
  .m9g-v.plc { fill: var(--dk-accent); }
  .m9g-guide { stroke-width: 3; stroke-dasharray: 8 7; opacity: 0; transition: opacity 0.5s; }
  .m9g-guide.plc { stroke: var(--dk-accent); }
  .m9g-guide.pcc { stroke: var(--dk-encre); }
  .m9g-guide.vu { opacity: 1; }
  .m9g-dit { margin: 0; font-size: 1.25em; font-weight: 700; color: var(--dk-accent); text-align: center; opacity: 0; transition: opacity 0.4s; }
  .m9g-dit.vu { opacity: 1; }
  .m9g-src { margin: 0; }
  @media (prefers-reduced-motion: reduce) { .m9g-data, .m9g-doute, .m9g-guide, .m9g-dit { transition: none; } }
</style>
