<script>
  /**
   * « Qu'est-ce qui élargit la cloche ? », séance 7 : les trois ingrédients
   * de l'erreur type de la pente, un par temps. Chaque rangée : à gauche,
   * un petit schéma de ce qui change (pas des données); au centre, les
   * 1 000 pentes de 1 000 sondages faits de cette façon (tranches de 0,02);
   * à droite, leur écart type, l'erreur type (trois décimales).
   *
   * À armes égales : chaque sondage tire ici des personnes qui ont répondu
   * aux deux questions (ERREUR_TYPE, outils/seance7_data.R), sinon le nombre
   * de cas complets changerait d'une rangée à l'autre.
   *
   * Toutes les cloches ont la même échelle horizontale (on compare les
   * largeurs) et chacune est centrée sur sa propre moyenne. Raison : la
   * cloche « 0,5 ou 0,75 » n'est pas centrée sur −0,31 (moyenne −0,21 : la
   * satisfaction baisse moins entre ces deux niveaux, voir POP.moyennes).
   * Sur un axe commun, on la lirait comme un biais, ce n'est pas le propos
   * ici. Chaque rangée est aussi à sa propre échelle verticale (son plus
   * haut bâton touche le plafond) : c'est la largeur qui compte, pas la
   * hauteur.
   *
   *   0  Le point de départ : 1 000 sondages de 500 personnes
   *      (ERREUR_TYPE.base, 0,045).
   *   1  Moins de monde : 1 000 sondages de 50 (ERREUR_TYPE.petit, 0,146).
   *   2  De plus grosses erreurs de prédiction : les mêmes 1 000 sondages de
   *      500, dans des données modifiées où chaque personne est deux fois
   *      plus loin de la vraie droite (DOUBLE, 0,090, exactement deux fois
   *      0,045). Dit sur la diapo : « Données fictives ».
   *   3  X qui varie peu : 1 000 sondages de 500 parmi les personnes qui ont
   *      répondu 0,5 ou 0,75 au populisme seulement (ERREUR_TYPE.centre,
   *      0,096).
   *
   * Sources : ERREUR_TYPE (src/lib/data/seance7.js, outils/seance7_data.R);
   * DOUBLE (src/lib/data/seance7_d.js, outils/seance7_d.R). Les schémas de
   * gauche sont dessinés à la main, à titre d'illustration, et le disent.
   */
  import { brancherTemps } from '../temps.js';
  import { ERREUR_TYPE } from '$lib/data/seance7.js';
  import { DOUBLE } from '$lib/data/seance7_d.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const NN = ' ';
  const f = (v, d = 0) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, NN).replace('-', '−');

  // Les cloches : même échelle pour toutes, centrées sur leur moyenne.
  const CX = 700, PX = 340, L = 0.02, HMAX = 74;
  const moyenne = (v) => v.reduce((s, p) => s + p, 0) / v.length;
  function cloche(pentes) {
    const m = moyenne(pentes);
    const c = new Map();
    for (const p of pentes) {
      const k = Math.floor((p - m) / L + 0.5);
      c.set(k, (c.get(k) || 0) + 1);
    }
    const max = Math.max(...c.values());
    return [...c.entries()].map(([k, n]) => ({ x: CX + (k - 0.5) * L * PX, w: L * PX, h: (n / max) * HMAX }));
  }

  // Les schémas : une droite et des points, écarts fixés à la main.
  const ECARTS = [-9, 6, -3, 11, -7, 2, 9, -11, 4, -5, 8, -2, 10, -8];
  const schema = (n, ampleur, de, a) =>
    Array.from({ length: n }, (_, i) => {
      const t = n === 1 ? 0.5 : i / (n - 1);
      const xs = de + t * (a - de);
      return { x: xs, y: 20 + 0.38 * xs + ECARTS[(i * 3) % ECARTS.length] * ampleur };
    });

  const ET = ERREUR_TYPE;
  const RANGEES = [
    { quoi: `${f(ET.base.n)} personnes`, sous: 'notre point de départ', pentes: ET.base.pentes, et: ET.base.ecart_type,
      pts: schema(14, 0.65, 6, 114) },
    { quoi: `${f(ET.petit.n)} personnes`, sous: 'moins de monde', pentes: ET.petit.pentes, et: ET.petit.ecart_type,
      pts: schema(4, 0.65, 6, 114) },
    { quoi: 'erreurs 2 fois plus grandes', sous: 'Données fictives', pentes: DOUBLE.pentes, et: DOUBLE.ecart_type,
      pts: schema(14, 1.3, 6, 114) },
    { quoi: `populisme à ${ET.centre.bornes.map((b) => f(b, 2)).join(' ou ')}`, sous: 'X varie peu', pentes: ET.centre.pentes, et: ET.centre.ecart_type,
      pts: schema(14, 0.65, 48, 72) }
  ].map((r, i) => ({ ...r, y: 150 + i * 118, barres: cloche(r.pentes) }));

  const ARIA =
    `Ce qui élargit la cloche des pentes. ${RANGEES.map((r) => `${r.quoi} : erreur type ${f(r.et, 3)}`).join('. ')}. ` +
    `Moins de monde, de plus grosses erreurs de prédiction ou un X qui varie peu : plus d’incertitude.`;
</script>

<div class="visuel d7-ingredients" bind:this={hote}>
  <svg viewBox="0 0 1000 600" role="img" aria-label={ARIA}>
    <text x={CX} y="36" class="in-tete">pentes de {f(1000)} sondages</text>
    <text x="995" y="36" class="in-tete in-fin">erreur type</text>

    {#each RANGEES as r, i}
      <g class="in-rangee" class:in-vu={e >= i}>
        <!-- Le schéma. -->
        <g transform="translate(14 {r.y - 74})">
          <rect x="0" y="0" width="120" height="80" class="in-cadre" />
          <line x1="4" y1="21.5" x2="116" y2="64.1" class="in-droite" />
          {#each r.pts as p}
            <circle cx={p.x} cy={p.y} r="4" class="in-pt" />
          {/each}
        </g>
        <text x="152" y={r.y - 40} class="in-quoi" class:in-rouge={i > 0}>{r.quoi}</text>
        <text x="152" y={r.y - 12} class="in-sous">{r.sous}</text>

        <!-- La cloche. -->
        {#each r.barres as b}
          <rect x={b.x + 0.75} y={r.y - b.h} width={b.w - 1.5} height={b.h} class="in-baton" />
        {/each}
        <line x1={CX - 0.56 * PX} y1={r.y} x2={CX + 0.6 * PX} y2={r.y} class="in-axe" />
        <line x1={CX - r.et * PX} y1={r.y + 10} x2={CX + r.et * PX} y2={r.y + 10} class="in-regle" />

        <!-- Le nombre. -->
        <text x="995" y={r.y - 14} class="in-et" class:in-rouge={i > 0}>{f(r.et, 3)}</text>
      </g>
    {/each}

    <text x="14" y="592" class="in-note">à gauche, des schémas · chaque cloche est centrée sur sa moyenne{NN}: on compare les largeurs</text>
  </svg>
</div>

<style>
  .d7-ingredients { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 64vh; display: block; }
  text { font-family: var(--dk-mono); }

  .in-tete { font-size: 19px; text-anchor: middle; fill: var(--dk-gris); }
  .in-fin { text-anchor: end; }

  .in-cadre { fill: none; stroke: var(--dk-filet); stroke-width: 2; }
  .in-droite { stroke: var(--dk-encre); stroke-width: 2.5; }
  .in-pt { fill: var(--dk-gris); }
  .in-quoi { font-size: 23px; font-weight: 700; fill: var(--dk-encre); }
  .in-sous { font-size: 18px; fill: var(--dk-gris); }
  .in-rouge { fill: var(--dk-accent); }

  .in-baton { fill: var(--dk-encre); }
  .in-axe { stroke: var(--dk-filet); stroke-width: 2; }
  .in-regle { stroke: var(--dk-accent); stroke-width: 5; }
  .in-et { font-size: 36px; font-weight: 700; text-anchor: end; fill: var(--dk-encre); }

  .in-note { font-size: 16px; fill: var(--dk-gris); }

  .in-rangee { opacity: 0; transition: opacity 0.2s; }
  .in-rangee.in-vu { opacity: 1; transition: opacity 0.5s; }

  @media (prefers-reduced-motion: reduce) {
    .in-rangee, .in-rangee.in-vu { transition: none; }
  }
</style>
