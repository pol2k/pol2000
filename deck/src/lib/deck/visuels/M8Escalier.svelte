<script>
  /**
   * Une variable à la fois : toujours la même régression de l'intérêt sur la
   * scolarité, à laquelle on ajoute un contrôle à chaque clic (âge, femme,
   * revenu, Québec). Chaque rangée montre les ingrédients du modèle en
   * pastilles (Y ~ X + contrôles) et, à droite, le coefficient de la
   * scolarité dans ce modèle, avec son intervalle de confiance à 95 %.
   * Toujours les mêmes personnes (ESCALIER.n, les 877 du modèle complet de
   * la séance 7), pour que seule la liste de variables change.
   *
   *   0  la scolarité seule;
   *   1 à 4  une pastille de plus à chaque clic; le point rouge est le
   *          modèle courant, le cercle creux la position d'avant.
   *
   * Le trait pointillé vertical : la scolarité seule, pour voir la dérive.
   * L'axe va de 0,10 à 0,30 (un graphique à points, pas des barres : il n'a
   * pas à partir de zéro), pour que le déplacement se voie.
   * Rien n'est calculé ici : tout vient de ESCALIER (src/lib/data/seance8.js,
   * outils/seance8_data.R, section 1c). La première pente (0,194) n'est pas
   * celle du modèle 1 de la séance 7 (0,203, N 981) : ici, les 877 qui ont
   * répondu aux six questions.
   */
  import { brancherTemps } from '../temps.js';
  import { ESCALIER as E } from '$lib/data/seance8.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: E.modeles.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 3) => (v < 0 ? '−' : '') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });

  // Les pastilles : IBM Plex Mono, chasse fixe (0,6 em par caractère).
  const FS = 26, CH = FS * 0.6, PAD = 13, H = 42;
  const larg = (s) => s.length * CH + 2 * PAD;
  const CONTROLES = ['âge', 'femme', 'revenu', 'Québec'];
  const Y0 = 0, PLUS = 30, TILDE = 36;
  const xY = Y0, lY = larg('intérêt');
  const xX = xY + lY + TILDE, lX = larg('scolarité');
  const POS = [];
  {
    let x = xX + lX;
    for (const c of CONTROLES) { x += PLUS; POS.push({ nom: c, x, l: larg(c) }); x += larg(c); }
  }

  // Le graphique, à droite.
  const X0 = 1100, X1 = 1480, MIN = 0.1, MAX = 0.3;
  const gx = (v) => X0 + ((v - MIN) / (MAX - MIN)) * (X1 - X0);
  const RY = (i) => 128 + i * 88;
  const BAS = RY(4) + 44;
  const B0 = E.modeles[0].b;

  // Une flèche pleine, du point d'avant vers le point courant (polygone, pas de <marker>).
  function fleche(xa, xb, y) {
    const s = Math.sign(xb - xa);
    const pointe = xb - s * 13;
    return { ligne: [xa + s * 11, pointe], tri: `${pointe - s * 12},${y - 8} ${pointe},${y} ${pointe - s * 12},${y + 8}` };
  }
</script>

<div class="visuel m8e" bind:this={hote}>
  <svg viewBox="0 0 1600 640" role="img" aria-label="Toujours la même régression de l’intérêt sur la scolarité, un contrôle de plus à chaque étape. Coefficient de la scolarité : {E.modeles.map((m) => `${m.ajout} ${f(m.b)}`).join(', ')}.">
    <!-- En-têtes -->
    <text x={xY + lY / 2} y="50" class="m8e-ent m8e-c">Y</text>
    <text x={xX + lX / 2} y="50" class="m8e-ent m8e-c m8e-rouge">X</text>
    <text x={POS[0].x} y="50" class="m8e-ent">les contrôles</text>
    <text x={(X0 + X1) / 2} y="50" class="m8e-ent m8e-c">coefficient de la scolarité</text>

    <!-- Grille du graphique -->
    {#each [0.1, 0.15, 0.2, 0.25, 0.3] as t}
      <line x1={gx(t)} y1="78" x2={gx(t)} y2={BAS} class="m8e-grille" />
      <text x={gx(t)} y={BAS + 32} class="m8e-tick">{f(t, 2)}</text>
    {/each}
    <line x1={gx(B0)} y1="88" x2={gx(B0)} y2={BAS} class="m8e-ref" />

    {#each E.modeles as m, i}
      {@const y = RY(i)}
      {@const courant = i === e}
      <g class="m8e-rang" class:m8e-vu={e >= i} class:m8e-passe={e > i}>
        <!-- Le modèle, en pastilles -->
        <rect x={xY} y={y - H / 2} width={lY} height={H} class="m8e-p m8e-py" />
        <text x={xY + lY / 2} y={y + 9} class="m8e-pt m8e-c">intérêt</text>
        <text x={xX - TILDE / 2} y={y + 9} class="m8e-op m8e-c">~</text>
        <rect x={xX} y={y - H / 2} width={lX} height={H} class="m8e-p m8e-px" />
        <text x={xX + lX / 2} y={y + 9} class="m8e-pt m8e-c m8e-blanc">scolarité</text>
        {#each POS.slice(0, i) as c, k}
          {@const neuf = k === i - 1}
          <g class:m8e-neuf={neuf && courant}>
            <text x={c.x - PLUS / 2} y={y + 9} class="m8e-op m8e-c">+</text>
            <rect x={c.x} y={y - H / 2} width={c.l} height={H} class="m8e-p m8e-pc" />
            <text x={c.x + c.l / 2} y={y + 9} class="m8e-pt m8e-c m8e-ptc">{c.nom}</text>
          </g>
        {/each}

        <!-- Le coefficient de la scolarité dans ce modèle -->
        <line x1={gx(m.bas)} y1={y} x2={gx(m.haut)} y2={y} class="m8e-ic" />
        {#if courant && i > 0 && Math.abs(m.b - E.modeles[i - 1].b) > 0.003}
          {@const fl = fleche(gx(E.modeles[i - 1].b), gx(m.b), y)}
          <circle cx={gx(E.modeles[i - 1].b)} cy={y} r="10" class="m8e-avant" />
          <line x1={fl.ligne[0]} y1={y} x2={fl.ligne[1]} y2={y} class="m8e-fl" />
          <polygon points={fl.tri} class="m8e-fl-p" />
        {/if}
        <circle cx={gx(m.b)} cy={y} r="13" class="m8e-pt-b" class:m8e-pt-courant={courant} />
        <text x="1580" y={y + 10} class="m8e-b" class:m8e-b-courant={courant}>{f(m.b)}</text>
      </g>
    {/each}

    <text x="0" y="630" class="m8e-source">Notre sondage de la séance 7 · les mêmes {E.n} personnes dans les cinq modèles · trait : intervalle de confiance à 95{' '}%</text>
  </svg>
</div>

<style>
  .m8e { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 68vh; display: block; }
  text { font-family: var(--dk-mono); }
  .m8e-c { text-anchor: middle; }
  .m8e-ent { font-size: 21px; font-weight: 600; fill: var(--dk-gris); letter-spacing: 0.04em; }
  .m8e-ent.m8e-rouge { fill: var(--dk-accent); }
  .m8e-grille { stroke: var(--dk-filet); stroke-width: 1.5; }
  .m8e-tick { font-size: 20px; fill: var(--dk-gris); text-anchor: middle; }
  .m8e-ref { stroke: var(--dk-gris-2); stroke-width: 2; stroke-dasharray: 6 6; }

  .m8e-p { stroke-width: 2; }
  .m8e-py { fill: var(--dk-fond); stroke: var(--dk-encre); }
  .m8e-px { fill: var(--dk-accent); stroke: var(--dk-accent); }
  .m8e-pc { fill: var(--dk-fond); stroke: var(--dk-gris-2); transition: fill 0.4s, stroke 0.4s; }
  .m8e-pt { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .m8e-pt.m8e-blanc { fill: #fff; }
  .m8e-ptc { fill: var(--dk-gris); transition: fill 0.4s; }
  .m8e-op { font-size: 26px; font-weight: 600; fill: var(--dk-gris); }
  .m8e-neuf .m8e-pc { fill: var(--dk-encre); stroke: var(--dk-encre); }
  .m8e-neuf .m8e-ptc { fill: var(--dk-fond); }
  .m8e-neuf { animation: m8e-pop 0.5s ease-out both; }

  .m8e-ic { stroke: var(--dk-gris-2); stroke-width: 4; }
  .m8e-pt-b { fill: var(--dk-gris-2); transition: fill 0.4s; }
  .m8e-pt-b.m8e-pt-courant { fill: var(--dk-accent); }
  .m8e-avant { fill: var(--dk-fond); stroke: var(--dk-gris-2); stroke-width: 2.5; }
  .m8e-fl { stroke: var(--dk-accent); stroke-width: 3; }
  .m8e-fl-p { fill: var(--dk-accent); }
  .m8e-b { font-size: 26px; font-weight: 600; fill: var(--dk-gris); text-anchor: end; font-variant-numeric: tabular-nums; }
  .m8e-b.m8e-b-courant { fill: var(--dk-accent); font-weight: 700; }
  .m8e-source { font-size: 18px; fill: var(--dk-gris); }

  .m8e-rang { opacity: 0; transition: opacity 0.45s; }
  .m8e-rang.m8e-vu { opacity: 1; }
  .m8e-rang.m8e-passe .m8e-py, .m8e-rang.m8e-passe .m8e-px { opacity: 0.55; }
  .m8e-rang.m8e-passe .m8e-pt { opacity: 0.7; }

  @keyframes m8e-pop { from { opacity: 0; transform: translateX(-14px); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .m8e-rang, .m8e-pc, .m8e-ptc, .m8e-pt-b { transition: none; }
    .m8e-neuf { animation: none; }
  }
</style>
