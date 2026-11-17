<script>
  /**
   * Un chemin du GOA dessiné comme une vieille guirlande de Noël montée en
   * série : une seule ampoule qui bloque, et toute la guirlande s'éteint.
   * C'est la règle d'Arel-Bundock (2021, p. 123) : un chemin est ouvert si,
   * et seulement si, tous ses maillons le sont.
   *
   * Chaque maillon (un nœud intérieur du chemin) a son interrupteur :
   *   - chaîne et fourchette : l'interrupteur laisse passer;
   *   - collision : il bloque;
   *   - contrôler le maillon (cadre rouge) renverse son interrupteur
   *     (p. 122-123).
   * Les ampoules s'allument toutes ensemble si tout passe, et le fil
   * s'anime : l'information circule d'un bout à l'autre. Sinon tout est
   * éteint, et l'interrupteur fautif est marqué.
   *
   * Pour une diapo sur fond encre (l'or n'y est permis que sur l'encre).
   *
   *   chemin  le chemin en toutes lettres, ex. « A ← B → C »; les flèches
   *           donnent le type de chaque maillon, et se dessinent sur le fil;
   *   temps   un état par clic : { controles: ['B'], note: '…', cache: true };
   *           cache : la question seule (ampoules neutres, interrupteurs et
   *           verdict masqués), pour les exercices;
   *   types   true : le nom du type sous chaque interrupteur;
   *   taille  multiplie la largeur;
   *   haut    hauteur maximale du dessin (CSS).
   *
   * Schéma, aucune donnée. Le verdict vient de goa.js (etatChemin, testé
   * par goa.test.js), jamais écrit à la main.
   */
  import { brancherTemps } from '../temps.js';
  import { etatChemin } from '../goa.js';

  let { chemin = 'A → B → C', temps = [{}], types = true, taille = 1, haut = '44vh' } = $props();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote || temps.length < 2) return;
    e = 0;
    return brancherTemps(hote, { total: temps.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });
  const s = $derived(temps[Math.min(e, temps.length - 1)] ?? {});

  const toks = $derived(chemin.split(/\s*([←→])\s*/));
  const noeuds = $derived(toks.filter((_, i) => i % 2 === 0));
  const fleches = $derived(toks.filter((_, i) => i % 2 === 1));

  const Y0 = 150, SAG = 46;
  // Largeur d'un bout : une lettre tient dans un carré, un mot s'allonge.
  const largeur = (t) => Math.max(68, t.replace(/\d$/, '').length * 23 + 34);
  const PAS = $derived(noeuds.some((n) => n.length > 2) ? 360 : 300);
  const xs = $derived.by(() => {
    const g = largeur(noeuds[0]) / 2 + 10;
    return noeuds.map((_, i) => g + i * PAS);
  });
  const W = $derived(xs.at(-1) + largeur(noeuds.at(-1)) / 2 + 10);
  const cache = $derived(!!s.cache);

  // Les flèches du texte deviennent des arêtes : goa.js (testé) décide.
  const aretes = $derived(fleches.map((f, i) => (f === '→' ? [noeuds[i], noeuds[i + 1]] : [noeuds[i + 1], noeuds[i]])));
  const lecture = $derived(etatChemin(aretes, noeuds, s.controles ?? []));
  const maillons = $derived(
    lecture.maillons.map((m, k) => ({ nom: m.id, type: m.type, passe: m.ouvert, controle: (s.controles ?? []).includes(m.id), x: xs[k + 1] }))
  );
  const ouvert = $derived(!cache && maillons.every((m) => m.passe));

  // Le fil : un arc qui pend entre chaque paire de points d'attache.
  const fil = $derived(xs.slice(1).map((x, i) => `M ${xs[i]} ${Y0} Q ${(xs[i] + x) / 2} ${Y0 + 2 * SAG} ${x} ${Y0}`).join(' '));
  const chevrons = $derived(
    fleches.map((f, i) => {
      const mx = (xs[i] + xs[i + 1]) / 2, my = Y0 + SAG;
      const sgn = f === '→' ? 1 : -1;
      return { pts: `${mx + 16 * sgn},${my} ${mx - 12 * sgn},${my - 14} ${mx - 12 * sgn},${my + 14}` };
    })
  );
  const NOMS = { fourchette: 'fourchette', chaine: 'chaîne', collision: 'collision' };
  const indice = (t) => t.match(/^([A-Z])(\d)$/);
</script>

<div class="visuel m11g" class:ouvert class:cache bind:this={hote}>
  <svg viewBox="0 {Y0 - 110} {W} 440" style="max-width: {50 * taille}em; max-height: {haut}" role="img" aria-label="Le chemin {chemin} : {ouvert ? 'ouvert, l’information passe' : 'fermé, rien ne passe'}.">
    <defs>
      <filter id="m11g-halo" x="-100%" y="-100%" width="300%" height="300%"><feGaussianBlur stdDeviation="14" /></filter>
    </defs>

    <!-- le fil -->
    <path d={fil} class="fil" />
    <path d={fil} class="courant" />
    {#each chevrons as c, i (i)}<polygon points={c.pts} class="chevron" />{/each}

    <!-- les deux bouts -->
    {#each [0, noeuds.length - 1] as k (k)}
      {@const m = indice(noeuds[k])}
      <g class="bout">
        <rect x={xs[k] - largeur(noeuds[k]) / 2} y={Y0 - 34} width={largeur(noeuds[k])} height="68" />
        <text x={xs[k]} y={Y0 + 13}>{#if m}{m[1]}<tspan class="ind" dy="8">{m[2]}</tspan>{:else}{noeuds[k]}{/if}</text>
      </g>
    {/each}

    <!-- les maillons : une ampoule, un interrupteur -->
    {#each maillons as m (m.nom)}
      {@const ix = indice(m.nom)}
      <g class="maillon" class:passe={m.passe}>
        <circle cx={m.x} cy={Y0 + 92} r="52" class="halo" filter="url(#m11g-halo)" />
        <rect x={m.x - 13} y={Y0 - 4} width="26" height="30" class="douille" />
        <path d="M {m.x - 22} {Y0 + 28} C {m.x - 50} {Y0 + 62} {m.x - 46} {Y0 + 132} {m.x} {Y0 + 140} C {m.x + 46} {Y0 + 132} {m.x + 50} {Y0 + 62} {m.x + 22} {Y0 + 28} Z" class="verre" />
        {#if m.nom.length <= 2}
          <text x={m.x} y={Y0 + 100} class="nom-a">{#if ix}{ix[1]}<tspan class="ind" dy="7">{ix[2]}</tspan>{:else}{m.nom}{/if}</text>
        {:else}
          <text x={m.x} y={Y0 - 52} class="nom-mot">{m.nom}</text>
        {/if}
        {#if m.controle}<rect x={m.x - 66} y={Y0 - 16} width="132" height="172" class="cadre" />{/if}
        {#if !cache}
        <!-- l'interrupteur -->
        <g transform="translate({m.x} {Y0 + 196})">
          <rect x="-40" y="-16" width="80" height="32" rx="16" class="inter" />
          <circle cx={m.passe ? 22 : -22} cy="0" r="12" class="bouton" />
        </g>
        <text x={m.x} y={Y0 + 250} class="etat">{m.passe ? 'passe' : 'bloque'}</text>
        {#if types}<text x={m.x} y={Y0 + 280} class="type">{NOMS[m.type]}{m.controle ? ', contrôlée' : ''}</text>{/if}
        {/if}
      </g>
    {/each}
  </svg>
  {#if cache}
    <p class="verdict"><strong>Ouvert ou fermé ?</strong></p>
  {:else}
    <p class="verdict"><strong>{ouvert ? 'Ouvert' : 'Fermé'}</strong><span>{ouvert ? 'l’information passe d’un bout à l’autre' : 'rien ne passe'}</span></p>
  {/if}
  {#if s.note}<p class="note">{s.note}</p>{/if}
</div>

<style>
  .m11g { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.3em; }
  svg { width: 100%; height: auto; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .fil { fill: none; stroke: var(--dk-gris); stroke-width: 6; }
  .courant { fill: none; stroke: var(--dk-accent-clair); stroke-width: 6; stroke-dasharray: 18 26; opacity: 0; transition: opacity 0.4s; }
  .ouvert .courant { opacity: 1; animation: m11g-courant 1.2s linear infinite; }
  @keyframes m11g-courant { to { stroke-dashoffset: -44; } }
  .chevron { fill: var(--dk-gris-2); }
  .ouvert .chevron { fill: var(--dk-accent-clair); }
  .cache .verre { fill: #1d2023; stroke: var(--dk-gris-2); }

  .bout rect { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 4; }
  .nom-mot { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-fond); }
  .bout text { font-size: 38px; font-weight: 700; text-anchor: middle; fill: var(--dk-fond); }
  .ind { font-size: 0.65em; }

  .douille { fill: var(--dk-gris); }
  .verre { fill: #1d2023; stroke: var(--dk-gris); stroke-width: 4; transition: fill 0.35s, stroke 0.35s; }
  .halo { fill: var(--dk-accent-clair); opacity: 0; transition: opacity 0.35s; }
  .ouvert .verre { fill: var(--dk-accent-clair); stroke: var(--dk-accent-clair); }
  .ouvert .halo { opacity: 0.55; animation: m11g-scintille 2.4s ease-in-out infinite alternate; }
  @keyframes m11g-scintille { from { opacity: 0.4; } to { opacity: 0.7; } }
  .nom-a { font-size: 32px; font-weight: 700; text-anchor: middle; fill: var(--dk-gris-2); transition: fill 0.35s; }
  .ouvert .nom-a { fill: var(--dk-encre); }
  .cadre { fill: none; stroke: var(--dk-accent); stroke-width: 6; }

  .inter { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; }
  .bouton { fill: var(--dk-gris-2); transition: cx 0.3s; }
  .passe .inter { stroke: var(--dk-accent-clair); }
  .passe .bouton { fill: var(--dk-accent-clair); }
  .maillon:not(.passe) .inter { stroke: var(--dk-accent); }
  .maillon:not(.passe) .bouton { fill: var(--dk-accent); }
  .etat { font-size: 24px; font-weight: 700; text-anchor: middle; fill: var(--dk-accent); }
  .passe .etat { fill: var(--dk-accent-clair); }
  .type { font-size: 22px; text-anchor: middle; fill: var(--dk-gris-2); }

  .verdict { margin: 0; display: flex; gap: 0.8em; align-items: baseline; }
  .verdict strong { font-size: 1.5em; color: var(--dk-gris-2); }
  .ouvert .verdict strong { color: var(--dk-accent-clair); }
  .verdict span { font-size: 0.9em; color: var(--dk-gris-2); }
  .note { margin: 0; font-size: 0.95em; font-weight: 600; text-align: center; }

  @media (prefers-reduced-motion: reduce) { .ouvert .courant, .ouvert .halo { animation: none; } .verre, .halo, .bouton { transition: none; } }
</style>
