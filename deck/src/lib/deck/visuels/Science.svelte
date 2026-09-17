<script>
  /**
   * C'est quoi, la science ? Les quatre caractéristiques de la recherche
   * scientifique selon King, Keohane et Verba (1994, p. 7-9). Quatre tuiles,
   * une par clic.
   *
   *   0  Quatre tuiles pointillées, vides : seulement leurs numéros.
   *   1  Le but : l'inférence. Un petit groupe de points, une flèche rouge
   *      qui saute vers une zone plus grande, pointillée.
   *   2  Des procédures publiques. Un cahier ouvert, un œil au-dessus.
   *   3  Des conclusions incertaines. Une estimation, et sa marge en rouge.
   *   4  Le contenu, c'est la méthode. Une clé qui sert à trois sujets.
   *
   * La tuile courante porte un cadre rouge; les précédentes restent
   * dévoilées, cadre d'encre. Pictogrammes schématiques, aucune donnée.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const N = ' ';
  const TUILES = [
    { t: `Le but${N}: l’inférence`, l: 'aller au-delà de ce qu’on a observé' },
    { t: 'Des procédures publiques', l: 'tout le monde peut vérifier, et refaire' },
    { t: 'Des conclusions incertaines', l: 'on dit à quel point on peut se tromper' },
    { t: `Le contenu, c’est la méthode`, l: 'la même méthode, pour n’importe quel sujet' }
  ];
  // Le petit groupe de points de la tuile 1 : positions fixes.
  const GROUPE = [[20, 52], [30, 44], [30, 60], [40, 52], [22, 66], [38, 68], [26, 36]];
</script>

<div class="visuel science" bind:this={hote}>
  <div class="rangee">
    {#each TUILES as t, i}
      {@const vu = e >= i + 1}
      <div class="tuile-s" class:vu class:ici={e === i + 1}>
        <span class="num">{i + 1}</span>
        <svg viewBox="0 0 120 100" aria-hidden="true">
          {#if vu}
            {#if i === 0}
              {#each GROUPE as [x, y], k}
                <circle cx={x} cy={y} r="5" class="pt" style="--k: {k}" />
              {/each}
              <rect x="66" y="24" width="48" height="60" pathLength="1" class="trait pointille" style="--k: 1" />
              <path d="M 46 48 Q 62 10 84 38" pathLength="1" class="trait rouge" style="--k: 3" />
              <path d="M 74 34 L 84 38 L 82 27" pathLength="1" class="trait rouge" style="--k: 5" />
            {:else if i === 1}
              <path d="M 12 44 L 58 52 L 58 94 L 12 86 Z" pathLength="1" class="trait" style="--k: 0" />
              <path d="M 108 44 L 62 52 L 62 94 L 108 86 Z" pathLength="1" class="trait" style="--k: 1" />
              <path d="M 20 58 L 50 63 M 20 68 L 50 73 M 20 78 L 50 83" pathLength="1" class="trait fin" style="--k: 2" />
              <path d="M 70 63 L 100 58 M 70 73 L 100 68 M 70 83 L 100 78" pathLength="1" class="trait fin" style="--k: 3" />
              <path d="M 36 22 Q 60 2 84 22 Q 60 42 36 22 Z" pathLength="1" class="trait rouge" style="--k: 4" />
              <circle cx="60" cy="22" r="6" class="pt rouge" style="--k: 6" />
            {:else if i === 2}
              <path d="M 8 70 L 112 70" pathLength="1" class="trait" style="--k: 0" />
              <circle cx="60" cy="70" r="8" class="pt" style="--k: 2" />
              <path d="M 32 50 L 24 50 L 24 90 L 32 90" pathLength="1" class="trait rouge epais" style="--k: 3" />
              <path d="M 88 50 L 96 50 L 96 90 L 88 90" pathLength="1" class="trait rouge epais" style="--k: 3" />
              <text x="60" y="40" class="pm">±</text>
            {:else}
              <path d="M 12 86 L 38 60" pathLength="1" class="trait epais" style="--k: 0" />
              <path d="M 32 50 A 13 13 0 1 0 50 66" pathLength="1" class="trait epais" style="--k: 1" />
              <path d="M 56 46 L 78 24 M 56 52 L 80 52 M 56 58 L 78 80" pathLength="1" class="trait rouge" style="--k: 3" />
              <!-- Trois sujets : une urne, un drapeau, un journal. -->
              <path d="M 86 14 L 110 14 L 110 32 L 86 32 Z M 93 19 L 103 19" pathLength="1" class="trait fin" style="--k: 4" />
              <path d="M 90 42 L 90 64 M 90 43 L 108 48 L 90 53" pathLength="1" class="trait fin" style="--k: 5" />
              <path d="M 86 72 L 110 72 L 110 92 L 86 92 Z M 90 78 L 106 78 M 90 84 L 106 84" pathLength="1" class="trait fin" style="--k: 6" />
            {/if}
          {/if}
        </svg>
        <span class="nom">{#if vu}{t.t}{/if}</span>
        <span class="ligne">{#if vu}{t.l}{/if}</span>
      </div>
    {/each}
  </div>
  <p class="source-s">King, Keohane et Verba (1994), <i>Designing Social Inquiry</i>, p. 7-9</p>
</div>

<style>
  .science { display: flex; flex-direction: column; gap: 0.7em; }
  .rangee { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1em; }
  .tuile-s {
    position: relative;
    display: flex;
    flex-direction: column;
    gap: 0.5em;
    padding: 0.8em 0.8em 1em;
    min-height: 19em;
    border: 3px dashed var(--dk-filet);
    transition: border-color 0.3s;
  }
  .tuile-s.vu { border-style: solid; border-color: var(--dk-encre); }
  .tuile-s.ici { border-color: var(--dk-accent); animation: rebond 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
  .num { font-size: 2.2em; font-weight: 600; line-height: 1; color: var(--dk-gris-2); transition: color 0.3s; }
  .vu .num { color: var(--dk-encre); }
  .ici .num { color: var(--dk-accent); }
  svg { width: 100%; height: auto; max-height: 26vh; display: block; }
  .trait { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; stroke-dasharray: 1; stroke-dashoffset: 1; animation: trace 0.55s ease-out forwards; animation-delay: calc(var(--k) * 110ms + 100ms); }
  .trait.fin { stroke-width: 3; }
  .trait.epais { stroke-width: 7; }
  .trait.rouge { stroke: var(--dk-accent); }
  .trait.pointille { stroke: var(--dk-gris-2); stroke-width: 3; }
  .pt { fill: var(--dk-encre); transform-box: fill-box; transform-origin: center; animation: pop 0.4s cubic-bezier(0.34, 1.8, 0.64, 1) both; animation-delay: calc(var(--k) * 60ms + 100ms); }
  .pt.rouge { fill: var(--dk-accent); }
  .pm { font-family: var(--dk-mono); font-size: 28px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); animation: pop 0.45s cubic-bezier(0.34, 1.8, 0.64, 1) 0.5s both; transform-box: fill-box; transform-origin: center; }
  .nom { font-size: 1em; font-weight: 600; line-height: 1.2; min-height: 2.4em; animation: monte 0.45s cubic-bezier(0.34, 1.56, 0.64, 1) 0.3s both; }
  .ici .nom { color: var(--dk-accent); }
  .ligne { font-size: 0.78em; line-height: 1.35; color: var(--dk-gris); animation: monte 0.45s ease-out 0.5s both; }
  .source-s { margin: 0; font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }
  .source-s i { font-style: italic; }
  @keyframes trace { to { stroke-dashoffset: 0; } }
  @keyframes pop { from { transform: scale(0); } to { transform: scale(1); } }
  @keyframes monte { from { opacity: 0; transform: translateY(0.6em); } to { opacity: 1; transform: none; } }
  @keyframes rebond { from { transform: scale(0.93); } to { transform: scale(1); } }
  @media (prefers-reduced-motion: reduce) {
    .tuile-s, .pt, .pm, .nom, .ligne { animation: none; }
    .trait { animation: none; stroke-dashoffset: 0; }
  }
</style>
