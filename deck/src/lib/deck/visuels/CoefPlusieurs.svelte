<script>
  /**
   * Le graphique des coefficients d'un modèle à plusieurs variables : un
   * aperçu de la séance 8. Même sondage (ces1000), 772 cas complets :
   * note_carney ~ gauche_droite + age10 + femme + quebec + universitaire.
   * Cinq rangées, dans l'ordre du tableau (de haut en bas), la constante
   * laissée de côté. Deux usages, selon `mode` :
   *
   * mode = 'signif' (lire la significativité, colonne « significatif à 5 % ? ») :
   *   0  Les cinq points et leurs moustaches, la ligne à 0.
   *   1  Femme et Québec : la moustache croise 0. En rouge, « non ».
   *   2  Les trois autres ne la croisent pas : « oui ».
   *   3  Les étoiles du tableau (R : *** p < 0,001, ** < 0,01, * < 0,05)
   *      s'ajoutent à côté du « oui » : la même information.
   *
   * mode = 'unites' (prudence avec les unités, colonne « 1 unité de x ») :
   *   0  Le même dessin.
   *   1  Ce que vaut « une unité » pour chaque variable (un cran sur 10,
   *      10 ans, être une femme...), et la phrase : comparer avec prudence.
   *
   * Tous les nombres viennent de MULTIPLE.coefs (src/lib/data/seance7.js,
   * généré par outils/seance7_data.R : coef(summary(m2)) et confint(m2)).
   * « Croise 0 » se lit sur les bornes : bas < 0 < haut.
   */
  import { brancherTemps } from '../temps.js';
  import { MULTIPLE } from '$lib/data/seance7.js';

  /** @type {{ mode?: 'signif' | 'unites' }} */
  let { mode = 'signif' } = $props();
  const TOTAL = $derived(mode === 'unites' ? 1 : 3);

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });
  const f = (v, d = 1) =>
    v.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace('-', '−').replace(/\s/g, ' ');
  const etoiles = (p) => (p < 0.001 ? '***' : p < 0.01 ? '**' : p < 0.05 ? '*' : '');

  // Les libellés, dans l'ordre du modèle.
  const NOMS = {
    gauche_droite: ['Position gauche-droite', '(0 à 10)', '1 cran vers la droite'],
    age10: ['Âge', '(par 10 ans)', '10 ans de plus'],
    femme: ['Femme', '', 'être une femme'],
    quebec: ['Québec', '', 'vivre au Québec'],
    universitaire: ['Diplôme universitaire', '', 'avoir un diplôme']
  };
  const RANGS = MULTIPLE.coefs
    .filter((c) => c.terme !== '(Intercept)')
    .map((c) => ({ ...c, nom: NOMS[c.terme], croise: c.bas < 0 && c.haut > 0 }));

  // L'axe, plus étroit qu'aux diapos d'avant : il faut une colonne à droite.
  const V0 = -10, V1 = 15, XL = 320, XR = 720;
  const x = (v) => XL + ((v - V0) / (V1 - V0)) * (XR - XL);
  const ticks = [-10, -5, 0, 5, 10, 15];
  const Y1 = 110, PAS = 62, AXE = Y1 + 4 * PAS + 50;
  const y = (i) => Y1 + i * PAS;
  const XCOL = 750; // début de la colonne de droite

  // Mode « signif » : rouge pour ce qui croise 0 (temps 1), encre grasse pour le reste (temps 2).
  const rouge = (r) => mode === 'signif' && e >= 1 && r.croise;
  const fort = (r) => mode === 'signif' && e >= 2 && !r.croise;
</script>

<div class="visuel coef-plus" bind:this={hote}>
  <svg viewBox="0 0 1000 500" role="img" aria-label="Graphique des coefficients du modèle à cinq variables, notre sondage, {MULTIPLE.n_modele} personnes. {RANGS.map((r) => `${r.nom[0]} ${r.nom[1]} : ${f(r.b)} points, de ${f(r.bas)} à ${f(r.haut)}${r.croise ? ', la moustache croise 0' : ''}.`).join(' ')}">

    <text x="20" y="30" class="cp-note">notre sondage · N = {MULTIPLE.n_modele.toLocaleString('fr-CA')}</text>

    <!-- La colonne de droite : significatif ou pas, ou l'unité de chaque variable. -->
    {#if mode === 'signif'}
      <g class="cp-etape" class:cp-vu={e >= 1}>
        <text x={XCOL} y="62" class="cp-tete">significatif à 5&#8239;%&#8239;?</text>
      </g>
    {:else}
      <g class="cp-etape" class:cp-vu={e >= 1}>
        <text x={XCOL} y="62" class="cp-tete">1 unité de x, c’est&#8239;:</text>
      </g>
    {/if}

    <!-- La ligne à 0, puis l'axe. -->
    <line x1={x(0)} y1="74" x2={x(0)} y2={AXE} class="cp-zero" class:cp-zero-r={mode === 'signif' && e === 1} />
    <line x1={XL} y1={AXE} x2={XR} y2={AXE} class="cp-axe" />
    {#each ticks as t}
      <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 9} class="cp-axe" />
      <text x={x(t)} y={AXE + 32} class="cp-tick">{f(t, 0)}</text>
    {/each}
    <text x={(XL + XR) / 2} y={AXE + 66} class="cp-titre-axe">effet sur la note de Carney, en points</text>

    {#each RANGS as r, i}
      <g class="cp-rang" class:cp-rouge={rouge(r)} class:cp-fort={fort(r)}>
        <text x="296" y={y(i) + (r.nom[1] ? -4 : 7)} class="cp-lab">{r.nom[0]}</text>
        {#if r.nom[1]}<text x="296" y={y(i) + 21} class="cp-sous">{r.nom[1]}</text>{/if}
        <line x1={x(r.bas)} y1={y(i)} x2={x(r.haut)} y2={y(i)} class="cp-moustache" />
        <line x1={x(r.bas)} y1={y(i) - 8} x2={x(r.bas)} y2={y(i) + 8} class="cp-borne" />
        <line x1={x(r.haut)} y1={y(i) - 8} x2={x(r.haut)} y2={y(i) + 8} class="cp-borne" />
        <circle cx={x(r.b)} cy={y(i)} r="9" class="cp-point" />
      </g>

      {#if mode === 'signif'}
        <!-- 1 : « non » pour ce qui croise 0. 2 : « oui » pour le reste. 3 : les étoiles. -->
        <g class="cp-etape" class:cp-vu={r.croise ? e >= 1 : e >= 2}>
          <text x={XCOL} y={y(i) + 8} class="cp-verdict" class:cp-non={r.croise}>{r.croise ? 'non' : 'oui'}</text>
        </g>
        <g class="cp-etape" class:cp-vu={e >= 3}>
          <text x={XCOL + 70} y={y(i) + 8} class="cp-etoiles">{etoiles(r.p)}</text>
        </g>
      {:else}
        <g class="cp-etape" class:cp-vu={e >= 1} style="transition-delay: {e >= 1 ? i * 120 : 0}ms">
          <text x={XCOL} y={y(i) + 8} class="cp-unite">{r.nom[2]}</text>
        </g>
      {/if}
    {/each}

    {#if mode === 'signif'}
      <g class="cp-etape" class:cp-vu={e >= 3}>
        <text x={XCOL + 91} y={y(4) + 42} class="cp-tete cp-tete-g">les étoiles du tableau</text>
      </g>
    {/if}
  </svg>
  {#if mode === 'unites'}
    <p class="cp-phrase cp-etape" class:cp-vu={e >= 1}>Pas la même règle&#8239;: comparer avec prudence.</p>
  {/if}
</div>

<style>
  .coef-plus { display: flex; flex-direction: column; align-items: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .cp-note { font-size: 18px; fill: var(--dk-gris); }
  .cp-tete { font-size: 19px; font-weight: 600; fill: var(--dk-gris); }
  .cp-tete-g { font-size: 17px; font-weight: 400; text-anchor: middle; }
  .cp-zero { stroke: var(--dk-encre); stroke-width: 2; stroke-dasharray: 7 6; transition: stroke 0.4s, stroke-width 0.4s; }
  .cp-zero.cp-zero-r { stroke: var(--dk-accent); stroke-width: 4; }
  .cp-axe { stroke: var(--dk-encre); stroke-width: 2; }
  .cp-tick { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .cp-titre-axe { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }
  .cp-lab { font-size: 22px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); transition: fill 0.4s; }
  .cp-sous { font-size: 18px; text-anchor: end; fill: var(--dk-gris); }
  .cp-moustache { stroke: var(--dk-encre); stroke-width: 5; transition: stroke 0.4s, stroke-width 0.4s; }
  .cp-borne { stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.4s; }
  .cp-point { fill: var(--dk-encre); transition: fill 0.4s; }
  .cp-rouge .cp-lab, .cp-rouge .cp-point { fill: var(--dk-accent); }
  .cp-rouge .cp-moustache, .cp-rouge .cp-borne { stroke: var(--dk-accent); }
  .cp-fort .cp-moustache { stroke-width: 7; }
  .cp-verdict { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .cp-verdict.cp-non { fill: var(--dk-accent); }
  .cp-etoiles { font-size: 24px; font-weight: 600; fill: var(--dk-gris); }
  .cp-unite { font-size: 21px; fill: var(--dk-encre); }
  .cp-phrase { margin: 0.4em 0 0; font-size: 1.05em; font-weight: 600; color: var(--dk-accent); text-align: center; }
  .cp-etape { opacity: 0; transition: opacity 0.3s; }
  .cp-etape.cp-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .cp-etape, .cp-etape.cp-vu, .cp-zero, .cp-lab, .cp-moustache, .cp-borne, .cp-point { transition: none; }
  }
</style>
