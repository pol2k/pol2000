<script>
  /**
   * « Pis, ça sert à quoi ? » La coquille commune des diapositives qui
   * répondent, statistique par statistique, à la personne qui suit ce cours
   * parce qu'il est obligatoire. Toujours la même mise en scène, pour que la
   * salle la reconnaisse au premier coup d'œil : la bulle de la question, le
   * nom de la statistique, une scène dessinée, puis la réponse en une ligne.
   *
   *   stat     : le nom de la statistique, en étiquette (« la médiane »)
   *   reponse  : la réponse, une ligne; elle apparaît quand vu est vrai
   *   vu       : la scène décide quand la réponse arrive (son dernier temps)
   *   source   : d'où vient le fait, en petit, facultatif
   *   children : la scène (un SVG animé), rendue au milieu
   */
  let { stat, reponse = '', vu = true, source = '', children } = $props();
</script>

<div class="visuel pis">
  <div class="tete">
    <p class="bulle">Pis, ça sert à quoi&#8239;?</p>
    <span class="stat">{stat}</span>
  </div>
  <div class="scene">{@render children()}</div>
  <p class="reponse" class:vu>{reponse}</p>
  {#if source}<p class="source">{source}</p>{/if}
</div>

<style>
  .pis { display: flex; flex-direction: column; gap: 0.7em; min-height: 0; }
  .tete { display: flex; align-items: flex-end; justify-content: space-between; gap: 1em; }
  /* La bulle : carrée, filaire, avec sa pointe en bas à gauche. Elle arrive en rebondissant. */
  .bulle {
    position: relative;
    margin: 0 0 0.9em;
    padding: 0.35em 0.8em;
    border: 3px solid var(--dk-encre);
    background: var(--dk-fond);
    font-size: 1.6em;
    font-weight: 600;
    line-height: 1.15;
    letter-spacing: -0.02em;
    transform-origin: 1.2em 100%;
    animation: bulle 0.6s cubic-bezier(0.34, 1.7, 0.64, 1) both;
  }
  .bulle::after {
    content: '';
    position: absolute;
    left: 1.1em;
    bottom: -0.62em;
    width: 0.9em;
    height: 0.9em;
    background: var(--dk-fond);
    border-right: 3px solid var(--dk-encre);
    border-bottom: 3px solid var(--dk-encre);
    transform: rotate(45deg) skew(12deg, 12deg);
  }
  .stat {
    font-size: 0.8em;
    font-weight: 600;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--dk-accent);
    margin-bottom: 1em;
    white-space: nowrap;
  }
  .stat::before { content: '[ '; }
  .stat::after { content: ' ]'; }
  .scene { flex: 1 1 auto; min-height: 0; }
  .reponse {
    margin: 0;
    min-height: 1.3em;
    padding-left: 0.6em;
    border-left: 0.34em solid var(--dk-accent);
    font-size: 1.3em;
    font-weight: 600;
    line-height: 1.25;
    opacity: 0;
    transform: translateY(0.4em);
    transition: opacity 0.45s, transform 0.45s cubic-bezier(0.34, 1.56, 0.64, 1);
  }
  .reponse.vu { opacity: 1; transform: none; }
  .source { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }
  @keyframes bulle { from { opacity: 0; transform: scale(0.6) rotate(-4deg); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .bulle { animation: none; }
    .reponse { transition: none; }
  }
</style>
