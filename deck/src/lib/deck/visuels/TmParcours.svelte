<script>
  /**
   * Le parcours du travail de mi-session : les sept étapes des consignes
   * (travaux/pdf/travail-mi-session-A26.tex, « À l'intérieur de ce travail,
   * vous devrez »), en une bande mince qui revient en tête de chaque diapo
   * d'étape. L'étape du moment est pleine, en rouge; celles d'avant sont
   * cochées à l'encre; celles d'après attendent, pâles.
   *
   * ici = 1 à 7 (l'étape en cours); 0 = toutes à égalité (vue d'ensemble).
   * Pas de temps : la bande ne bouge qu'à l'arrivée sur la diapo.
   */
  let { ici = 0 } = $props();
  const ETAPES_MS = ['Question', 'Littérature', 'Hypothèse', 'Données', 'Pertinence', 'Contribution', 'Vous'];
</script>

<ol class="visuel tm-parcours" aria-label="Les sept étapes du travail de mi-session{ici ? `, étape ${ici}` : ''}">
  {#each ETAPES_MS as nom, i}
    {@const n = i + 1}
    <li class:tm-fait={ici && n < ici} class:tm-ici={n === ici} class:tm-apres={ici && n > ici} style="--i: {i}">
      <span class="tm-n">{n}</span><span class="tm-nom">{nom}</span>
    </li>
  {/each}
</ol>

<style>
  .tm-parcours { list-style: none; margin: 0 0 0.2em; padding: 0; display: grid; grid-template-columns: repeat(7, 1fr); gap: 0.3em; }
  .tm-parcours li { margin: 0; display: flex; align-items: baseline; gap: 0.45em; padding: 0.3em 0.5em 0.28em; border-top: 4px solid var(--dk-encre); font-size: 0.62em; letter-spacing: 0.05em; line-height: 1.2; white-space: nowrap; animation: tm-p-fondu 0.4s both; animation-delay: calc(var(--i) * 40ms); }
  .tm-n { font-weight: 600; }
  .tm-nom { overflow: hidden; text-overflow: ellipsis; }
  .tm-fait { color: var(--dk-gris); border-top-color: var(--dk-gris-2) !important; }
  .tm-fait .tm-n::after { content: ' ✓'; }
  .tm-apres { color: var(--dk-gris-2); border-top-color: var(--dk-filet) !important; }
  .tm-ici { background: var(--dk-accent); color: var(--dk-fond); border-top-color: var(--dk-accent) !important; font-weight: 600; }
  @keyframes tm-p-fondu { from { opacity: 0; transform: translateY(-0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .tm-parcours li { animation: none; } }
</style>
