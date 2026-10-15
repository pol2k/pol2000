<script>
  /**
   * La régression est partout : un mur de tuiles, une par étude classique
   * des diapos suivantes, rangées par année. Deux temps.
   *
   *   0  Le mur éteint : on ne lit que les domaines, en gris (hérédité,
   *      éducation, travail social...). Déjà, la largeur du terrain.
   *   1  Les tuiles s'allument l'une après l'autre : le domaine passe au
   *      rouge, l'année, l'auteur et la question en quelques mots
   *      apparaissent.
   *   2  La dernière tuile, en rouge plein : vous, 2026, et votre lm().
   *
   * `ids` : les études montrées dans la section (clés de ETUDES,
   * ClEtude.svelte). Le mur se construit seul : aucun domaine décoratif,
   * seulement ceux qu'on montre vraiment. Quatre colonnes; la tuile « vous »
   * occupe la place qui reste au bout de la dernière rangée (deux cases
   * avec six études).
   */
  import { brancherTemps } from '../temps.js';
  import { ETUDES } from './ClEtude.svelte';

  let { ids } = $props();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Nom court : « Auteur » ou « Auteur et al. » au-delà de deux noms.
  function court(s) {
    if (s.court) return s.court;
    const a = s.auteurs.replace(/\s*\(\d{4}\)\s*$/, '');
    return a.includes(',') ? a.split(',')[0] + ' et al.' : a;
  }

  const COLS = 4;
  const tuiles = $derived(
    ids
      .map((id) => ETUDES[id])
      .map((s) => ({ annee: s.annee, domaine: s.domaine, nom: court(s), mots: s.mots ?? s.y }))
      .sort((a, b) => a.annee - b.annee)
  );
  // La tuile « vous » prend le reste de la dernière rangée (au moins une case).
  const reste = $derived(COLS - (tuiles.length % COLS) || COLS);
</script>

<div class="visuel cl-mur" bind:this={hote}>
  {#each tuiles as t, i}
    <div class="tuile" class:vu={e >= 1} style="--i:{i}">
      <span class="dom">{t.domaine}</span>
      <span class="an">{t.annee}</span>
      <strong class="nom">{t.nom}</strong>
      <span class="mots">{t.mots}</span>
    </div>
  {/each}
  <div class="tuile vous" class:vu={e >= 2} style="grid-column: span {reste}">
    <span class="dom">Vous</span>
    <span class="an">2026</span>
    <code class="lm">lm(interet ~ scolarite)</code>
  </div>
</div>

<style>
  .cl-mur { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.7em; }

  .tuile { display: flex; flex-direction: column; gap: 0.15em; border: 2px solid var(--dk-filet); padding: 0.6em 0.75em 0.7em; min-height: 7.4em; transition: border-color 0.4s; transition-delay: calc(var(--i) * 0.35s); }
  .dom { font-size: 0.62em; letter-spacing: 0.14em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris-2); transition: color 0.4s; transition-delay: inherit; }
  .an { font-size: 1.7em; font-weight: 600; line-height: 1.05; letter-spacing: -0.03em; font-variant-numeric: tabular-nums; }
  .nom { font-size: 0.86em; font-weight: 600; }
  .mots { font-size: 0.72em; color: var(--dk-gris); line-height: 1.35; }
  .an, .nom, .mots { opacity: 0; transform: translateY(6px); transition: opacity 0.4s, transform 0.4s; transition-delay: inherit; }

  .tuile.vu { border-color: var(--dk-encre); }
  .tuile.vu .dom { color: var(--dk-accent); }
  .tuile.vu .an, .tuile.vu .nom, .tuile.vu .mots { opacity: 1; transform: none; }

  /* « Vous » : rouge plein, au dernier temps. */
  .vous { border-style: dashed; justify-content: flex-start; }
  .cl-mur .vous .lm { font-family: var(--dk-mono); font-size: 0.9em; font-weight: 600; background: none; border: 0; padding: 0; opacity: 0; transition: opacity 0.4s; }
  .vous.vu { background: var(--dk-accent); border-color: var(--dk-accent); border-style: solid; color: var(--dk-fond); }
  .vous.vu .dom, .cl-mur .vous.vu .lm { color: var(--dk-fond); opacity: 1; }
  .vous.vu .an { opacity: 1; transform: none; }

  @media (prefers-reduced-motion: reduce) {
    .tuile, .dom, .an, .nom, .mots, .lm { transition: none; }
  }
</style>
