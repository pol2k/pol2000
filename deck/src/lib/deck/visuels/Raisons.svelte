<script>
  /**
   * « Pourquoi est-ce que je suis obligé de suivre ce maudit cours là ? »
   * Onze raisons distribuées comme des cartes sur une table: deux par clic,
   * chacune glisse en tournant jusqu'à sa place. La dernière, seule, est le
   * joker rouge — « parce que c'est le fun » — qui se retourne. Les textes
   * sont ceux de l'enseignant.
   */
  import { brancherTemps } from '../temps.js';
  const R = [
    { g: 'job', t: "Parce que le marché du travail s'arrache ces compétences." },
    { g: 'polsci', t: "Parce que vous étudiez en science politique pour devenir politologue, et la science politique est la science sociale la plus quantitative." },
    { g: 'cerveau', t: "Parce que ça rend meilleur pour penser et résoudre des problèmes." },
    { g: 'oeil', t: "Parce que ça change la façon de voir le monde." },
    { g: 'donnees', t: "Parce qu'il y a plus de données que de gens pour les analyser." },
    { g: 'sondage', t: "Parce que vous ne lirez plus jamais un sondage sans vous demander comment il a été fait." },
    { g: 'cause', t: "Parce que « corrélation n'est pas causalité », c'est pas juste un slogan." },
    { g: 'debat', t: "Parce que vous allez mieux argumenter quand quelqu'un vous parlera de statistiques." },
    { g: 'partout', t: "Parce que ces compétences se transfèrent partout : ONG, fonction publique, politique, privé, journalisme." },
    { g: 'cite', t: "Parce que les décisions qui vous concernent (élections, politiques, algorithmes) se prennent avec ces outils." },
    { g: 'fun', t: "Parce que c'est le fun." }
  ];
  // Place de chaque carte sur la table (en % de la scène) et sa rotation. Fixe.
  // Quatre colonnes, trois rangées; le milieu de la rangée centrale reste
  // libre pour le joker.
  const POS = [
    [1, 3, -4], [26, 1, 3], [51, 4, -2], [76, 2, 4],
    [1, 36, 2], [76, 35, -3],
    [1, 68, -3], [26, 66, 2], [51, 69, -4], [76, 67, 3]
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 6, lire: () => e, ecrire: (v) => (e = v) });
  });
  const vue = (i) => i < Math.min(e * 2, 10);
</script>

<div class="visuel raisons" bind:this={hote}>
  <div class="table">
    {#each R.slice(0, 10) as r, i}
      <div class="carte" class:vu={vue(i)} style="left: {POS[i][0]}%; top: {POS[i][1]}%; --rot: {POS[i][2]}deg; transition-delay: {(i % 2) * 180}ms">
        <span class="num">{i + 1}</span>
        <svg viewBox="0 0 48 48" class="g" aria-hidden="true">
          {#if r.g === 'job'}<rect x="8" y="16" width="32" height="22" rx="2" /><path d="M 18 16 v -5 h 12 v 5" /><line x1="8" y1="26" x2="40" y2="26" />
          {:else if r.g === 'polsci'}<path d="M 8 40 h 32 M 12 40 v -14 M 24 40 v -14 M 36 40 v -14 M 6 26 h 36 M 24 8 l 18 10 h -36 Z" />
          {:else if r.g === 'cerveau'}<path d="M 18 10 a 7 7 0 0 0 -7 8 a 6 6 0 0 0 -1 11 a 7 7 0 0 0 8 8 h 12 a 7 7 0 0 0 8 -8 a 6 6 0 0 0 -1 -11 a 7 7 0 0 0 -7 -8 Z" /><line x1="24" y1="10" x2="24" y2="37" />
          {:else if r.g === 'oeil'}<path d="M 5 24 q 19 -18 38 0 q -19 18 -38 0 Z" /><circle cx="24" cy="24" r="6" /><circle cx="24" cy="24" r="2" class="f" />
          {:else if r.g === 'donnees'}<rect x="8" y="10" width="32" height="10" /><rect x="8" y="24" width="32" height="10" /><circle cx="14" cy="15" r="1.6" class="f" /><circle cx="14" cy="29" r="1.6" class="f" />
          {:else if r.g === 'sondage'}<rect x="10" y="8" width="28" height="32" /><path d="M 16 17 h 8 M 16 24 h 12 M 16 31 h 6" /><circle cx="34" cy="31" r="3" />
          {:else if r.g === 'cause'}<circle cx="12" cy="30" r="5" /><circle cx="36" cy="30" r="5" /><circle cx="24" cy="12" r="5" class="z" /><path d="M 17 30 h 14" /><path d="M 20 16 l -5 9 M 28 16 l 5 9" class="z" />
          {:else if r.g === 'debat'}<path d="M 6 12 h 22 v 14 h -12 l -6 6 v -6 h -4 Z" /><path d="M 30 22 h 12 v 12 h -4 v 5 l -5 -5 h -3 Z" />
          {:else if r.g === 'partout'}<circle cx="24" cy="24" r="17" /><path d="M 7 24 h 34 M 24 7 q 10 17 0 34 M 24 7 q -10 17 0 34" />
          {:else}<rect x="10" y="20" width="28" height="20" /><path d="M 20 20 v -8 h 8 v 8" /><line x1="16" y1="30" x2="32" y2="30" />
          {/if}
        </svg>
        <p>{r.t}</p>
      </div>
    {/each}
    <div class="joker" class:vu={e >= 6}>
      <div class="face dos"><span>?</span></div>
      <div class="face avant">
        <svg viewBox="0 0 48 48" class="g" aria-hidden="true"><circle cx="24" cy="24" r="17" /><path d="M 15 28 q 9 10 18 0" /><circle cx="18" cy="19" r="2" class="f" /><circle cx="30" cy="19" r="2" class="f" /></svg>
        <p>Parce que c'est le fun.</p>
        <small>Vraiment.</small>
      </div>
    </div>
  </div>
</div>

<style>
  .raisons { width: 100%; }
  .table { position: relative; height: 66vh; }
  .carte { position: absolute; width: 22.5%; background: var(--dk-fond); border: 2.5px solid var(--dk-encre); padding: 0.7em 0.8em 0.7em; display: grid; grid-template-columns: 2em 1fr; gap: 0.6em; align-items: start;
    opacity: 0; transform: translate(40vw, -40vh) rotate(25deg); transition: transform 0.75s cubic-bezier(0.2, 0.8, 0.2, 1), opacity 0.4s; box-shadow: 0.35em 0.35em 0 var(--dk-filet); }
  .carte.vu { opacity: 1; transform: rotate(var(--rot)); }
  .num { position: absolute; top: -0.65em; left: -0.65em; width: 1.5em; height: 1.5em; border-radius: 50%; background: var(--dk-encre); color: var(--dk-fond); font-family: var(--dk-mono); font-weight: 600; font-size: 0.75em; display: flex; align-items: center; justify-content: center; }
  .g { width: 2em; height: 2em; margin-top: 0.1em; }
  .g * { fill: none; stroke: var(--dk-encre); stroke-width: 2.4; stroke-linejoin: round; stroke-linecap: round; }
  .g .f { fill: var(--dk-encre); stroke: none; }
  .g .z { stroke-dasharray: 3 2; }
  .carte p { margin: 0; font-size: 0.68em; line-height: 1.33; }
  /* Le joker: au centre, plus grand, retourné au dernier temps. */
  .joker { position: absolute; left: 50%; top: 50%; width: 30%; aspect-ratio: 5 / 3; transform: translate(-50%, -50%) rotate(-6deg) scale(0.6); opacity: 0; transition: opacity 0.4s, transform 0.9s cubic-bezier(0.2, 0.8, 0.2, 1); transform-style: preserve-3d; }
  .joker.vu { opacity: 1; transform: translate(-50%, -50%) rotate(-6deg) scale(1) rotateY(180deg); }
  .face { position: absolute; inset: 0; backface-visibility: hidden; border: 3px solid var(--dk-accent); display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.2em; box-shadow: 0.45em 0.45em 0 var(--dk-accent-clair); }
  .face.dos { background: var(--dk-accent); color: var(--dk-fond); font-family: var(--dk-mono); font-size: 4em; font-weight: 600; }
  .face.avant { background: var(--dk-fond); transform: rotateY(180deg); }
  .face.avant .g { width: 3.4em; height: 3.4em; }
  .face.avant .g * { stroke: var(--dk-accent); }
  .face.avant .g .f { fill: var(--dk-accent); }
  .face.avant p { margin: 0; font-size: 1.2em; font-weight: 600; color: var(--dk-accent); text-align: center; padding: 0 0.8em; }
  .face.avant small { font-size: 0.8em; color: var(--dk-gris); }
</style>
