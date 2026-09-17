<script>
  /**
   * Trois gestes, un seul chemin. On se sert d’un chemin dans exactement
   * trois gestes de tous les jours, et la seule chose qui change est le sens
   * de la flèche : le fichier entre dans R, ou R envoie un fichier dans un
   * dossier. Dans les trois cas, on écrit un chemin entre guillemets.
   *
   *   0  La scène au repos : le dossier pol2000 à gauche, avec data/ (qui
   *      contient data.csv) et resultats/ (vide), à droite le vrai logo de
   *      R dans son cadre.
   *   1  LIRE : la flèche va de data.csv vers R, une copie de la feuille
   *      glisse dans R.
   *   2  ÉCRIRE : la flèche repart de R vers resultats/, une nouvelle
   *      feuille, data_propre.csv, arrive dans le dossier jusque-là vide.
   *   3  EXPORTER : même flèche, et une image, age.png, arrive à côté.
   *      Puis la phrase de clôture.
   *
   * Les trois commandes et les trois noms de fichiers viennent de la vraie
   * session R (seance3_chemins.js) : rien n’est retapé ici. Le mini
   * histogramme du glyphe est un pictogramme, pas une donnée. Tracés fixes,
   * aucun hasard.
   *
   * R est le logo officiel (static/img/Rlogo.png, 724 × 561, proportions
   * gardées), posé dans un cadre carré : les flèches horizontales partent
   * du bord droit du cadre et y arrivent, ce que l’ovale du logo seul ne
   * permettrait pas proprement.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  import { CHEMINS } from '$lib/data/seance3_chemins.js';

  const LIRE = CHEMINS.consoles.charger[0].in;
  const ECRIRE = CHEMINS.consoles.sauver[0].in;
  const EXPORTER = CHEMINS.consoles.graphique[2].in;
  const COMMANDES = [LIRE, LIRE, ECRIRE, EXPORTER];

  /* Le nom du fichier est le dernier segment du chemin entre guillemets. */
  const nomDe = (cmd) => cmd.split('"')[1].split('/').pop();
  const SOURCE = nomDe(LIRE);
  const PROPRE = nomDe(ECRIRE);
  const IMAGE = nomDe(EXPORTER);

  /* Hauteurs des barres du pictogramme : fixes. */
  const BARRES = [10, 20, 30, 22, 12];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  /* Morceaux de la commande : les rangs impairs sont entre guillemets. */
  const morceaux = $derived(COMMANDES[e].split('"'));
</script>

<div class="visuel tg-fig" bind:this={hote}>
  <svg
    class="tg-scene"
    viewBox="0 0 1000 375"
    role="img"
    aria-label="À gauche, le dossier pol2000 avec deux sous-dossiers&#8239;: data, qui contient le fichier data.csv, et resultats, vide au départ. À droite, le logo de R dans un cadre carré. Une flèche va d’abord du fichier vers R (lire), puis de R vers le dossier resultats, où apparaissent un nouveau fichier csv (écrire) puis une image (exporter)."
  >
    {#snippet feuille()}
      <path d="M -28 -35 H 12 L 28 -19 V 35 H -28 Z" class="tg-papier" />
      <path d="M 12 -35 V -19 H 28" class="tg-pli" />
      <path d="M -17 -4 H 17 M -17 8 H 17 M -17 20 H 17" class="tg-rang" />
    {/snippet}

    <!-- ——— Le dossier pol2000 ——— -->
    <path d="M 20 40 V 8 H 200 V 40" class="tg-onglet" />
    <rect x="20" y="40" width="560" height="325" class="tg-dossier" />
    <text x="38" y="33" class="tg-nom">pol2000</text>

    <!-- data/ -->
    <rect x="40" y="65" width="520" height="135" class="tg-sous" />
    <text x="56" y="100" class="tg-sous-nom">data/</text>
    <g transform="translate(315 113)">{@render feuille()}</g>
    <text x="315" y="181" class="tg-fichier" class:tg-actif={e === 1}>{SOURCE}</text>

    <!-- resultats/ : vide au départ -->
    <rect x="40" y="215" width="520" height="135" class="tg-sous" />
    <text x="56" y="250" class="tg-sous-nom">resultats/</text>
    <g class="tg-vide" class:tg-parti={e >= 2}>
      <rect x="287" y="228" width="56" height="70" class="tg-creux" />
      <text x="315" y="331" class="tg-vide-t">vide</text>
    </g>

    <g class="tg-neuf" class:tg-vu={e >= 2} class:tg-arrive-csv={e === 2}>
      <g transform="translate(315 263)">{@render feuille()}</g>
      <text x="315" y="331" class="tg-fichier" class:tg-actif={e === 2}>{PROPRE}</text>
    </g>

    <g class="tg-neuf" class:tg-vu={e >= 3} class:tg-arrive-png={e === 3}>
      <rect x="458" y="233" width="64" height="60" class="tg-papier" />
      {#each BARRES as h, i}
        <rect x={466 + i * 10} y={285 - h} width="8" height={h} class="tg-barre" />
      {/each}
      <text x="490" y="331" class="tg-fichier" class:tg-actif={e === 3}>{IMAGE}</text>
    </g>

    <!-- ——— R, l’atelier ——— -->
    <rect x="772" y="97" width="216" height="216" class="tg-r" />
    <image href="{base}/img/Rlogo.png" x="786" y="132.2" width="188" height="145.7" />

    <!-- ——— La flèche : seul son sens change ——— -->
    {#if e === 1}
      <g>
        <line x1="360" y1="113" x2="756" y2="113" pathLength="1" class="tg-trait" />
        <path d="M 740 100 L 758 113 L 740 126" class="tg-pointe" />
        <text x="675" y="92" class="tg-geste">lire</text>
        <g class="tg-copie"><g transform="translate(315 113)">{@render feuille()}</g></g>
      </g>
    {:else if e === 2}
      <g>
        <line x1="764" y1="263" x2="364" y2="263" pathLength="1" class="tg-trait" />
        <path d="M 380 250 L 362 263 L 380 276" class="tg-pointe" />
        <text x="675" y="242" class="tg-geste">écrire</text>
      </g>
    {:else if e === 3}
      <g>
        <line x1="764" y1="263" x2="538" y2="263" pathLength="1" class="tg-trait" />
        <path d="M 554 250 L 536 263 L 554 276" class="tg-pointe" />
        <text x="675" y="242" class="tg-geste">exporter</text>
      </g>
    {/if}
  </svg>

  <!-- La commande : le chemin, guillemets compris, en rouge. -->
  <p class="tg-cmd" class:tg-la={e >= 1} aria-hidden={e < 1}>
    {#key e}
      <span class="tg-cmd-in">
        {#each morceaux as m, i}{#if i % 2 === 1}<span class="tg-chemin">"{m}"</span>{:else}{m}{/if}{/each}
      </span>
    {/key}
  </p>

  <p class="tg-fin" class:tg-la={e >= 3} aria-hidden={e < 3}>
    Trois gestes, une seule chose à écrire&#8239;: le chemin, entre guillemets.
  </p>
</div>

<style>
  .tg-fig { display: flex; flex-direction: column; align-items: flex-start; gap: 0.55em; }

  .tg-scene { width: 100%; max-height: 46vh; display: block; overflow: visible; }
  .tg-scene text { font-family: var(--dk-mono); }

  /* Le dossier et ses deux sous-dossiers. */
  .tg-onglet { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; }
  .tg-dossier { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 4; }
  .tg-nom { font-size: 26px; font-weight: 600; fill: var(--dk-encre); }
  .tg-sous { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .tg-sous-nom { font-size: 24px; font-weight: 600; fill: var(--dk-encre); }

  /* Les glyphes : feuille de données, image. */
  .tg-papier { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3.5; stroke-linejoin: miter; }
  .tg-pli { fill: none; stroke: var(--dk-encre); stroke-width: 3.5; }
  .tg-rang { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; }
  .tg-barre { fill: var(--dk-encre); }
  .tg-fichier { font-size: 22px; text-anchor: middle; fill: var(--dk-gris); transition: fill 0.3s; }
  .tg-fichier.tg-actif { fill: var(--dk-accent); font-weight: 600; }

  /* resultats/ est vide, et cela se voit. */
  .tg-vide { opacity: 1; transition: opacity 0.3s; }
  .tg-vide.tg-parti { opacity: 0; transition-delay: 0.5s; }
  .tg-creux { fill: none; stroke: var(--dk-gris-2); stroke-width: 3; stroke-dasharray: 8 7; }
  .tg-vide-t { font-size: 22px; text-anchor: middle; fill: var(--dk-gris-2); }

  /* R. */
  .tg-r { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }

  /* La flèche se trace, puis la pointe se pose. */
  .tg-trait { stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 1; stroke-dashoffset: 0; animation: tg-trace 0.5s ease-out both; }
  .tg-pointe { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-linejoin: miter; animation: tg-parait 0.2s ease-out 0.45s both; }
  .tg-geste { font-size: 34px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); animation: tg-parait 0.35s ease-out both; }

  /* Lire : une copie de la feuille glisse le long de la flèche, dans R. */
  .tg-copie { opacity: 0; animation: tg-entre 1.3s ease-in-out 0.45s 1 both; }

  /* Écrire, exporter : le nouveau fichier sort de R et se pose. */
  .tg-neuf { opacity: 0; }
  .tg-neuf.tg-vu { opacity: 1; }
  .tg-neuf.tg-arrive-csv { animation: tg-sort-csv 1.2s ease-in-out 0.45s 1 both; }
  .tg-neuf.tg-arrive-png { animation: tg-sort-png 1.1s ease-in-out 0.45s 1 both; }

  /* La commande et la clôture gardent leur place dès le temps 0. */
  .tg-cmd {
    margin: 0;
    padding: 0.4em 0.8em;
    border: 2px solid var(--dk-encre);
    background: var(--dk-fond-2);
    font-family: var(--dk-mono);
    font-size: 1.15em;
    font-weight: 500;
    line-height: 1.4;
    white-space: nowrap;
    color: var(--dk-encre);
    opacity: 0;
    transition: opacity 0.3s;
  }
  .tg-cmd.tg-la { opacity: 1; }
  .tg-cmd-in { display: inline-block; animation: tg-monte 0.35s ease-out both; }
  .tg-chemin { color: var(--dk-accent); font-weight: 600; }

  .tg-fin { margin: 0; font-size: 1em; font-weight: 600; line-height: 1.4; color: var(--dk-accent); opacity: 0; transition: opacity 0.4s; }
  .tg-fin.tg-la { opacity: 1; transition-delay: 1.6s; }

  @keyframes tg-trace { from { stroke-dashoffset: 1; } to { stroke-dashoffset: 0; } }
  @keyframes tg-parait { from { opacity: 0; } to { opacity: 1; } }
  @keyframes tg-monte { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @keyframes tg-entre {
    0% { opacity: 0; transform: translate(0, 0); }
    12% { opacity: 1; transform: translate(0, 0); }
    80% { opacity: 1; transform: translate(500px, 0); }
    100% { opacity: 0; transform: translate(565px, 0); }
  }
  @keyframes tg-sort-csv {
    0% { opacity: 0; transform: translate(565px, 0); }
    20% { opacity: 1; transform: translate(500px, 0); }
    100% { opacity: 1; transform: translate(0, 0); }
  }
  @keyframes tg-sort-png {
    0% { opacity: 0; transform: translate(390px, 0); }
    20% { opacity: 1; transform: translate(330px, 0); }
    100% { opacity: 1; transform: translate(0, 0); }
  }

  @media (prefers-reduced-motion: reduce) {
    .tg-trait, .tg-pointe, .tg-geste, .tg-copie, .tg-cmd-in { animation: none; }
    .tg-neuf.tg-arrive-csv, .tg-neuf.tg-arrive-png { animation: none; }
    .tg-vide, .tg-fichier, .tg-cmd, .tg-fin { transition: none; }
    .tg-vide.tg-parti, .tg-fin.tg-la { transition-delay: 0s; }
  }
</style>
