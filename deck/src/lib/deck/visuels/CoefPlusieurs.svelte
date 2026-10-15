<script>
  /**
   * Le graphique des coefficients d'un modèle à plusieurs variables : un
   * aperçu de la séance 8. Même sondage (ces1000), 877 cas complets :
   * interet ~ scolarite + age + femme + revenu + quebec, toutes les
   * variables codées de 0 à 1 (âge : 0 = 18 ans, 1 = MULTIPLE.age_max ans,
   * la personne la plus âgée de la CES. Revenu : 0 = la tranche la plus
   * basse, 1 = la plus haute, sur huit). Cinq rangées, dans l'ordre du
   * tableau (de haut en bas), la constante laissée de côté. Deux usages,
   * selon `mode` :
   *
   * mode = 'signif' (lire la significativité, colonne « significatif à 5 % ? ») :
   *   0  Les cinq points et leurs moustaches, la ligne à 0.
   *   1  Québec : la moustache croise 0. En rouge, « non ».
   *   2  Les quatre autres ne la croisent pas : « oui » (femme aussi, du
   *      côté négatif).
   *   3  Les étoiles du tableau (R : *** p < 0,001, ** < 0,01, * < 0,05)
   *      s'ajoutent à côté du « oui » : la même information.
   *
   * mode = 'unites' (prudence avec les unités, colonne « de 0 à 1, c'est ») :
   *   0  Le même dessin.
   *   1  Tout va de 0 à 1 : chaque point se lit « du minimum au maximum »,
   *      c'est pour ça que le cours code tout de 0 à 1.
   *   2  Mais 0 → 1 ne veut pas dire la même chose partout (cinq niveaux
   *      de diplôme, 78 ans d'écart, oui ou non, huit tranches de revenu) :
   *      comparer avec prudence.
   *
   * Tous les nombres viennent de MULTIPLE.coefs (l'âge maximal de
   * MULTIPLE.age_max, le nom de la scolarité de VARS.x)
   * (src/lib/data/seance7.js, généré par outils/seance7_data.R :
   * coef(summary(m2)) et confint(m2)). « Croise 0 » se lit sur les bornes :
   * bas < 0 < haut.
   */
  import { brancherTemps } from '../temps.js';
  import { MULTIPLE, VARS } from '$lib/data/seance7.js';

  /** @type {{ mode?: 'signif' | 'unites' }} */
  let { mode = 'signif' } = $props();
  const TOTAL = $derived(mode === 'unites' ? 2 : 3);

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

  // Les libellés, dans l'ordre du modèle : [nom, sous-titre, de quel genre est 0 → 1, ses deux bouts].
  const AGE_MAX = MULTIPLE.age_max;
  const NOMS = {
    scolarite: [VARS.x.court, '', `${VARS.x.niveaux.length} niveaux de diplôme`, 'secondaire → doctorat'],
    age: ['Âge', `(18 ans → ${AGE_MAX} ans)`, `${AGE_MAX - 18} ans d’écart`, `18 → ${AGE_MAX} ans`],
    femme: ['Femme', '', 'oui ou non', 'homme → femme'],
    revenu: ['Revenu', '(le plus bas → le plus haut)', '8 tranches de revenu', 'basse → haute'],
    quebec: ['Québec', '', 'oui ou non', 'ailleurs → Québec']
  };
  const RANGS = MULTIPLE.coefs
    .filter((c) => c.terme !== '(Intercept)')
    .map((c) => ({ ...c, nom: NOMS[c.terme], croise: c.bas < 0 && c.haut > 0 }));

  // L'axe, dans les unités de l'intérêt (0 à 1).
  const V0 = -0.2, V1 = 0.5, XL = 320, XR = 720;
  const x = (v) => XL + ((v - V0) / (V1 - V0)) * (XR - XL);
  const ticks = [-0.2, 0, 0.2, 0.4];
  const Y1 = 108, PAS = 62, AXE = Y1 + 4 * PAS + 46;
  const y = (i) => Y1 + i * PAS;
  const XCOL = 750; // début de la colonne de droite

  // Mode « signif » : rouge pour ce qui croise 0 (temps 1), encre grasse pour le reste (temps 2).
  const rouge = (r) => mode === 'signif' && e >= 1 && r.croise;
  const fort = (r) => mode === 'signif' && e >= 2 && !r.croise;
</script>

<div class="visuel coef-plus" bind:this={hote}>
  <svg viewBox="0 0 1000 {mode === 'unites' ? 480 : 500}" role="img" aria-label="Graphique des coefficients du modèle à cinq variables, toutes codées de 0 à 1, notre sondage, {MULTIPLE.n_modele} personnes. {RANGS.map((r) => `${r.nom[0]} : ${f(r.b, 2)}, de ${f(r.bas, 2)} à ${f(r.haut, 2)}${r.croise ? ', la moustache croise 0' : ''}.`).join(' ')}">

    <text x="20" y="30" class="cp-note">notre sondage · N = {MULTIPLE.n_modele.toLocaleString('fr-CA')}</text>

    <!-- La colonne de droite : significatif ou pas, ou ce que veut dire 0 → 1. -->
    {#if mode === 'signif'}
      <g class="cp-etape" class:cp-vu={e >= 1}>
        <text x={XCOL} y="62" class="cp-tete">significatif à 5&#8239;%&#8239;?</text>
      </g>
    {:else}
      <g class="cp-etape" class:cp-vu={e >= 2}>
        <text x={XCOL} y="62" class="cp-tete">de 0 à 1, c’est&#8239;:</text>
      </g>
    {/if}

    <!-- La ligne à 0, puis l'axe. -->
    <line x1={x(0)} y1="74" x2={x(0)} y2={AXE} class="cp-zero" class:cp-zero-r={mode === 'signif' && e === 1} />
    <line x1={XL} y1={AXE} x2={XR} y2={AXE} class="cp-axe" />
    {#each ticks as t}
      <line x1={x(t)} y1={AXE} x2={x(t)} y2={AXE + 9} class="cp-axe" />
      <text x={x(t)} y={AXE + 32} class="cp-tick">{t === 0 ? '0' : f(t, 1)}</text>
    {/each}
    <text x={(XL + XR) / 2} y={AXE + 64} class="cp-titre-axe" class:cp-titre-r={mode === 'unites' && e === 1}>effet sur l’intérêt (de 0 à 1)</text>

    {#each RANGS as r, i}
      <g class="cp-rang" class:cp-rouge={rouge(r)} class:cp-fort={fort(r)}>
        <text x="296" y={y(i) + (r.nom[1] ? -4 : 7)} class="cp-lab">{r.nom[0]}</text>
        {#if r.nom[1]}<text x="296" y={y(i) + 20} class="cp-sous">{r.nom[1]}</text>{/if}
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
        <g class="cp-etape" class:cp-vu={e >= 2} style="transition-delay: {e >= 2 ? i * 120 : 0}ms">
          <text x={XCOL} y={y(i) + 2} class="cp-unite">{r.nom[2]}</text>
          <text x={XCOL} y={y(i) + 23} class="cp-genre">{r.nom[3]}</text>
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
    <p class="cp-phrase cp-etape" class:cp-vu={e >= 1}>
      {#if e >= 2}<span class="cp-mais">Mais 0 → 1 n’a pas le même sens partout&#8239;: comparer avec prudence.</span>
      {:else}Tout va de 0 à 1&#8239;: chaque point, c’est du minimum au maximum.{/if}
    </p>
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
  .cp-titre-axe { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); transition: fill 0.4s; }
  .cp-titre-axe.cp-titre-r { fill: var(--dk-encre); font-weight: 600; }
  .cp-lab { font-size: 22px; font-weight: 600; text-anchor: end; fill: var(--dk-encre); transition: fill 0.4s; }
  .cp-sous { font-size: 17px; text-anchor: end; fill: var(--dk-gris); }
  .cp-moustache { stroke: var(--dk-encre); stroke-width: 5; transition: stroke 0.4s, stroke-width 0.4s; }
  .cp-borne { stroke: var(--dk-encre); stroke-width: 3; transition: stroke 0.4s; }
  .cp-point { fill: var(--dk-encre); transition: fill 0.4s; }
  .cp-rouge .cp-lab, .cp-rouge .cp-point { fill: var(--dk-accent); }
  .cp-rouge .cp-moustache, .cp-rouge .cp-borne { stroke: var(--dk-accent); }
  .cp-fort .cp-moustache { stroke-width: 7; }
  .cp-verdict { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }
  .cp-verdict.cp-non { fill: var(--dk-accent); }
  .cp-etoiles { font-size: 24px; font-weight: 600; fill: var(--dk-gris); }
  .cp-unite { font-size: 19px; fill: var(--dk-encre); }
  .cp-genre { font-size: 17px; fill: var(--dk-gris); }
  .cp-phrase { margin: 0.3em 0 0; font-size: 1em; font-weight: 600; color: var(--dk-encre); text-align: center; }
  .cp-mais { color: var(--dk-accent); }
  .cp-etape { opacity: 0; transition: opacity 0.3s; }
  .cp-etape.cp-vu { opacity: 1; transition: opacity 0.5s; }
  @media (prefers-reduced-motion: reduce) {
    .cp-etape, .cp-etape.cp-vu, .cp-zero, .cp-lab, .cp-moustache, .cp-borne, .cp-point, .cp-titre-axe { transition: none; }
  }
</style>
