<script>
  /**
   * Se placer soi-même de 0 à 10 : la question de la CES 2025. Mais un 3
   * veut-il dire la même chose pour tout le monde ? Une ligne par parti; sur
   * chaque ligne, deux points : où le placent les gens qui se disent à gauche
   * (plein) et ceux qui se disent à droite (vide). Vrais chiffres (GAUCHE,
   * outils/seance9_data.R). Au clic :
   *
   *   0  la question et la règle de 0 à 10;
   *   1  la question qui dérange;
   *   2  le PLC, vu des deux côtés;
   *   3  le PCC, et la phrase.
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
  const X0 = 190, U = 72;
  const x = (v) => X0 + v * U;
  const f = (v) => v.toFixed(1).replace('.', ',');
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const PARTIS = [
    { cle: 'lib', t: 'Le PLC', y: 70, temps: 2 },
    { cle: 'con', t: 'Le PCC', y: 170, temps: 3 }
  ];
</script>

<div class="visuel m9g" bind:this={hote}>
  <p class="m9g-q">« Où vous placeriez-vous sur une échelle de 0 (gauche) à 10 (droite) ? »</p>
  <svg viewBox="0 0 1000 64" class="m9g-regle" aria-hidden="true">
    <line x1={x(0)} y1="22" x2={x(10)} y2="22" class="m9g-axe" />
    {#each Array.from({ length: 11 }, (_, k) => k) as k}
      <line x1={x(k)} y1="14" x2={x(k)} y2="30" class="m9g-tick" />
      <text x={x(k)} y="56" class="m9g-n">{k}</text>
    {/each}
    <text x={x(0) - 20} y="29" class="m9g-bout fin">gauche</text>
    <text x={x(10) + 20} y="29" class="m9g-bout">droite</text>
  </svg>
  <p class="m9g-doute" class:vu={e >= 1}>Mais un 3, est-ce le même 3 pour tout le monde ?</p>

  <div class="m9g-bas" class:vu={e >= 2}>
    <p class="m9g-legende">
      <span><i class="plein"></i>placé par les gens qui se disent <b>à gauche</b></span>
      <span><i class="vide"></i>placé par les gens qui se disent <b>à droite</b></span>
    </p>
    <svg viewBox="0 0 1000 220" class="m9g-data" role="img" aria-label="Les gens qui se disent à gauche placent le PLC à {f(G.gauche.lib)} et le PCC à {f(G.gauche.con)}. Ceux qui se disent à droite placent le PLC à {f(G.droite.lib)} et le PCC à {f(G.droite.con)}.">
      {#each PARTIS as p}
        <g class="m9g-rang" class:vu={e >= p.temps}>
          <text x="0" y={p.y + 8} class="m9g-parti">{p.t}</text>
          <line x1={x(0)} y1={p.y} x2={x(10)} y2={p.y} class="m9g-axe pale" />
          {#each Array.from({ length: 11 }, (_, k) => k) as k}
            <line x1={x(k)} y1={p.y - 6} x2={x(k)} y2={p.y + 6} class="m9g-tick pale" />
          {/each}
          <line x1={x(G.gauche[p.cle])} y1={p.y} x2={x(G.droite[p.cle])} y2={p.y} class="m9g-ecart" />
          <circle cx={x(G.gauche[p.cle])} cy={p.y} r="14" class="m9g-pt plein" />
          <circle cx={x(G.droite[p.cle])} cy={p.y} r="14" class="m9g-pt vide" />
          <text x={x(G.gauche[p.cle])} y={p.y - 26} class="m9g-v">{f(G.gauche[p.cle])}</text>
          <text x={x(G.droite[p.cle])} y={p.y + 46} class="m9g-v">{f(G.droite[p.cle])}</text>
        </g>
      {/each}
    </svg>
  </div>
  <p class="m9g-dit" class:vu={e >= 3}>Le même parti, un autre nombre, selon qui répond.</p>
  <p class="credits m9g-src">CES 2025, sondage de campagne, pondéré. Moyennes de 0 à 10. Gauche : se placent de 0 à 2, n = {nb(G.gauche.n)}. Droite : de 8 à 10, n = {nb(G.droite.n)}.</p>
</div>

<style>
  .m9g { display: flex; flex-direction: column; gap: 0.35em; max-width: 58em; margin: 0 auto; }
  .m9g-q { margin: 0; font-size: 1.05em; line-height: 1.35; border-left: 4px solid var(--dk-encre); padding-left: 0.8em; }
  svg { width: 100%; height: auto; display: block; }
  .m9g-regle { max-height: 8vh; }
  .m9g-data { max-height: 27vh; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9g-axe { stroke: var(--dk-encre); stroke-width: 4; }
  .m9g-tick { stroke: var(--dk-encre); stroke-width: 3; }
  .m9g-axe.pale, .m9g-tick.pale { stroke: var(--dk-gris); stroke-width: 2; }
  .m9g-n { font-size: 22px; text-anchor: middle; font-weight: 600; }
  .m9g-bout { font-size: 20px; fill: var(--dk-gris); font-weight: 600; }
  .m9g-bout.fin { text-anchor: end; }
  .m9g-doute { margin: 0.1em 0 0; font-size: 1.35em; font-weight: 700; text-align: center; opacity: 0; transition: opacity 0.4s; }
  .m9g-doute.vu, .m9g-bas.vu, .m9g-dit.vu, .m9g-rang.vu { opacity: 1; }
  .m9g-bas { opacity: 0; transition: opacity 0.4s; }
  .m9g-legende { margin: 0.2em 0 0; display: flex; gap: 2.4em; justify-content: center; font-size: 0.85em; }
  .m9g-legende span { display: inline-flex; align-items: center; gap: 0.5em; }
  .m9g-legende i { width: 1em; height: 1em; border-radius: 50%; border: 3px solid var(--dk-encre); display: inline-block; }
  .m9g-legende i.plein { background: var(--dk-encre); }
  .m9g-rang { opacity: 0; transition: opacity 0.5s; }
  .m9g-parti { font-size: 26px; font-weight: 700; }
  .m9g-ecart { stroke: var(--dk-accent); stroke-width: 6; }
  .m9g-pt.plein { fill: var(--dk-encre); stroke: var(--dk-encre); stroke-width: 3; }
  .m9g-pt.vide { fill: var(--dk-fond, #f6f6f3); stroke: var(--dk-encre); stroke-width: 4; }
  .m9g-v { font-size: 24px; font-weight: 700; text-anchor: middle; }
  .m9g-dit { margin: 0; font-size: 1.25em; font-weight: 700; color: var(--dk-accent); text-align: center; opacity: 0; transition: opacity 0.4s; }
  .m9g-src { margin: 0; }
  @media (prefers-reduced-motion: reduce) { .m9g-doute, .m9g-bas, .m9g-dit, .m9g-rang { transition: none; } }
</style>
