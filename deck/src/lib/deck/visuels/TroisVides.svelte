<script>
  /**
   * Trois sortes de vide dans l'Étude électorale canadienne 2025. Une carte
   * par clic, un grand nombre, une ligne chacune.
   *
   *   1  -99 : le code de non-réponse des curseurs de 0 à 10. R le prend pour
   *      un nombre (GAUCHE_DROITE.n99).
   *   2  « Ne sait pas » : une vraie réponse, code 7 de l'intention de vote
   *      (VOTE_VIDE.nsp). À vous de choisir : catégorie ou NA.
   *   3  NA : la question n'a jamais été posée (VOTE_VIDE.na), surtout parce
   *      que la personne avait déjà voté par anticipation (raisons["6"]).
   */
  import { brancherTemps } from '../temps.js';
  import { GAUCHE_DROITE, VOTE_VIDE } from '$lib/data/seance4.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const CARTES = [
    { code: '-99', n: GAUCHE_DROITE.n99, quoi: 'sur l’échelle gauche-droite', ligne: 'Un code de non-réponse. R le compte comme un nombre.', danger: true },
    { code: 'Ne sait pas', n: VOTE_VIDE.nsp, quoi: 'intention de vote, code 7', ligne: 'Une vraie réponse. Catégorie ou NA : à vous de choisir.' },
    { code: 'NA', n: VOTE_VIDE.na, quoi: 'sans intention de vote', ligne: `Question jamais posée : ${milliers(VOTE_VIDE.raisons['6'])} avaient déjà voté.` }
  ];
</script>

<div class="visuel trois-vides" bind:this={hote}>
  {#each CARTES as c, i}
    <div class="carte" class:vu={e > i} class:danger={c.danger}>
      <span class="code">{c.code}</span>
      <span class="n">{milliers(c.n)}</span>
      <span class="quoi">{c.quoi}</span>
      <p>{c.ligne}</p>
    </div>
  {/each}
  <p class="source">Étude électorale canadienne 2025 · 20 180 personnes</p>
</div>

<style>
  .trois-vides { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.2em; align-items: stretch; }
  .carte { display: flex; flex-direction: column; gap: 0.35em; border: 3px solid var(--dk-encre); padding: 1.1em 1em 1em; visibility: hidden; opacity: 0; }
  .carte.vu { visibility: visible; animation: fondu 0.45s both; }
  .carte.danger { border-color: var(--dk-accent); }
  .code { font-size: 1.5em; font-weight: 600; font-family: var(--dk-mono); }
  .danger .code { color: var(--dk-accent); }
  .n { font-size: 2.6em; font-weight: 600; line-height: 1; letter-spacing: -0.03em; margin-top: 0.3em; }
  .quoi { font-size: 0.72em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; }
  .carte p { margin: auto 0 0; padding-top: 0.6em; border-top: 2px solid var(--dk-filet); font-size: 0.85em; line-height: 1.4; }
  .source { grid-column: 1 / -1; margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .carte.vu { animation: none; opacity: 1; } }
</style>
