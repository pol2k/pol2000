<script>
  /**
   * « No such file or directory » ne veut jamais dire qu’une chose : il n’y a
   * rien à cette adresse. Et cela n’arrive que de trois façons, chacune avec
   * sa vérification d’une commande. Trois panneaux, dans l’ordre où l’on
   * vérifie; ils s’allument un à un, comme une liste que l’on coche.
   *
   *   0  Trois cadres pâles en tirets, numérotés 1, 2, 3. Rien d’autre.
   *   1  « R n’est pas au bon endroit » : le jeton R tombe dans
   *      Téléchargements, sa place reste vide dans pol2000. getwd()
   *   2  « Le fichier est ailleurs » : la feuille ces2025.csv est dans
   *      Téléchargements, pol2000/data est vide. list.files("data")
   *   3  « Le nom n’est pas le bon » : ces2025.csv tapé, ces2025.xlsx dans
   *      le dossier, l’extension en rouge. file.exists("data/ces2025.csv")
   *      Puis la phrase de clôture, en rouge, sous les trois panneaux.
   *
   * Le contraste retenu est l’extension et non la majuscule : sous Windows
   * et macOS, « CES2025.csv » s’ouvre quand même, l’exemple serait faux sur
   * la plupart des portables de la salle. Tracés fixes, aucun hasard.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel pd-fig" bind:this={hote}>
  <div class="pd-rang">
    <!-- ——— 1 : R n’est pas au bon endroit ——— -->
    <section class="pd-panneau" class:pd-allume={e >= 1}>
      <span class="pd-no">1</span>
      <div class="pd-corps">
        <svg
          class="pd-scene"
          viewBox="0 0 300 165"
          role="img"
          aria-label="Deux dossiers côte à côte. Le jeton R, un carré rouge, se trouve dans le dossier Téléchargements&#8239;; dans le dossier pol2000, sa place est vide, marquée en tirets rouges."
        >
          <path d="M 4 28 L 4 16 L 56 16 L 66 28 L 144 28 L 144 132 L 4 132 Z" class="pd-dossier" />
          <text x="74" y="154" class="pd-nom">Téléchargements</text>
          <path d="M 156 28 L 156 16 L 208 16 L 218 28 L 296 28 L 296 132 L 156 132 Z" class="pd-dossier" />
          <text x="226" y="154" class="pd-nom pd-fort">pol2000</text>

          <rect x="204" y="58" width="44" height="44" class="pd-fantome" />
          <g class="pd-tombe">
            <rect x="52" y="58" width="44" height="44" class="pd-jeton" />
            <text x="74" y="91" class="pd-jeton-t">R</text>
          </g>
        </svg>
        <p class="pd-titre">R n’est pas au bon endroit</p>
        <code class="pd-cmd">getwd()</code>
        <p class="pd-glose">ouvrez le dossier pol2000 dans Positron</p>
      </div>
    </section>

    <!-- ——— 2 : le fichier est ailleurs ——— -->
    <section class="pd-panneau" class:pd-allume={e >= 2}>
      <span class="pd-no">2</span>
      <div class="pd-corps">
        <svg
          class="pd-scene"
          viewBox="0 0 300 165"
          role="img"
          aria-label="Deux dossiers côte à côte. La feuille ces2025.csv se trouve dans le dossier Téléchargements&#8239;; le dossier pol2000/data est vide, la place de la feuille y est marquée en tirets rouges."
        >
          <path d="M 4 28 L 4 16 L 56 16 L 66 28 L 144 28 L 144 132 L 4 132 Z" class="pd-dossier" />
          <text x="74" y="154" class="pd-nom">Téléchargements</text>
          <path d="M 156 28 L 156 16 L 208 16 L 218 28 L 296 28 L 296 132 L 156 132 Z" class="pd-dossier" />
          <text x="226" y="154" class="pd-nom pd-fort">pol2000/data</text>

          <path d="M 209 40 L 233 40 L 243 50 L 243 84 L 209 84 Z" class="pd-fantome" />
          <g class="pd-tombe">
            <path d="M 57 40 L 81 40 L 91 50 L 91 84 L 57 84 Z" class="pd-feuille" />
            <path d="M 81 40 L 81 50 L 91 50" class="pd-pli" />
            <path d="M 63 60 L 85 60 M 63 68 L 85 68 M 63 76 L 79 76" class="pd-lignes" />
            <text x="74" y="112" class="pd-nom pd-fort">ces2025.csv</text>
          </g>
        </svg>
        <p class="pd-titre">Le fichier est ailleurs</p>
        <code class="pd-cmd">list.files("data")</code>
        <p class="pd-glose">regardez ce que R voit</p>
      </div>
    </section>

    <!-- ——— 3 : le nom n’est pas le bon ——— -->
    <section class="pd-panneau" class:pd-allume={e >= 3}>
      <span class="pd-no">3</span>
      <div class="pd-corps">
        <svg
          class="pd-scene"
          viewBox="0 0 300 165"
          role="img"
          aria-label="Deux noms de fichier presque identiques, l’un au-dessus de l’autre. Tapé dans R&#8239;: ces2025.csv. Dans le dossier&#8239;: ces2025.xlsx. Seule l’extension diffère, elle est en rouge."
        >
          <text x="16" y="18" class="pd-leg">tapé dans R</text>
          <rect x="16" y="28" width="268" height="40" class="pd-case" />
          <text x="32" y="55" class="pd-fichier" textLength="145.2" lengthAdjust="spacing">ces2025.<tspan class="pd-diff">csv</tspan></text>
          <rect x="137.6" y="60" width="39.6" height="3" class="pd-trait" />

          <text x="284" y="97" class="pd-pasegal">≠</text>

          <text x="16" y="98" class="pd-leg">dans le dossier</text>
          <rect x="16" y="108" width="268" height="40" class="pd-case" />
          <text x="32" y="135" class="pd-fichier" textLength="158.4" lengthAdjust="spacing">ces2025.<tspan class="pd-diff">xlsx</tspan></text>
          <rect x="137.6" y="140" width="52.8" height="3" class="pd-trait" />
        </svg>
        <p class="pd-titre">Le nom n’est pas le bon</p>
        <code class="pd-cmd">file.exists("data/ces2025.csv")</code>
        <p class="pd-glose">une lettre, une majuscule, l’extension</p>
      </div>
    </section>
  </div>

  <p class="pd-cloture" class:pd-dit={e >= 3}>
    "No such file or directory"&#8239;: il n’y a rien à cette adresse. Trois vérifications, dans cet ordre.
  </p>
</div>

<style>
  .pd-fig { display: flex; flex-direction: column; gap: 0.8em; }

  /* Trois colonnes égales. La marge haute loge les numéros, à cheval sur le
     filet du cadre. */
  .pd-rang { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 0.9em; margin-top: 0.75em; }

  .pd-panneau {
    position: relative;
    margin: 0;
    padding: 1.05em 0.7em 0.75em;
    border: 2px dashed var(--dk-filet);
    background: var(--dk-fond);
    transition: border-color 0.4s;
  }
  .pd-panneau.pd-allume { border-style: solid; border-color: var(--dk-encre); }

  .pd-no {
    position: absolute;
    top: -0.85em;
    left: 0.7em;
    width: 1.6em;
    height: 1.6em;
    box-sizing: border-box;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.9em;
    font-weight: 600;
    line-height: 1;
    color: var(--dk-gris-2);
    background: var(--dk-fond);
    border: 2px dashed var(--dk-filet);
    transition: background-color 0.4s, color 0.4s, border-color 0.4s;
  }
  .pd-allume .pd-no { color: var(--dk-fond); background: var(--dk-encre); border-style: solid; border-color: var(--dk-encre); }

  /* Le contenu occupe sa hauteur dès le temps 0 : la grille ne saute pas. */
  .pd-corps { display: flex; flex-direction: column; align-items: flex-start; gap: 0.4em; opacity: 0; transition: opacity 0.4s; }
  .pd-allume .pd-corps { opacity: 1; }

  .pd-scene { width: 100%; max-height: 24vh; display: block; overflow: visible; margin-bottom: 0.2em; }
  .pd-scene text { font-family: var(--dk-mono); }

  .pd-dossier { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3; stroke-linejoin: miter; }
  .pd-nom { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .pd-nom.pd-fort { font-weight: 600; fill: var(--dk-encre); }

  .pd-fantome { fill: none; stroke: var(--dk-accent); stroke-width: 2.5; stroke-dasharray: 5 4; }
  .pd-allume .pd-fantome { animation: pd-clignote 1.6s ease-in-out 0.7s 1 both; }

  .pd-jeton { fill: var(--dk-accent); }
  .pd-jeton-t { font-size: 30px; font-weight: 700; text-anchor: middle; fill: var(--dk-fond); }

  .pd-feuille { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 2.5; stroke-linejoin: miter; }
  .pd-pli { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; }
  .pd-lignes { fill: none; stroke: var(--dk-gris-2); stroke-width: 2; }

  .pd-allume .pd-tombe { animation: pd-tombe 0.55s ease-out 0.15s 1 both; }

  .pd-leg { font-size: 15px; fill: var(--dk-gris); }
  .pd-case { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 2.5; }
  .pd-fichier { font-size: 22px; font-weight: 600; fill: var(--dk-encre); }
  .pd-diff { fill: var(--dk-accent); }
  .pd-trait { fill: var(--dk-accent); transform-box: fill-box; transform-origin: left center; }
  .pd-allume .pd-trait { animation: pd-souligne 0.5s ease-out 0.5s 1 both; }
  .pd-pasegal { font-size: 28px; font-weight: 700; text-anchor: end; fill: var(--dk-accent); }
  .pd-allume .pd-pasegal { animation: pd-clignote 1.6s ease-in-out 1s 1 both; }

  .pd-titre { margin: 0; font-size: 0.95em; font-weight: 600; line-height: 1.3; }
  .pd-cmd { font-size: 0.8em; line-height: 1.4; padding: 0.15em 0.45em; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); white-space: nowrap; }
  .pd-glose { margin: 0; font-size: 0.7em; line-height: 1.4; color: var(--dk-gris); }

  /* La phrase de clôture réserve sa hauteur dès le temps 0. */
  .pd-cloture {
    margin: 0;
    min-height: 2.9em;
    font-size: 0.85em;
    font-weight: 600;
    line-height: 1.45;
    color: var(--dk-accent);
    opacity: 0;
    transform: translateY(0.4em);
    transition: opacity 0.45s ease-out, transform 0.45s ease-out;
  }
  .pd-cloture.pd-dit { opacity: 1; transform: none; transition-delay: 1.2s; }

  @keyframes pd-tombe { from { opacity: 0; transform: translateY(-16px); } to { opacity: 1; transform: none; } }
  @keyframes pd-clignote { 0% { opacity: 0; } 25% { opacity: 1; } 50% { opacity: 0.2; } 75% { opacity: 1; } 100% { opacity: 1; } }
  @keyframes pd-souligne { from { transform: scaleX(0); } to { transform: scaleX(1); } }

  @media (prefers-reduced-motion: reduce) {
    .pd-panneau, .pd-no, .pd-corps { transition: none; }
    .pd-allume .pd-fantome, .pd-allume .pd-tombe, .pd-allume .pd-trait, .pd-allume .pd-pasegal { animation: none; }
    .pd-cloture { transition: none; transform: none; }
  }
</style>
