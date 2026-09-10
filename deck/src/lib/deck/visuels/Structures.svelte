<script>
  /**
   * Une dimension, deux dimensions. Un vecteur est une rangée de cases ;
   * un tableau (data frame) est une grille de lignes et de colonnes, faite
   * de vecteurs collés côte à côte. Le troisième temps sort une colonne
   * de la grille : ce qui en sort est exactement un vecteur. Les réponses
   * de R viennent d'un vrai R 4.6.1.
   */
  import { brancherTemps } from '../temps.js';
  const TEMPS = [
    { et: 'UNE DIMENSION', txt: 'Un vecteur : une rangée de cases. On avance d’une case à la suivante, dans un seul sens.', lignes: [{ in: 'ages', out: '[1] 24 30' }] },
    { et: 'DEUX DIMENSIONS', txt: 'data.frame() colle des vecteurs côte à côte. Des lignes et des colonnes : un tableau. Chaque colonne a un nom.', lignes: [{ in: 'df', out: '    nom age\n1 Alice  24\n2   Bob  30' }] },
    { et: 'UNE COLONNE, C’EST UN VECTEUR', txt: 'Le $ sort une colonne du tableau. Ce qui sort, c’est le vecteur qu’on y avait mis.', lignes: [{ in: 'df$age', out: '[1] 24 30' }] },
    { et: 'DONC TOUT MARCHE', txt: 'Tout ce qu’on sait faire à un vecteur, on peut le faire à une colonne.', lignes: [{ in: 'mean(df$age)', out: '[1] 27' }] }
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TEMPS.length - 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel structures" bind:this={hote}>
  <div class="haut">
    <!-- 1D : deux vecteurs, une rangée chacun -->
    <div class="panneau">
      <span class="et">1 DIMENSION · LE VECTEUR</span>
      <div class="vec">
        <span class="nom">noms</span>
        <div class="cases"><span>"Alice"</span><span>"Bob"</span></div>
      </div>
      <div class="vec" class:pale={e >= 2}>
        <span class="nom" class:rouge={e >= 2}>ages</span>
        <div class="cases" class:rouge={e >= 2}><span>24</span><span>30</span></div>
      </div>
      <pre class="code">noms &lt;- c("Alice", "Bob")
ages &lt;- c(24, 30)</pre>
    </div>

    <!-- 2D : la grille, puis la colonne qui en sort -->
    <div class="panneau deux" class:vu={e >= 1}>
      <span class="et">2 DIMENSIONS · LE TABLEAU (data frame)</span>
      <div class="zone">
        <span class="nom df">df</span>
        <div class="grille">
          <span class="coin"></span><span class="tete">nom</span><span class="tete age" class:pale={e >= 2}>age</span>
          <span class="i">1</span><span>Alice</span><span class="age" class:pale={e >= 2}>24</span>
          <span class="i">2</span><span>Bob</span><span class="age" class:pale={e >= 2}>30</span>
        </div>
        <div class="colonne" class:sortie={e >= 2} class:tous={e === 3}>
          <span class="tete">age</span><span>24</span><span>30</span>
        </div>
        <span class="dollar" class:vu={e >= 2}>df$age</span>
        <span class="moy" class:vu={e === 3}>→ 27</span>
      </div>
      <pre class="code">df &lt;- data.frame(nom = noms, age = ages)</pre>
    </div>
  </div>

  <div class="bas">
    {#key e}
      <pre class="console">{#each TEMPS[e].lignes as l}<span class="in"><span class="prompt">&gt;</span> {l.in}</span><span class="out">{l.out}</span>{/each}</pre>
      <div class="legende">
        <span class="et rouge">{TEMPS[e].et}</span>
        <p>{TEMPS[e].txt}</p>
      </div>
    {/key}
  </div>
</div>

<style>
  .structures { display: flex; flex-direction: column; gap: 0.9em; }
  .haut { display: grid; grid-template-columns: 1fr 1.25fr; gap: 1.6em; align-items: start; }
  .panneau { display: flex; flex-direction: column; gap: 0.7em; }
  .deux { opacity: 0.15; transition: opacity 0.5s; }
  .deux.vu { opacity: 1; }
  .et { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .et.rouge { color: var(--dk-accent); }

  /* Un vecteur : le nom, puis des cases collées bord à bord. */
  .vec { display: flex; align-items: center; gap: 0.7em; transition: opacity 0.4s; }
  .nom { font-family: var(--dk-mono); font-weight: 600; font-size: 1.15em; width: 3em; text-align: right; transition: color 0.3s; }
  .nom.rouge { color: var(--dk-accent); }
  .cases { display: flex; }
  .cases span { font-family: var(--dk-mono); font-size: 1.15em; font-weight: 600; border: 3px solid var(--dk-encre); min-width: 4.4em; height: 2.3em; display: flex; align-items: center; justify-content: center; padding: 0 0.5em; margin-right: -3px; background: var(--dk-fond); transition: border-color 0.3s, color 0.3s; }
  .cases.rouge span { border-color: var(--dk-accent); color: var(--dk-accent); }

  /* La grille : coin vide, en-têtes, numéros de ligne, cellules. */
  /* Toutes les mesures ci-dessous sont en em du parent : les éléments
     positionnés gardent font-size 1em, la taille du texte va sur les cases.
     Le nom fait 3em × 1.15 = 3.45em, la grille 2.1 + 7.1 + 5 = 14.2em. */
  .zone { position: relative; display: flex; align-items: flex-start; gap: 0.7em; padding-bottom: 1.8em; }
  .nom.df { align-self: center; }
  .grille { display: grid; grid-template-columns: 2.1em 7.1em 5em; grid-auto-rows: 2.65em; border-top: 3px solid var(--dk-encre); border-left: 3px solid var(--dk-encre); font-family: var(--dk-mono); }
  .grille span { font-size: 1.15em; border-right: 3px solid var(--dk-encre); border-bottom: 3px solid var(--dk-encre); display: flex; align-items: center; justify-content: center; font-weight: 600; transition: opacity 0.4s; }
  .grille .coin, .grille .i { background: var(--dk-fond-2); color: var(--dk-gris); font-weight: 400; }
  .grille .tete { background: var(--dk-fond-2); }
  .grille .pale { opacity: 0.25; }

  /* La colonne qui glisse hors de la grille : même largeur, mêmes hauteurs. */
  /* Posée exactement sur la colonne « age » (3.45 + 0.7 + 2.1 + 7.1 = 13.35em,
     plus le filet gauche), elle glisse de 6.4em vers la droite. */
  .colonne { position: absolute; left: calc(13.35em + 3px); top: 0; width: 5em; display: grid; grid-auto-rows: 2.65em; font-family: var(--dk-mono); opacity: 0; pointer-events: none; transition: transform 0.7s ease, opacity 0.5s; }
  .colonne span { font-size: 1.15em; border: 3px solid var(--dk-accent); margin-bottom: -3px; display: flex; align-items: center; justify-content: center; font-weight: 600; color: var(--dk-accent); background: var(--dk-fond); }
  .colonne .tete { background: var(--dk-fond-2); }
  .colonne.sortie { opacity: 1; transform: translateX(6.4em); }
  .colonne.tous span { background: var(--dk-fond-2); }
  /* Le nom de ce qui sort, sous la colonne glissée ; la moyenne, à sa droite. */
  .dollar { position: absolute; left: calc(19.75em + 3px); top: 8.3em; width: 5em; text-align: center; font-family: var(--dk-mono); font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.4s 0.4s; white-space: nowrap; }
  .dollar.vu { opacity: 1; }
  .moy { position: absolute; left: 22.05em; top: 2.8em; font-family: var(--dk-mono); font-weight: 600; font-size: 1.15em; color: var(--dk-accent); opacity: 0; transition: opacity 0.4s; white-space: nowrap; }
  .moy.vu { opacity: 1; }

  .code { margin: 0; font-family: var(--dk-mono); font-size: 0.85em; line-height: 1.5; white-space: pre; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left-width: 0.34em; padding: 0.4em 0.8em; }

  /* En bas : la vraie console et le mot. */
  .bas { display: grid; grid-template-columns: 1fr 1.3fr; gap: 1.4em; align-items: start; }
  .console { margin: 0; font-family: var(--dk-mono); font-size: 0.9em; line-height: 1.5; white-space: pre; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left-width: 0.34em; border-left-color: var(--dk-accent); padding: 0.5em 0.9em; min-height: 3.4em; animation: fondu 0.3s both; }
  .in, .out { display: block; }
  .prompt { color: var(--dk-accent); font-weight: 600; }
  .out { color: var(--dk-gris); padding-left: 1.1em; }
  .legende { display: flex; flex-direction: column; gap: 0.3em; }
  .legende p { margin: 0; font-size: 1em; line-height: 1.4; animation: fondu 0.4s both; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
