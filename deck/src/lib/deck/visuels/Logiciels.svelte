<script>
  /**
   * Le paysage des logiciels d'analyse, en autocollants : les vrais logos,
   * posés de travers comme sur un portable, qui flottent doucement. R au
   * centre, plus grand. Aucune part de marché n'est dessinée ; on n'a pas
   * mesuré ça. Un mot sous chaque logo dit ce que c'est.
   */
  import { base } from '$app/paths';
  const L = [
    { img: 'python-logo.svg', nom: 'Python', q: 'gratuit · généraliste', x: 4, y: 4, r: -7, s: 1 },
    { img: 'spss-logo.svg', nom: 'SPSS', q: 'payant · menus et clics', x: 6, y: 54, r: 5, s: 1 },
    { img: 'stata-logo.png', nom: 'Stata', q: 'payant · commandes', x: 74, y: 4, r: 6, s: 1 },
    { img: 'julia-logo.svg', nom: 'Julia', q: 'gratuit · rapide, récent', x: 75, y: 54, r: -5, s: 1 },
    { img: 'excel-logo.svg', nom: 'Excel', q: 'payant · le tableur', x: 28, y: 62, r: 4, s: 0.85 }
  ];
</script>

<div class="visuel logiciels">
  {#each L as l, i}
    <div class="colle" style="left: {l.x}%; top: {l.y}%; --rot: {l.r}deg; --s: {l.s}; animation-delay: {i * 0.6}s">
      <img src="{base}/img/{l.img}" alt={l.nom} />
      <span>{l.nom}</span>
      <em>{l.q}</em>
    </div>
  {/each}
  <div class="colle r" style="left: 42%; top: 0%; --rot: -3deg; --s: 1">
    <img src="{base}/img/Rlogo.png" alt="R" />
    <span>R</span>
    <em>gratuit · libre · fait pour les données</em>
  </div>
</div>

<style>
  .logiciels { position: relative; height: 62vh; }
  .colle { position: absolute; width: 20%; border: 2px solid var(--dk-encre); background: #fff; padding: 0.9em 0.8em 0.7em; display: flex; flex-direction: column; align-items: center; gap: 0.25em; transform: rotate(var(--rot)) scale(var(--s)); animation: flotte 4.5s ease-in-out infinite; transition: transform 0.2s; }
  .colle:hover { transform: rotate(0deg) scale(calc(var(--s) * 1.06)); animation-play-state: paused; }
  .colle img { height: 4.2em; width: auto; max-width: 90%; object-fit: contain; }
  .colle span { font-family: var(--dk-mono); font-weight: 600; font-size: 1.05em; margin-top: 0.3em; }
  .colle em { font-style: normal; font-size: 0.62em; color: var(--dk-gris); text-align: center; }
  .colle.r { width: 24%; border: 4px solid var(--dk-accent); padding: 1.3em 1em 1em; }
  .colle.r img { height: 6.8em; }
  .colle.r span { font-size: 2em; color: var(--dk-accent); line-height: 1; }
  @keyframes flotte { 0%, 100% { translate: 0 0; } 50% { translate: 0 -0.5em; } }
</style>
