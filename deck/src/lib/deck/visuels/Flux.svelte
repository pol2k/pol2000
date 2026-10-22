<script>
  /**
   * Le flux d'un effet le long d'une flèche : des points qui voyagent de la
   * cause vers la conséquence, en boucle. À placer DANS un <svg>, par-dessus
   * le trait de la flèche (même tracé d).
   *
   *   d        le tracé (le même que la flèche), de la cause vers l'effet;
   *   actif    false : aucun point (la cause ne varie pas, ou pas encore);
   *   arret    de 0 à 1 : la fraction du tracé où les points s'arrêtent, se
   *            tiennent un instant sur la barrière, puis s'éteignent (une
   *            variable contrôlée les absorbe). 1 = jusqu'au bout;
   *   passe    de 0 à 1 : la part des points qui passent malgré l'arrêt
   *            (un contrôle mal mesuré ne bloque qu'en partie). Les autres
   *            s'éteignent à « arret »;
   *   rouge    la couleur du point (accent) plutôt que l'encre;
   *   n        nombre de points sur le tracé à la fois;
   *   duree    secondes pour parcourir le tracé entier;
   *   r        rayon des points (unités du viewBox).
   *
   * SMIL (animateMotion) : déterministe, aucun calcul par image. Les départs
   * sont décalés de duree / n; les points gardent leur décalage même s'ils
   * apparaissent après le chargement de la page. Sous
   * prefers-reduced-motion, les points disparaissent : la flèche reste.
   */
  let { d, actif = true, arret = 1, passe = 0, rouge = false, n = 4, duree = 2.4, r = 7 } = $props();
  const pts = $derived(Array.from({ length: n }, (_, i) => i));
  // Qui passe, qui s'arrête : la suite de van der Corput (0, ½, ¼, ¾…)
  // alterne les deux sortes de points le long du tracé. Déterministe.
  const vdc = (i) => { let v = 0, b = 0.5; for (let k = i; k > 0; k >>= 1, b /= 2) if (k & 1) v += b; return v; };
  // Un point arrêté arrive sur la barrière au plus tard aux 4/5 du cycle,
  // y reste un instant (il s'y empile), puis s'éteint : l'arrêt se voit, il
  // ne ressemble pas au bout d'une flèche.
  const arrivee = (fin) => Math.min(fin, 0.8);
  const arretTemps = (fin) => { const t = arrivee(fin); return `0;0.06;${t + 0.12};${t + 0.18};1`; };
  const bloque = (i) => arret < 1 && (passe <= 0 || vdc(i) >= passe);
</script>

{#if actif}
  <g class="flux" class:flux-rouge={rouge} aria-hidden="true">
    {#each pts as i (i)}
      {@const b = bloque(i)}
      {@const fin = b ? arret : 1}
      <circle r={r} class="flux-pt">
        <animateMotion path={d} dur="{duree}s" begin="{-(duree * i) / n}s" repeatCount="indefinite" calcMode="linear" keyPoints={b ? `0;${fin};${fin}` : '0;1'} keyTimes={b ? `0;${arrivee(fin)};1` : '0;1'} />
        <animate attributeName="opacity" dur="{duree}s" begin="{-(duree * i) / n}s" repeatCount="indefinite" calcMode="linear"
          values={b ? '0;1;1;0;0' : '0;1;1;0'}
          keyTimes={b ? arretTemps(fin) : '0;0.06;0.92;1'} />
      </circle>
    {/each}
  </g>
{/if}

<style>
  .flux-pt { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 2; }
  .flux-rouge .flux-pt { fill: var(--dk-accent); }
  @media (prefers-reduced-motion: reduce) { .flux { display: none; } }
</style>
