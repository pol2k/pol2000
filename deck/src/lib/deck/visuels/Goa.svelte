<script>
  /**
   * Un graphe orienté acyclique (GOA), dessiné à partir d'une définition de
   * src/lib/data/seance11-goa.js et piloté au clic (brancherTemps). Mêmes
   * conventions que M8DeuxRegles et M8DagModeles : des boîtes, des flèches
   * de la cause vers l'effet, une variable contrôlée encadrée en rouge
   * (Arel-Bundock 2021, figure 6.1), des points qui voyagent pour l'effet
   * causal (Flux.svelte).
   *
   * Deux signaux, jamais confondus :
   *   - l'effet causal : les points du flux, toujours de la cause vers
   *     l'effet. Une variable contrôlée ne varie plus : les points qui y
   *     arrivent s'arrêtent à son cadre, rien n'en repart;
   *   - l'information statistique : le chemin surligné (état `chemin`)
   *     s'allume en entier, d'un bout à l'autre, en rouge et d'un seul
   *     battement quand il est ouvert. Fermé, il est gris et pointillé, et
   *     une coupure marque chaque maillon qui le bloque.
   * Ouvert ou fermé n'est jamais écrit à la main : goa.js le calcule
   * (etatChemin) à partir des flèches et des variables contrôlées.
   *
   *   graphe   une entrée de GOA : { noeuds, aretes };
   *   temps    un état par clic (un seul état : aucun clic). Un état :
   *              voir      ids des nœuds visibles (défaut : tous);
   *              aretes    index des flèches visibles (défaut : toutes);
   *              controles ids encadrés (contrôlés);
   *              barres    ids marqués d'un ✕ rouge (à ne pas contrôler);
   *              accent    ids dont la boîte est rouge;
   *              rouges    index des flèches dessinées en rouge;
   *              chemin    ids, d'une extrémité à l'autre : le chemin lu;
   *              types     true : sous chaque maillon du chemin, son type;
   *              verdict   false : pas de verdict sous le graphe;
   *              court     true : le verdict sans sa glose;
   *              note      quelques mots après le verdict;
   *              flux      true (toutes) ou index des flèches avec le flux;
   *              coefs     true : les coefficients sur les flèches;
   *   taille   multiplie la taille du dessin (1 : texte ≈ 1,35 fois le corps du deck);
   *   haut     hauteur maximale du dessin (CSS);
   *   legende  ligne grise sous le graphe.
   *
   * L'image de repos de chaque état ne dépend que de l'état : un clic
   * rapide ou un retour en arrière tombe toujours sur la bonne image.
   * Coordonnées fixes, aucun hasard.
   */
  import { brancherTemps } from '../temps.js';
  import { etatChemin } from '../goa.js';
  import Flux from './Flux.svelte';

  let { graphe, temps = [{}], taille = 1, haut = '54vh', legende = '' } = $props();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote || temps.length < 2) return;
    e = 0;
    return brancherTemps(hote, { total: temps.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const s = $derived(temps[Math.min(e, temps.length - 1)] ?? {});

  // ---------- géométrie (unités du viewBox)
  const F = 30; // corps du texte
  const LH = 38; // interligne
  const PX = 18, PY = 13; // marges dans la boîte
  const ECART = 20; // entre la boîte et la flèche : la place du cadre
  const POINTE = 20;

  const lignes = (label) => label.split('\n');
  const nbCar = (l) => l.replace(/_/g, '').length;
  const morceaux = (l) => l.split(/(_\d)/).filter(Boolean).map((m) => (m.startsWith('_') ? { t: m.slice(1), indice: true } : { t: m, indice: false }));

  const N = $derived(
    Object.fromEntries(
      graphe.noeuds.map((n) => {
        const ls = lignes(n.label);
        const w = Math.max(...ls.map(nbCar)) * F * 0.6 + 2 * PX;
        const h = ls.length * LH + 2 * PY - (LH - F);
        return [n.id, { ...n, ls, w, h }];
      })
    )
  );

  // Distance du centre au bord de la boîte, dans la direction (ux, uy).
  const bord = (n, ux, uy) => Math.min(ux ? n.w / 2 / Math.abs(ux) : Infinity, uy ? n.h / 2 / Math.abs(uy) : Infinity);

  const F_ = $derived(
    graphe.aretes.map(([de, vers, coef], i) => {
      const A = N[de], B = N[vers];
      const dx = B.x - A.x, dy = B.y - A.y, L = Math.hypot(dx, dy);
      const ux = dx / L, uy = dy / L;
      const ta = bord(A, ux, uy) + ECART, tb = bord(B, ux, uy) + ECART;
      const ax = A.x + ux * ta, ay = A.y + uy * ta;
      const bx = B.x - ux * tb, by = B.y - uy * tb;
      const px = bx - ux * POINTE, py = by - uy * POINTE;
      const nx = -uy * POINTE * 0.5, ny = ux * POINTE * 0.5;
      const long = Math.hypot(px - ax, py - ay);
      // La coupure d'un maillon fermé : près du nœud d'arrivée ou de départ.
      const coupe = (t) => {
        const cx = ax + (bx - ax) * t, cy = ay + (by - ay) * t;
        return { x1: cx - uy * 22, y1: cy + ux * 22, x2: cx + uy * 22, y2: cy - ux * 22 };
      };
      return {
        i, de, vers, coef,
        d: `M ${ax} ${ay} L ${px} ${py}`,
        tete: `${bx},${by} ${px + nx},${py + ny} ${px - nx},${py - ny}`,
        long,
        mx: (ax + bx) / 2 - uy * 30, my: (ay + by) / 2 + ux * 30,
        coupeVers: coupe(0.72), coupeDe: coupe(0.28)
      };
    })
  );

  // Le cadre du dessin : toutes les boîtes, avec la place des cadres, des
  // badges et des étiquettes de type.
  const VB = $derived.by(() => {
    const ns = Object.values(N);
    const x0 = Math.min(...ns.map((n) => n.x - n.w / 2)) - 40;
    const x1 = Math.max(...ns.map((n) => n.x + n.w / 2)) + 40;
    const y0 = Math.min(...ns.map((n) => n.y - n.h / 2)) - 40;
    const bas = temps.some((t) => t.types) ? 70 : 40;
    const y1 = Math.max(...ns.map((n) => n.y + n.h / 2)) + bas;
    return { x: x0, y: y0, w: x1 - x0, h: y1 - y0 };
  });

  // ---------- l'état courant
  const has = (liste, v) => (liste ?? []).includes(v);
  const voitN = (id) => !s.voir || s.voir.includes(id);
  const voitA = (a) => (!s.aretes || s.aretes.includes(a.i)) && voitN(a.de) && voitN(a.vers);
  const ctrl = $derived(s.controles ?? []);

  const lecture = $derived(s.chemin ? etatChemin(graphe.aretes, s.chemin, ctrl) : null);
  const surChemin = $derived.by(() => {
    if (!s.chemin) return new Set();
    const out = new Set();
    for (let k = 0; k < s.chemin.length - 1; k++) {
      const p = s.chemin[k], q = s.chemin[k + 1];
      const a = F_.find((f) => (f.de === p && f.vers === q) || (f.de === q && f.vers === p));
      if (a) out.add(a.i);
    }
    return out;
  });
  // Les maillons qui bloquent : une coupure sur la flèche du chemin qui y entre.
  const coupures = $derived.by(() => {
    if (!lecture) return [];
    const out = [];
    lecture.maillons.forEach((m, k) => {
      if (m.ouvert) return;
      const avant = s.chemin[k];
      const a = F_.find((f) => (f.de === avant && f.vers === m.id) || (f.de === m.id && f.vers === avant));
      if (a) out.push(a.vers === m.id ? a.coupeVers : a.coupeDe);
    });
    return out;
  });
  const fluxSur = (a) => s.flux === true || (Array.isArray(s.flux) && s.flux.includes(a.i));
  const virgule = (c) => String(c).replace('.', ',');
  const TYPES = { fourchette: 'fourchette', chaine: 'chaîne', collision: 'collision' };

  const aria = $derived(
    legende ||
      'Graphe : ' + graphe.aretes.map(([p, q]) => `${N[p].ls.join(' ').replace(/_/g, '')} cause ${N[q].ls.join(' ').replace(/_/g, '')}`).join(', ') + '.'
  );
</script>

<div class="visuel goa" bind:this={hote}>
  <svg
    viewBox="{VB.x} {VB.y} {VB.w} {VB.h}"
    style="width: {(VB.w * taille * 1.35) / F}em; max-height: {haut};"
    role="img"
    aria-label={aria}
  >
    <!-- les flèches -->
    {#each F_ as a (a.i)}
      {@const etat = surChemin.has(a.i) ? (lecture.ouvert ? 'ouvert' : 'ferme') : has(s.rouges, a.i) ? 'rouge' : ''}
      <g class="goa-a {etat}" class:cache={!voitA(a)}>
        <path d={a.d} class="goa-fl" />
        <polygon points={a.tete} class="goa-pt" />
      </g>
    {/each}

    <!-- l'effet causal : les points, de la cause vers l'effet -->
    {#each F_ as a (a.i)}
      {#if fluxSur(a)}
        <Flux d={a.d} actif={voitA(a) && !ctrl.includes(a.de)} arret={ctrl.includes(a.vers) ? 0.97 : 1} n={2} duree={a.long / 95} r={7} />
      {/if}
    {/each}

    <!-- les coupures des maillons qui ferment le chemin -->
    {#each coupures as c, k (k)}
      <line {...c} class="goa-cut" />
    {/each}

    <!-- les coefficients -->
    {#if s.coefs}
      {#each F_ as a (a.i)}
        {#if a.coef !== undefined && voitA(a)}
          <text x={a.mx} y={a.my + 9} class="goa-coef">{virgule(a.coef)}</text>
        {/if}
      {/each}
    {/if}

    <!-- les nœuds -->
    {#each Object.values(N) as n (n.id)}
      <g class="goa-n" class:cache={!voitN(n.id)}>
        <rect x={n.x - n.w / 2} y={n.y - n.h / 2} width={n.w} height={n.h} class="goa-boite" class:accent={has(s.accent, n.id)} />
        {#each n.ls as l, k (k)}
          <text x={n.x} y={n.y - ((n.ls.length - 1) * LH) / 2 + k * LH + F * 0.35} class="goa-nom" class:accent={has(s.accent, n.id)}>
            {#each morceaux(l) as m, j (j)}{#if m.indice}<tspan class="goa-ind" dy="8">{m.t}</tspan><tspan dy="-8">&#8203;</tspan>{:else}{m.t}{/if}{/each}
          </text>
        {/each}
        <rect x={n.x - n.w / 2 - 11} y={n.y - n.h / 2 - 11} width={n.w + 22} height={n.h + 22} class="goa-cadre" class:vu={ctrl.includes(n.id)} />
        <g transform="translate({n.x + n.w / 2 + 11} {n.y - n.h / 2 - 11})" class="goa-badge" class:vu={has(s.barres, n.id)}>
          <rect x="-20" y="-20" width="40" height="40" />
          <path d="M -9 -9 L 9 9 M 9 -9 L -9 9" />
        </g>
      </g>
    {/each}

    <!-- le type de chaque maillon du chemin -->
    {#if lecture && s.types}
      {#each lecture.maillons as m (m.id)}
        <text x={N[m.id].x} y={N[m.id].y + N[m.id].h / 2 + 46} class="goa-type" class:ouvert={m.ouvert}>{TYPES[m.type]}</text>
      {/each}
    {/if}
  </svg>

  {#if lecture && s.verdict !== false}
    <p class="goa-verdict" class:ouvert={lecture.ouvert}>
      <span class="goa-v-ligne"><span class="goa-v-mot">{lecture.ouvert ? 'Ouvert' : 'Fermé'}</span>
      {#if !s.court}<span class="goa-v-glose">{lecture.ouvert ? 'l’information circule' : 'l’information ne circule pas'}</span>{/if}</span>
      {#if s.note}<span class="goa-v-note">{s.note}</span>{/if}
    </p>
  {:else if s.note}
    <p class="goa-verdict"><span class="goa-v-note">{s.note}</span></p>
  {/if}
  {#if legende}<p class="goa-leg">{legende}</p>{/if}
</div>

<style>
  .goa { display: flex; flex-direction: column; align-items: center; gap: 0.35em; width: 100%; }
  svg { display: block; max-width: 100%; height: auto; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .cache { opacity: 0; }
  .goa-a, .goa-n { transition: opacity 0.4s; }

  .goa-fl { fill: none; stroke: var(--dk-encre); stroke-width: 4; transition: stroke 0.3s, stroke-width 0.3s; }
  .goa-pt { fill: var(--dk-encre); transition: fill 0.3s; }
  .goa-a.rouge .goa-fl, .goa-a.ouvert .goa-fl { stroke: var(--dk-accent); }
  .goa-a.rouge .goa-pt, .goa-a.ouvert .goa-pt { fill: var(--dk-accent); }
  .goa-a.ouvert .goa-fl { stroke-width: 8; }
  .goa-a.ouvert { animation: goa-pouls 1.8s ease-in-out infinite; }
  .goa-a.ferme .goa-fl { stroke: var(--dk-gris-2); stroke-dasharray: 12 10; }
  .goa-a.ferme .goa-pt { fill: var(--dk-gris-2); }
  @keyframes goa-pouls { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }

  .goa-cut { stroke: var(--dk-encre); stroke-width: 7; }

  .goa-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .goa-boite.accent { stroke: var(--dk-accent); }
  .goa-nom { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .goa-nom.accent { fill: var(--dk-accent); }
  .goa-ind { font-size: 21px; }
  .goa-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 5; opacity: 0; transition: opacity 0.3s; }
  .goa-cadre.vu { opacity: 1; }
  .goa-badge { opacity: 0; transition: opacity 0.3s; }
  .goa-badge.vu { opacity: 1; }
  .goa-badge rect { fill: var(--dk-accent); }
  .goa-badge path { stroke: #fff; stroke-width: 5; }

  .goa-coef { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 10px; }
  .goa-type { font-size: 22px; text-anchor: middle; fill: var(--dk-gris); font-weight: 600; }
  .goa-type.ouvert { fill: var(--dk-accent); }

  .goa-verdict { margin: 0.2em 0 0; display: flex; flex-direction: column; gap: 0.25em; align-items: center; text-align: center; }
  .goa-v-ligne { display: flex; gap: 0.8em; align-items: baseline; }
  .goa-v-mot { font-size: 1.35em; font-weight: 700; color: var(--dk-gris); }
  .goa-verdict.ouvert .goa-v-mot { color: var(--dk-accent); }
  .goa-v-glose { font-size: 0.9em; color: var(--dk-gris); }
  .goa-v-note { font-size: 0.95em; font-weight: 600; }
  .goa-leg { margin: 0; font-size: 0.62em; color: var(--dk-gris); }

  @media (prefers-reduced-motion: reduce) {
    .goa-a, .goa-n, .goa-fl, .goa-pt, .goa-cadre, .goa-badge { transition: none; }
    .goa-a.ouvert { animation: none; }
  }
</style>
