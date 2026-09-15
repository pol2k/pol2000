<script>
  /**
   * Deux variables catégorielles : le sexe et la survie des 1 313 passagers
   * du Titanic (src/lib/data/seance3.js). Un carré vaut dix passagers,
   * arrondi case par case.
   *
   *   0  Tous les carrés tombent dans un seul bloc, mêlés.
   *   1  Ils se séparent : les hommes à gauche, les femmes à droite.
   *   2  Ils se trient et se colorent : encre = mort.e.s, rouge = survivant.e.s.
   *   3  Le tableau croisé arrive, avec la part de survie de chaque ligne.
   *
   * L'ordre « mêlé » est une permutation fixe ((i × 37) mod 131) : aucun hasard.
   */
  import { untrack } from 'svelte';
  import { brancherTemps } from '../temps.js';
  import { TITANIC } from '$lib/data/seance3.js';
  let e = $state(0);
  let tour = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, {
      total: 3,
      lire: () => e,
      ecrire: (v) => untrack(() => { if (v === 0) tour += 1; e = v; })
    });
  });

  const T = TITANIC;
  const nb = (v) => v.toLocaleString('fr-CA');
  const hommes = T.hommes.morts + T.hommes.vivants;
  const femmes = T.femmes.morts + T.femmes.vivants;
  const total = hommes + femmes;
  const pct = (v, n) => `${Math.round((100 * v) / n)} %`;

  // Les carrés : hommes (mort.e.s puis survivant.e.s), puis femmes.
  const carres = [];
  const ajouter = (n, g, vivant) => { for (let k = 0; k < Math.round(n / 10); k++) carres.push({ g, vivant }); };
  ajouter(T.hommes.morts, 0, false);
  ajouter(T.hommes.vivants, 0, true);
  ajouter(T.femmes.morts, 1, false);
  ajouter(T.femmes.vivants, 1, true);
  const N = carres.length;

  const P = 26, S = 22, W = 680, H = 326;
  const COL0 = 14, GX = [40, 380], GY = 72;
  const melange = carres.map((_, i) => (i * 37) % N);
  // Rang dans le groupe : mêlé (temps 1) ou trié (temps 2 et 3).
  const rangMele = carres.map((c, i) => carres.filter((d, j) => d.g === c.g && melange[j] < melange[i]).length);
  const rangTrie = carres.map((c, i) => carres.filter((d, j) => d.g === c.g && j < i).length);
  const bloc0x = (W - COL0 * P) / 2;

  function position(i, temps) {
    if (temps === 0) {
      const r = melange[i];
      return [bloc0x + (r % COL0) * P, 52 + Math.floor(r / COL0) * P];
    }
    const r = temps === 1 ? rangMele[i] : rangTrie[i];
    return [GX[carres[i].g] + (r % 10) * P, GY + Math.floor(r / 10) * P];
  }
</script>

<div class="visuel titanic" bind:this={hote}>
  {#key tour}
    <svg viewBox="0 0 {W} {H}" class:trie={e >= 2} role="img" aria-label="Les 1 313 passagers du Titanic, un carré pour dix : 851 hommes, dont 142 ont survécu, et 462 femmes, dont 308 ont survécu.">
      <text x={W / 2} y="32" class="grp" class:vu={e === 0}>{nb(total)} passagers</text>
      <text x={GX[0] + 130} y="52" class="grp" class:vu={e >= 1}>Hommes · {nb(hommes)}</text>
      <text x={GX[1] + 130} y="52" class="grp" class:vu={e >= 1}>Femmes · {nb(femmes)}</text>
      {#each carres as c, i}
        {@const [px, py] = position(i, Math.min(e, 2))}
        <g class="case" style="transform: translate({px}px, {py}px); --i: {i}">
          <rect width={S} height={S} class="carre" class:vivant={c.vivant} style="--r: {melange[i]}" />
        </g>
      {/each}
      <g class="cles" class:vu={e >= 2}>
        <rect x={GX[1]} y="238" width="20" height="20" class="k mort" />
        <text x={GX[1] + 30} y="254" class="kt">mort.e.s</text>
        <rect x={GX[1]} y="272" width="20" height="20" class="k vif" />
        <text x={GX[1] + 30} y="288" class="kt">survivant.e.s</text>
      </g>
    </svg>
  {/key}

  <div class="tableau" class:vu={e >= 3}>
    <table>
      <thead>
        <tr><th></th><th class="num-c">mort.e.s</th><th class="num-c">survivant.e.s</th><th class="num-c">survie</th></tr>
      </thead>
      <tbody>
        <tr><td>Hommes</td><td class="num-c">{nb(T.hommes.morts)}</td><td class="num-c">{nb(T.hommes.vivants)}</td><td class="num-c"><span class="pct">{pct(T.hommes.vivants, hommes)}</span></td></tr>
        <tr><td>Femmes</td><td class="num-c">{nb(T.femmes.morts)}</td><td class="num-c">{nb(T.femmes.vivants)}</td><td class="num-c"><span class="pct">{pct(T.femmes.vivants, femmes)}</span></td></tr>
      </tbody>
    </table>
  </div>

  <p class="legende">Passagers du Titanic, 1912 · données du cours POL-2000, hiver 2024 · ▪ = 10 passagers</p>
</div>

<style>
  .titanic { display: grid; grid-template-columns: 1.4fr 1fr; gap: 0.6em 1.6em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }
  text { font-family: var(--dk-mono); }
  .grp { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.35s; }
  .grp.vu { opacity: 1; transition-delay: 0.35s; }

  .case {
    transition: transform 0.85s cubic-bezier(0.34, 1.3, 0.64, 1);
    transition-delay: calc(var(--i) * 4ms);
  }
  .carre {
    fill: var(--dk-gris-2);
    transform-box: fill-box;
    transform-origin: center;
    transition: fill 0.4s;
    animation: pop 0.35s cubic-bezier(0.34, 1.8, 0.64, 1) backwards;
    animation-delay: calc(var(--r) * 7ms);
  }
  .trie .carre { fill: var(--dk-encre); transition-delay: 0.5s; }
  .trie .carre.vivant { fill: var(--dk-accent); }

  .cles { opacity: 0; transition: opacity 0.4s; }
  .cles.vu { opacity: 1; transition-delay: 0.9s; }
  .k.mort { fill: var(--dk-encre); }
  .k.vif { fill: var(--dk-accent); }
  .kt { font-size: 17px; fill: var(--dk-gris); }

  .tableau {
    opacity: 0;
    transform: translateX(2em);
    transition: opacity 0.3s, transform 0.3s;
  }
  .tableau.vu {
    opacity: 1;
    transform: none;
    transition: opacity 0.5s, transform 0.7s cubic-bezier(0.34, 1.56, 0.64, 1);
  }
  .tableau table { font-size: 0.9em; }
  .pct { display: inline-block; color: var(--dk-accent); font-weight: 600; font-size: 1.35em; }
  .vu .pct { animation: pouls 1.3s ease-in-out 0.8s infinite; }

  .legende { grid-column: 1 / -1; margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }

  @keyframes pop { from { transform: scale(0); } }
  @keyframes pouls { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.18); } }

  @media (prefers-reduced-motion: reduce) {
    .grp, .case, .carre, .cles, .tableau, .pct { animation: none !important; transition: none !important; }
  }
</style>
