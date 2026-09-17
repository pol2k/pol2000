<script>
  /**
   * Où est R ? Un plan de l’ordinateur, dessiné comme des pièces. R (le vrai
   * logo) reste debout dans UNE pièce, pol2000, et n’en bouge jamais. C’est
   * le FICHIER qui peut être ailleurs. Un chemin relatif est un itinéraire
   * qui part de la pièce où R se trouve ; « ~ » part du dossier personnel.
   *
   *   0  Le plan : ~ contient Documents > pol2000 > data, R, resultats et, à
   *      part, Downloads. R est dans pol2000. La vraie console : getwd().
   *   1  Le fichier est dans data. La commande relative, un tracé rouge part
   *      de R, passe la porte de data, atteint le fichier. Coche.
   *   2  Le fichier est plutôt dans Downloads, data est vide. Même commande,
   *      même tracé : il ne trouve rien. Croix.
   *   3  Sortie A : donner l’adresse complète. Le tracé part de ~, descend
   *      dans Downloads, atteint le fichier. Coche.
   *   4  Sortie B (le mieux) : la feuille glisse de Downloads vers data, la
   *      première commande fonctionne de nouveau. Coche. La règle en rouge.
   *
   * getwd() reste affiché du début à la fin : R ne bouge pas, la sortie est
   * toujours vraie. Toutes les chaînes R viennent de seance3_chemins.js
   * (vraie session R). Coordonnées fixes, aucun hasard.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { CHEMINS } from '$lib/data/seance3_chemins.js';

  const appel = CHEMINS.consoles.ou[0];
  const charger = CHEMINS.consoles.charger[0].in;
  const ailleurs = CHEMINS.consoles.ailleurs[1].in;
  /* "data/data.csv" → data.csv : le nom vient de la commande elle-même. */
  const fichier = charger.match(/"([^"]+)"/)[1].split('/').pop();

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  /* Le fichier est-il dans Downloads ? (temps 2 et 3) */
  let loin = $derived(e === 2 || e === 3);
  /* Le tracé R → data est joué aux temps 1, 2 et 4. */
  let versData = $derived(e === 1 || e === 2 || e === 4);
  let reussi = $derived(e === 1 || e === 3 || e === 4);
  /* Au temps 4, le tracé attend que la feuille soit rangée. */
  let delai = $derived(e === 4 ? '0.9s' : '0s');
</script>

<div class="visuel or-fig" bind:this={hote}>
  <svg
    class="or-plan"
    viewBox="0 0 1200 526"
    role="img"
    style:--or-d={delai}
    aria-label="Un plan schématique de l’ordinateur, dessiné comme des pièces. La grande pièce, le tilde, est le dossier personnel. Elle contient Documents, qui contient pol2000, qui contient trois pièces&#8239;: data, R et resultats. À part, dans le dossier personnel, une autre pièce&#8239;: Downloads. Le logo de R se tient dans pol2000 et n’en bouge pas. Quand le fichier data.csv est dans data, un tracé rouge en pointillés part de R, entre dans data et atteint le fichier. Quand le fichier est dans Downloads, le même tracé ne trouve rien dans data et finit sur une croix. Deux sorties&#8239;: A, un tracé part du dossier personnel, descend dans Downloads et atteint le fichier&#8239;; B, le fichier est déplacé de Downloads vers data et le premier tracé réussit de nouveau."
  >
    <!-- ——— Les pièces ——— -->
    <rect x="10" y="10" width="1180" height="506" class="or-mur or-dehors" />
    <text x="30" y="48" class="or-nom or-pale"><tspan class="or-tilde">~</tspan>&#8239;: votre dossier personnel</text>

    <rect x="40" y="66" width="750" height="434" class="or-mur or-dehors" />
    <text x="60" y="102" class="or-nom or-pale">Documents</text>

    <rect x="70" y="118" width="690" height="366" class="or-mur or-projet" />
    <text x="90" y="156" class="or-nom or-fort">pol2000</text>

    <rect x="410" y="136" width="330" height="166" class="or-mur" />
    <text x="430" y="172" class="or-nom">data</text>
    <line x1="410" y1="222" x2="410" y2="258" class="or-porte" />

    <rect x="410" y="318" width="140" height="68" class="or-mur" />
    <text x="480" y="362" class="or-nom or-centre">R</text>
    <line x1="430" y1="318" x2="466" y2="318" class="or-porte" />

    <rect x="570" y="318" width="170" height="68" class="or-mur" />
    <text x="655" y="362" class="or-nom or-centre or-serre">resultats</text>
    <line x1="590" y1="318" x2="626" y2="318" class="or-porte" />

    <rect x="850" y="66" width="320" height="250" class="or-mur" />
    <text x="1150" y="102" class="or-nom or-fin">Downloads</text>
    <line x1="912" y1="66" x2="948" y2="66" class="or-porte or-porte-f" />

    <!-- ——— La console : où suis-je ? Vraie du début à la fin. ——— -->
    <line x1="150" y1="278" x2="150" y2="400" class="or-lien" />
    <rect x="90" y="400" width="600" height="70" class="or-ecran" />
    <text x="108" y="429" class="or-petit or-fort">&gt; {appel.in}</text>
    <text x="108" y="459" class="or-petit">{appel.out}</text>

    <!-- ——— R, qui ne bouge pas ——— -->
    <text x="100" y="188" class="or-ici">R est ici</text>
    <image href="{base}/img/Rlogo.png" x="100" y="200" width="100" height="77.5" />

    <!-- ——— Les places vides ——— -->
    {#if loin}
      <path d="M 520 205 L 564 205 L 580 221 L 580 275 L 520 275 Z" class="or-vide or-parait" />
    {/if}
    {#if e === 4}
      <path d="M 900 205 L 944 205 L 960 221 L 960 275 L 900 275 Z" class="or-vide or-parait" />
      <!-- Sortie B : le déménagement. -->
      <g class="or-parait">
        <path d="M 892 264 L 662 264 M 678 254 L 662 264 L 678 274" class="or-demenage" />
        <rect x="803" y="247" width="34" height="34" class="or-pastille" />
        <text x="820" y="273" class="or-pastille-t">B</text>
      </g>
    {/if}

    <!-- ——— Le fichier, une feuille à coin plié. Il est dans data, ou dans
         Downloads (fondu), ou il y revient en glissant (temps 4). ——— -->
    <g class="or-feuille" class:or-loin={loin} class:or-range={e === 4}>
      <path d="M 520 205 L 564 205 L 580 221 L 580 275 L 520 275 Z" class="or-papier" />
      <path d="M 564 205 L 564 221 L 580 221" class="or-pli" />
      <path d="M 532 236 L 568 236 M 532 249 L 568 249 M 532 262 L 568 262" class="or-rang" />
      <text x="594" y="236" class="or-petit">{fichier}</text>
      {#key e}
        {#if reussi}
          <g class="or-gagne">
            <path d="M 520 205 L 564 205 L 580 221 L 580 275 L 520 275 Z M 564 205 L 564 221 L 580 221" class="or-rouge" />
            <path d="M 600 264 L 613 279 L 638 248" class="or-coche" />
          </g>
        {/if}
      {/key}
    </g>

    <!-- ——— Les tracés : rejoués à chaque temps ——— -->
    {#key e}
      <!-- Le chemin relatif : de R vers data. -->
      {#if versData}
        <mask id="or-masque-data" maskUnits="userSpaceOnUse" x="0" y="0" width="1200" height="526">
          <path d="M 208 240 L 514 240.5" pathLength="1" class="or-trace" />
        </mask>
        <path d="M 208 240 L 514 240.5" class="or-route" mask="url(#or-masque-data)" />
      {/if}
      {#if e === 2}
        <path d="M 528 218 L 572 262 M 572 218 L 528 262" class="or-croix" />
      {/if}
      <!-- Sortie A : de ~ vers Downloads. -->
      {#if e === 3}
        <mask id="or-masque-tilde" maskUnits="userSpaceOnUse" x="0" y="0" width="1200" height="526">
          <path d="M 557 36 L 930 36 L 930 199" pathLength="1" class="or-trace" />
        </mask>
        <path d="M 557 36 L 930 36 L 930 199" class="or-route" mask="url(#or-masque-tilde)" />
        <g class="or-parait">
          <rect x="523" y="19" width="34" height="34" class="or-pastille" />
          <text x="540" y="45" class="or-pastille-t">A</text>
        </g>
      {/if}
    {/key}
  </svg>

  <!-- Sous le plan : la place est réservée, le plan ne bouge pas. -->
  <div class="or-bas">
    <div class="or-haut">
      {#if e === 1 || e === 2}
        <p class="or-cmd or-monte">&gt; {charger}</p>
      {:else if e >= 3}
        <div class="or-choix">
          <div class="or-opt or-monte" class:or-passe={e === 4}>
            <p class="or-opt-t"><span class="or-lettre">A</span> donner l’adresse complète</p>
            <p class="or-cmd">&gt; {ailleurs}</p>
          </div>
          {#if e === 4}
            <div class="or-opt or-monte">
              <p class="or-opt-t"><span class="or-lettre">B</span> ranger le fichier dans le projet <span class="or-tag">le mieux</span></p>
              <p class="or-cmd">&gt; {charger}</p>
            </div>
          {/if}
        </div>
      {/if}
    </div>
    <div class="or-dit">
      {#if e === 1}
        <p class="or-ligne or-monte">depuis ici&#8239;: on entre dans <b>data</b>, on prend le fichier</p>
      {:else if e === 2}
        <p class="or-ligne or-monte">le fichier n’est pas là</p>
      {:else if e === 3}
        <p class="or-ligne or-monte">depuis <b>~</b>&#8239;: on entre dans <b>Downloads</b>, on prend le fichier</p>
      {:else if e === 4}
        <p class="or-regle or-monte">Un chemin relatif part de l’endroit où R se trouve.</p>
        <p class="or-regle or-monte"><b>~</b> part de votre dossier personnel.</p>
      {/if}
    </div>
  </div>
</div>

<style>
  .or-fig { display: flex; flex-direction: column; gap: 0.5em; }

  .or-plan { width: 100%; max-height: 48vh; display: block; overflow: visible; }
  .or-plan text { font-family: var(--dk-mono); }

  /* Les pièces */
  .or-mur { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .or-mur.or-dehors { fill: none; stroke: var(--dk-gris-2); }
  .or-mur.or-projet { fill: var(--dk-fond-2); stroke-width: 5; }
  .or-porte { stroke: var(--dk-fond-2); stroke-width: 8; }
  .or-porte.or-porte-f { stroke: var(--dk-fond); }

  .or-nom { font-size: 29px; fill: var(--dk-encre); }
  .or-nom.or-serre { font-size: 27px; }
  .or-nom.or-pale { fill: var(--dk-gris); }
  .or-nom.or-fin { text-anchor: end; }
  .or-tilde { font-weight: 700; fill: var(--dk-encre); }
  .or-fort { font-weight: 600; }
  .or-centre { text-anchor: middle; }
  .or-petit { font-size: 26px; fill: var(--dk-encre); }

  /* La console */
  .or-lien { stroke: var(--dk-encre); stroke-width: 4; }
  .or-ecran { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }

  /* R */
  .or-ici { font-size: 29px; font-weight: 600; fill: var(--dk-accent); }

  /* Le fichier : fondu quand il change de pièce « par hypothèse » (temps 2),
     glissement quand on le déplace pour vrai (temps 4). */
  .or-papier { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; stroke-linejoin: miter; }
  .or-pli { fill: none; stroke: var(--dk-encre); stroke-width: 4; }
  .or-rang { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; }
  .or-feuille { animation: or-fondu-a 0.4s ease-out both; }
  .or-feuille.or-loin { transform: translateX(380px); animation-name: or-fondu-b; }
  .or-feuille.or-range { animation: none; transition: transform 0.9s ease-in-out; }

  .or-rouge { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linejoin: miter; }
  .or-coche { fill: none; stroke: var(--dk-accent); stroke-width: 8; }
  .or-gagne { animation: or-parait 0.25s ease-out calc(var(--or-d) + 1.05s) both; }

  .or-vide { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; stroke-dasharray: 12 9; }
  .or-parait { animation: or-parait 0.3s ease-out both; }
  .or-croix { fill: none; stroke: var(--dk-accent); stroke-width: 9; animation: or-parait 0.25s ease-out 1.05s both; }

  /* Le tracé : pointillés rouges, dévoilés par un masque qui se dessine. */
  .or-route { fill: none; stroke: var(--dk-accent); stroke-width: 6; stroke-dasharray: 16 10; stroke-linejoin: miter; }
  .or-trace { fill: none; stroke: #fff; stroke-width: 16; stroke-dasharray: 1; stroke-dashoffset: 0; animation: or-dessine 1s ease-in-out var(--or-d) both; }

  /* Les sorties A et B */
  .or-pastille { fill: var(--dk-accent); }
  .or-pastille-t { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-fond); }
  .or-demenage { fill: none; stroke: var(--dk-encre); stroke-width: 5; stroke-linejoin: miter; }

  /* Sous le plan */
  .or-bas { display: flex; flex-direction: column; gap: 0.45em; }
  .or-haut { min-height: 3.7em; }
  .or-dit { min-height: 3.1em; display: flex; flex-direction: column; }

  .or-cmd { margin: 0; display: inline-block; font-size: 0.9em; font-weight: 600; line-height: 1.3; padding: 0.3em 0.7em; border: 2px solid var(--dk-accent); background: var(--dk-fond); color: var(--dk-encre); white-space: nowrap; }

  .or-choix { display: grid; grid-template-columns: 1fr 1fr; gap: 1.2em; }
  .or-opt { display: flex; flex-direction: column; align-items: flex-start; gap: 0.3em; transition: opacity 0.3s; }
  .or-opt.or-passe { opacity: 0.45; }
  .or-opt-t { margin: 0; font-size: 0.8em; line-height: 1.4; color: var(--dk-encre); }
  .or-lettre { display: inline-block; width: 1.5em; text-align: center; font-weight: 700; background: var(--dk-accent); color: var(--dk-fond); margin-right: 0.3em; }
  .or-tag { display: inline-block; margin-left: 0.4em; padding: 0 0.5em; font-weight: 600; border: 2px solid var(--dk-accent); color: var(--dk-accent); }

  .or-ligne { margin: 0; font-size: 1.05em; line-height: 1.4; }
  .or-ligne b { font-weight: 600; }
  .or-regle { margin: 0; font-size: 1.15em; font-weight: 600; line-height: 1.3; color: var(--dk-accent); }
  .or-regle b { font-weight: 700; }
  .or-monte { animation: or-monte 0.4s ease-out both; }

  @keyframes or-dessine { from { stroke-dashoffset: 1; } to { stroke-dashoffset: 0; } }
  @keyframes or-parait { from { opacity: 0; } to { opacity: 1; } }
  @keyframes or-fondu-a { from { opacity: 0; } to { opacity: 1; } }
  @keyframes or-fondu-b { from { opacity: 0; } to { opacity: 1; } }
  @keyframes or-monte { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .or-feuille, .or-feuille.or-loin, .or-gagne, .or-parait, .or-croix, .or-trace, .or-monte { animation: none; }
    .or-feuille.or-range, .or-opt { transition: none; }
  }
</style>
