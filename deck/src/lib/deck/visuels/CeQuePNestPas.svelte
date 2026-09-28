<script>
  /**
   * Ce que la valeur p ne dit pas. Trois lectures fausses, rayées une par
   * une, et la seule lecture juste, en bas, qui s'allume à la fin.
   *
   *   0  Quatre cartes : trois lectures courantes (la probabilité que H₀
   *      soit vraie, la taille ou l'importance de l'effet, la preuve d'une
   *      cause) et, en dessous, en style neutre, ce que p dit vraiment.
   *   1  La première lecture est rayée, un X rouge dans son coin.
   *   2  La deuxième aussi.
   *   3  La troisième aussi. La carte du bas passe au rouge : à quel point
   *      nos données seraient surprenantes si H₀ était vraie.
   *
   * Schéma, aucune donnée. Source : Wasserstein et Lazar (2016), l'énoncé
   * de l'American Statistical Association sur la valeur p.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const FAUSSES = ['la probabilité que H₀ soit vraie', 'la taille ou l’importance de l’effet', 'la preuve d’une cause'];
</script>

<div class="visuel ce-que-p" bind:this={hote}>
  <div class="cp-cartes" role="img" aria-label="La valeur p n’est pas la probabilité que H₀ soit vraie. Elle n’est pas la taille ou l’importance de l’effet. Elle n’est pas la preuve d’une cause. Ce qu’elle dit&#8239;: à quel point nos données seraient surprenantes si H₀ était vraie.">
    {#each FAUSSES as f, i}
      <div class="cp-carte" class:cp-raye={e >= i + 1}>
        <span class="cp-x"></span>
        <span class="cp-texte">{f}</span>
      </div>
    {/each}
    <div class="cp-carte cp-juste" class:cp-allume={e >= 3}>
      <span class="cp-texte"><strong>ce qu’elle dit&#8239;:</strong> à quel point nos données seraient surprenantes si H₀ était vraie</span>
    </div>
  </div>
  <p class="cp-src">Wasserstein et Lazar (2016), énoncé de l’American Statistical Association sur la valeur p</p>
</div>

<style>
  .ce-que-p { display: flex; flex-direction: column; gap: 0.6em; }
  .cp-cartes { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; }
  .cp-carte { position: relative; display: flex; align-items: center; min-height: 5.4em; padding: 0.9em 2.4em 0.9em 1em; border: 3px solid var(--dk-encre); animation: cp-monte 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) both; transition: border-color 0.3s; }
  .cp-carte:nth-child(2) { animation-delay: 0.1s; }
  .cp-carte:nth-child(3) { animation-delay: 0.2s; }
  .cp-texte { font-size: 1.15em; line-height: 1.35; font-weight: 600; text-decoration: line-through; text-decoration-color: transparent; text-decoration-thickness: 0.14em; transition: color 0.3s, text-decoration-color 0.35s; }
  .cp-raye { border-color: var(--dk-gris-2); }
  .cp-raye .cp-texte { color: var(--dk-gris); text-decoration-color: var(--dk-accent); }

  /* Le X rouge : deux barres croisées, dessinées. */
  .cp-x { position: absolute; top: 0.55em; right: 0.55em; width: 1.3em; height: 1.3em; transform: scale(0); transition: transform 0.4s cubic-bezier(0.34, 1.8, 0.64, 1); }
  .cp-x::before, .cp-x::after { content: ''; position: absolute; left: 50%; top: 50%; width: 1.5em; height: 0.2em; margin: -0.1em 0 0 -0.75em; background: var(--dk-accent); }
  .cp-x::before { transform: rotate(45deg); }
  .cp-x::after { transform: rotate(-45deg); }
  .cp-raye .cp-x { transform: scale(1); transition-delay: 0.15s; }

  .cp-juste { grid-column: 1 / 4; min-height: 0; padding: 0.9em 1.2em; border: 3px dashed var(--dk-gris-2); animation-delay: 0.3s; transition: border-color 0.4s, transform 0.4s; }
  .cp-juste .cp-texte { text-decoration: none; font-weight: 400; color: var(--dk-gris); transition: color 0.4s; }
  .cp-juste .cp-texte strong { font-weight: 600; }
  .cp-juste.cp-allume { border-style: solid; border-color: var(--dk-accent); animation: cp-rebond 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
  .cp-juste.cp-allume .cp-texte { color: var(--dk-encre); }
  .cp-juste.cp-allume .cp-texte strong { color: var(--dk-accent); }

  .cp-src { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); text-align: right; }
  @keyframes cp-monte { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @keyframes cp-rebond { from { transform: scale(0.97); } to { transform: scale(1); } }

  @media (prefers-reduced-motion: reduce) {
    .cp-carte, .cp-juste.cp-allume { animation: none; }
    .cp-carte, .cp-texte, .cp-x, .cp-raye .cp-x, .cp-juste, .cp-juste .cp-texte { transition: none; }
  }
</style>
