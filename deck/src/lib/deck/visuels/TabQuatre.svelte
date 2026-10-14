<script>
  /**
   * Lire un tableau en quatre questions. Quatre cartes, la question et un
   * petit dessin d'emblée. Chaque clic donne la réponse pour notre modèle,
   * pour que la salle réponde avant.
   *
   *   1  Le sens : le signe du coefficient (−, la note baisse).
   *   2  La taille : en unités de y, par unité de x (5 points par cran).
   *   3  Le hasard : les étoiles (*** : le hasard l'explique mal).
   *   4  Le contexte : N et R² (783 personnes, 14 % de la variation).
   *
   * Nombres : NOTRE dans src/lib/data/seance7.js (outils/seance7_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE } from '$lib/data/seance7.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (v, d = 2) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');
  const C = NOTRE.coefs[1];
  const et = (p) => (p < 0.001 ? '***' : p < 0.01 ? '**' : p < 0.05 ? '*' : 'aucune');
  const CARTES = [
    { q: 'Le sens ?', r: C.b < 0 ? '− : la note baisse' : '+ : la note monte', icone: 'sens' },
    { q: 'La taille ?', r: `${f(Math.abs(C.b))} points par cran`, icone: 'taille' },
    { q: 'Le hasard ?', r: C.p < 0.05 ? `${et(C.p)} : le hasard l’explique mal` : 'pas d’étoile : le hasard peut l’expliquer', icone: 'hasard' },
    { q: 'Le contexte ?', r: `N = ${f(NOTRE.n_modele, 0)} · R² = ${f(NOTRE.r2)}`, icone: 'contexte' }
  ];
</script>

<div class="visuel tab-quatre" bind:this={hote}>
  {#each CARTES as c, i}
    <div class="tq-carte" class:tq-actif={e === i + 1} class:tq-vu={e >= i + 1}>
      <span class="tq-num">{i + 1}</span>
      <svg viewBox="0 0 120 80" class="tq-icone" aria-hidden="true">
        {#if c.icone === 'sens'}
          <line x1="14" y1="16" x2="106" y2="64" class="tq-trait tq-rouge" />
          <text x="60" y="30" class="tq-signe">−</text>
          <text x="80" y="80" class="tq-signe tq-gris">+</text>
          <line x1="14" y1="64" x2="106" y2="16" class="tq-trait tq-pale" />
        {:else if c.icone === 'taille'}
          <path d="M14 18 H60 V58 H106" class="tq-trait" />
          <line x1="60" y1="18" x2="60" y2="58" class="tq-trait tq-rouge" />
          <text x="37" y="12" class="tq-petit">+1</text>
        {:else if c.icone === 'hasard'}
          <text x="60" y="58" class="tq-etoiles">***</text>
        {:else}
          {#each Array(24) as _, k}
            <rect x={14 + (k % 8) * 12} y={14 + Math.floor(k / 8) * 18} width="9" height="13" class:tq-manque={k === 7 || k === 13 || k === 22} class="tq-pers" />
          {/each}
        {/if}
      </svg>
      <span class="tq-q">{c.q}</span>
      <span class="tq-r">{c.r}</span>
    </div>
  {/each}
</div>

<style>
  .tab-quatre { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1em; }
  .tq-carte { position: relative; display: flex; flex-direction: column; align-items: center; gap: 0.55em; padding: 1.4em 0.7em 1.1em; border: 2px solid var(--dk-encre); text-align: center; transition: border-color 0.3s; }
  .tq-carte.tq-actif { border-color: var(--dk-accent); border-width: 3px; padding: calc(1.4em - 1px) calc(0.7em - 1px) calc(1.1em - 1px); }
  .tq-num { position: absolute; top: -0.75em; left: 0.8em; background: var(--dk-fond); padding: 0 0.35em; font-size: 0.9em; font-weight: 700; color: var(--dk-gris); }
  .tq-actif .tq-num { color: var(--dk-accent); }
  .tq-icone { width: 6em; height: 4em; }
  .tq-trait { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .tq-rouge { stroke: var(--dk-accent); stroke-width: 6; }
  .tq-pale { stroke: var(--dk-filet); }
  .tq-signe { font-family: var(--dk-mono); font-size: 30px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; }
  .tq-gris { fill: var(--dk-gris-2); }
  .tq-petit { font-family: var(--dk-mono); font-size: 16px; font-weight: 600; fill: var(--dk-encre); text-anchor: middle; }
  .tq-etoiles { font-family: var(--dk-mono); font-size: 46px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; }
  .tq-pers { fill: var(--dk-encre); }
  .tq-pers.tq-manque { fill: var(--dk-filet); }
  .tq-q { font-size: 1.15em; font-weight: 700; color: var(--dk-encre); white-space: nowrap; }
  .tq-r { min-height: 2.6em; font-size: 0.85em; font-weight: 600; line-height: 1.3; color: var(--dk-accent); visibility: hidden; opacity: 0; transform: translateY(0.3em); transition: opacity 0.35s, transform 0.35s, visibility 0s 0.35s; }
  .tq-vu .tq-r { visibility: visible; opacity: 1; transform: none; transition: opacity 0.35s, transform 0.35s; }

  @media (prefers-reduced-motion: reduce) {
    .tq-carte, .tq-r, .tq-vu .tq-r { transition: none; transform: none; }
  }
</style>
