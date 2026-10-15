<script>
  /**
   * Étape 6 du travail : la contribution. Qu'est-ce que votre travail
   * apporte de neuf ? Les sept pistes de l'enseignant, en cartes face
   * cachée qui se retournent une par une : une méthode, une théorie, une
   * perspective, une population, une variable, une mesure, une question.
   * Chaque carte a son glyphe et un exemple de trois mots, pensé pour la
   * question de la séance (interet selon scolarite). La huitième
   * case donne la règle : une seule suffit, mais il faut la nommer.
   * Huit temps (0 à 7) : 0 tout est caché; k = la carte k se retourne; au
   * temps 7, la règle s'affiche avec la dernière carte.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 7, lire: () => e, ecrire: (v) => (e = v) });
  });

  const CARTES = [
    { k: 'methode', mot: 'méthode', ex: 'un autre modèle' },
    { k: 'theorie', mot: 'théorie', ex: 'une autre explication' },
    { k: 'perspective', mot: 'perspective', ex: 'un autre angle' },
    { k: 'population', mot: 'population', ex: 'les 18-24 ans seulement' },
    { k: 'variable', mot: 'variable', ex: 'ajouter l’âge' },
    { k: 'mesure', mot: 'mesure', ex: 'une autre mesure de l’intérêt' },
    { k: 'question', mot: 'question', ex: 'jamais posée' }
  ];
</script>

<div class="visuel tm-contrib" bind:this={hote}>
  {#each CARTES as c, i}
    <div class="tm-ct-carte" class:tm-tourne={e >= i + 1} class:tm-actif={e === i + 1}>
      <div class="tm-ct-in">
        <div class="tm-ct-dos"><span>?</span></div>
        <div class="tm-ct-face">
          <svg viewBox="0 0 80 60" aria-hidden="true">
            {#if c.k === 'methode'}
              <circle cx="40" cy="30" r="19" class="tm-g-dents" />
              <circle cx="40" cy="30" r="13" class="tm-g-plein" />
              <circle cx="40" cy="30" r="5" class="tm-g-trou" />
            {:else if c.k === 'theorie'}
              <line x1="16" y1="44" x2="40" y2="14" class="tm-g-trait" /><line x1="40" y1="14" x2="64" y2="44" class="tm-g-trait" /><line x1="16" y1="44" x2="64" y2="44" class="tm-g-trait" />
              <circle cx="16" cy="44" r="7" class="tm-g-plein" /><circle cx="40" cy="14" r="7" class="tm-g-rouge" /><circle cx="64" cy="44" r="7" class="tm-g-plein" />
            {:else if c.k === 'perspective'}
              <path d="M 8 30 Q 40 2 72 30 Q 40 58 8 30 Z" class="tm-g-trait" />
              <circle cx="40" cy="30" r="10" class="tm-g-rouge" />
            {:else if c.k === 'population'}
              {#each [0, 1, 2, 3, 4] as x}{#each [0, 1, 2] as y}
                <circle cx={14 + x * 13} cy={14 + y * 16} r="4.5" class={x >= 3 ? 'tm-g-rouge' : 'tm-g-pale'} />
              {/each}{/each}
            {:else if c.k === 'variable'}
              {#each [0, 1, 2, 3] as col}
                <rect x={10 + col * 15} y="8" width="13" height="44" class={col === 3 ? 'tm-g-rouge' : 'tm-g-cadre'} />
              {/each}
            {:else if c.k === 'mesure'}
              <rect x="6" y="20" width="68" height="20" class="tm-g-cadre" />
              {#each Array.from({ length: 11 }) as _, t}
                <line x1={10 + t * 6} y1="20" x2={10 + t * 6} y2={t % 5 === 0 ? 34 : 28} class="tm-g-fin" />
              {/each}
            {:else}
              <text x="40" y="50" class="tm-g-q">?</text>
            {/if}
          </svg>
          <span class="tm-ct-neuf">une nouvelle</span>
          <strong>{c.mot}</strong>
          <span class="tm-ct-ex">{c.ex}</span>
        </div>
      </div>
    </div>
  {/each}
  <div class="tm-ct-regle" class:tm-on={e >= 7}>
    <strong>Une seule suffit.</strong>
    <span>Dites laquelle.</span>
  </div>
</div>

<style>
  .tm-contrib { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1em; perspective: 60em; }
  .tm-ct-carte { height: 10.6em; animation: tm-ct-f 0.35s both; }
  .tm-ct-in { position: relative; width: 100%; height: 100%; transform-style: preserve-3d; transition: transform 0.6s cubic-bezier(0.34, 1.3, 0.64, 1); }
  .tm-tourne .tm-ct-in { transform: rotateY(180deg); }
  .tm-ct-dos, .tm-ct-face { position: absolute; inset: 0; backface-visibility: hidden; box-sizing: border-box; border: 3px solid var(--dk-encre); }
  .tm-ct-dos { display: flex; align-items: center; justify-content: center; background: var(--dk-encre); }
  .tm-ct-dos span { font-size: 3em; font-weight: 600; color: var(--dk-fond); opacity: 0.35; }
  .tm-ct-face { transform: rotateY(180deg); display: flex; flex-direction: column; align-items: flex-start; gap: 0.1em; padding: 0.6em 0.8em; background: #fff; }
  .tm-actif .tm-ct-face { border-color: var(--dk-accent); border-width: 4px; }
  .tm-ct-face svg { width: 3.8em; height: auto; margin-bottom: 0.3em; }
  .tm-ct-neuf { font-size: 0.62em; letter-spacing: 0.08em; color: var(--dk-gris); }
  .tm-ct-face strong { font-size: 1.25em; line-height: 1.1; }
  .tm-actif .tm-ct-face strong { color: var(--dk-accent); }
  .tm-ct-ex { margin-top: auto; font-size: 0.72em; line-height: 1.3; color: var(--dk-gris); border-top: 2px solid var(--dk-filet); padding-top: 0.3em; width: 100%; }

  .tm-g-trait { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .tm-g-plein { fill: var(--dk-encre); }
  .tm-g-rouge { fill: var(--dk-accent); }
  .tm-g-pale { fill: var(--dk-filet); }
  .tm-g-cadre { fill: none; stroke: var(--dk-encre); stroke-width: 3; }
  .tm-g-fin { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tm-g-trou { fill: #fff; }
  .tm-g-dents { fill: none; stroke: var(--dk-encre); stroke-width: 9; stroke-dasharray: 7 7; }
  .tm-g-q { font-family: var(--dk-mono); font-size: 58px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .tm-ct-regle { display: flex; flex-direction: column; justify-content: center; gap: 0.3em; padding: 0.6em 1em; border-left: 0.4em solid var(--dk-accent); opacity: 0; transform: translateX(0.6em); transition: opacity 0.5s 0.5s, transform 0.5s 0.5s; }
  .tm-ct-regle.tm-on { opacity: 1; transform: none; }
  .tm-ct-regle strong { font-size: 1.4em; line-height: 1.15; color: var(--dk-accent); }
  .tm-ct-regle span { font-size: 1.05em; }

  @keyframes tm-ct-f { from { opacity: 0; transform: translateY(0.5em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .tm-ct-carte { animation: none; } .tm-ct-in, .tm-ct-regle { transition: none; } }
</style>
