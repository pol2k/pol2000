<script>
  /**
   * Étape 2, suite : trouver les bons articles. Deux portes d'entrée
   * (Google Scholar, Sofia de la Bibliothèque de l'Université Laval), une
   * pile de résultats, puis deux tamis. Ce qui reste va dans le travail,
   * cité en APA (auteur-date), quatre références au minimum (consignes,
   * partie 2). Quatre temps :
   *
   *   0  les deux portes et une pile de douze résultats;
   *   1  tamis 1 : révisé par les pairs. Le blogue, le journal, Wikipédia
   *      et le site d'opinion tombent;
   *   2  tamis 2 : fort facteur d'impact, beaucoup cité ou récent. Les vieux articles peu cités, parus dans des revues
   *      sérieuses mais peu citées, tombent; le récent reste même s'il est
   *      encore peu cité;
   *   3  ce qui reste : au moins quatre, et comment on les cite en APA.
   *
   * Les revues et leurs facteurs d'impact sont réels (sources plus bas).
   * Les articles (« Article A »), leurs années et leurs nombres de
   * citations sont fictifs, et la légende le dit. Le gabarit APA n'a que des
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
  // revue : une vraie revue révisée par les pairs et son facteur d'impact
  // 2025 (Journal Citation Reports de Clarivate, publiés en juin 2026), tel
  // que la revue ou son éditeur l'affiche (pages consultées le 15 octobre
  // 2026) :
  //   Nature 56,1 : nature.com/nature/journal-impact (« Journal Impact
  //     Factor: 56.1 (2025) »);
  //   American Journal of Political Science 4,7 : ajps.org (« Impact factor:
  //     4.7 », « Clarivate, 2025 »);
  //   British Journal of Political Science 4,6, Japanese Journal of Political
  //     Science 1,6, Politics and Religion 1,5 : pages des revues sur
  //     cambridge.org (« 2025 Impact Factor », « 2025 Journal Citation
  //     Reports © Clarivate »).
  // Les revues à faible facteur d'impact sont des revues sérieuses, moins
  // citées : rien d'autre n'est sous-entendu. Les articles (« Article A »),
  // leurs années et leurs nombres de citations sont fictifs, et le disent.
  const NATURE = { nom: 'Nature', fi: 56.1 };
  const AJPS = { nom: 'American Journal of Political Science', fi: 4.7 };
  const BJPS = { nom: 'British Journal of Political Science', fi: 4.6 };
  const JJPS = { nom: 'Japanese Journal of Political Science', fi: 1.6 };
  const PR = { nom: 'Politics and Religion', fi: 1.5 };
  const PAIRS = 'révisée par les pairs';
  const CARTES = [
    { nom: 'Article A', type: PAIRS, revue: NATURE, an: 2019, cite: 1250, tombe: 0 },
    { nom: 'Blogue', type: 'billet de blogue', an: 2023, tombe: 1 },
    { nom: 'Article B', type: PAIRS, revue: AJPS, an: 2024, cite: 18, tombe: 0 },
    { nom: 'Journal', type: 'article de presse', an: 2025, tombe: 1 },
    { nom: 'Article C', type: PAIRS, revue: PR, an: 2006, cite: 9, tombe: 2 },
    { nom: 'Article D', type: PAIRS, revue: AJPS, an: 1998, cite: 2400, tombe: 0 },
    { nom: 'Wikipédia', type: 'encyclopédie', an: 2025, tombe: 1 },
    { nom: 'Article E', type: PAIRS, revue: BJPS, an: 2021, cite: 310, tombe: 0 },
    { nom: 'Article F', type: PAIRS, revue: JJPS, an: 2010, cite: 7, tombe: 2 },
    { nom: 'Opinion', type: 'site d’opinion', an: 2024, tombe: 1 },
    { nom: 'Article G', type: PAIRS, revue: NATURE, an: 2016, cite: 640, tombe: 0 },
    { nom: 'Article H', type: PAIRS, revue: PR, an: 2013, cite: 4, tombe: 2 }
  ];
  const TAMIS = ['Révisé par les pairs', 'Fort facteur d’impact, beaucoup cité ou récent'];
  const nb = (n) => n.toLocaleString('fr-CA');
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
        <div class="tm-tr-carte" class:tm-tombe={c.tombe && e >= c.tombe} class:tm-garde={!c.tombe && e >= 3} class:tm-pairs={!!c.revue} style="--i: {i}">
          <span class="tm-tr-type">{c.type} · {c.an}</span>
          <strong>{c.nom}</strong>
          {#if c.revue}
            <span class="tm-tr-cite">cité {nb(c.cite)} fois</span>
            <span class="tm-tr-revue">{c.revue.nom}</span>
            <span class="tm-tr-fi">facteur d’impact 2025&#8239;: <b>{c.revue.fi.toLocaleString('fr-CA')}</b></span>
          {/if}
        </div>
      {/each}
    </div>
    <p class="tm-tr-leg">articles et citations fictifs · revues et facteurs d’impact réels (Clarivate, 2025)</p>
  </div>

  <div class="tm-tr-apa" class:tm-on={e >= 3}>
    <span class="tm-tr-compte"><b>{restent}</b> gardés · minimum 4</span>
    <span class="tm-tr-apa-l"><b class="tm-tr-apa-b">APA, AUTEUR-DATE ·</b> dans le texte&#8239;: <code>(Nom, 2022)</code></span>
    <span class="tm-tr-apa-l">bibliographie&#8239;: <code>Nom, P. (2022). Titre. <i>Revue</i>, 12(3), 45-67.</code></span>
  </div>
</div>

<style>
  .tm-trouver { display: grid; grid-template-columns: 12em 1fr; grid-template-rows: auto auto; gap: 0.55em 1.6em; align-items: start; }
  .tm-tr-portes { grid-row: 1; display: flex; flex-direction: column; gap: 0.9em; position: relative; padding-top: 2.6em; }
  .tm-tr-porte { display: flex; flex-direction: column; gap: 0.2em; border: 3px solid var(--dk-encre); padding: 0.7em 0.8em; animation: tm-tr-f 0.4s both; }
  .tm-tr-porte:nth-child(2) { animation-delay: 0.15s; }
  .tm-tr-porte strong { font-size: 1.15em; }
  .tm-tr-porte span { font-size: 0.66em; color: var(--dk-gris); line-height: 1.3; }
  .tm-tr-fl { position: absolute; right: -1.25em; top: 50%; font-size: 1.4em; font-weight: 600; color: var(--dk-accent); }

  .tm-tr-centre { grid-row: 1; display: flex; flex-direction: column; gap: 0.35em; }
  .tm-tr-tamis { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: 1fr 1fr; gap: 0.6em; }
  .tm-tr-tamis li { margin: 0; display: flex; flex-direction: column; gap: 0.1em; font-size: 0.78em; line-height: 1.3; border-top: 4px solid var(--dk-filet); padding-top: 0.3em; color: var(--dk-gris-2); transition: color 0.4s, border-color 0.4s; }
  .tm-tr-tamis li span { font-size: 0.8em; font-weight: 600; letter-spacing: 0.14em; }
  .tm-tr-tamis li.tm-on { color: var(--dk-encre); border-top-color: var(--dk-encre); }
  .tm-tr-tamis li.tm-actif { border-top-color: var(--dk-accent); }
  .tm-tr-tamis li.tm-actif span { color: var(--dk-accent); }

  .tm-tr-cartes { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.4em; }
  .tm-tr-carte { display: grid; grid-template-columns: 1fr auto; grid-template-areas: 'type type' 'nom cite' 'revue revue' 'fi fi'; grid-template-rows: auto auto auto auto; gap: 0.05em 0.4em; align-items: baseline; border: 2px solid var(--dk-encre); background: #fff; padding: 0.3em 0.55em 0.32em; animation: tm-tr-pile 0.35s backwards; animation-delay: calc(var(--i) * 45ms); transition: opacity 0.45s, transform 0.45s, border-color 0.3s; }
  .tm-tr-carte:not(.tm-pairs) { background: var(--dk-fond-2); }
  .tm-tr-type { grid-area: type; font-size: 0.52em; letter-spacing: 0.08em; text-transform: uppercase; color: var(--dk-gris); white-space: nowrap; }
  .tm-tr-carte strong { grid-area: nom; font-size: 0.8em; white-space: nowrap; }
  .tm-tr-revue { grid-area: revue; align-self: start; font-size: 0.54em; line-height: 1.2; font-style: italic; }
  .tm-tr-fi { grid-area: fi; font-size: 0.56em; color: var(--dk-gris); white-space: nowrap; }
  .tm-tr-fi b { color: var(--dk-encre); font-size: 1.15em; }
  .tm-tr-cite { grid-area: cite; justify-self: end; font-size: 0.56em; color: var(--dk-gris); white-space: nowrap; }
  .tm-tr-carte.tm-tombe { opacity: 0.12; transform: translateY(0.5em) rotate(-3deg); }
  .tm-tr-carte.tm-garde { border: 3px solid var(--dk-accent); }
  .tm-tr-carte.tm-garde .tm-tr-fi b, .tm-tr-carte.tm-garde .tm-tr-cite { color: var(--dk-accent); font-weight: 600; }
  .tm-tr-leg { margin: 0; font-size: 0.56em; letter-spacing: 0.05em; color: var(--dk-gris); }

  .tm-tr-apa { grid-column: 1 / -1; display: grid; grid-template-columns: auto 1fr; gap: 0.15em 1.4em; align-items: baseline; border-top: 3px solid var(--dk-encre); padding-top: 0.35em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.5s 0.3s, transform 0.5s 0.3s; }
  .tm-tr-apa.tm-on { opacity: 1; transform: none; }
  .tm-tr-compte { grid-row: 1 / 3; font-size: 0.9em; font-weight: 600; color: var(--dk-accent); white-space: nowrap; align-self: center; }
  .tm-tr-compte b { font-size: 2em; }
  .tm-tr-apa-b { font-size: 0.8em; letter-spacing: 0.1em; color: var(--dk-accent); margin-right: 0.3em; }
  .tm-tr-apa-l { font-size: 0.82em; color: var(--dk-gris); }
  .tm-tr-apa-l code { font-size: 1.05em; color: var(--dk-encre); background: var(--dk-fond-2); padding: 0.05em 0.4em; }

  @keyframes tm-tr-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @keyframes tm-tr-pile { from { opacity: 0; transform: translateY(-0.6em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-tr-porte, .tm-tr-carte { animation: none; }
    .tm-tr-carte, .tm-tr-apa, .tm-tr-tamis li { transition: none; }
  }
</style>
