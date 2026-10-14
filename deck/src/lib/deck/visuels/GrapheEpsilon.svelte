<script>
  /**
   * Ce qui se cache dans ε, dessiné en graphe : des boîtes (les variables) et
   * des flèches (« cause »). Premier regard intuitif; la théorie des graphes
   * orientés acycliques (GOA) vient à la séance 11.
   *
   * Deux usages, selon les props :
   *   - l'exemple d'Arel-Bundock (2021, p. 84) : crème glacée (x), noyades (y),
   *     et la chaleur cachée dans ε (par défaut);
   *   - notre sondage de la CES : gauche_droite (x), note_carney (y), et un
   *     « ? » dans ε (inconnu = true). Là, une question, aucune réponse.
   *
   * Quatre temps :
   *   0  L'équation, et le graphe qu'elle dessine : x → y, la flèche β1, avec
   *      un « ? » (ce que la régression veut estimer).
   *   1  ε devient un nuage pointillé attaché à y : tout ce qui cause y sauf x,
   *      qu'on ne voit jamais. La régression suppose qu'aucune flèche ne part
   *      de ε vers x : un trait gris barré.
   *   2  Dans le nuage, la chaleur (ou « ? ») s'allume en rouge, et sa flèche
   *      vers y se trace : elle était dans ε depuis le début.
   *   3  La flèche interdite se trace en rouge : la chaleur pousse aussi x. La
   *      supposition tombe, β1 est biaisé (ou, pour la CES, la question).
   *
   * Schématique : aucune donnée. `b1` (facultatif) affiche la pente estimée
   * par R, passée par la diapo depuis un module de données.
   */
  import { brancherTemps } from '../temps.js';

  let {
    x = 'crème glacée',
    y = 'noyades',
    z = 'la chaleur',
    autres = ['savoir nager', 'l’alcool', 'les vacances'],
    inconnu = false,
    b1 = null,
    goa = true
  } = $props();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const N = ' '; // espace fine insécable
  const f = (v) => (v < 0 ? '−' : '+') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

  // Les boîtes x et y, et le nuage ε.
  const BX = { cx: 200, cy: 62, w: 300, h: 92 };
  const BY = { cx: 800, cy: 62, w: 300, h: 92 };
  const NU = { cx: 690, cy: 322, rx: 270, ry: 92 };
  const Z = { x: 545, y: 332 }; // la chaleur, dans le nuage, côté x

  // Une flèche de (a) vers (b) : le trait s'arrête au pied de la pointe.
  function fleche(ax, ay, bx, by, pointe = 20) {
    const dx = bx - ax, dy = by - ay, L = Math.hypot(dx, dy);
    const ux = dx / L, uy = dy / L;
    const px = bx - ux * pointe, py = by - uy * pointe;
    const nx = -uy * pointe * 0.5, ny = ux * pointe * 0.5;
    return {
      d: `M ${ax} ${ay} L ${px} ${py}`,
      tete: `${bx},${by} ${px + nx},${py + ny} ${px - nx},${py - ny}`,
      mx: (ax + bx) / 2, my: (ay + by) / 2
    };
  }
  const XY = fleche(BX.cx + BX.w / 2 + 6, BX.cy, BY.cx - BY.w / 2 - 6, BY.cy);
  const EY = fleche(NU.cx + 150, NU.cy - NU.ry + 8, BY.cx + 40, BY.cy + BY.h / 2 + 6);
  const ZY = $derived(fleche(Z.x + (inconnu ? 14 : 50), Z.y - (inconnu ? 40 : 30), BY.cx - 70, BY.cy + BY.h / 2 + 6));
  const ZX = $derived(fleche(Z.x - (inconnu ? 14 : 40), Z.y - (inconnu ? 42 : 34), BX.cx + 30, BX.cy + BX.h / 2 + 6, 24));
  // Le trait gris de la supposition : même chemin que ZX, depuis le bord du nuage.
  const SUP = { x1: NU.cx - NU.rx + 12, y1: NU.cy - 22, x2: BX.cx + 30, y2: BX.cy + BX.h / 2 + 10 };
  const SUPM = { x: (SUP.x1 + SUP.x2) / 2, y: (SUP.y1 + SUP.y2) / 2 };

  // Les autres causes, éparpillées dans le nuage (positions fixes).
  const POS = [{ x: 745, y: 292 }, { x: 830, y: 345 }, { x: 690, y: 390 }];
</script>

<div class="visuel ge" bind:this={hote}>
  <p class="ge-eq">{y} = β0 + β1 × {x} + <span class="ge-eps" class:ge-allume={e >= 1}>ε</span></p>

  <svg viewBox="0 0 1000 470" role="img" aria-label="Un graphe : {x} pointe vers {y}, la flèche β1. Un nuage ε, tout ce qui cause {y} sauf {x}, pointe aussi vers {y}. {inconnu ? `Dans ε, quelque chose pourrait-il pousser aussi ${x} ?` : `Dans ε se cache ${z}, qui pousse ${y} et aussi ${x} : la pente β1 est biaisée.`}">
    <!-- x → y : ce que la régression estime. -->
    <path d={XY.d} class="ge-fl" />
    <polygon points={XY.tete} class="ge-tete" />
    <text x={XY.mx} y={XY.my - 22} class="ge-b1" class:ge-rouge={e >= 3 && !inconnu}>
      {#if e >= 3 && !inconnu}β1 biaisé{:else}β1 = {b1 === null ? '?' : f(b1)}{/if}
    </text>

    <rect x={BX.cx - BX.w / 2} y={BX.cy - BX.h / 2} width={BX.w} height={BX.h} class="ge-boite" class:ge-touche={e >= 3} />
    <text x={BX.cx} y={BX.cy + 2} class="ge-nom">{x}</text>
    <text x={BX.cx} y={BX.cy + 32} class="ge-role">x</text>
    <rect x={BY.cx - BY.w / 2} y={BY.cy - BY.h / 2} width={BY.w} height={BY.h} class="ge-boite" />
    <text x={BY.cx} y={BY.cy + 2} class="ge-nom">{y}</text>
    <text x={BY.cx} y={BY.cy + 32} class="ge-role">y</text>

    <!-- 1 : ε, un nuage qu'on ne voit jamais. -->
    <g class="ge-etape" class:ge-vu={e >= 1}>
      <ellipse cx={NU.cx} cy={NU.cy} rx={NU.rx} ry={NU.ry} class="ge-nuage" />
      <text x={NU.cx + NU.rx - 30} y={NU.cy + 2} class="ge-eps-n">ε</text>
      <path d={EY.d} class="ge-fl ge-gris" />
      <polygon points={EY.tete} class="ge-tete ge-gris-t" />
      {#each autres as a, i}
        <text x={POS[i].x} y={POS[i].y} class="ge-autre">{a}</text>
      {/each}
      <text x={Z.x} y={Z.y} class="ge-z" class:ge-z-on={e >= 2} class:ge-z-q={inconnu}>{inconnu ? '?' : z}</text>
      <text x={NU.cx + NU.rx} y={NU.cy + NU.ry + 30} class="ge-cap ge-fin">tout le reste · on ne le voit jamais</text>
    </g>

    <!-- 1-2 : la supposition, une flèche qui ne doit pas exister. -->
    <g class="ge-etape" class:ge-vu={e >= 1 && e < 3}>
      <line {...SUP} class="ge-sup" />
      <g transform="translate({SUPM.x} {SUPM.y})">
        <circle r="17" class="ge-croix-f" />
        <path d="M -9 -9 L 9 9 M 9 -9 L -9 9" class="ge-croix" />
      </g>
      <text x={SUPM.x - 30} y={SUPM.y + 54} class="ge-hyp ge-fin">on suppose{N}:</text>
      <text x={SUPM.x - 30} y={SUPM.y + 82} class="ge-hyp ge-fin">rien dans ε</text>
      <text x={SUPM.x - 30} y={SUPM.y + 110} class="ge-hyp ge-fin">ne pousse x</text>
    </g>

    <!-- 2 : la chaleur pousse y. -->
    <path d={ZY.d} pathLength="1" class="ge-fl ge-rouge-fl ge-trace" class:ge-pointille={inconnu} class:ge-vu={e >= 2} />
    <polygon points={ZY.tete} class="ge-tete ge-rouge-t ge-etape ge-tard" class:ge-vu={e >= 2} />

    <!-- 3 : … et x aussi. La supposition tombe. -->
    <path d={ZX.d} pathLength="1" class="ge-fl ge-rouge-fl ge-trace ge-epais" class:ge-pointille={inconnu} class:ge-vu={e >= 3} />
    <polygon points={ZX.tete} class="ge-tete ge-rouge-t ge-etape ge-tard" class:ge-vu={e >= 3} />
    <g class="ge-etape ge-tard" class:ge-vu={e >= 3}>
      {#if inconnu}
        <text x={SUPM.x - 30} y={SUPM.y + 60} class="ge-alerte ge-fin">qu’est-ce qui</text>
        <text x={SUPM.x - 30} y={SUPM.y + 92} class="ge-alerte ge-fin">pousserait</text>
        <text x={SUPM.x - 30} y={SUPM.y + 124} class="ge-alerte ge-fin">les deux{N}?</text>
      {:else}
        <text x={SUPM.x - 30} y={SUPM.y + 60} class="ge-alerte ge-fin">{z}</text>
        <text x={SUPM.x - 30} y={SUPM.y + 92} class="ge-alerte ge-fin">pousse aussi x</text>
        <text x={SUPM.x - 30} y={SUPM.y + 128} class="ge-hyp ge-encre ge-fin">une variable confondante</text>
      {/if}
    </g>

    {#if goa}
      <text x="0" y="462" class="ge-cap">un graphe orienté acyclique (GOA) · séance 11</text>
    {/if}
  </svg>
</div>

<style>
  .ge { display: flex; flex-direction: column; gap: 0.2em; }
  .ge-eq { margin: 0; text-align: center; font-size: 1.15em; font-weight: 600; }
  .ge-eps { transition: color 0.4s; }
  .ge-eps.ge-allume { color: var(--dk-accent); }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); }

  .ge-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.4s; }
  .ge-boite.ge-touche { stroke: var(--dk-accent); }
  .ge-nom { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .ge-role { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }

  .ge-fl { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .ge-tete { fill: var(--dk-encre); }
  .ge-gris { stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 8 7; }
  .ge-gris-t { fill: var(--dk-gris-2); }
  .ge-b1 { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .ge-b1.ge-rouge { fill: var(--dk-accent); }

  .ge-nuage { fill: var(--dk-fond-2); stroke: var(--dk-gris); stroke-width: 2.5; stroke-dasharray: 10 8; }
  .ge-eps-n { font-size: 46px; font-weight: 700; text-anchor: end; fill: var(--dk-accent); }
  .ge-autre { font-size: 21px; text-anchor: middle; fill: var(--dk-gris); }
  .ge-z { font-size: 21px; text-anchor: middle; fill: var(--dk-gris); transition: fill 0.4s, font-size 0.4s; }
  .ge-z.ge-z-on { font-size: 28px; font-weight: 700; fill: var(--dk-accent); }
  .ge-z.ge-z-q { font-size: 44px; font-weight: 700; }
  .ge-cap { font-size: 18px; fill: var(--dk-gris); }
  .ge-fin { text-anchor: end; }

  .ge-sup { stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 3 7; }
  .ge-croix-f { fill: var(--dk-fond); stroke: var(--dk-gris); stroke-width: 2.5; }
  .ge-croix { stroke: var(--dk-gris); stroke-width: 3; }
  .ge-hyp { font-size: 21px; fill: var(--dk-gris); }
  .ge-alerte { font-size: 26px; font-weight: 700; fill: var(--dk-accent); }
  .ge-hyp.ge-encre { fill: var(--dk-encre); font-weight: 600; }

  .ge-rouge-fl { stroke: var(--dk-accent); }
  .ge-epais { stroke-width: 5; }
  .ge-rouge-t { fill: var(--dk-accent); }
  .ge-trace { stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out; }
  .ge-trace.ge-vu { stroke-dashoffset: 0; }
  /* Pour la CES, la flèche reste une hypothèse : pointillée, une fois tracée. */
  .ge-trace.ge-pointille.ge-vu { stroke-dasharray: 0.03 0.02; }

  .ge-etape { opacity: 0; transition: opacity 0.3s; }
  .ge-etape.ge-vu { opacity: 1; transition: opacity 0.5s; }
  .ge-etape.ge-tard.ge-vu { transition: opacity 0.3s 0.7s; }

  @media (prefers-reduced-motion: reduce) {
    .ge-trace, .ge-etape, .ge-etape.ge-vu, .ge-etape.ge-tard.ge-vu { transition: none; }
  }
</style>
