<script>
  /**
   * Le sondage du Literary Digest, présidentielle américaine de 1936
   * (Roosevelt contre Landon) : beaucoup de réponses, un mauvais
   * échantillon. Tous les nombres viennent de DIGEST (src/lib/data/seance5.js),
   * qui les tient de Squire (1988, p. 126-127) : plus de 10 millions de
   * bulletins postés, plus de 2,3 millions retournés (moins de 25 %),
   * prévision Landon 55 %, Roosevelt 41 %; résultat Roosevelt 61 %,
   * Landon 37 %. D'où venaient les adresses : Squire, même pages.
   *
   *   0  « 10 millions de bulletins postés » : dix enveloppes, une par
   *      million, et d'où venaient les adresses.
   *   1  « 2,3 millions de réponses » : 2,3 enveloppes se remplissent de
   *      rouge; moins de 25 %.
   *   2  À droite, deux paires de barres sur la même échelle, dans le même
   *      ordre (Landon, puis Roosevelt) : la prévision, puis le résultat.
   *      Landon est en rouge dans les deux : longue barre, puis courte.
   */
  import { brancherTemps } from '../temps.js';
  import { DIGEST } from '$lib/data/seance5.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const f = (x, d = 0) => x.toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d }).replace(/\s/g, ' ');
  const MILLIONS_POSTES = DIGEST.postes / 1e6;
  const MILLIONS_RECUS = DIGEST.retournes / 1e6;
  const TAUX = Math.round(DIGEST.taux * 100);

  // Une enveloppe par million de bulletins postés; le rouge, les réponses.
  const ENV = Array.from({ length: Math.round(MILLIONS_POSTES) }, (_, i) => ({
    x: 40 + i * 42,
    part: Math.max(0, Math.min(1, MILLIONS_RECUS - i))
  }));
  const EY = 172, EW = 34, EH = 24;

  // Les barres : une seule échelle pour les deux paires.
  const XN = 540, XB = 668, K = 3.9, BH = 32;
  const GROUPES = [
    { titre: 'prévision', y: 110, barres: [['Landon', DIGEST.prevision.Landon], ['Roosevelt', DIGEST.prevision.Roosevelt]] },
    { titre: 'résultat', y: 272, barres: [['Landon', DIGEST.resultat.Landon], ['Roosevelt', DIGEST.resultat.Roosevelt]] }
  ];
</script>

<div class="visuel digest1936" bind:this={hote}>
  <svg viewBox="0 0 1000 460" role="img" aria-label="Présidentielle américaine de 1936. Le Literary Digest poste {f(MILLIONS_POSTES)} millions de bulletins et reçoit {f(MILLIONS_RECUS, 1)} millions de réponses, moins de {TAUX}&#8239;%. Il prévoit Landon {DIGEST.prevision.Landon}&#8239;%, Roosevelt {DIGEST.prevision.Roosevelt}&#8239;%. Résultat : Roosevelt {DIGEST.resultat.Roosevelt}&#8239;%, Landon {DIGEST.resultat.Landon}&#8239;%.">
    <text x="40" y="30" class="dg-contexte">présidentielle américaine de 1936&#8239;: Roosevelt contre Landon</text>

    <!-- 0 : les bulletins postés. -->
    <text x="40" y="118" class="dg-gros">{f(MILLIONS_POSTES)} millions</text>
    <text x="40" y="152" class="dg-mot">de bulletins postés</text>
    {#each ENV as v, i}
      <rect x={v.x} y={EY} width={EW * v.part} height={EH} class="dg-recu" class:dg-vu={e >= 1} style="transition-delay: {i * 120}ms" />
      <rect x={v.x} y={EY} width={EW} height={EH} class="dg-env" />
      <path d="M {v.x} {EY} L {v.x + EW / 2} {EY + 13} L {v.x + EW} {EY}" class="dg-rabat" />
    {/each}
    <text x="40" y="226" class="dg-petit">tirés des listes d’automobiles</text>
    <text x="40" y="248" class="dg-petit">et des annuaires téléphoniques</text>

    <!-- 1 : les réponses. -->
    <g class="dg-bloc" class:dg-vu={e >= 1}>
      <text x="40" y="334" class="dg-gros">{f(MILLIONS_RECUS, 1)} millions</text>
      <text x="40" y="368" class="dg-mot">de réponses</text>
      <text x="40" y="406" class="dg-taux">moins de {TAUX}&#8239;%</text>
    </g>

    <!-- 2 : la prévision, puis le résultat. -->
    <g class="dg-bloc dg-barres" class:dg-vu={e >= 2}>
      {#each GROUPES as g, gi}
        <text x={XN} y={g.y} class="dg-titre">{#if gi === 0}prévision du <tspan class="dg-ital">Literary Digest</tspan>{:else}résultat de l’élection{/if}</text>
        <line x1={XB} y1={g.y + 14} x2={XB} y2={g.y + 22 + 2 * BH + 10 + 4} class="dg-axe" />
        {#each g.barres as [nom, v], k}
          {@const y = g.y + 22 + k * (BH + 10)}
          <text x={XN} y={y + 23} class="dg-nom" class:dg-landon={nom === 'Landon'}>{nom}</text>
          <rect x={XB} {y} width={v * K} height={BH} class="dg-barre" class:dg-landon={nom === 'Landon'} style="transition-delay: {e >= 2 ? 250 + gi * 500 + k * 120 : 0}ms" />
          <text x={XB + v * K + 10} y={y + 24} class="dg-val" class:dg-landon={nom === 'Landon'} style="transition-delay: {e >= 2 ? 650 + gi * 500 + k * 120 : 0}ms">{v}&#8239;%</text>
        {/each}
      {/each}
    </g>

    <text x="40" y="448" class="dg-source">Squire (1988, p. 126-127)</text>
  </svg>
</div>

<style>
  .digest1936 { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 56vh; display: block; }
  text { font-family: var(--dk-mono); }
  .dg-contexte { font-size: 20px; fill: var(--dk-gris); letter-spacing: 0.02em; }
  .dg-gros { font-size: 60px; font-weight: 600; fill: var(--dk-encre); letter-spacing: -0.03em; }
  .dg-mot { font-size: 24px; fill: var(--dk-encre); }
  .dg-petit { font-size: 18px; fill: var(--dk-gris); }
  .dg-taux { font-size: 28px; font-weight: 600; fill: var(--dk-accent); }
  .dg-source { font-size: 17px; fill: var(--dk-gris-2); letter-spacing: 0.04em; }

  .dg-env { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; }
  .dg-rabat { fill: none; stroke: var(--dk-encre); stroke-width: 2; }
  .dg-recu { fill: var(--dk-accent); transform-box: fill-box; transform-origin: left center; transform: scaleX(0); transition: transform 0.2s; }
  .dg-recu.dg-vu { transform: scaleX(1); transition: transform 0.4s ease-out; }

  .dg-bloc { opacity: 0; transition: opacity 0.2s; }
  .dg-bloc.dg-vu { opacity: 1; transition: opacity 0.4s 0.2s; }

  .dg-titre { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .dg-ital { font-style: italic; }
  .dg-axe { stroke: var(--dk-encre); stroke-width: 3; }
  .dg-nom { font-size: 22px; fill: var(--dk-encre); }
  .dg-barre { fill: var(--dk-encre); transform-box: fill-box; transform-origin: left center; transform: scaleX(0); transition: transform 0.2s; }
  .dg-barres.dg-vu .dg-barre { transform: scaleX(1); transition: transform 0.6s cubic-bezier(0.34, 1.3, 0.64, 1); }
  .dg-val { font-size: 22px; font-weight: 600; fill: var(--dk-encre); opacity: 0; transition: opacity 0.2s; }
  .dg-barres.dg-vu .dg-val { opacity: 1; transition: opacity 0.4s; }
  .dg-nom.dg-landon, .dg-val.dg-landon { fill: var(--dk-accent); font-weight: 600; }
  .dg-barre.dg-landon { fill: var(--dk-accent); }

  @media (prefers-reduced-motion: reduce) {
    .dg-recu, .dg-recu.dg-vu, .dg-bloc, .dg-bloc.dg-vu, .dg-barre, .dg-barres.dg-vu .dg-barre, .dg-val, .dg-barres.dg-vu .dg-val { transition: none; }
  }
</style>
