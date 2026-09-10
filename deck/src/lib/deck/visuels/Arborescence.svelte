<script>
  /**
   * L'arborescence des fichiers, pour une salle qui a grandi avec un iPad :
   * une boîte dans une boîte dans une boîte. Six temps. D'abord l'adresse
   * postale, que tout le monde comprend ; puis un explorateur de fichiers
   * schématique qu'on ouvre un dossier à la fois, pendant qu'à droite le
   * chemin s'écrit tout seul. À la fin, le chemin complet du fichier :
   * la seule chose que R comprend.
   */
  import { brancherTemps } from '../temps.js';
  const NIVEAUX = [
    { titre: 'Votre ordinateur', items: [['Bureau', 'd'], ['Documents', 'd', true], ['Téléchargements', 'd'], ['Images', 'd']] },
    { titre: 'Documents', items: [['cégep', 'd'], ['cv.docx', 'f'], ['pol2000', 'd', true], ['photos', 'd']] },
    { titre: 'pol2000', items: [['data', 'd', true], ['R', 'd'], ['resultats', 'd'], ['plan-de-cours.pdf', 'f']] },
    { titre: 'data', items: [['ces2025.csv', 'f', true], ['codebook.pdf', 'f']] },
    { titre: 'data', items: [['ces2025.csv', 'f', true, 'sel'], ['codebook.pdf', 'f']] }
  ];
  const CHEMIN = ['Documents', 'pol2000', 'data', 'ces2025.csv'];
  const LEG = [
    ['UNE ADRESSE', 'Pour trouver ce local, on va du plus grand au plus petit : le pays, la ville, l’université, le pavillon, la porte. Un fichier a une adresse pareille.'],
    ['DES BOÎTES DANS DES BOÎTES', 'Votre ordinateur range tout dans des dossiers. Un dossier, c’est une boîte. Dedans, d’autres boîtes.'],
    ['ON OUVRE DOCUMENTS', 'Le chemin s’allonge d’un cran. Chaque dossier ouvert ajoute son nom, séparé par une barre.'],
    ['LE DOSSIER DU COURS', 'pol2000 : tout ce qui touche au cours vit ici. C’est ce dossier qu’on ouvrira dans Positron.'],
    ['ENCORE UNE BOÎTE', 'data : les données. R : les scripts. resultats : ce que vous produirez.'],
    ['LE CHEMIN', 'L’adresse complète du fichier, du dossier le plus grand au fichier. C’est la seule chose que R comprend : pas les icônes, pas les clics, le chemin.']
  ];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 5, lire: () => e, ecrire: (v) => (e = v) });
  });
  const niv = $derived(e > 0 ? NIVEAUX[e - 1] : null);
  const segs = $derived(e > 1 ? CHEMIN.slice(0, e - 1) : []);
</script>

<div class="visuel arbo" bind:this={hote}>
  <div class="gauche">
    {#if e === 0}
      <div class="adresse">
        <div class="b b1"><span>Canada</span>
          <div class="b b2"><span>Québec</span>
            <div class="b b3"><span>Université Laval</span>
              <div class="b b4"><span>Pavillon De Koninck</span>
                <div class="b b5"><span>local 3159 · vous</span></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    {:else}
      <div class="explo">
        <div class="barre">
          <span class="fil">
            <b>Ordinateur</b>{#each segs as s}<i>›</i><b>{s}</b>{/each}
          </span>
        </div>
        <div class="corps">
          <aside>
            <span class="sec">Favoris</span>
            {#each ['Bureau', 'Documents', 'Téléchargements', 'Images'] as f}
              <span class="lien" class:on={segs[0] === f && e >= 2}>{f}</span>
            {/each}
          </aside>
          {#key e}
            <main>
              {#each niv.items as [nom, type, cible, sel]}
                <div class="item" class:cible class:sel={sel === 'sel'}>
                  <svg viewBox="0 0 48 40" aria-hidden="true">
                    {#if type === 'd'}<path d="M3 8h15l4 4h23v24H3z" class="dossier" />{:else}<path d="M12 3h16l8 8v26H12z" class="fichier" /><path d="M28 3v8h8" class="fichier" />{/if}
                  </svg>
                  <span>{nom}</span>
                </div>
              {/each}
            </main>
          {/key}
        </div>
      </div>
    {/if}
  </div>
  <div class="droite">
    {#key e}
      <div class="legende">
        <span class="et">{LEG[e][0]}</span>
        <p>{LEG[e][1]}</p>
      </div>
    {/key}
    {#if e > 0}
      <div class="chemin" class:fini={e === 5}>
        <span class="et2">le chemin</span>
        <code>{#if segs.length === 0}<i>Ordinateur</i>{/if}{#each segs as s, i}<b class:der={i === segs.length - 1 && e === 5}>{s}</b>{#if i < segs.length - 1}<em>/</em>{/if}{/each}</code>
      </div>
    {/if}
  </div>
</div>

<style>
  .arbo { display: grid; grid-template-columns: 1.35fr 1fr; gap: 1.8em; align-items: center; }
  /* L'adresse postale: cinq boîtes emboîtées. */
  .adresse .b { border: 3px solid var(--dk-encre); padding: 0.55em 0.7em 0.7em; display: flex; flex-direction: column; gap: 0.35em; animation: ouvre 0.5s both; }
  .adresse .b > span { font-size: 0.8em; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; }
  .b2 { animation-delay: 0.25s !important; } .b3 { animation-delay: 0.5s !important; } .b4 { animation-delay: 0.75s !important; }
  .b5 { animation-delay: 1s !important; border-color: var(--dk-accent) !important; border-width: 4px !important; }
  .b5 > span { color: var(--dk-accent); font-size: 1em; }
  @keyframes ouvre { from { opacity: 0; transform: scale(0.96); } to { opacity: 1; transform: none; } }
  /* L'explorateur schématique. */
  .explo { border: 3px solid var(--dk-encre); background: #fff; display: flex; flex-direction: column; min-height: 17em; }
  .barre { padding: 0.45em 0.8em; border-bottom: 2px solid var(--dk-encre); background: var(--dk-fond-2); font-size: 0.8em; }
  .fil { display: flex; gap: 0.4em; align-items: center; flex-wrap: wrap; }
  .fil b { font-weight: 600; } .fil i { color: var(--dk-gris-2); font-style: normal; }
  .corps { display: grid; grid-template-columns: 9em 1fr; flex: 1; }
  aside { border-right: 2px solid var(--dk-filet); padding: 0.6em 0; display: flex; flex-direction: column; font-size: 0.78em; }
  .sec { padding: 0.2em 0.9em 0.4em; font-size: 0.8em; letter-spacing: 0.12em; text-transform: uppercase; color: var(--dk-gris-2); }
  .lien { padding: 0.25em 0.9em; color: var(--dk-gris); } .lien.on { background: var(--dk-fond-2); color: var(--dk-encre); font-weight: 600; }
  main { padding: 1em; display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.8em; align-content: start; animation: fondu 0.35s both; }
  .item { display: flex; flex-direction: column; align-items: center; gap: 0.3em; text-align: center; font-size: 0.75em; padding: 0.5em 0.2em; border: 3px solid transparent; }
  .item.cible { border-color: var(--dk-accent); animation: clignote 1.4s ease-in-out infinite; }
  .item.sel { background: var(--dk-accent); color: #fff; animation: none; }
  .item svg { width: 3.4em; height: auto; }
  .dossier { fill: #ffd9a0; stroke: var(--dk-encre); stroke-width: 2; stroke-linejoin: round; }
  .fichier { fill: #fff; stroke: var(--dk-encre); stroke-width: 2; stroke-linejoin: round; }
  .sel .fichier { fill: #fff; }
  @keyframes clignote { 50% { border-color: transparent; } }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  /* Droite: légende et chemin. */
  .droite { display: flex; flex-direction: column; gap: 1.2em; }
  .legende { display: flex; flex-direction: column; gap: 0.4em; }
  .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.15em; line-height: 1.35; animation: fondu2 0.4s both; }
  @keyframes fondu2 { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  .chemin { border: 2px solid var(--dk-encre); padding: 0.6em 0.9em; display: flex; flex-direction: column; gap: 0.3em; transition: border-color 0.3s; }
  .chemin.fini { border: 3px solid var(--dk-accent); }
  .et2 { font-size: 0.58em; letter-spacing: 0.16em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .chemin code { background: none; padding: 0; font-size: 1.05em; word-break: break-all; }
  .chemin code i { color: var(--dk-gris-2); font-style: normal; }
  .chemin code em { color: var(--dk-accent); font-style: normal; font-weight: 600; margin: 0 0.05em; }
  .chemin code b { font-weight: 500; animation: fondu 0.3s both; }
  .chemin code b.der { font-weight: 600; color: var(--dk-accent); }
</style>
