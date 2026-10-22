<script>
  /**
   * Ce que contrôler ne règle pas : quatre limites qui restent, même avec un
   * bon modèle. Un schéma par limite (aucune donnée), une phrase, et le nom
   * du biais dans le vocabulaire d'Arel-Bundock (2021), avec la séance où on
   * y revient. Une case de plus à chaque clic.
   *
   *   0  une cause non mesurée : U (pointillé) agit sur X et sur Y, et
   *      personne ne la tient égale (biais par variable omise, séance 13);
   *   1  un contrôle mal mesuré : la boîte ne ferme qu'en partie le chemin
   *      par la porte arrière (erreur de mesure, séance 13);
   *   2  le sens de la causalité : l'intérêt pousse-t-il à étudier plus
   *      longtemps ? Ajouter des variables ne le dit pas (simultanéité,
   *      séance 13);
   *   3  cause commune ou conséquence : la flèche entre X et Z, dans un sens
   *      ou dans l'autre, change tout (la contrôler ou surtout pas), et le
   *      tableau ne la montre pas (biais post-traitement, séance 11).
   *
   * Le flux de l'effet (Flux.svelte, comme M8Intuition) : des points
   * voyagent de la cause vers la conséquence, en boucle. Encre pour
   * scolarité → intérêt, rouge pour le chemin qui pose problème. Chaque case
   * lance son flux quand elle apparaît. La case la plus récente coule à
   * pleine force; les précédentes gardent un flux rouge pâli et perdent le
   * flux à l'encre (quatre fois le même flux noir, c'est du bruit).
   *
   *   0  les points rouges partent de l'intérêt des parents vers les deux
   *      boîtes, sans arrêt possible : pas de cadre, pas de coupure, la
   *      variable n'est pas dans la base;
   *   1  le milieu social est encadré (contrôlé, cadre rouge) mais le cadre
   *      est troué : la coupure laisse passer la moitié des points (passe),
   *      l'autre moitié s'éteint à la coupure;
   *   2  deux flux : scolarité → intérêt (encre) et intérêt → scolarité
   *      (rouge, l'arc). Le modèle ne dit pas lequel est le vrai;
   *   3  le flux entre scolarité et nouvelles change de sens en boucle
   *      (fondu enchaîné CSS, cycle de 9,6 s) : nouvelles → scolarité
   *      (cause commune) puis scolarité → nouvelles (conséquence). La pointe
   *      active est pleine, l'autre pâlit. Nouvelles → intérêt coule tout
   *      le temps.
   *
   * La diapo des deux règles du contrôle (plus tôt) dit quoi faire; celle-ci
   * dit ce qui reste hors de portée. Les exemples (intérêt des parents,
   * milieu social, consommation de nouvelles) sont des schémas : aucune de
   * ces variables n'est dans notre modèle. Flèches en polygones, pas de
   * <marker> (les id SVG ne sont pas isolés d'une diapo à l'autre).
   */
  import { brancherTemps } from '../temps.js';
  import Flux from './Flux.svelte';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Les nœuds, dans un viewBox de 460 × 250.
  const X = [80, 200], Y = [380, 200], Z = [230, 56];
  function fl([x1, y1], [x2, y2], r1, r2) {
    const dx = x2 - x1, dy = y2 - y1, d = Math.hypot(dx, dy), ux = dx / d, uy = dy / d;
    const a = [x1 + ux * r1, y1 + uy * r1], b = [x2 - ux * r2, y2 - uy * r2];
    const p = [b[0] - ux * 16, b[1] - uy * 16];
    return { a, p, ux, uy, d: `M${a[0]},${a[1]} L${p[0]},${p[1]}`, tri: `${b[0]},${b[1]} ${p[0] - uy * 8},${p[1] + ux * 8} ${p[0] + uy * 8},${p[1] - ux * 8}` };
  }
  const XY = fl(X, Y, 84, 66);
  const ZX = fl(Z, X, 34, 34);
  const ZY = fl(Z, Y, 34, 34);
  const XZ = fl(X, Z, 34, 34);
  // Cas 2 : les flèches partent du bord de la boîte (pour que la coupure
  // tombe au milieu du trait visible).
  const ZX2 = fl(Z, X, 44, 34);
  const ZY2 = fl(Z, Y, 44, 34);
  // La flèche à rebours (cas 3) : un arc par-dessus, de l'intérêt vers la scolarité.
  const YX = { d: 'M372,168 Q230,40 104,160', tri: '' };
  {
    const b = [92, 172], c = [230, 40], tx = b[0] - c[0], ty = b[1] - c[1], tn = Math.hypot(tx, ty), vx = tx / tn, vy = ty / tn;
    const p = [b[0] - vx * 16, b[1] - vy * 16];
    YX.d = `M372,168 Q230,40 ${p[0]},${p[1]}`;
    YX.tri = `${b[0]},${b[1]} ${p[0] - vy * 8},${p[1] + vx * 8} ${p[0] + vy * 8},${p[1] - vx * 8}`;
  }
  // Le trait à double pointe entre X et Z (cas 4) : sans ses deux pointes.
  const XZ2 = (() => {
    const dx = Z[0] - X[0], dy = Z[1] - X[1], d = Math.hypot(dx, dy), ux = dx / d, uy = dy / d;
    return { x1: X[0] + ux * 50, y1: X[1] + uy * 50, x2: Z[0] - ux * 50, y2: Z[1] - uy * 50 };
  })();

  // Le flux sur le trait à double pointe (cas 4) : d'un pied de pointe à l'autre.
  const D_SN = `M${XZ2.x1},${XZ2.y1} L${XZ2.x2},${XZ2.y2}`;
  const D_NS = `M${XZ2.x2},${XZ2.y2} L${XZ2.x1},${XZ2.y1}`;

  // La coupure trouée (cas 2) : au point « ARRET » du tracé même du flux,
  // perpendiculaire, avec un trou au centre où passent les points.
  const ARRET = 0.5, RP = 8;
  function coupe(f) {
    const cx = f.a[0] + (f.p[0] - f.a[0]) * ARRET, cy = f.a[1] + (f.p[1] - f.a[1]) * ARRET;
    const nx = -f.uy, ny = f.ux, l = 26, t = RP + 4;
    return [
      { x1: cx + nx * t, y1: cy + ny * t, x2: cx + nx * l, y2: cy + ny * l },
      { x1: cx - nx * t, y1: cy - ny * t, x2: cx - nx * l, y2: cy - ny * l }
    ];
  }
  const COUPES = [...coupe(ZX2), ...coupe(ZY2)];

  const CASES = [
    { titre: 'Une cause non mesurée', dit: 'On ne contrôle que ce qu’on a mesuré.', biais: 'biais par variable omise', ou: 'séance 13' },
    { titre: 'Un contrôle mal mesuré', dit: 'Le chemin ne se ferme qu’en partie.', biais: 'erreur de mesure', ou: 'séance 13' },
    { titre: 'Le sens de la causalité', dit: 'Ajouter des variables ne dit pas qui cause qui.', biais: 'simultanéité', ou: 'séance 13' },
    { titre: 'Cause commune ou conséquence', dit: 'Le tableau ne montre pas le sens de cette flèche.', biais: 'biais post-traitement', ou: 'séance 11' }
  ];
</script>

{#snippet xy(i)}
  <path d={XY.d} class="m8l-fl m8l-fl-fort" />
  <polygon points={XY.tri} class="m8l-pt m8l-pt-fort" />
  <g class="m8l-flux m8l-flux-encre" class:m8l-ancien={e > i}>
    <Flux d={XY.d} actif={e >= i} n={3} duree={2.4} r={RP} />
  </g>
  <text x={X[0]} y={X[1] + 9} class="m8l-n">scolarité</text>
  <text x={Y[0]} y={Y[1] + 9} class="m8l-n">intérêt</text>
{/snippet}

<div class="visuel m8l" bind:this={hote}>
  {#each CASES as c, i}
    <section class="m8l-case" class:m8l-vu={e >= i}>
      <svg viewBox="0 0 460 250" role="img" aria-label="Schéma : {c.titre}.">
        {#if i === 0}
          <path d={ZX.d} class="m8l-fl m8l-tiret" /><polygon points={ZX.tri} class="m8l-pt" />
          <path d={ZY.d} class="m8l-fl m8l-tiret" /><polygon points={ZY.tri} class="m8l-pt" />
          <!-- Rien ne peut arrêter ces points : la variable n'est pas dans la base. -->
          <g class="m8l-flux" class:m8l-ancien={e > i}>
            <Flux d={ZX.d} actif={e >= i} rouge n={2} duree={2.4} r={RP} />
            <Flux d={ZY.d} actif={e >= i} rouge n={2} duree={2.4} r={RP} />
          </g>
          <ellipse cx={Z[0]} cy={Z[1]} rx="148" ry="32" class="m8l-ombre" />
          <text x={Z[0]} y={Z[1] + 8} class="m8l-n m8l-n-gris">intérêt des parents</text>
          <text x={Z[0]} y={Z[1] - 42} class="m8l-note">pas dans la base</text>
          {@render xy(i)}
        {:else if i === 1}
          <path d={ZX2.d} class="m8l-fl" /><polygon points={ZX2.tri} class="m8l-pt" />
          <path d={ZY2.d} class="m8l-fl" /><polygon points={ZY2.tri} class="m8l-pt" />
          <!-- Contrôlé, mais mal : la moitié des points passe la coupure trouée. -->
          {#each COUPES as k}
            <line x1={k.x1} y1={k.y1} x2={k.x2} y2={k.y2} class="m8l-cut" />
          {/each}
          <g class="m8l-flux" class:m8l-ancien={e > i}>
            <Flux d={ZX2.d} actif={e >= i} arret={ARRET} passe={0.5} rouge n={4} duree={2.8} r={RP} />
            <Flux d={ZY2.d} actif={e >= i} arret={ARRET} passe={0.5} rouge n={4} duree={2.8} r={RP} />
          </g>
          <rect x={Z[0] - 128} y={Z[1] - 30} width="256" height="60" class="m8l-boite m8l-boite-trouee" />
          <text x={Z[0]} y={Z[1] + 9} class="m8l-n">milieu social</text>
          <text x={Z[0]} y={Z[1] - 42} class="m8l-note">une seule question</text>
          {@render xy(i)}
        {:else if i === 2}
          <path d={YX.d} class="m8l-fl m8l-fl-rouge" /><polygon points={YX.tri} class="m8l-pt m8l-pt-rouge" />
          <g class="m8l-flux" class:m8l-ancien={e > i}>
            <Flux d={YX.d} actif={e >= i} rouge n={3} duree={3} r={RP} />
          </g>
          <text x="230" y="92" class="m8l-q">?</text>
          {@render xy(i)}
        {:else}
          <path d={ZY.d} class="m8l-fl" /><polygon points={ZY.tri} class="m8l-pt" />
          <line x1={XZ2.x1} y1={XZ2.y1} x2={XZ2.x2} y2={XZ2.y2} class="m8l-fl m8l-fl-rouge" />
          <!-- Le sens alterne : cause commune (nouvelles → scolarité), puis
               conséquence (scolarité → nouvelles). -->
          <g class="m8l-flux" class:m8l-ancien={e > i} class:m8l-alterne={e >= i}>
            <polygon points={ZX.tri} class="m8l-pt m8l-pt-rouge m8l-sens-a" />
            <polygon points={XZ.tri} class="m8l-pt m8l-pt-rouge m8l-sens-b" />
            <g class="m8l-sens-a"><Flux d={D_NS} actif={e >= i} rouge n={2} duree={2.4} r={RP} /></g>
            <g class="m8l-sens-b"><Flux d={D_SN} actif={e >= i} rouge n={2} duree={2.4} r={RP} /></g>
            <Flux d={ZY.d} actif={e >= i} rouge n={2} duree={2.4} r={RP} />
          </g>
          <text x={(X[0] + Z[0]) / 2 - 26} y={(X[1] + Z[1]) / 2 - 2} class="m8l-q">?</text>
          <text x={Z[0]} y={Z[1] + 9} class="m8l-n">nouvelles</text>
          {@render xy(i)}
        {/if}
      </svg>
      <div class="m8l-texte">
        <h3>{c.titre}</h3>
        <p class="m8l-dit">{c.dit}</p>
        <p class="m8l-biais">{c.biais}<span class="m8l-ou">{c.ou}</span></p>
      </div>
    </section>
  {/each}
  <p class="m8l-source">Schémas · vocabulaire d’Arel-Bundock (2021)</p>
</div>

<style>
  .m8l { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 1.2em 1.6em; max-width: 66em; margin: 0.4em auto 0; }
  .m8l-case { display: grid; grid-template-columns: minmax(0, 1.1fr) minmax(0, 1fr); gap: 0.9em; align-items: center; border-top: 2px solid var(--dk-encre); padding-top: 0.7em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.45s, transform 0.45s; }
  .m8l-case.m8l-vu { opacity: 1; transform: none; }
  svg { width: 100%; height: auto; display: block; }
  .m8l-texte { display: flex; flex-direction: column; gap: 0.45em; }
  h3 { margin: 0; font-size: 1.12em; font-weight: 700; line-height: 1.22; }
  .m8l-dit { margin: 0; font-size: 0.9em; line-height: 1.35; }
  .m8l-biais { margin: 0.2em 0 0; font-size: 0.66em; font-weight: 600; letter-spacing: 0.05em; color: var(--dk-accent); }
  .m8l-ou { display: block; color: var(--dk-gris); font-weight: 400; }
  .m8l-source { grid-column: 1 / -1; margin: 0; font-size: 0.6em; color: var(--dk-gris); }

  svg text { font-family: var(--dk-mono); text-anchor: middle; }
  .m8l-n { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .m8l-n-gris { fill: var(--dk-gris); font-size: 22px; }
  .m8l-note { font-size: 18px; fill: var(--dk-gris); }
  .m8l-q { font-size: 40px; font-weight: 700; fill: var(--dk-accent); }
  .m8l-fl { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; }
  .m8l-fl-fort { stroke: var(--dk-encre); stroke-width: 4; }
  .m8l-fl-rouge { stroke: var(--dk-accent); stroke-width: 4; }
  .m8l-tiret { stroke-dasharray: 8 7; }
  .m8l-pt { fill: var(--dk-gris-2); }
  .m8l-pt-fort { fill: var(--dk-encre); }
  .m8l-pt-rouge { fill: var(--dk-accent); }
  .m8l-ombre { fill: var(--dk-fond); stroke: var(--dk-gris-2); stroke-width: 2.5; stroke-dasharray: 8 7; }
  .m8l-boite { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 3.5; }
  .m8l-boite-trouee { stroke-dasharray: 14 10; }

  .m8l-cut { stroke: var(--dk-accent); stroke-width: 5; }

  /* Le flux : plein dans la case la plus récente, pâli dans les autres. */
  .m8l-flux { transition: opacity 0.6s; }
  .m8l-flux.m8l-ancien { opacity: 0.35; }
  .m8l-flux-encre.m8l-ancien { opacity: 0; }

  /* Cas 4 : les deux sens se relaient (le flux rouge et sa pointe). */
  .m8l-alterne .m8l-sens-a { animation: m8l-sens-a 9.6s linear infinite; }
  .m8l-alterne .m8l-sens-b { animation: m8l-sens-b 9.6s linear infinite; }
  polygon.m8l-sens-a, polygon.m8l-sens-b { --m8l-bas: 0.25; }
  g.m8l-sens-a, g.m8l-sens-b { --m8l-bas: 0; }
  @keyframes m8l-sens-a { 0%, 44% { opacity: 1; } 50%, 94% { opacity: var(--m8l-bas); } 100% { opacity: 1; } }
  @keyframes m8l-sens-b { 0%, 44% { opacity: var(--m8l-bas); } 50%, 94% { opacity: 1; } 100% { opacity: var(--m8l-bas); } }

  @media (prefers-reduced-motion: reduce) {
    .m8l-case, .m8l-flux { transition: none; transform: none; }
    .m8l-alterne .m8l-sens-a, .m8l-alterne .m8l-sens-b { animation: none; opacity: 1; }
  }
</style>
