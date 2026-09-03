<script>
  /**
   * « Pourquoi diable devrais-je m'en soucier ? » Douze réponses, une tuile
   * chacune, avec son glyphe. Quatre temps: trois tuiles par clic. Les six
   * premières sont celles de l'enseignant; les six suivantes sont ajoutées.
   */
  import { brancherTemps } from '../temps.js';
  const R = [
    { g: 'fun', t: "Parce que c'est le fun. Vraiment." },
    { g: 'job', t: "Parce que le marché du travail s'arrache ces compétences." },
    { g: 'uni', t: "Parce qu'on est à l'université pour apprendre quelque chose de neuf." },
    { g: 'cerveau', t: "Parce que ça rend meilleur.e pour penser et résoudre des problèmes." },
    { g: 'oeil', t: "Parce que ça change la façon de voir le monde." },
    { g: 'donnees', t: "Parce qu'il y a plus de données que de gens pour les analyser." },
    { g: 'sondage', t: "Parce que vous ne lirez plus jamais un sondage ou une manchette sans savoir quoi lui demander." },
    { g: 'cause', t: "Parce que « corrélation n'est pas causalité » cessera d'être un slogan : vous saurez pourquoi." },
    { g: 'ia', t: "Parce que l'IA écrit le code, maintenant. Mais quelqu'un doit savoir si la réponse est juste." },
    { g: 'cite', t: "Parce que les décisions qui vous concernent — élections, politiques, algorithmes — se prennent avec ces outils." },
    { g: 'debat', t: "Parce que les chiffres qu'on vous lance dans un débat cesseront de vous intimider." },
    { g: 'partout', t: "Parce que ça se transfère partout : journalisme, fonction publique, ONG, entreprise, politique." }
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel pourquoi" bind:this={hote}>
  {#each R as r, i}
    <div class="tuile" class:vu={i < e * 3} class:mienne={i >= 6} style="transition-delay: {(i % 3) * 120}ms">
      <svg viewBox="0 0 48 48" class="g" aria-hidden="true">
        {#if r.g === 'fun'}<circle cx="24" cy="24" r="17" /><path d="M 15 28 q 9 10 18 0" /><circle cx="18" cy="19" r="2" class="f" /><circle cx="30" cy="19" r="2" class="f" />
        {:else if r.g === 'job'}<rect x="8" y="16" width="32" height="22" rx="2" /><path d="M 18 16 v -5 h 12 v 5" /><line x1="8" y1="26" x2="40" y2="26" />
        {:else if r.g === 'uni'}<path d="M 6 20 L 24 12 L 42 20 L 24 28 Z" /><path d="M 13 24 v 9 q 11 7 22 0 v -9" /><line x1="42" y1="20" x2="42" y2="32" />
        {:else if r.g === 'cerveau'}<path d="M 18 10 a 7 7 0 0 0 -7 8 a 6 6 0 0 0 -1 11 a 7 7 0 0 0 8 8 h 12 a 7 7 0 0 0 8 -8 a 6 6 0 0 0 -1 -11 a 7 7 0 0 0 -7 -8 Z" /><line x1="24" y1="10" x2="24" y2="37" /><path d="M 15 22 h 6 M 27 26 h 6" />
        {:else if r.g === 'oeil'}<path d="M 5 24 q 19 -18 38 0 q -19 18 -38 0 Z" /><circle cx="24" cy="24" r="6" /><circle cx="24" cy="24" r="2" class="f" />
        {:else if r.g === 'donnees'}<rect x="8" y="10" width="32" height="10" /><rect x="8" y="24" width="32" height="10" /><circle cx="14" cy="15" r="1.6" class="f" /><circle cx="14" cy="29" r="1.6" class="f" /><path d="M 30 38 h 10 v -4" />
        {:else if r.g === 'sondage'}<rect x="10" y="8" width="28" height="32" /><path d="M 16 17 h 8 M 16 24 h 12 M 16 31 h 6" /><circle cx="34" cy="31" r="3" />
        {:else if r.g === 'cause'}<circle cx="12" cy="30" r="5" /><circle cx="36" cy="30" r="5" /><circle cx="24" cy="12" r="5" class="z" /><path d="M 17 30 h 14" /><path d="M 20 16 l -5 9 M 28 16 l 5 9" class="z" />
        {:else if r.g === 'ia'}<rect x="10" y="14" width="28" height="22" rx="4" /><circle cx="19" cy="24" r="2.5" class="f" /><circle cx="29" cy="24" r="2.5" class="f" /><line x1="24" y1="8" x2="24" y2="14" /><path d="M 17 31 q 7 4 14 0" />
        {:else if r.g === 'cite'}<rect x="10" y="20" width="28" height="20" /><path d="M 20 20 v -8 h 8 v 8" /><path d="M 24 12 v -4" /><line x1="16" y1="30" x2="32" y2="30" />
        {:else if r.g === 'debat'}<path d="M 6 12 h 22 v 14 h -12 l -6 6 v -6 h -4 Z" /><path d="M 30 22 h 12 v 12 h -4 v 5 l -5 -5 h -3 Z" />
        {:else}<circle cx="24" cy="24" r="17" /><path d="M 7 24 h 34 M 24 7 q 10 17 0 34 M 24 7 q -10 17 0 34" />
        {/if}
      </svg>
      <p>{r.t}</p>
    </div>
  {/each}
</div>

<style>
  .pourquoi { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.7em; }
  .tuile { border: 2px solid var(--dk-encre); padding: 0.75em 0.85em; display: grid; grid-template-columns: 2.4em 1fr; gap: 0.7em; align-items: center; opacity: 0.08; transform: translateY(0.4em); transition: opacity 0.45s, transform 0.45s; }
  .tuile.vu { opacity: 1; transform: none; }
  .tuile.mienne { border-color: var(--dk-accent); }
  .g { width: 2.4em; height: 2.4em; }
  .g * { fill: none; stroke: var(--dk-encre); stroke-width: 2.4; stroke-linejoin: round; stroke-linecap: round; }
  .mienne .g * { stroke: var(--dk-accent); }
  .g .f { fill: var(--dk-encre); stroke: none; }
  .mienne .g .f { fill: var(--dk-accent); }
  .g .z { stroke-dasharray: 3 2; }
  .tuile p { margin: 0; font-size: 0.78em; line-height: 1.35; }
</style>
