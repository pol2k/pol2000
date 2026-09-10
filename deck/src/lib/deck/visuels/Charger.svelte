<script>
  /**
   * Charger ses propres données : quatre formats qu'on croise en sciences
   * sociales, une fonction chacun, le chemin relatif toujours. Chaque ligne
   * se copie d'un clic. Les deux packages qui ne viennent pas avec R sont
   * dits tels.
   */
  import Copier from '../Copier.svelte';
  const F = [
    { ext: '.csv', quoi: 'Le tableau texte universel. Excel, Google Sheets et tous les sites de données l’exportent.', code: 'df <- read.csv("data/sondage.csv")', pkg: 'livré avec R' },
    { ext: '.rds', quoi: 'Le format de R. Garde tout : les étiquettes, les types, les facteurs. Le package ces vous donne des .rds.', code: 'df <- readRDS("data/sondage.rds")', pkg: 'livré avec R' },
    { ext: '.sav', quoi: 'SPSS. La plupart des grandes enquêtes de sciences sociales sont livrées ainsi, étiquettes comprises.', code: 'df <- haven::read_sav("data/sondage.sav")', pkg: 'install.packages("haven")' },
    { ext: '.xlsx', quoi: 'Excel. Une feuille à la fois ; dites laquelle avec sheet = si ce n’est pas la première.', code: 'df <- readxl::read_excel("data/sondage.xlsx")', pkg: 'install.packages("readxl")' }
  ];
</script>

<div class="visuel charger">
  <div class="grille">
    {#each F as f, i}
      <div class="tuile" style="animation-delay: {i * 110}ms">
        <div class="haut">
          <svg viewBox="0 0 48 60" aria-hidden="true"><path d="M6 3h24l12 12v42H6z" /><path d="M30 3v12h12" /></svg>
          <span class="ext">{f.ext}</span>
        </div>
        <p>{f.quoi}</p>
        <div class="cmd"><code>{f.code}</code><Copier texte={f.code} /></div>
        <span class="pkg" class:inst={f.pkg.startsWith('install')}>{f.pkg}</span>
      </div>
    {/each}
  </div>
  <p class="note">Toujours le même geste : un nom d’objet, la flèche, une fonction qui lit, et entre guillemets <strong>le chemin relatif</strong>, depuis le dossier ouvert dans Positron. Le tableau apparaît dans « Variables ».</p>
</div>

<style>
  .charger { display: flex; flex-direction: column; gap: 0.6em; }
  .grille { display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.7em; }
  .tuile { border: 2px solid var(--dk-encre); padding: 0.55em 0.8em 0.55em; display: flex; flex-direction: column; gap: 0.3em; animation: fondu 0.5s both; }
  .haut { display: flex; align-items: center; gap: 0.6em; }
  .haut svg { width: 2.2em; height: auto; fill: #fff; stroke: var(--dk-encre); stroke-width: 2.5; stroke-linejoin: round; }
  .ext { font-family: var(--dk-mono); font-size: 1.35em; font-weight: 600; color: var(--dk-accent); letter-spacing: -0.02em; }
  .tuile p { margin: 0; font-size: 0.68em; line-height: 1.35; color: var(--dk-gris); }
  .cmd { position: relative; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left-width: 0.34em; border-left-color: var(--dk-accent); padding: 0.45em 5em 0.45em 0.8em; }
  .cmd code { background: none; padding: 0; font-size: 0.86em; }
  .cmd :global(.copier) { position: absolute; top: 0.35em; right: 0.35em; }
  .pkg { font-size: 0.6em; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-gris); }
  .pkg.inst { color: var(--dk-accent); font-weight: 600; text-transform: none; letter-spacing: 0; font-family: var(--dk-mono); }
  .note { margin: 0; font-size: 0.76em; line-height: 1.4; border-left: 0.34em solid var(--dk-accent); padding-left: 0.8em; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
