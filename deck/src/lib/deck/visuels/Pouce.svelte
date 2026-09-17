<script>
  /**
   * La règle du pouce : moyenne ou médiane ? Un seul geste, deux issues.
   * On calcule les deux. Si elles se touchent, la distribution est à peu
   * près symétrique : la moyenne. Si elles s’écartent, quelque chose tire
   * la moyenne : la médiane, et on va voir la forme.
   *
   *   0  « Calculez les deux. » et deux silhouettes schématiques : à gauche
   *      une bosse symétrique où les deux repères se touchent, à droite une
   *      bosse à longue queue où la moyenne est tirée vers la queue.
   *   1  Verdict de gauche : elles se touchent, prenez la moyenne. Exemple
   *      réel : l’âge.
   *   2  Verdict de droite : elles s’écartent, prenez la médiane. Exemple
   *      réel : la taille du ménage. La moyenne glisse de la médiane vers
   *      la queue (moins d’une seconde, sans délai).
   *   3  La version de poche, en trois lignes à recopier.
   *
   * Les silhouettes sont des schémas, pas des données. Les repères ne sont
   * pourtant pas posés au jugé : la médiane (moitié de l’aire) et la moyenne
   * (point d’équilibre) ont été calculées sur chaque tracé. À gauche elles
   * tombent toutes deux à x = 220 : on les dessine côte à côte (217 et 223)
   * pour qu’on voie deux traits qui se touchent. À droite : 619 et 650.
   *
   * Les chiffres des exemples ne sont pas retapés. L’âge vient de AGE ; la
   * taille du ménage est lue dans la sortie de summary() de la console
   * montrée plus tôt dans la séance (CONSOLES.menage), pour que les deux
   * diapositives affichent exactement les mêmes nombres.
   */
  import { brancherTemps } from '../temps.js';
  import { AGE, MENAGE, CONSOLES } from '$lib/data/seance3.js';

  /* summary() : une ligne de noms, une ligne de valeurs, six colonnes. */
  function lireSummary(sortie) {
    const [entete = '', valeurs = ''] = sortie.split('\n');
    const noms = entete.match(/Min\.|1st Qu\.|Median|Mean|3rd Qu\.|Max\./g) ?? [];
    const vals = valeurs.trim().split(/\s+/).map(Number);
    if (noms.length !== 6 || vals.length !== 6 || vals.some(Number.isNaN)) return null;
    return { moyenne: vals[noms.indexOf('Mean')], mediane: vals[noms.indexOf('Median')] };
  }
  const LU = lireSummary(CONSOLES.menage[0].out);
  const MEN = LU ?? { moyenne: MENAGE.moyenneValide, mediane: MENAGE.medianeValide };

  /* Nombre à la française : virgule décimale, espace fine insécable des milliers. */
  function fr(n, decimales = 0) {
    const [ent, dec] = n.toFixed(decimales).split('.');
    const groupes = ent.replace(/\B(?=(\d{3})+$)/g, '\u202F');
    return dec ? `${groupes},${dec}` : groupes;
  }

  const EX = {
    age: { moyenne: fr(AGE.moyenne, 1), mediane: fr(AGE.mediane) },
    menage: { moyenne: fr(MEN.moyenne), mediane: fr(MEN.mediane) }
  };

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel po-fig" bind:this={hote}>
  <p class="po-dit">Calculez <span class="po-rouge">les deux</span>.</p>

  <svg
    class="po-scene"
    viewBox="0 0 1000 325"
    role="img"
    aria-label="Deux silhouettes schématiques de distribution. À gauche, une bosse symétrique&#8239;: les repères de la moyenne et de la médiane se touchent, on prend la moyenne. À droite, une bosse suivie d’une longue queue vers la droite&#8239;: la moyenne est tirée vers la queue, loin de la médiane, on prend la médiane."
  >
    <!-- ——— À gauche : symétrique ——— -->
    <path d="M 40 170 C 115 170, 160 50, 220 50 C 280 50, 325 170, 400 170 Z" class="po-forme" />
    <line x1="30" y1="170" x2="410" y2="170" class="po-sol" />
    <g>
      <line x1="217" y1="44" x2="217" y2="180" class="po-rep po-rep-med" />
      <text x="207" y="34" class="po-nom po-nom-med" text-anchor="end">médiane</text>
    </g>
    <g>
      <line x1="223" y1="44" x2="223" y2="180" class="po-rep po-rep-moy" />
      <text x="233" y="34" class="po-nom po-nom-moy">moyenne</text>
    </g>

    <text x="440" y="202" class="po-schema" text-anchor="middle">schéma</text>

    <!-- ——— À droite : une longue queue ——— -->
    <path d="M 480 170 C 503 170, 510 50, 530 50 C 556 50, 571 100, 644 115 C 790 145, 909 150, 985 170 Z" class="po-forme" />
    <line x1="470" y1="170" x2="995" y2="170" class="po-sol" />
    <g>
      <line x1="619" y1="44" x2="619" y2="180" class="po-rep po-rep-med" />
      <text x="609" y="34" class="po-nom po-nom-med" text-anchor="end">médiane</text>
    </g>
    <g class="po-tiree" class:po-glisse={e === 2}>
      <line x1="650" y1="44" x2="650" y2="180" class="po-rep po-rep-moy" />
      <text x="660" y="34" class="po-nom po-nom-moy">moyenne</text>
    </g>

    <!-- ——— Les verdicts ——— -->
    {#if e >= 1}
      <g class="po-verdict" text-anchor="middle">
        <text x="220" y="218" class="po-constat">elles se touchent</text>
        <text x="220" y="256" class="po-prenez">→ prenez la <tspan class="po-mot-moy">moyenne</tspan></text>
        <text x="220" y="292" class="po-ex">l’âge</text>
        <text x="220" y="319" class="po-ex-n"><tspan class="po-n-moy">moyenne {EX.age.moyenne}</tspan> · <tspan class="po-n-med">médiane {EX.age.mediane}</tspan></text>
      </g>
    {/if}
    {#if e >= 2}
      <g class="po-verdict" text-anchor="middle">
        <text x="732" y="218" class="po-constat">elles s’écartent</text>
        <text x="732" y="256" class="po-prenez">→ prenez la <tspan class="po-mot-med">médiane</tspan></text>
        <text x="732" y="292" class="po-ex">la taille du ménage</text>
        <text x="732" y="319" class="po-ex-n"><tspan class="po-n-moy">moyenne {EX.menage.moyenne}</tspan> · <tspan class="po-n-med">médiane {EX.menage.mediane}</tspan></text>
      </g>
    {/if}
  </svg>

  <!-- La version de poche garde sa place dès le temps 0 : rien ne saute. -->
  <div class="po-poche" class:po-la={e >= 3} aria-hidden={e < 3}>
    <p class="po-ligne">proches&#8239;: la <span class="po-cle">moyenne</span></p>
    <p class="po-ligne">éloignées&#8239;: la <span class="po-cle">médiane</span>, et on va voir la forme</p>
    <p class="po-ligne po-mode">des catégories (parti, religion)&#8239;: ni l’une ni l’autre, le mode</p>
  </div>

  <p class="po-source" class:po-la={e >= 1} aria-hidden={e < 1}>Exemples&#8239;: Étude électorale canadienne 2025</p>
</div>

<style>
  .po-fig { display: flex; flex-direction: column; align-items: center; gap: 0.5em; }

  /* La consigne : une seule, en grand. */
  .po-fig .po-dit { margin: 0; font-family: var(--dk-mono); font-size: 1.9em; font-weight: 600; line-height: 1.15; letter-spacing: -0.02em; color: var(--dk-encre); }
  .po-rouge { color: var(--dk-accent); }

  .po-scene { width: 100%; max-height: 44vh; display: block; overflow: visible; }
  .po-scene text { font-family: var(--dk-mono); }

  /* Les silhouettes. */
  .po-forme { fill: var(--dk-fond-2); stroke: var(--dk-encre); stroke-width: 3.5; stroke-linejoin: miter; }
  .po-sol { stroke: var(--dk-encre); stroke-width: 3.5; }
  .po-schema { font-size: 18px; letter-spacing: 0.06em; fill: var(--dk-gris); }

  /* Les deux repères : la moyenne à l’encre, la médiane en rouge. */
  .po-rep { stroke-width: 4; }
  .po-rep-moy { stroke: var(--dk-encre); }
  .po-rep-med { stroke: var(--dk-accent); }
  .po-nom { font-size: 23px; font-weight: 600; }
  .po-nom-moy { fill: var(--dk-encre); }
  .po-nom-med { fill: var(--dk-accent); }

  /* Au temps 2, la moyenne part de la médiane et se fait tirer vers la queue.
     Son état de repos est sa vraie place : l’animation n’ajoute rien au sens. */
  .po-tiree.po-glisse { animation: po-tire 0.8s ease-out both; }

  /* Les verdicts. */
  .po-verdict { animation: po-monte 0.4s ease-out both; }
  .po-constat { font-size: 24px; fill: var(--dk-gris); }
  .po-prenez { font-size: 30px; font-weight: 500; fill: var(--dk-encre); }
  .po-mot-moy { font-weight: 700; fill: var(--dk-encre); }
  .po-mot-med { font-weight: 700; fill: var(--dk-accent); }
  .po-ex { font-size: 20px; fill: var(--dk-gris); }
  .po-ex-n { font-size: 22px; fill: var(--dk-gris); }
  .po-n-moy { font-weight: 600; fill: var(--dk-encre); }
  .po-n-med { font-weight: 600; fill: var(--dk-accent); }

  /* La version de poche. */
  .po-poche {
    display: flex;
    flex-direction: column;
    gap: 0.15em;
    margin-top: 0.3em;
    padding: 0.5em 1em;
    border: 2px solid var(--dk-encre);
    background: var(--dk-fond-2);
    opacity: 0;
    transition: opacity 0.4s;
  }
  .po-poche.po-la { opacity: 1; }
  .po-fig .po-ligne { margin: 0; font-family: var(--dk-mono); font-size: 1.05em; font-weight: 500; line-height: 1.4; color: var(--dk-encre); }
  .po-cle { color: var(--dk-accent); font-weight: 700; }
  .po-fig .po-ligne.po-mode { font-size: 0.78em; font-weight: 400; color: var(--dk-gris); }

  .po-fig .po-source { margin: 0; font-family: var(--dk-mono); font-size: 0.56em; letter-spacing: 0.06em; line-height: 1.3; color: var(--dk-gris); opacity: 0; transition: opacity 0.3s; }
  .po-fig .po-source.po-la { opacity: 1; }

  @keyframes po-tire { from { transform: translateX(-31px); } to { transform: none; } }
  @keyframes po-monte { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .po-tiree.po-glisse, .po-verdict { animation: none; }
    .po-poche, .po-source { transition: none; }
  }
</style>
