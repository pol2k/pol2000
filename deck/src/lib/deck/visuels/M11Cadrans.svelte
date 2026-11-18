<script>
  /**
   * Un chemin du GOA dessiné comme une rangée de cadrans : chaque cadran
   * est notre estimé d'une variable. On observe le premier bout (son
   * aiguille bouge, en rouge) : quelles aiguilles suivent ? C'est la
   * définition d'Arel-Bundock (2021, p. 118, note 2) : l'information
   * circule entre A et C si observer A change notre estimé de C. Si
   * l'aiguille du dernier bout suit, les deux bouts « communiquent » : le
   * chemin est ouvert.
   *
   * Contrôler un maillon, c'est le fixer à une valeur connue (p. 120) : une
   * pince rouge bloque son aiguille. Ce que ça donne (goa.js, propagation,
   * testé) :
   *   - fourchette et chaîne : le maillon suit, puis l'autre bout; fixé,
   *     plus rien ne passe;
   *   - collision : le maillon suit (le premier bout le cause), l'autre bout
   *     reste immobile; fixé, l'autre bout se met à bouger, à l'envers (« elle
   *     a gagné en jouant mal : l'arbitre était sans doute biaisé », p. 122).
   *
   *   chemin  le chemin en toutes lettres, ex. « A ← B → C »;
   *   temps   un état par clic : { controles: ['B'], valeurs: { B: '35 °C' },
   *           note: '…', cache: true }; cache : la question seule (seul le
   *           premier bout bouge, un « ? » sur l'autre);
   *   types   true : le type de chaque maillon sous son cadran;
   *   taille  multiplie la largeur;
   *   haut    hauteur maximale du dessin (CSS).
   *
   * Schéma, aucune donnée. Le mouvement est en CSS, déterministe; sans
   * animation (prefers-reduced-motion), chaque aiguille reste penchée du
   * côté où elle irait.
   */
  import { brancherTemps } from '../temps.js';
  import { propagation } from '../goa.js';

  let { chemin = 'A → B → C', temps = [{}], types = true, taille = 1, haut = '44vh' } = $props();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote || temps.length < 2) return;
    e = 0;
    return brancherTemps(hote, { total: temps.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const s = $derived(temps[Math.min(e, temps.length - 1)] ?? {});
  const cache = $derived(!!s.cache);

  const toks = $derived(chemin.split(/\s*([←→])\s*/));
  const noeuds = $derived(toks.filter((_, i) => i % 2 === 0));
  const fleches = $derived(toks.filter((_, i) => i % 2 === 1));
  const aretes = $derived(fleches.map((f, i) => (f === '→' ? [noeuds[i], noeuds[i + 1]] : [noeuds[i + 1], noeuds[i]])));
  const etat = $derived(propagation(aretes, noeuds, s.controles ?? []));
  const NOMS = { fourchette: 'fourchette', chaine: 'chaîne', collision: 'collision' };
  const typeDe = (k) => {
    const [g, b, d] = [noeuds[k - 1], noeuds[k], noeuds[k + 1]];
    const versB = (x) => aretes.some(([p, q]) => p === x && q === b);
    return versB(g) && versB(d) ? 'collision' : !versB(g) && !versB(d) ? 'fourchette' : 'chaine';
  };

  // Géométrie : un cadran par nœud, des flèches entre les cadrans.
  const R = 78, Y0 = 210;
  const mots = $derived(noeuds.some((n) => n.length > 2));
  const PAS = $derived(mots ? 400 : 270);
  const G = $derived(mots ? 180 : 110);
  const xs = $derived(noeuds.map((_, i) => G + i * PAS));
  const W = $derived(xs.at(-1) + G);
  const H = $derived(Y0 + (types ? 150 : 115));

  // Un nom long se coupe en deux lignes, au milieu.
  const lignes = (t) => {
    if (t.length <= 12 || !t.includes(' ')) return [t];
    const m = t.split(' ');
    let best = 1, ecart = Infinity;
    for (let k = 1; k < m.length; k++) {
      const d = Math.abs(m.slice(0, k).join(' ').length - m.slice(k).join(' ').length);
      if (d < ecart) [best, ecart] = [k, d];
    }
    return [m.slice(0, best).join(' '), m.slice(best).join(' ')];
  };
  const indice = (t) => t.match(/^([A-Z])(\d)$/);

  const arc = (x) => {
    const a0 = (-70 * Math.PI) / 180, a1 = (70 * Math.PI) / 180;
    return `M ${x + R * Math.sin(a0)} ${Y0 - R * Math.cos(a0)} A ${R} ${R} 0 0 1 ${x + R * Math.sin(a1)} ${Y0 - R * Math.cos(a1)}`;
  };
  const TICKS = [-60, -30, 0, 30, 60];

  const cadrans = $derived(
    etat.map((n, k) => {
      const premier = k === 0, dernier = k === noeuds.length - 1;
      const masque = cache && !premier;
      const sens = masque ? 0 : n.sens;
      return {
        ...n, k, x: xs[k], premier, dernier, masque, sens,
        valeur: s.valeurs?.[n.id],
        type: !premier && !dernier ? typeDe(k) : null,
        statut: premier ? 'observé' : masque ? '' : n.fixe ? '' : sens === 1 ? 'suit' : sens === -1 ? 'suit à l’envers' : 'immobile'
      };
    })
  );
  const ouvert = $derived(!cache && etat.at(-1).sens !== 0);
  const fleche = (i) => {
    const x1 = xs[i] + R + 18, x2 = xs[i + 1] - R - 18, y = Y0 - 34;
    const vers = fleches[i] === '→';
    const [a, b] = vers ? [x1, x2] : [x2, x1];
    const sg = vers ? 1 : -1;
    return { d: `M ${a} ${y} L ${b - 14 * sg} ${y}`, pt: `${b},${y} ${b - 22 * sg},${y - 12} ${b - 22 * sg},${y + 12}` };
  };
</script>

<div class="visuel m11c" class:ouvert class:cache bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" style="max-width: {50 * taille}em; max-height: {haut}" role="img" aria-label="Le chemin {chemin}, en cadrans. On fait bouger {noeuds[0]}. {cache ? 'L’autre bout bouge-t-il ?' : ouvert ? `${noeuds.at(-1)} suit : les deux bouts communiquent, le chemin est ouvert.` : `${noeuds.at(-1)} ne bouge pas : les deux bouts ne communiquent pas, le chemin est fermé.`}">
    {#each fleches as _, i (i)}
      {@const f = fleche(i)}
      <path d={f.d} class="lien" />
      <polygon points={f.pt} class="pointe" />
    {/each}

    {#each cadrans as c (c.id)}
      {@const ix = indice(c.id)}
      {@const L = lignes(c.id)}
      <g class="cadran" class:premier={c.premier} class:fixe={c.fixe} class:bouge={c.sens !== 0} class:envers={c.sens === -1}>
        <!-- le nom -->
        {#each L as l, j (j)}
          <text x={c.x} y={Y0 - R - 26 - (L.length - 1 - j) * 32} class="nom">{#if ix}{ix[1]}<tspan class="ind" dy="8">{ix[2]}</tspan>{:else}{l}{/if}</text>
        {/each}

        <!-- le cadran -->
        <path d={arc(c.x)} class="arc" />
        {#each TICKS as t (t)}
          {@const a = (t * Math.PI) / 180}
          <line x1={c.x + (R - 14) * Math.sin(a)} y1={Y0 - (R - 14) * Math.cos(a)} x2={c.x + R * Math.sin(a)} y2={Y0 - R * Math.cos(a)} class="tick" />
        {/each}
        <line x1={c.x - R - 6} y1={Y0} x2={c.x + R + 6} y2={Y0} class="socle" />
        <g transform="translate({c.x} {Y0})">
          {#if !(c.masque && c.dernier)}
            <g class="aiguille" style="--d: {c.k * 0.06}s">
              <line x1="0" y1="0" x2="0" y2={-(R - 10)} />
            </g>
          {/if}
          <circle r="9" class="pivot" />
        </g>
        {#if c.masque && c.dernier}<text x={c.x} y={Y0 - 14} class="q">?</text>{/if}

        <!-- la pince : contrôler, c'est fixer à une valeur connue -->
        {#if c.fixe}
          <rect x={c.x - R - 16} y={Y0 - R - 12} width={2 * R + 32} height={R + 26} class="pince" />
          <text x={c.x} y={Y0 + 44} class="statut rouge">contrôlé</text>
          {#if c.valeur}<text x={c.x} y={Y0 + 78} class="valeur">{c.valeur}</text>{/if}
        {:else}
          <text x={c.x} y={Y0 + 44} class="statut" class:rouge={c.premier}>{c.statut}</text>
        {/if}
        {#if types && c.type && !cache}<text x={c.x} y={Y0 + (c.fixe && c.valeur ? 112 : 80)} class="type">{NOMS[c.type]}</text>{/if}
      </g>
    {/each}
  </svg>
  {#if cache}
    <p class="verdict"><strong>Communiquent-ils ?</strong></p>
  {:else}
    <p class="verdict"><strong>{ouvert ? 'Ouvert' : 'Fermé'}</strong><span>{ouvert ? 'les deux bouts communiquent' : 'les deux bouts ne communiquent pas'}</span></p>
  {/if}
  {#if s.note}<p class="note">{s.note}</p>{/if}
</div>

<style>
  .m11c { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.3em; }
  svg { width: 100%; height: auto; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .lien { stroke: var(--dk-encre); stroke-width: 5; }
  .pointe { fill: var(--dk-encre); }

  .nom { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .ind { font-size: 0.68em; }
  .arc { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 5; }
  .tick { stroke: var(--dk-encre); stroke-width: 3; }
  .socle { stroke: var(--dk-encre); stroke-width: 4; }
  .pivot { fill: var(--dk-encre); }
  .aiguille line { stroke: var(--dk-gris-2); stroke-width: 7; stroke-linecap: round; transition: stroke 0.3s; }
  .bouge .aiguille line { stroke: var(--dk-encre); }
  .premier .aiguille line, .premier .pivot { stroke: var(--dk-accent); fill: var(--dk-accent); }

  /* Le mouvement : le premier bout oscille, ceux qui suivent aussi, un
     peu après (l'information fait son chemin); à l'envers, en opposition. */
  .bouge .aiguille { animation: m11c-va 1.8s ease-in-out infinite alternate both; animation-delay: var(--d); }
  .bouge.envers .aiguille { animation-name: m11c-vient; }
  .fixe .aiguille { transform: rotate(28deg); }
  @keyframes m11c-va { from { transform: rotate(-48deg); } to { transform: rotate(48deg); } }
  @keyframes m11c-vient { from { transform: rotate(48deg); } to { transform: rotate(-48deg); } }

  .pince { fill: none; stroke: var(--dk-accent); stroke-width: 7; }
  .statut { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-gris-2); }
  .bouge .statut { fill: var(--dk-encre); }
  .statut.rouge { fill: var(--dk-accent); }
  .valeur { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .type { font-size: 22px; text-anchor: middle; fill: var(--dk-gris); }
  .q { font-size: 64px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }

  .verdict { margin: 0; display: flex; flex-wrap: wrap; justify-content: center; column-gap: 0.8em; align-items: baseline; text-align: center; }
  .verdict strong { font-size: 1.5em; color: var(--dk-gris); }
  .ouvert .verdict strong { color: var(--dk-accent); }
  .verdict span { font-size: 0.9em; color: var(--dk-gris); }
  .note { margin: 0; font-size: 0.95em; font-weight: 600; text-align: center; }

  @media (prefers-reduced-motion: reduce) {
    .bouge .aiguille { animation: none; transform: rotate(40deg); }
    .bouge.envers .aiguille { transform: rotate(-40deg); }
  }
</style>
