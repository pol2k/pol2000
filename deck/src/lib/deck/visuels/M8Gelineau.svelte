<script>
  /**
   * Le vrai tableau 1 de Blais et Gélineau (2007, p. 431), découpé tel quel
   * dans la page du PDF : la satisfaction envers la démocratie (de 0 à 1),
   * avant et après l'élection fédérale de 1997, chez les mêmes personnes
   * (CES 1997, sondage de campagne puis réentrevue après l'élection).
   *
   * Les cinq colonnes (article, p. 428 et 430) :
   *   - « federal » : le résultat national. Les libéraux forment le
   *     gouvernement (155 sièges sur 301) : avoir voté libéral, c'est
   *     gagner au pays, avoir voté pour un autre parti, perdre au pays;
   *   - « constituency » : le résultat dans la circonscription du
   *     répondant : son candidat est élu ou battu;
   *   - « Non-voters » : n'a pas voté.
   * Sous le tableau, une clé en français alignée sur ces colonnes : son vote,
   * puis gagné ou perdu au pays et dans sa circonscription. À gauche, le sens
   * de chaque ligne (Before, After, Difference, N).
   *
   *   0  le tableau, la clé, les lignes traduites;
   *   1  la ligne « Before » : les futurs gagnants sont déjà plus satisfaits;
   *   2  la ligne « Difference » : tous les groupes montent après l'élection.
   *
   * L'image (static/img/s8-bg-tableau1.png, 1978 × 867, 400 ppp) vient de
   * outils/seance8_tableaux.sh. Les cadres, les lignes et les colonnes sont
   * en % de l'image, calculés depuis les boîtes de pdftotext -bbox (boîte de
   * la découpe : x 38 à 394 pt, y 54 à 210 pt) : ils suivent l'image à
   * toutes les tailles.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Les lignes du tableau : centre vertical en % de l'image, et leur sens.
  const LIGNES = [
    { y: 54.7, t: 'avant l’élection', temps: 1 },
    { y: 62.4, t: 'après l’élection', temps: 0 },
    { y: 70.0, t: 'changement', temps: 2 },
    { y: 79.6, t: 'répondants', temps: 0 }
  ];
  // Le cadre de chaque temps [haut, hauteur] et le voile sur les lignes du dessous.
  const CADRES = [
    { y: 50.9, h: 7.6, voile: 58.9 },
    { y: 66.2, h: 7.6, voile: 74.2 }
  ];
  // Les colonnes : centre en % de la largeur de l'image (en-têtes du PDF).
  const COLS = [
    { x: 26.4, vote: 'libéral', pays: true, circ: true },
    { x: 42.0, vote: 'libéral', pays: true, circ: false },
    { x: 57.5, vote: 'autre parti', pays: false, circ: true },
    { x: 73.1, vote: 'autre parti', pays: false, circ: false }
  ];
  const ABST = 87.8;
</script>

{#snippet marque(gagne)}
  <span class="m8gl-m" class:m8gl-g={gagne} class:m8gl-p={!gagne}>
    <span class="m8gl-tuile" aria-hidden="true">{gagne ? '✓' : '✗'}</span>
    <span class="m8gl-mot">{gagne ? 'gagné' : 'perdu'}</span>
  </span>
{/snippet}

<div class="visuel m8gl" bind:this={hote}>
  <div class="m8gl-grille">
    <!-- le sens des lignes, à gauche du tableau -->
    <div class="m8gl-gloses" aria-hidden="true">
      {#each LIGNES as l}
        <span class="m8gl-glose" class:on={l.temps && e === l.temps} style="top: {l.y}%">{l.t}</span>
      {/each}
    </div>

    <div class="m8gl-feuille">
      <img src="{base}/img/s8-bg-tableau1.png" alt="Le tableau 1 de l’article, en anglais : la satisfaction moyenne avant l’élection, après l’élection, la différence et le nombre de personnes, pour cinq groupes. Gagnants partout : 0,645 avant, 0,738 après. Perdants partout : 0,526 avant, 0,579 après. N’a pas voté : 0,493 avant, 0,577 après. Tous les groupes augmentent." />
      {#each CADRES as c, i}
        <span class="m8gl-voile" class:on={e === i + 1} style="top: {c.voile}%"></span>
        <span class="m8gl-cadre" class:on={e === i + 1} style="top: {c.y}%; height: {c.h}%"></span>
      {/each}
      <!-- temps 1 : sous les deux colonnes des futurs gagnants -->
      <span class="m8gl-note m8gl-n1" class:on={e === 1}>▲ déjà plus satisfaits</span>
      <!-- temps 2 : sur toute la largeur -->
      <span class="m8gl-note m8gl-n2" class:on={e === 2}>▲ les cinq groupes montent après l’élection</span>
    </div>

    <!-- la clé : trois lignes, alignées sur les colonnes du tableau -->
    <div class="m8gl-cle-tetes">
      <span class="m8gl-tete">son vote</span>
      <span class="m8gl-tete">au pays<small>gouvernement libéral</small></span>
      <span class="m8gl-tete">dans sa circonscription<small>son candidat</small></span>
    </div>
    <div class="m8gl-cle">
      {#each COLS as c, i}
        <div class="m8gl-col" style="left: {c.x}%; animation-delay: {0.1 + i * 0.12}s">
          <span class="m8gl-vote" class:m8gl-lib={c.vote === 'libéral'}>{c.vote}</span>
          {@render marque(c.pays)}
          {@render marque(c.circ)}
        </div>
      {/each}
      <div class="m8gl-col m8gl-abst" style="left: {ABST}%; animation-delay: 0.58s">
        <span class="m8gl-vote m8gl-rien">abstention</span>
        <span class="m8gl-vide" aria-hidden="true"></span>
        <span class="m8gl-vide" aria-hidden="true"></span>
      </div>
    </div>
  </div>
  <div class="m8gl-legende">Blais et Gélineau (2007), tableau 1, p. 431 · CES 1997 · satisfaction de 0 (pas du tout) à 1 (très satisfait)</div>
</div>

<style>
  .m8gl { display: flex; flex-direction: column; gap: 0.5em; margin: 0 auto; }
  /* deux colonnes : le sens des lignes (en français), puis le tableau; la clé en dessous */
  .m8gl-grille {
    display: grid;
    grid-template-columns: 8.8em min(calc(100% - 9.4em), 100vh);
    grid-template-rows: auto auto;
    column-gap: 0.6em;
    row-gap: 0.55em;
    justify-content: center;
  }

  .m8gl-gloses { position: relative; }
  .m8gl-glose {
    position: absolute; right: 0; transform: translateY(-50%);
    font-size: 0.72em; line-height: 1.15; text-align: right; color: var(--dk-gris); white-space: nowrap;
    transition: color 0.3s;
  }
  .m8gl-glose::after { content: ' →'; color: var(--dk-gris-2); }
  .m8gl-glose.on { color: var(--dk-accent); font-weight: 600; }

  .m8gl-feuille { position: relative; border: 2px solid var(--dk-filet); background: #fff; animation: m8gl-f 0.4s both; }
  .m8gl-feuille img { display: block; width: 100%; height: auto; }
  .m8gl-cadre { position: absolute; left: 5.2%; width: 91%; outline: 4px solid var(--dk-accent); opacity: 0; transition: opacity 0.35s; }
  .m8gl-voile { position: absolute; left: 0; right: 0; bottom: 0; background: rgba(255, 255, 255, 0.92); opacity: 0; transition: opacity 0.35s; }
  .m8gl-cadre.on, .m8gl-voile.on { opacity: 1; }
  .m8gl-note {
    position: absolute; transform: translate(-50%, -50%);
    font-size: 0.72em; font-weight: 600; color: var(--dk-accent); white-space: nowrap;
    opacity: 0; transition: opacity 0.35s 0.15s;
  }
  .m8gl-note.on { opacity: 1; }
  /* sous 0,645 et 0,634 : colonnes 1 et 2 (x 24,6 à 45,2 %), dans la ligne After voilée;
     au temps 2, au milieu des cinq colonnes, dans la ligne N voilée */
  .m8gl-n1 { left: 34.9%; top: 62.4%; }
  .m8gl-n2 { left: 57%; top: 79.6%; }

  /* la clé */
  .m8gl-cle-tetes { display: grid; grid-template-rows: repeat(3, 1fr); row-gap: 0.2em; }
  .m8gl-tete {
    display: flex; flex-direction: column; justify-content: center; align-items: flex-end; text-align: right;
    font-size: 0.72em; line-height: 1.15; font-weight: 600;
  }
  .m8gl-tete small { font-size: 0.85em; font-weight: 400; color: var(--dk-gris); }
  .m8gl-cle { position: relative; display: grid; }
  .m8gl-col {
    position: relative; grid-area: 1 / 1; width: 14%; transform: translateX(-50%);
    display: grid; grid-template-rows: repeat(3, 1fr); row-gap: 0.2em; justify-items: center; align-items: center;
    animation: m8gl-f 0.4s both;
  }
  .m8gl-vote {
    font-size: 0.64em; font-weight: 600; padding: 0.15em 0.4em; border: 2px solid var(--dk-encre); white-space: nowrap;
  }
  .m8gl-vote:not(.m8gl-lib) { border-color: var(--dk-gris-2); color: var(--dk-gris); }
  .m8gl-rien { border-style: dashed; }
  .m8gl-m { display: inline-flex; align-items: center; gap: 0.35em; }
  .m8gl-tuile {
    display: inline-grid; place-items: center; width: 1.45em; height: 1.45em;
    font-size: 0.9em; font-weight: 700; line-height: 1; box-sizing: border-box;
  }
  .m8gl-g .m8gl-tuile { background: var(--dk-encre); color: var(--dk-fond); }
  .m8gl-p .m8gl-tuile { border: 2px solid var(--dk-accent); color: var(--dk-accent); }
  .m8gl-mot { font-size: 0.68em; }
  .m8gl-p .m8gl-mot { color: var(--dk-accent); }
  .m8gl-vide { width: 1.3em; height: 1.3em; border: 2px dashed var(--dk-gris-2); box-sizing: border-box; }

  .m8gl-legende { text-align: center; color: var(--dk-gris); font-size: 0.6em; }

  @keyframes m8gl-f { from { opacity: 0; transform: translate(var(--m8gl-tx, 0), 0.4em); } to { opacity: 1; transform: translate(var(--m8gl-tx, 0), 0); } }
  .m8gl-col { --m8gl-tx: -50%; }
  @media (prefers-reduced-motion: reduce) {
    .m8gl-feuille, .m8gl-col { animation: none; }
    .m8gl-cadre, .m8gl-voile, .m8gl-note, .m8gl-glose { transition: none; }
  }
</style>
