<script>
  /**
   * Lire une entrée du codebook : cps25_demsat, la satisfaction envers la
   * démocratie, dans l'Étude électorale canadienne 2025. La question reste
   * en anglais, comme dans le codebook. Quatre temps, une partie à la fois :
   *
   *   1  le nom : ce qu'on tape dans R;
   *   2  la question : ce qu'on a demandé;
   *   3  les codes : ce que chaque chiffre veut dire;
   *   4  le code piège : 5 = ne sait pas, pas un degré de satisfaction.
   *
   * La question vient de attr(df$cps25_demsat, "label") et les codes de la
   * variable elle-même (seance4.js, généré par outils/seance4_data.R).
   */
  import { brancherTemps } from '../temps.js';
  import { CONSOLES, SATISFACTION } from '$lib/data/seance4.js';

  const brut = CONSOLES.codebook[0].out;
  const question = brut.slice(brut.indexOf('"') + 1, brut.lastIndexOf('"')).replace(/\\n/g, ' ');
  const CODES = SATISFACTION.codes.map((c, i) => ({
    code: c,
    etiquette: SATISFACTION.etiquettes[i].replace(/^\d+\.\s*/, ''),
    n: SATISFACTION.effectifs[i].toLocaleString('fr-CA')
  }));
  const PIEGE = CODES.length; // le dernier code : ne sait pas

  const LEG = [
    ['UNE ENTRÉE DU CODEBOOK', 'Quatre choses à trouver, chaque fois.'],
    ['LE NOM', 'Ce que vous tapez dans R.'],
    ['LA QUESTION', 'Ce qu’on a demandé, mot pour mot.'],
    ['LES CODES', 'Ce que chaque chiffre veut dire.'],
    ['LE CODE PIÈGE', '5 n’est pas « encore moins satisfait ». C’est « ne sait pas ».']
  ];

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel fiche-cb" bind:this={hote}>
  <div class="fiche">
    <div class="nom" class:on={e === 1}>cps25_demsat</div>
    <p class="q" class:on={e === 2}>{question}</p>
    <ul class="codes" class:on={e === 3}>
      {#each CODES as c}
        <li class:piege={c.code === PIEGE && e === 4} class:eteint={e === 4 && c.code !== PIEGE}>
          <b>{c.code}</b><span>{c.etiquette}</span><i>{c.n}</i>
        </li>
      {/each}
    </ul>
  </div>
  {#key e}
    <div class="legende">
      <span class="et">{LEG[e][0]}</span>
      <p>{LEG[e][1]}</p>
    </div>
  {/key}
</div>

<style>
  .fiche-cb { display: grid; grid-template-columns: 1.5fr 1fr; gap: 2em; align-items: center; }
  .fiche { border: 3px solid var(--dk-encre); background: #fff; padding: 1em 1.2em; display: flex; flex-direction: column; gap: 0.8em; }
  .nom, .q, .codes { transition: background 0.3s, box-shadow 0.3s, color 0.3s; padding: 0.2em 0.4em; }
  .nom { font-weight: 600; font-size: 1.35em; align-self: flex-start; }
  .q { margin: 0; font-size: 0.95em; line-height: 1.4; font-family: Georgia, 'Times New Roman', serif; }
  .on { background: var(--dk-fond-2); box-shadow: inset 0.3em 0 0 var(--dk-accent); color: var(--dk-accent); }
  .q.on { color: var(--dk-encre); }
  .codes { list-style: none; margin: 0; display: flex; flex-direction: column; gap: 0.2em; }
  .codes li { display: grid; grid-template-columns: 1.6em 1fr auto; gap: 0.6em; align-items: baseline; font-size: 0.9em; transition: opacity 0.3s, color 0.3s; }
  .codes b { font-weight: 600; }
  .codes i { font-style: normal; color: var(--dk-gris); font-variant-numeric: tabular-nums; font-size: 0.85em; }
  .codes.on li { color: var(--dk-encre); }
  .codes.on b { color: var(--dk-accent); }
  li.eteint { opacity: 0.3; }
  li.piege { color: var(--dk-accent); font-weight: 600; outline: 3px solid var(--dk-accent); outline-offset: 0.15em; }
  .legende { display: flex; flex-direction: column; gap: 0.4em; }
  .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .legende p { margin: 0; font-size: 1.35em; line-height: 1.35; animation: fondu 0.4s both; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) { .legende p { animation: none; } }
</style>
