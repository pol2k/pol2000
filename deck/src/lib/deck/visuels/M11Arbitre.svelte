<script>
  /**
   * Contrôler une collision ouvre le chemin (Arel-Bundock 2021, p. 122),
   * avec son exemple : le jeu d'une équipe de hockey et le biais de
   * l'arbitre causent tous deux la victoire.
   *
   *   0  150 matchs fictifs : le jeu de l'équipe (axe horizontal) et le
   *      biais de l'arbitre (axe vertical) n'ont aucun lien. La droite est
   *      à plat;
   *   1  les victoires s'allument en rouge : elles sont en haut à droite
   *      (bien jouer, ou un arbitre favorable, ou les deux);
   *   2  on ne garde que les victoires (contrôler la victoire). Une droite
   *      qui descend apparaît : parmi les victoires, moins l'équipe a bien
   *      joué, plus l'arbitre l'a aidée;
   *   3  un match : une victoire en jouant mal. Alors l'arbitre l'a
   *      probablement aidée.
   *
   * Données fictives, tirées une fois pour toutes par un générateur
   * déterministe (graine fixe, aucun Math.random) : la même image à chaque
   * projection. Les deux droites sont des moindres carrés calculés ici sur
   * ces points fictifs.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Générateur de Park et Miller (graine fixe, entiers exacts en JS) et Box-Muller : des normales
  // reproductibles.
  let graine = 20261119;
  const unif = () => (graine = (graine * 16807) % 2147483647) / 2147483647;
  const normale = () => Math.sqrt(-2 * Math.log(unif())) * Math.cos(2 * Math.PI * unif());
  const MATCHS = Array.from({ length: 150 }, () => {
    const jeu = Math.max(-2.6, Math.min(2.6, normale()));
    const biais = Math.max(-2.6, Math.min(2.6, normale()));
    return { jeu, biais, victoire: jeu + biais > 0.9 };
  });
  const pente = (pts) => {
    const mx = pts.reduce((a, p) => a + p.jeu, 0) / pts.length;
    const my = pts.reduce((a, p) => a + p.biais, 0) / pts.length;
    const b = pts.reduce((a, p) => a + (p.jeu - mx) * (p.biais - my), 0) / pts.reduce((a, p) => a + (p.jeu - mx) ** 2, 0);
    return { b, a: my - b * mx };
  };
  const TOUS = pente(MATCHS);
  const VICT = pente(MATCHS.filter((m) => m.victoire));
  // Le match montré au temps 3 : la victoire la plus mal jouée.
  const ETOILE = MATCHS.filter((m) => m.victoire).reduce((p, m) => (m.jeu < p.jeu ? m : p));

  const G = 140, D = 1060, H = 40, B = 520;
  const px = (v) => G + ((v + 2.8) / 5.6) * (D - G);
  const py = (v) => B - ((v + 2.8) / 5.6) * (B - H);
  const droite = (l, x0, x1) => ({ x1: px(x0), y1: py(l.a + l.b * x0), x2: px(x1), y2: py(l.a + l.b * x1) });
  const DT = droite(TOUS, -2.6, 2.6);
  const DV = droite(VICT, -1.6, 2.6);

  const LEG = [
    '150 matchs. Le jeu de l’équipe et l’arbitre : aucun lien.',
    'Les victoires : bien jouer, ou un arbitre favorable.',
    'On ne regarde que les victoires : un lien apparaît.',
    'Gagner en jouant mal ? L’arbitre a dû aider.'
  ];
</script>

<div class="visuel m11a" bind:this={hote}>
  <svg viewBox="0 0 1100 600" role="img" aria-label="Un nuage de 150 matchs fictifs : le jeu de l’équipe et le biais de l’arbitre ne sont pas liés. Parmi les victoires seulement, une droite descendante apparaît : moins l’équipe a bien joué, plus l’arbitre l’a aidée.">
    <line x1={G} y1={B} x2={D} y2={B} class="axe" />
    <line x1={G} y1={B} x2={G} y2={H} class="axe" />
    <text x={(G + D) / 2} y={B + 50} class="titre-axe">jeu de l’équipe →</text>
    <text x={G - 30} y={(H + B) / 2} class="titre-axe" transform="rotate(-90 {G - 30} {(H + B) / 2})">biais de l’arbitre →</text>

    {#each MATCHS as m, i (i)}
      <circle cx={px(m.jeu)} cy={py(m.biais)} r="9" class="pt" class:v={m.victoire && e >= 1} class:efface={!m.victoire && e >= 2} />
    {/each}

    <line {...DT} class="droite" class:efface={e >= 2} />
    <line {...DV} class="droite rouge" class:vu={e >= 2} />

    <g class="etoile" class:vu={e >= 3}>
      <circle cx={px(ETOILE.jeu)} cy={py(ETOILE.biais)} r="24" />
      <text x={px(ETOILE.jeu) + 36} y={py(ETOILE.biais) - 20}>gagné en jouant mal</text>
    </g>
  </svg>
  <p class="legende"><b>{e + 1}</b>{LEG[e]}</p>
  <p class="cap">Données fictives</p>
</div>

<style>
  .m11a { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.25em; }
  svg { width: 100%; max-width: 46em; height: auto; max-height: 56vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 3; }
  .titre-axe { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .pt { fill: var(--dk-gris-2); transition: fill 0.4s, opacity 0.6s; }
  .pt.v { fill: var(--dk-accent); }
  .pt.efface { opacity: 0.08; }
  .droite { stroke: var(--dk-encre); stroke-width: 5; transition: opacity 0.5s; }
  .droite.efface { opacity: 0; }
  .droite.rouge { stroke: var(--dk-accent); stroke-width: 7; opacity: 0; }
  .droite.rouge.vu { opacity: 1; transition-delay: 0.5s; }
  .etoile { opacity: 0; transition: opacity 0.4s; }
  .etoile.vu { opacity: 1; }
  .etoile circle { fill: none; stroke: var(--dk-encre); stroke-width: 5; }
  .etoile text { font-size: 26px; font-weight: 700; fill: var(--dk-encre); }
  .legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  .cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .pt, .droite, .etoile { transition: none; } }
</style>
