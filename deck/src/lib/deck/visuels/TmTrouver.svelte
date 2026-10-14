<script>
  /**
   * Étape 2, suite : trouver les bons articles. Deux portes d'entrée
   * (Google Scholar, Sofia de la Bibliothèque de l'Université Laval), une
   * pile de résultats, puis deux tamis. Ce qui reste va dans le travail,
   * cité en APA (auteur-date), quatre références au minimum (consignes,
   * partie 2). Quatre temps :
   *
   *   0  les deux portes et une pile de douze résultats;
   *   1  tamis 1 : évalué par les pairs, dans une revue reconnue. Le blogue,
   *      le journal, Wikipédia, le site d'opinion et la revue douteuse
   *      tombent;
   *   2  tamis 2 : beaucoup cité, ou récent. Le vieil article que personne
   *      ne cite tombe; le récent reste même s'il est encore peu cité;
   *   3  ce qui reste : au moins quatre, et comment on les cite en APA.
   *
   * Tout est schématique : des cartes sans titre (« Article A »), une barre
   * « cité » sans chiffre, des années d'exemple. Aucune vraie référence,
   * aucun vrai compte de citations. Le gabarit APA n'a que des
   * paramètres fictifs (Nom, Titre, Revue).
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // tombe : le tamis qui l'écarte (1 ou 2), 0 s'il reste.
  // cite : longueur de la barre « cité », de 0 à 1 (schématique).
  const CARTES = [
    { nom: 'Article A', type: 'revue savante', an: 2011, cite: 0.95, tombe: 0 },
    { nom: 'Blogue', type: 'billet de blogue', an: 2023, cite: 0, tombe: 1 },
    { nom: 'Article B', type: 'revue savante', an: 2024, cite: 0.12, tombe: 0 },
    { nom: 'Journal', type: 'article de presse', an: 2025, cite: 0, tombe: 1 },
    { nom: 'Article C', type: 'revue savante', an: 2003, cite: 0.08, tombe: 2 },
    { nom: 'Article D', type: 'revue savante', an: 1998, cite: 1, tombe: 0 },
    { nom: 'Wikipédia', type: 'encyclopédie', an: 2025, cite: 0, tombe: 1 },
    { nom: 'Article E', type: 'revue savante', an: 2022, cite: 0.45, tombe: 0 },
    { nom: 'Article F', type: 'revue savante', an: 2008, cite: 0.1, tombe: 2 },
    { nom: 'Opinion', type: 'site d’opinion', an: 2024, cite: 0, tombe: 1 },
    { nom: 'Article G', type: 'revue savante', an: 2016, cite: 0.7, tombe: 0 },
    { nom: 'Article H', type: 'revue douteuse', an: 2021, cite: 0.05, tombe: 1 }
  ];
  const TAMIS = ['Évalué par les pairs, dans une revue reconnue', 'Beaucoup cité, ou récent'];
  const restent = CARTES.filter((c) => !c.tombe).length;
</script>

<div class="visuel tm-trouver" bind:this={hote}>
  <div class="tm-tr-portes">
    <div class="tm-tr-porte">
      <strong>Google Scholar</strong>
      <span>scholar.google.com</span>
    </div>
    <div class="tm-tr-porte">
      <strong>Sofia</strong>
      <span>Bibliothèque de l’Université Laval</span>
    </div>
    <div class="tm-tr-fl" aria-hidden="true">→</div>
  </div>

  <div class="tm-tr-centre">
    <ol class="tm-tr-tamis">
      {#each TAMIS as t, i}
        <li class:tm-on={e >= i + 1} class:tm-actif={e === i + 1}><span>TAMIS {i + 1}</span>{t}</li>
      {/each}
    </ol>
    <div class="tm-tr-cartes">
      {#each CARTES as c, i}
        <div class="tm-tr-carte" class:tm-tombe={c.tombe && e >= c.tombe} class:tm-garde={!c.tombe && e >= 3} class:tm-savante={c.type === 'revue savante'} style="--i: {i}">
          <span class="tm-tr-type">{c.type}</span>
          <strong>{c.nom}</strong>
          <span class="tm-tr-an">{c.an}</span>
          <span class="tm-tr-cite" aria-label="cité">{#if c.cite > 0}<i style="width: {c.cite * 100}%"></i>{/if}</span>
        </div>
      {/each}
    </div>
    <p class="tm-tr-leg">barre = cité souvent ou peu · cartes fictives</p>
  </div>

  <div class="tm-tr-apa" class:tm-on={e >= 3}>
    <span class="tm-tr-compte"><b>{restent}</b> gardés · minimum 4</span>
    <span class="tm-tr-apa-et">APA · AUTEUR-DATE</span>
    <span class="tm-tr-apa-l">dans le texte&#8239;: <code>(Nom, 2022)</code></span>
    <span class="tm-tr-apa-l">bibliographie&#8239;: <code>Nom, P. (2022). Titre. <i>Revue</i>, 12(3), 45-67.</code></span>
  </div>
</div>

<style>
  .tm-trouver { display: grid; grid-template-columns: 12em 1fr; grid-template-rows: auto auto; gap: 1em 1.6em; align-items: start; }
  .tm-tr-portes { grid-row: 1; display: flex; flex-direction: column; gap: 0.9em; position: relative; padding-top: 2.6em; }
  .tm-tr-porte { display: flex; flex-direction: column; gap: 0.2em; border: 3px solid var(--dk-encre); padding: 0.7em 0.8em; animation: tm-tr-f 0.4s both; }
  .tm-tr-porte:nth-child(2) { animation-delay: 0.15s; }
  .tm-tr-porte strong { font-size: 1.15em; }
  .tm-tr-porte span { font-size: 0.66em; color: var(--dk-gris); line-height: 1.3; }
  .tm-tr-fl { position: absolute; right: -1.25em; top: 50%; font-size: 1.4em; font-weight: 600; color: var(--dk-accent); }

  .tm-tr-centre { grid-row: 1; display: flex; flex-direction: column; gap: 0.5em; }
  .tm-tr-tamis { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: 1fr 1fr; gap: 0.6em; }
  .tm-tr-tamis li { margin: 0; display: flex; flex-direction: column; gap: 0.1em; font-size: 0.78em; line-height: 1.3; border-top: 4px solid var(--dk-filet); padding-top: 0.3em; color: var(--dk-gris-2); transition: color 0.4s, border-color 0.4s; }
  .tm-tr-tamis li span { font-size: 0.8em; font-weight: 600; letter-spacing: 0.14em; }
  .tm-tr-tamis li.tm-on { color: var(--dk-encre); border-top-color: var(--dk-encre); }
  .tm-tr-tamis li.tm-actif { border-top-color: var(--dk-accent); }
  .tm-tr-tamis li.tm-actif span { color: var(--dk-accent); }

  .tm-tr-cartes { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.5em; }
  .tm-tr-carte { display: grid; grid-template-columns: 1fr auto; grid-template-areas: 'type type' 'nom an' 'cite cite'; gap: 0.15em 0.4em; align-items: baseline; border: 2px solid var(--dk-encre); background: #fff; padding: 0.4em 0.55em 0.5em; animation: tm-tr-pile 0.35s backwards; animation-delay: calc(var(--i) * 45ms); transition: opacity 0.45s, transform 0.45s, border-color 0.3s; }
  .tm-tr-carte:not(.tm-savante) { background: var(--dk-fond-2); }
  .tm-tr-type { grid-area: type; font-size: 0.58em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); white-space: nowrap; }
  .tm-tr-carte strong { grid-area: nom; font-size: 0.82em; white-space: nowrap; }
  .tm-tr-an { grid-area: an; font-size: 0.68em; color: var(--dk-gris); }
  .tm-tr-cite { grid-area: cite; display: block; height: 0.42em; background: var(--dk-filet); margin-top: 0.2em; }
  .tm-tr-cite i { display: block; height: 100%; background: var(--dk-encre); }
  .tm-tr-carte.tm-tombe { opacity: 0.12; transform: translateY(0.5em) rotate(-3deg); }
  .tm-tr-carte.tm-garde { border: 3px solid var(--dk-accent); }
  .tm-tr-carte.tm-garde .tm-tr-cite i { background: var(--dk-accent); }
  .tm-tr-leg { margin: 0; font-size: 0.56em; letter-spacing: 0.05em; color: var(--dk-gris); }

  .tm-tr-apa { grid-column: 1 / -1; display: grid; grid-template-columns: auto 1fr; gap: 0.25em 1.4em; align-items: baseline; border-top: 3px solid var(--dk-encre); padding-top: 0.5em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.5s 0.3s, transform 0.5s 0.3s; }
  .tm-tr-apa.tm-on { opacity: 1; transform: none; }
  .tm-tr-compte { grid-row: 1 / 4; font-size: 0.9em; font-weight: 600; color: var(--dk-accent); white-space: nowrap; align-self: center; }
  .tm-tr-compte b { font-size: 2em; }
  .tm-tr-apa-et { font-size: 0.62em; font-weight: 600; letter-spacing: 0.14em; color: var(--dk-accent); }
  .tm-tr-apa-l { font-size: 0.82em; color: var(--dk-gris); }
  .tm-tr-apa-l code { font-size: 1.05em; color: var(--dk-encre); background: var(--dk-fond-2); padding: 0.05em 0.4em; }

  @keyframes tm-tr-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @keyframes tm-tr-pile { from { opacity: 0; transform: translateY(-0.6em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-tr-porte, .tm-tr-carte { animation: none; }
    .tm-tr-carte, .tm-tr-apa, .tm-tr-tamis li { transition: none; }
  }
</style>
