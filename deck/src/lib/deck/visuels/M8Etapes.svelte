<script>
  /**
   * Le parcours de « Blais en 2025 » (séance 8), en bande mince en tête de
   * chaque diapo de code (comme TmParcours) : l'étape du moment en rouge,
   * celles d'avant cochées, celles d'après pâles.
   *
   * ici = 1 à 6 (l'étape en cours); 0 = toutes à égalité (vue d'ensemble).
   */
  let { ici = 0 } = $props();
  const ETAPES = ['Charger', 'Y : le vote', 'X : catholique', 'Contrôles', 'Modéliser', 'Tableau'];
</script>

<ol class="visuel m8-etapes" aria-label="Les six étapes{ici ? `, étape ${ici}` : ''}">
  {#each ETAPES as nom, i}
    {@const n = i + 1}
    <li class:fait={ici && n < ici} class:ici={n === ici} class:apres={ici && n > ici} style="--i: {i}">
      <span class="n">{n}</span><span class="nom">{nom}</span>
    </li>
  {/each}
</ol>

<style>
  .m8-etapes { list-style: none; margin: 0 0 0.2em; padding: 0; display: grid; grid-template-columns: repeat(6, 1fr); gap: 0.3em; }
  .m8-etapes li { margin: 0; display: flex; align-items: baseline; gap: 0.45em; padding: 0.3em 0.5em 0.28em; border-top: 4px solid var(--dk-encre); font-size: 0.62em; letter-spacing: 0.05em; line-height: 1.2; white-space: nowrap; animation: m8e-fondu 0.4s both; animation-delay: calc(var(--i) * 40ms); }
  .n { font-weight: 600; }
  .fait { color: var(--dk-gris); border-top-color: var(--dk-gris-2) !important; }
  .fait .n::after { content: ' ✓'; }
  .apres { color: var(--dk-gris-2); border-top-color: var(--dk-filet) !important; }
  .ici { background: var(--dk-accent); color: var(--dk-fond); border-top-color: var(--dk-accent) !important; font-weight: 600; }
  @keyframes m8e-fondu { from { opacity: 0; transform: translateY(-0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .m8-etapes li { animation: none; } }
</style>
