<script>
  /**
   * Les trois modèles en un graphe qui se construit (demande du professeur) :
   * on part du modèle 1 et on le transforme, pas à pas, jusqu'au modèle 3.
   * Mêmes conventions que M8DeuxRegles (Arel-Bundock 2021, ch. 6) : flèches
   * de la cause vers l'effet, flux de points (Flux.svelte), variables
   * contrôlées encadrées, chemins bloqués coupés.
   *
   *   0  modèle 1 : gagner → satisfaction après. Tout l'écart passe pour
   *      l'effet de gagner;
   *   1  une porte arrière : la satisfaction avant pousse le vote (pour le
   *      gouvernement sortant) et la satisfaction après (flux rouge). Les
   *      gagnants étaient déjà plus satisfaits avant (AVANT_APRES);
   *   2  modèle 2 : on contrôle la satisfaction avant. Elle est encadrée,
   *      ses chemins coupés;
   *   3  leur note 1 : l'élection de 2021 pousse le vote de 2025, la
   *      satisfaction avant (chemin déjà bloqué) et la satisfaction après
   *      (chemin encore ouvert);
   *   4  modèle 3 : on contrôle le vote de 2021. Seul reste gagner →
   *      satisfaction après.
   *
   * Le graphe est un schéma (nos hypothèses, pas des données). Les
   * coefficients de gagnant, à droite, viennent de COEFS (outils/seance8_data.R).
   */
  import { fade } from 'svelte/transition';
  import { brancherTemps } from '../temps.js';
  import { COEFS, AVANT_APRES as AA } from '$lib/data/seance8.js';
  import Flux from './Flux.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const W = 230, H = 88;
  const X = { cx: 150, cy: 390 }, Y = { cx: 670, cy: 390 };
  const A = { cx: 410, cy: 230 }, P = { cx: 150, cy: 70 };

  // Une flèche droite (ou courbe, avec un point de contrôle) : tracé sans
  // la pointe, pointe, longueur approchée, fraction de la coupure (milieu).
  function fleche(ax, ay, bx, by, q = null, pointe = 20) {
    const [tx, ty] = q ? [bx - q[0], by - q[1]] : [bx - ax, by - ay];
    const lt = Math.hypot(tx, ty), ux = tx / lt, uy = ty / lt;
    const px = bx - ux * pointe, py = by - uy * pointe;
    const nx = -uy * pointe * 0.5, ny = ux * pointe * 0.5;
    const d = q ? `M ${ax} ${ay} Q ${q[0]} ${q[1]} ${px} ${py}` : `M ${ax} ${ay} L ${px} ${py}`;
    const long = q ? (Math.hypot(q[0] - ax, q[1] - ay) + Math.hypot(px - q[0], py - q[1])) * 0.92 : Math.hypot(px - ax, py - ay);
    // Le milieu du tracé, et la coupure perpendiculaire.
    const mx = q ? 0.25 * ax + 0.5 * q[0] + 0.25 * px : (ax + px) / 2;
    const my = q ? 0.25 * ay + 0.5 * q[1] + 0.25 * py : (ay + py) / 2;
    const [dx, dy] = q ? [px - ax, py - ay] : [tx, ty];
    const ld = Math.hypot(dx, dy), vx = dx / ld, vy = dy / ld;
    return { d, long, coupe: 0.47, tete: `${bx},${by} ${px + nx},${py + ny} ${px - nx},${py - ny}`,
      cut: { x1: mx - vy * 20, y1: my + vx * 20, x2: mx + vy * 20, y2: my - vx * 20 } };
  }
  const XY = fleche(X.cx + W / 2 + 6, X.cy, Y.cx - W / 2 - 6, Y.cy);
  const AX = fleche(A.cx - 80, A.cy + H / 2 + 6, X.cx + 50, X.cy - H / 2 - 6);
  const AY = fleche(A.cx + 80, A.cy + H / 2 + 6, Y.cx - 50, Y.cy - H / 2 - 6);
  const PX = fleche(P.cx, P.cy + H / 2 + 6, X.cx, X.cy - H / 2 - 16);
  const PA = fleche(P.cx + 90, P.cy + H / 2 + 6, A.cx - 90, A.cy - H / 2 - 16);
  const PY = fleche(P.cx + W / 2 + 6, P.cy - 10, Y.cx + 10, Y.cy - H / 2 - 16, [650, 50]);
  const VIT = 95;
  const duree = (f) => f.long / VIT;

  const g = (m) => COEFS[m].find((c) => c.terme === 'gagnant').b;
  const f3 = (b) => b.toFixed(3).replace('.', ',');
  const f2 = (b) => b.toFixed(2).replace('.', ',');
  const N = ' ';
  const MOD = $derived(e <= 1 ? 0 : e <= 3 ? 1 : 2);
  const MODELES = [
    { nom: 'Modèle 1 · l’écart brut', base: 'apres ~ gagnant', ajout: '', b: g('modele1'), avant: null },
    { nom: 'Modèle 2 · leur modèle', base: 'apres ~ gagnant', ajout: ' + avant', b: g('modele2'), avant: g('modele1') },
    { nom: 'Modèle 3 · le nôtre', base: 'apres ~ gagnant + avant', ajout: ' + gagnant_2021', b: g('modele3'), avant: g('modele2') }
  ];
  const NOTES = [
    'Tout l’écart passe pour l’effet de gagner.',
    `Une porte arrière${N}: les gagnants étaient déjà plus satisfaits avant (${f2(AA.gagnants.avant)} contre ${f2(AA.perdants.avant)}).`,
    `Satisfaction avant contrôlée${N}: sa porte arrière est fermée.`,
    `Leur note 1${N}: l’élection de 2021. Le chemin par la satisfaction avant est déjà fermé, pas le chemin direct.`,
    `Vote de 2021 contrôlé${N}: il ne reste que gagner → satisfaction après.`
  ];
</script>

{#snippet boite(b, l1, l2, role, cls = '')}
  <rect x={b.cx - W / 2} y={b.cy - H / 2} width={W} height={H} class="m8g-boite {cls}" />
  <text x={b.cx} y={b.cy - 8} class="m8g-nom">{l1}</text>
  <text x={b.cx} y={b.cy + 20} class="m8g-nom">{l2}</text>
  {#if role}<text x={b.cx} y={b.cy + H / 2 + 26} class="m8g-role">{role}</text>{/if}
{/snippet}

{#snippet coupe(f, on)}
  <line x1={f.cut.x1} y1={f.cut.y1} x2={f.cut.x2} y2={f.cut.y2} class="m8g-cut m8g-etape" class:m8g-vu={on} />
{/snippet}

<div class="visuel m8g" bind:this={hote}>
  <svg viewBox="0 0 820 470" role="img" aria-label="Schéma. Modèle 1 : gagner pointe vers la satisfaction après. Une porte arrière : la satisfaction avant pointe vers gagner et vers la satisfaction après. Modèle 2 : on la contrôle, la porte se ferme. Leur note 1 : gagner en 2021 pointe vers gagner en 2025, vers la satisfaction avant et vers la satisfaction après. Modèle 3 : on le contrôle aussi. Il ne reste que gagner vers satisfaction après.">
    <!-- X → Y, toujours -->
    <path d={XY.d} class="m8g-fl m8g-epais" />
    <polygon points={XY.tete} class="m8g-pointe" />
    <Flux d={XY.d} n={3} duree={duree(XY)} r={8} />

    <!-- La satisfaction avant : porte arrière -->
    <g class="m8g-etape" class:m8g-vu={e >= 1}>
      <path d={AX.d} class="m8g-fl m8g-rouge" class:m8g-pale={e >= 2} />
      <polygon points={AX.tete} class="m8g-pointe m8g-rouge-t" class:m8g-pale={e >= 2} />
      <path d={AY.d} class="m8g-fl m8g-rouge" class:m8g-pale={e >= 2} />
      <polygon points={AY.tete} class="m8g-pointe m8g-rouge-t" class:m8g-pale={e >= 2} />
      {@render coupe(AX, e >= 2)}
      {@render coupe(AY, e >= 2)}
      <Flux d={AX.d} actif={e >= 1} rouge arret={e >= 2 ? AX.coupe : 1} n={2} duree={duree(AX)} r={7} />
      <Flux d={AY.d} actif={e >= 1} rouge arret={e >= 2 ? AY.coupe : 1} n={2} duree={duree(AY)} r={7} />
      {@render boite(A, 'satisfaction', 'avant', '')}
      <rect x={A.cx - W / 2 - 10} y={A.cy - H / 2 - 10} width={W + 20} height={H + 20} class="m8g-cadre m8g-etape" class:m8g-vu={e >= 2} />
    </g>

    <!-- L'élection de 2021 : leur note 1 -->
    <g class="m8g-etape" class:m8g-vu={e >= 3}>
      <path d={PX.d} class="m8g-fl m8g-rouge" class:m8g-pale={e >= 4} />
      <polygon points={PX.tete} class="m8g-pointe m8g-rouge-t" class:m8g-pale={e >= 4} />
      <path d={PA.d} class="m8g-fl m8g-rouge m8g-pale" />
      <polygon points={PA.tete} class="m8g-pointe m8g-rouge-t m8g-pale" />
      <path d={PY.d} class="m8g-fl m8g-rouge" class:m8g-pale={e >= 4} />
      <polygon points={PY.tete} class="m8g-pointe m8g-rouge-t" class:m8g-pale={e >= 4} />
      {@render coupe(PX, e >= 4)}
      {@render coupe(PY, e >= 4)}
      <Flux d={PX.d} actif={e >= 3} rouge arret={e >= 4 ? PX.coupe : 1} n={2} duree={duree(PX)} r={7} />
      <Flux d={PA.d} actif={e >= 3} rouge arret={0.97} n={1} duree={duree(PA)} r={7} />
      <Flux d={PY.d} actif={e >= 3} rouge arret={e >= 4 ? PY.coupe : 1} n={3} duree={duree(PY)} r={7} />
      {@render boite(P, 'gagner', 'en 2021', '')}
      <rect x={P.cx - W / 2 - 10} y={P.cy - H / 2 - 10} width={W + 20} height={H + 20} class="m8g-cadre m8g-etape" class:m8g-vu={e >= 4} />
    </g>

    {@render boite(X, 'gagner', 'en 2025', 'X')}
    {@render boite(Y, 'satisfaction', 'après', 'Y')}
  </svg>

  <div class="m8g-panneau">
    {#key MOD}
      <div class="m8g-mod" in:fade={{ duration: 400 }}>
        <span class="m8g-eti">{MODELES[MOD].nom}</span>
        <code class="m8g-f">lm({MODELES[MOD].base}<span class="m8g-ajout">{MODELES[MOD].ajout}</span>)</code>
        <p class="m8g-b">
          {#if MODELES[MOD].avant !== null}<span class="m8g-ancien">{f3(MODELES[MOD].avant)}</span>{' → '}{/if}{f3(MODELES[MOD].b)}
        </p>
        <span class="m8g-sous">coefficient de gagnant</span>
      </div>
    {/key}
    {#key e}
      <p class="m8g-note" in:fade={{ duration: 400, delay: 200 }}>{NOTES[e]}</p>
    {/key}
  </div>
</div>

<style>
  .m8g { display: grid; grid-template-columns: minmax(0, 1.55fr) minmax(0, 1fr); gap: 1.6em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 64vh; display: block; }
  text { font-family: var(--dk-mono); }
  .m8g-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .m8g-nom { font-size: 25px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m8g-role { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); font-weight: 600; }
  .m8g-fl { fill: none; stroke: var(--dk-encre); stroke-width: 4; transition: opacity 0.5s; }
  .m8g-epais { stroke-width: 7; }
  .m8g-pointe { fill: var(--dk-encre); transition: opacity 0.5s; }
  .m8g-rouge { stroke: var(--dk-accent); }
  .m8g-rouge-t { fill: var(--dk-accent); }
  .m8g-pale { opacity: 0.35; }
  .m8g-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 5; }
  .m8g-cut { stroke: var(--dk-accent); stroke-width: 7; }
  .m8g-etape { opacity: 0; transition: opacity 0.4s; }
  .m8g-etape.m8g-vu { opacity: 1; transition: opacity 0.6s; }

  .m8g-panneau { display: flex; flex-direction: column; gap: 1em; }
  .m8g-mod { display: flex; flex-direction: column; gap: 0.35em; border-left: 8px solid var(--dk-accent); padding-left: 0.9em; }
  .m8g-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m8g-f { font-family: var(--dk-mono); font-size: 0.78em; font-weight: 600; overflow-wrap: anywhere; }
  .m8g-ajout { color: var(--dk-accent); }
  .m8g-b { margin: 0.1em 0 0; font-size: 2.2em; font-weight: 700; line-height: 1; color: var(--dk-accent); }
  .m8g-ancien { color: var(--dk-gris-2); }
  .m8g-sous { font-size: 0.7em; color: var(--dk-gris); }
  .m8g-note { margin: 0; font-size: 0.95em; line-height: 1.4; font-weight: 600; }
  @media (prefers-reduced-motion: reduce) { .m8g-fl, .m8g-pointe, .m8g-etape, .m8g-etape.m8g-vu { transition: none; } }
</style>
