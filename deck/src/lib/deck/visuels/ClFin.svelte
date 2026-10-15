<script>
  /**
   * La même idée, partout : les études classiques de la section ramenées à leur
   * squelette, Y selon X, une ligne chacune. Puis la nôtre, en R. Puis la
   * phrase du prof. Deux temps.
   *
   *   0  Une ligne « Y ~ X » par étude de la section (prop `ids`, dans
   *      l'ordre des diapos), avec l'auteur et l'année.
   *   1  Notre ligne, en rouge : lm(interet ~ scolarite, data = ces1000),
   *      le modèle qu'on ajuste dans la suite de la séance.
   *   2  La phrase : le meilleur outil qu'on a pour étudier la relation
   *      entre deux variables.
   *
   * Prudence : Galton a tracé sa droite à la main, et toutes les études ne
   * sont pas des moindres carrés ordinaires (voir le genre de chacune dans
   * ClEtude). La diapo dit donc « la même idée », pas « le même lm() ». Les études et leurs pages : ClEtude.svelte.
   */
  import { brancherTemps } from '../temps.js';
  import { ETUDES } from './ClEtude.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // `ids` : les études de la section, dans l'ordre des diapos (ClEtude).
  let { ids } = $props();

  // Sans `fin`, on prend y et x de l'étude, sans l'article du début.
  const nu = (t) => t.replace(/^(le |la |les |l’|l')/, '');
  function court(s) {
    if (s.court) return s.court;
    const a = s.auteurs.replace(/\s*\(\d{4}\)\s*$/, '');
    return a.includes(',') ? a.split(',')[0] + ' et al.' : a;
  }
  const LIGNES = $derived(
    ids.map((id) => {
      const s = ETUDES[id];
      return { y: s.fin?.y ?? nu(s.y), x: s.fin?.x ?? nu(s.x), qui: `${court(s)}, ${s.annee}` };
    })
  );
</script>

<div class="visuel cl-fin" bind:this={hote}>
  <div class="cl-liste">
    {#each LIGNES as l, i}
      <span class="cl-y" style="--i:{i}">{l.y}</span>
      <span class="cl-tilde" style="--i:{i}">~</span>
      <span class="cl-x" style="--i:{i}">{l.x}</span>
      <span class="cl-qui" style="--i:{i}">{l.qui}</span>
    {/each}
    <code class="cl-nous" class:vu={e >= 1}>lm(interet ~ scolarite, data = ces1000)</code>
    <span class="cl-qui cl-vous" class:vu={e >= 1}>vous, aujourd’hui</span>
  </div>

  <p class="cl-phrase" class:vu={e >= 2}>
    Le meilleur outil qu’on a pour étudier la relation entre deux variables.
  </p>
</div>

<style>
  .cl-fin { display: flex; flex-direction: column; align-items: center; gap: 1.6em; }
  .cl-liste { display: grid; grid-template-columns: auto auto auto auto; column-gap: 0.8em; row-gap: 0.32em; align-items: baseline; font-size: 1.08em; }
  .cl-y { text-align: right; }
  .cl-tilde { color: var(--dk-accent); font-weight: 600; }
  .cl-qui { padding-left: 1.4em; font-size: 0.72em; color: var(--dk-gris); }
  .cl-y, .cl-tilde, .cl-x, .cl-qui:not(.cl-vous) { animation: cl-entre 0.4s both; animation-delay: calc(var(--i) * 0.12s); }
  @keyframes cl-entre { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: none; } }

  .cl-nous { grid-column: 1 / span 3; justify-self: center; margin-top: 0.55em; font-family: var(--dk-mono); font-size: 1em; font-weight: 600; color: var(--dk-fond); background: var(--dk-accent); padding: 0.3em 0.7em;
    opacity: 0; transform: scale(0.9); transition: opacity 0.4s, transform 0.5s cubic-bezier(0.34, 1.6, 0.64, 1); }
  .cl-vous { align-self: center; margin-top: 0.55em; color: var(--dk-accent); font-weight: 600; opacity: 0; transition: opacity 0.4s 0.2s; }
  .cl-nous.vu, .cl-vous.vu { opacity: 1; transform: none; }

  .cl-phrase { font-size: 1.3em !important; font-weight: 600; line-height: 1.3 !important; text-align: center; max-width: 24em; border-top: 2px solid var(--dk-encre); border-bottom: 2px solid var(--dk-encre); padding: 0.45em 0.6em;
    opacity: 0; transform: translateY(10px); transition: opacity 0.45s, transform 0.45s; }
  .cl-phrase.vu { opacity: 1; transform: none; }

  @media (prefers-reduced-motion: reduce) {
    .cl-y, .cl-tilde, .cl-x, .cl-qui { animation: none; }
    .cl-nous, .cl-vous, .cl-phrase { transition: none; }
  }
</style>
