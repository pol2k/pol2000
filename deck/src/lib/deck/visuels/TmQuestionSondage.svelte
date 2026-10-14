<script>
  /**
   * Étape 4 du travail : présenter les données, et d'abord la question du
   * sondage derrière chaque variable. Dans R, note_carney et gauche_droite
   * ne sont que des chiffres; c'est la question posée qui leur donne un
   * sens : ce que veut dire 0, ce que veut dire le maximum, et ce qui
   * devient NA. Cinq temps :
   *
   *   0  ce qu'on voit dans R : deux noms, des chiffres. De quoi ?
   *   1  note_carney : la question, mot pour mot, et son curseur 0 à 100;
   *   2  gauche_droite : la question, mot pour mot, et son échelle 0 à 10;
   *   3  les réponses qui ne sont pas des chiffres : « Je ne connais pas »,
   *      « Pas certain(e) » → -99 → NA;
   *   4  la note du codebook : en français, pendant une partie de la
   *      campagne, le nom affiché n'était pas « Mark Carney ».
   *
   * Source, mot pour mot (version française) : codebook officiel de la CES
   * 2025, ces::download_pdf_codebook("2025"), CES_2025_web_codebook.pdf.
   * cps25_lead_rating (dont _23 = Mark Carney), p. 73, avec la note sur
   * leader_fr_corrected; cps25_lr_scale_bef_1, p. 77. Seule retouche :
   * l'espace fine avant « ? ». Les étiquettes du curseur et les codes -99
   * viennent des mêmes pages.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const VARS = [
    {
      r: 'note_carney', ces: 'cps25_lead_rating_23', page: 73, de: 0, a: 100, pas: 10,
      q: 'Que pensez-vous des chefs de partis fédéraux énumérés ci-dessous ? Veuillez glisser le curseur sur un chiffre entre 0 et 100, où 0 indique que vous n’aimez vraiment pas du tout ce chef et 100 que vous aimez vraiment beaucoup ce chef.',
      g: 'Je n’aime vraiment pas du tout', d: 'J’aime vraiment beaucoup', na: 'Je ne connais pas'
    },
    {
      r: 'gauche_droite', ces: 'cps25_lr_scale_bef_1', page: 77, de: 0, a: 10, pas: 1,
      q: 'En politique, on parle parfois de gauche et de droite. Où placeriez-vous sur une échelle de 0 à 10, où 0 indique la gauche et 10 la droite ?',
      g: 'Gauche', d: 'Droite', na: 'Pas certain(e)'
    }
  ];
  const crans = (v) => Array.from({ length: (v.a - v.de) / v.pas + 1 }, (_, k) => v.de + k * v.pas);
</script>

<div class="visuel tm-qs" bind:this={hote}>
  {#each VARS as v, i}
    {@const vu = e >= i + 1}
    <div class="tm-qs-col" class:tm-vu={vu} class:tm-actif={e === i + 1}>
      <div class="tm-qs-tete">
        <code class="tm-qs-r">{v.r}</code>
        <span class="tm-qs-ces" class:tm-cache={!vu}>{v.ces}</span>
      </div>
      <p class="tm-qs-quoi" class:tm-cache={vu}>{v.de} à {v.a}. Mais de quoi&#8239;?</p>
      <div class="tm-qs-corps" class:tm-cache={!vu}>
        <blockquote class="tm-qs-q">«&#8239;{v.q}&#8239;»</blockquote>
        <div class="tm-qs-ech">
          <div class="tm-qs-crans">
            {#each crans(v) as c}<span>{c}</span>{/each}
          </div>
          <div class="tm-qs-bouts"><span>{v.g}</span><span>{v.d}</span></div>
        </div>
        <div class="tm-qs-na" class:tm-on={e >= 3}>
          <span class="tm-qs-case"><i></i>{v.na}</span>
          <span class="tm-qs-fl">→ -99 → <b>NA</b></span>
        </div>
        <small class="tm-qs-src">codebook CES 2025, p. {v.page}</small>
      </div>
    </div>
  {/each}

  <div class="tm-qs-note" class:tm-on={e >= 4}>
    <span class="tm-qs-note-et">NOTE DU CODEBOOK, p. 73</span>
    <p>En français, pendant une partie de la campagne, le nom affiché était <span class="tm-nw">«&#8239;[new Liberal leader]&#8239;»</span>, pas <span class="tm-nw">«&#8239;Mark Carney&#8239;»</span>.</p>
    <p class="tm-qs-note-cle">Sans le codebook, vous ne le sauriez pas.</p>
  </div>
</div>

<style>
  .tm-qs { display: grid; grid-template-columns: 1fr 1fr; gap: 1.1em 1.6em; align-items: start; position: relative; }
  .tm-qs-col { position: relative; display: flex; flex-direction: column; gap: 0.55em; border-top: 5px solid var(--dk-filet); padding-top: 0.5em; transition: border-color 0.4s; animation: tm-qs-f 0.4s both; }
  .tm-qs-col.tm-vu { border-top-color: var(--dk-encre); }
  .tm-qs-col.tm-actif { border-top-color: var(--dk-accent); }
  .tm-qs-tete { display: flex; align-items: baseline; justify-content: space-between; gap: 0.8em; }
  .tm-qs-r { font-size: 1.35em; font-weight: 600; }
  .tm-actif .tm-qs-r { color: var(--dk-accent); }
  .tm-qs-ces { font-size: 0.68em; color: var(--dk-gris); }
  .tm-qs-quoi { position: absolute; left: 0; top: 3.2em; margin: 0; font-size: 1.3em; color: var(--dk-gris); transition: opacity 0.3s; }
  .tm-qs-corps { display: flex; flex-direction: column; gap: 0.55em; transition: opacity 0.45s, transform 0.45s; }
  .tm-qs-corps.tm-cache { transform: translateY(0.5em); }
  .tm-qs-ces { transition: opacity 0.4s; }
  .tm-cache { opacity: 0; }
  .tm-qs-q { margin: 0; font-size: 0.86em; line-height: 1.45; background: var(--dk-fond-2); border-left: 0.3em solid var(--dk-encre); padding: 0.5em 0.8em; }
  .tm-actif .tm-qs-q { border-left-color: var(--dk-accent); }

  .tm-qs-ech { display: flex; flex-direction: column; gap: 0.2em; }
  .tm-qs-crans { display: flex; justify-content: space-between; border-bottom: 4px solid var(--dk-encre); padding-bottom: 0.15em; font-size: 0.66em; font-weight: 600; }
  .tm-qs-bouts { display: flex; justify-content: space-between; gap: 1em; font-size: 0.62em; color: var(--dk-accent); font-weight: 600; }
  .tm-qs-bouts span:last-child { text-align: right; }

  .tm-qs-na { display: flex; align-items: baseline; gap: 0.7em; font-size: 0.78em; opacity: 0.2; transition: opacity 0.4s; }
  .tm-qs-na.tm-on { opacity: 1; }
  .tm-qs-case { color: var(--dk-gris); display: inline-flex; align-items: center; gap: 0.4em; }
  .tm-qs-case i { display: inline-block; width: 0.8em; height: 0.8em; border: 2px solid var(--dk-gris); }
  .tm-qs-fl { font-weight: 600; }
  .tm-qs-na.tm-on .tm-qs-fl b { color: var(--dk-fond); background: var(--dk-accent); padding: 0 0.35em; }
  .tm-qs-src { font-size: 0.56em; letter-spacing: 0.05em; color: var(--dk-gris); }

  .tm-qs-note { grid-column: 1 / -1; display: flex; flex-direction: column; gap: 0.2em; background: var(--dk-encre); color: var(--dk-fond); padding: 0.6em 1em 0.7em; border-left: 0.5em solid var(--dk-accent); opacity: 0; transform: translateY(0.5em); transition: opacity 0.45s, transform 0.45s; }
  .tm-qs-note.tm-on { opacity: 1; transform: none; }
  .tm-qs-note-et { font-size: 0.6em; font-weight: 600; letter-spacing: 0.14em; color: var(--dk-accent-clair); }
  .tm-nw { white-space: nowrap; }
  .tm-qs-note p { margin: 0; font-size: 0.88em; line-height: 1.4; }
  .tm-qs-note .tm-qs-note-cle { font-weight: 600; color: var(--dk-accent-clair); }

  @keyframes tm-qs-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-qs-col { animation: none; }
    .tm-qs-corps, .tm-qs-quoi, .tm-qs-ces { transition: none; }
    .tm-qs-note, .tm-qs-na { transition: none; }
  }
</style>
