<script>
  /**
   * Le répertoire de travail, en trois temps : l'arborescence d'un projet ;
   * « ouvrir le dossier » dans Positron, qui y plante R ; puis le chemin
   * relatif, écrit depuis ce dossier, contre le chemin absolu qui ne marche
   * que sur une seule machine.
   */
  import { brancherTemps } from '../temps.js';
  const LEG = [
    ['UN PROJET, UN DOSSIER', 'Tout ce qui touche au cours vit dans un seul dossier, avec des sous-dossiers qui disent ce qu\u2019ils contiennent.'],
    ['OUVRIR LE DOSSIER', 'Dans Positron : File, puis Open Folder. R travaille maintenant depuis ici. C\u2019est le répertoire de travail.'],
    ['LE CHEMIN RELATIF', 'Depuis ce dossier, un fichier s\u2019appelle par son chemin court. Il marche chez vous, chez moi, sur l\u2019ordinateur de l\u2019examen.']
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel dossier" bind:this={hote}>
  <div class="arbre" class:ouvert={e >= 1}>
    <div class="racine"><span class="ic">▸</span> pol2000/ <em class="ici" class:vu={e >= 1}>← R est ici · getwd()</em></div>
    <div class="n1"><span class="ic">▸</span> data/</div>
    <div class="n2" class:cible={e === 2}>ces2025.csv</div>
    <div class="n1"><span class="ic">▸</span> R/</div>
    <div class="n2">seance2.R</div>
    <div class="n2">examen1.R</div>
    <div class="n1"><span class="ic">▸</span> resultats/</div>
    <div class="n2">graphique.png</div>
  </div>
  <div class="droite">
    {#key e}
      <div class="legende">
        <span class="et">{LEG[e][0]}</span>
        <p>{LEG[e][1]}</p>
      </div>
    {/key}
    <div class="chemins" class:vu={e === 2}>
      <div class="chemin bon"><span class="et2">relatif · oui</span><code>"data/ces2025.csv"</code></div>
      <div class="chemin mauvais"><span class="et2">absolu · non</span><code>"C:/Users/moi/Bureau/pol2000/data/ces2025.csv"</code></div>
    </div>
  </div>
</div>

<style>
  .dossier { display: grid; grid-template-columns: 1fr 1.2fr; gap: 2em; align-items: start; }
  .arbre { border: 3px solid var(--dk-encre); padding: 0.9em 1.1em; font-family: var(--dk-mono); font-size: 1.05em; line-height: 1.7; transition: box-shadow 0.3s; }
  .arbre.ouvert { box-shadow: 0 0 0 5px var(--dk-accent); }
  .racine { font-weight: 600; display: flex; gap: 0.4em; align-items: baseline; flex-wrap: wrap; }
  .ici { font-style: normal; font-size: 0.7em; color: var(--dk-accent); opacity: 0; transition: opacity 0.4s; }
  .ici.vu { opacity: 1; }
  .n1 { padding-left: 1.2em; font-weight: 600; }
  .n2 { padding-left: 3em; color: var(--dk-gris); transition: color 0.3s, background 0.3s; }
  .n2.cible { color: var(--dk-accent); font-weight: 600; }
  .ic { color: var(--dk-accent); }
  .droite { display: flex; flex-direction: column; gap: 1em; }
  .legende { display: flex; flex-direction: column; gap: 0.4em; }
  .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.25em; line-height: 1.35; animation: fondu 0.4s both; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  .chemins { display: flex; flex-direction: column; gap: 0.6em; opacity: 0; transition: opacity 0.4s; }
  .chemins.vu { opacity: 1; }
  .chemin { border: 2px solid var(--dk-encre); padding: 0.6em 0.8em; display: flex; flex-direction: column; gap: 0.2em; }
  .chemin.bon { border: 3px solid var(--dk-accent); }
  .chemin.mauvais code { text-decoration: line-through; text-decoration-color: var(--dk-accent); text-decoration-thickness: 3px; color: var(--dk-gris); }
  .et2 { font-size: 0.6em; letter-spacing: 0.16em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .bon .et2 { color: var(--dk-accent); }
  .chemin code { background: none; padding: 0; font-size: 0.85em; word-break: break-all; }
</style>
