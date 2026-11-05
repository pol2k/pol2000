<script>
  /**
   * Mesurer un concept : le même chemin pour une longueur, un poids et
   * l'idéologie. Une chose, un instrument, un nombre, puis on calcule. Les
   * instruments reprennent le dessin de M9Instruments (règle, pèse-personne),
   * plus une question de sondage. Au clic :
   *
   *   0  les trois choses : une longueur, un poids, l'idéologie;
   *   1  l'instrument de chacune : la règle, le pèse-personne, la question;
   *   2  la lecture et le nombre, en rouge : 14 cm, 68 kg, 0,72;
   *   3  les trois nombres entrent dans le calcul : une moyenne, une
   *      régression. Et la phrase.
   *
   * Un schéma, sans donnée : les points du calcul sont décoratifs.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const R = [
    { chose: 'une longueur', nombre: '14 cm', y: 130 },
    { chose: 'un poids', nombre: '68 kg', y: 275 },
    { chose: 'l’idéologie', nombre: '0,72', sous: 'de 0 à 1', y: 420 }
  ];
  // Le cadran du pèse-personne, comme dans M9Instruments.
  const rad = (a) => (a * Math.PI) / 180;
  const cad = (a, r) => [120 + r * Math.sin(rad(a)), 50 - r * Math.cos(rad(a))];
  // Le petit calcul : un nuage décoratif, sa moyenne, sa droite.
  const PX = (u) => 860 + u * 290;
  const PY = (v) => 340 - v * 240;
  const PTS = [[0.1, 0.28], [0.22, 0.3], [0.34, 0.48], [0.46, 0.42], [0.58, 0.62], [0.7, 0.6], [0.84, 0.8], [0.93, 0.78]];
  const MOY = PTS.reduce((s, p) => s + p[1], 0) / PTS.length;
  const ENTREES = [235, 275, 315];
</script>

<div class="visuel m9ch" bind:this={hote}>
  <svg viewBox="0 0 1200 500" role="img" aria-label="Une longueur, une règle, 14 cm. Un poids, un pèse-personne, 68 kg. L’idéologie, une question de sondage, 0,72 sur une échelle de 0 à 1. Puis on calcule : une moyenne, une régression.">
    <defs>
      <marker id="m9ch-pointe" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="4" markerHeight="4" orient="auto">
        <path d="M0 0 L10 5 L0 10 z" class="m9ch-pointe" />
      </marker>
    </defs>

    <!-- les têtes de colonne -->
    <text x="110" y="34" class="m9ch-tete">une chose</text>
    <text x="393" y="34" class="m9ch-tete m9ch-col" class:vu={e >= 1}>un instrument</text>
    <text x="640" y="34" class="m9ch-tete m9ch-col" class:vu={e >= 2}>un nombre</text>
    <text x="1005" y="34" class="m9ch-tete rouge m9ch-col" class:vu={e >= 3}>calculer</text>

    {#each R as r, i}
      <!-- 0 : la chose -->
      <g class="m9ch-entree" style="--i: {i}">
        <text x="0" y={r.y + 10} class="m9ch-chose" class:concept={i === 2}>{r.chose}</text>
      </g>

      <!-- 1 : l'instrument -->
      <g class="m9ch-col" class:vu={e >= 1} style="--i: {i}">
        <line x1="232" y1={r.y} x2="272" y2={r.y} class="m9ch-fl" marker-end="url(#m9ch-pointe)" />
        <g transform="translate(285 {r.y - 68}) scale(0.9)">
          {#if i === 0}
            <!-- la règle, et le crayon qu'on mesure -->
            <rect x="20" y="70" width="200" height="32" class="m9ch-tr" />
            {#each Array.from({ length: 21 }, (_, k) => k) as k}
              <line x1={20 + k * 10} y1="70" x2={20 + k * 10} y2={k % 5 === 0 ? 90 : 80} class="m9ch-tick" />
            {/each}
            {#each [0, 5, 10, 15, 20] as n}
              <text x={20 + n * 10} y="122" class="m9ch-num">{n}</text>
            {/each}
            <rect x="20" y="36" width="140" height="16" class="m9ch-objet" />
            <polygon points="160,36 176,44 160,52" class="m9ch-objet" />
            <line x1="20" y1="26" x2="20" y2="62" class="m9ch-lu" class:vu={e >= 2} />
            <line x1="160" y1="26" x2="160" y2="62" class="m9ch-lu" class:vu={e >= 2} />
          {:else if i === 1}
            <!-- le pèse-personne, vu de haut : un cadran, deux pieds -->
            <rect x="62" y="6" width="116" height="138" rx="20" class="m9ch-tr" />
            <rect x="86" y="16" width="68" height="38" rx="6" class="m9ch-fen" />
            {#each [-50, -25, 0, 25, 50] as a}
              <line x1={cad(a, 22)[0]} y1={cad(a, 22)[1]} x2={cad(a, 28)[0]} y2={cad(a, 28)[1]} class="m9ch-tick" />
            {/each}
            <line x1="120" y1="50" x2={cad(-50, 24)[0]} y2={cad(-50, 24)[1]} class="m9ch-repos" class:cache={e >= 2} />
            <line x1="120" y1="50" x2={cad(22, 24)[0]} y2={cad(22, 24)[1]} class="m9ch-lu rond" class:vu={e >= 2} />
            <ellipse cx="100" cy="102" rx="13" ry="25" class="m9ch-objet" />
            <ellipse cx="140" cy="102" rx="13" ry="25" class="m9ch-objet" />
          {:else}
            <!-- la question de sondage : une fiche, une échelle de 0 à 1 -->
            <rect x="8" y="12" width="224" height="126" class="m9ch-fen" />
            <text x="120" y="46" class="m9ch-question">Gauche ou droite ?</text>
            <line x1="30" y1="88" x2="210" y2="88" class="m9ch-axe" />
            {#each [0, 0.25, 0.5, 0.75, 1] as t}
              <line x1={30 + t * 180} y1="80" x2={30 + t * 180} y2="96" class="m9ch-tick" />
            {/each}
            <text x="30" y="122" class="m9ch-num">0</text>
            <text x="210" y="122" class="m9ch-num">1</text>
            <g class="m9ch-lu" class:vu={e >= 2}>
              <line x1={30 + 0.72 * 180} y1="70" x2={30 + 0.72 * 180} y2="106" class="m9ch-curseur" />
              <circle cx={30 + 0.72 * 180} cy="88" r="9" class="m9ch-pt-rouge" />
            </g>
          {/if}
        </g>
      </g>

      <!-- 2 : le nombre -->
      <g class="m9ch-col" class:vu={e >= 2} style="--i: {i}">
        <line x1="522" y1={r.y} x2="562" y2={r.y} class="m9ch-fl" marker-end="url(#m9ch-pointe)" />
        <text x="575" y={r.y + (r.sous ? 6 : 16)} class="m9ch-nombre">{r.nombre}</text>
        {#if r.sous}<text x="578" y={r.y + 38} class="m9ch-sous">{r.sous}</text>{/if}
      </g>

      <!-- 3 : vers le calcul -->
      <g class="m9ch-col" class:vu={e >= 3} style="--i: {i}">
        <line x1="738" y1={r.y} x2="812" y2={ENTREES[i]} class="m9ch-fl" marker-end="url(#m9ch-pointe)" />
      </g>
    {/each}

    <!-- 3 : le calcul -->
    <g class="m9ch-col" class:vu={e >= 3}>
      <rect x="822" y="62" width="368" height="426" class="m9ch-boite" />
      <line x1={PX(0)} y1={PY(1)} x2={PX(0)} y2={PY(0)} class="m9ch-axe" />
      <line x1={PX(0)} y1={PY(0)} x2={PX(1)} y2={PY(0)} class="m9ch-axe" />
      <line x1={PX(0)} y1={PY(MOY)} x2={PX(1)} y2={PY(MOY)} class="m9ch-moy" />
      {#each PTS as [u, v], k}
        <circle cx={PX(u)} cy={PY(v)} r="9" class="m9ch-pt" style="--k: {k}" />
      {/each}
      <line x1={PX(0.04)} y1={PY(0.22)} x2={PX(0.96)} y2={PY(0.86)} pathLength="1" class="m9ch-reg" />
      <line x1="860" y1="398" x2="904" y2="398" class="m9ch-moy" />
      <text x="918" y="406" class="m9ch-leg">moyenne</text>
      <line x1="860" y1="446" x2="904" y2="446" class="m9ch-reg plein" />
      <text x="918" y="454" class="m9ch-leg">régression</text>
    </g>
  </svg>
  <p class="m9ch-phrase" class:vu={e >= 3}>Les données : des <strong>nombres</strong> mis sur des concepts.</p>
</div>

<style>
  .m9ch { display: flex; flex-direction: column; gap: 0.6em; max-width: 62em; margin: 0.6em auto 0; }
  svg { width: 100%; height: auto; max-height: 55vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9ch-tete { font-size: 22px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; fill: var(--dk-gris); text-anchor: middle; }
  .m9ch-tete.rouge { fill: var(--dk-accent); }
  .m9ch-chose { font-size: 30px; font-weight: 600; }
  .m9ch-chose.concept { font-weight: 700; }
  .m9ch-fl { stroke: var(--dk-gris); stroke-width: 3; }
  .m9ch-pointe { fill: var(--dk-gris); }
  .m9ch-tr { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3; }
  .m9ch-fen { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .m9ch-tick { stroke: var(--dk-encre); stroke-width: 2; }
  .m9ch-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .m9ch-num { font-size: 15px; fill: var(--dk-gris); text-anchor: middle; }
  .m9ch-question { font-size: 17px; font-weight: 600; text-anchor: middle; }
  .m9ch-objet { fill: var(--dk-encre); }
  .m9ch-repos { stroke: var(--dk-gris); stroke-width: 3; stroke-linecap: round; transition: opacity 0.3s; }
  .m9ch-repos.cache { opacity: 0; }
  .m9ch-lu { stroke: var(--dk-accent); stroke-width: 4; opacity: 0; transition: opacity 0.4s 0.2s; }
  .m9ch-lu.rond { stroke-linecap: round; }
  .m9ch-lu.vu { opacity: 1; }
  .m9ch-curseur { stroke: var(--dk-accent); stroke-width: 4; }
  .m9ch-pt-rouge { fill: var(--dk-accent); stroke: none; }
  .m9ch-nombre { font-size: 46px; font-weight: 700; fill: var(--dk-accent); }
  .m9ch-sous { font-size: 18px; fill: var(--dk-gris); }
  .m9ch-boite { fill: none; stroke: var(--dk-accent); stroke-width: 4; }
  .m9ch-moy { stroke: var(--dk-gris); stroke-width: 3; stroke-dasharray: 10 8; }
  .m9ch-pt { fill: var(--dk-encre); opacity: 0; transition: opacity 0.3s; transition-delay: calc(0.2s + var(--k) * 0.06s); }
  .m9ch-col.vu .m9ch-pt { opacity: 1; }
  .m9ch-reg { stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s 0.6s; }
  .m9ch-col.vu .m9ch-reg { stroke-dashoffset: 0; }
  .m9ch-reg.plein { stroke-dasharray: none; stroke-dashoffset: 0; }
  .m9ch-leg { font-size: 24px; font-weight: 600; }
  .m9ch-entree { animation: m9ch-fondu 0.5s both; animation-delay: calc(var(--i) * 0.2s); }
  .m9ch-col { opacity: 0; transform: translateX(-12px); transition: opacity 0.45s, transform 0.45s; transition-delay: calc(var(--i, 0) * 0.12s); }
  .m9ch-col.vu { opacity: 1; transform: none; }
  .m9ch-phrase { margin: 0; text-align: center; font-size: 1.3em; line-height: 1.3; opacity: 0; transition: opacity 0.5s 0.6s; }
  .m9ch-phrase strong { color: var(--dk-accent); }
  .m9ch-phrase.vu { opacity: 1; }
  @keyframes m9ch-fondu { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .m9ch-entree { animation: none; }
    .m9ch-col, .m9ch-lu, .m9ch-repos, .m9ch-pt, .m9ch-reg, .m9ch-phrase { transition: none; }
  }
</style>
