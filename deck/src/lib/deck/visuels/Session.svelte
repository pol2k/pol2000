<script>
  /**
   * La session sur une ligne du temps: quatorze séances, trois parties, la
   * semaine de lecture. Un clic avance d'une séance: la ligne rouge s'étire
   * jusqu'à elle, son nœud grossit, et la fiche en dessous change — numéro,
   * date, titre, une phrase, le glyphe. Temps 0: la vue d'ensemble. Dates
   * et titres du plan de cours A26.
   */
  import { brancherTemps } from '../temps.js';
  import Glyphe from './Glyphe.svelte';
  const S = [
    { n: 1, d: 'jeudi 3 septembre', c: '3 sept', p: 1, t: 'Introduction et les éléments fondamentaux de la recherche', q: "Une question, les mots pour la poser, et ce qu'il faut installer." },
    { n: 2, d: 'jeudi 10 septembre', c: '10 sept', p: 1, t: 'Introduction à R et à Positron', q: 'R à partir de zéro, en direct, sur votre ordinateur.', note: "Apportez l'ordinateur, installé." },
    { n: 3, d: 'jeudi 17 septembre', c: '17 sept', p: 1, t: 'Les statistiques descriptives et la visualisation des données', q: "Décrire une variable : la forme d'une distribution, son centre, sa dispersion. Et la dessiner." },
    { n: 4, d: 'jeudi 24 septembre', c: '24 sept', p: 1, t: 'Préparer ses données avec R', q: 'Lire un codebook, recoder, gérer les valeurs manquantes. Le vrai travail.', note: "L'examen 1 ouvre aujourd'hui." },
    { n: 5, d: 'jeudi 1er octobre', c: '1 oct', p: 1, t: "L'inférence statistique", q: 'Ce que je vois dans un échantillon, puis-je le dire de toute la population ?', note: 'Examen 1 à remettre dimanche 4 octobre.' },
    { n: 6, d: 'jeudi 8 octobre', c: '8 oct', p: 0, t: 'Rencontres individuelles', q: 'Pas de cours magistral : on se voit, un.e à la fois, avec les auxiliaires et le tuteur.' },
    { n: 7, d: 'jeudi 15 octobre', c: '15 oct', p: 2, t: 'La régression linéaire simple', q: 'Une droite qui résume une relation, et ce que ses chiffres veulent dire.' },
    { n: 8, d: 'jeudi 22 octobre', c: '22 oct', p: 2, t: 'Examen 2, puis atelier de mi-session', q: "Une heure d'examen sur papier, puis on travaille votre devis, ensemble.", note: 'Mi-session à remettre dimanche 25 octobre.' },
    { n: 9, d: 'jeudi 5 novembre', c: '5 nov', p: 2, t: 'La régression linéaire multiple', q: 'Plusieurs variables explicatives à la fois. Ce que « contrôler pour » veut dire.' },
    { n: 10, d: 'jeudi 12 novembre', c: '12 nov', p: 2, t: "De la question au tableau de régression : à la main, puis avec l'IA", q: "Le travail final, du début à la fin. D'abord vous, puis un agent d'IA, et on le vérifie." },
    { n: 11, d: 'jeudi 19 novembre', c: '19 nov', p: 3, t: 'Les graphes orientés acycliques (GOA)', q: 'Dessiner ses hypothèses causales. Décider quoi contrôler, ou pas.' },
    { n: 12, d: 'jeudi 26 novembre', c: '26 nov', p: 3, t: "Le problème fondamental de l'inférence causale", q: 'On ne voit jamais les deux mondes à la fois. Tout part de là.' },
    { n: 13, d: 'jeudi 3 décembre', c: '3 déc', p: 3, t: 'Les biais', q: 'Variable omise, sélection, mesure, simultanéité : ce qui fausse une régression.' },
    { n: 14, d: 'jeudi 10 décembre', c: '10 déc', p: 3, t: 'Les expériences, et révision', q: 'Le hasard comme méthode. Puis on revoit tout.', note: 'Examen 3 en classe · travail final vendredi 18 décembre.' }
  ];
  const PARTIES = ['', 'Concepts de base', 'Régression', 'Inférence causale'];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 14, lire: () => e, ecrire: (v) => (e = v) });
  });
  // géométrie: 15 cases (la semaine de lecture entre 8 et 9)
  const W = 1200, X0 = 40, X1 = W - 40;
  const slot = (i) => (i >= 8 ? i + 1 : i);                 // index de case, 0..14
  const x = (i) => X0 + (slot(i) / 14) * (X1 - X0);
  const xLecture = X0 + (8 / 14) * (X1 - X0);
  const cur = $derived(e > 0 ? S[e - 1] : null);
</script>

<div class="visuel session" bind:this={hote}>
  <svg viewBox="0 0 {W} 168" class="ligne" role="img" aria-label="Ligne du temps des quatorze séances, de septembre à décembre.">
    <line x1={X0} y1="70" x2={X1} y2="70" class="rail" />
    <rect x={X0} y="67" height="6" rx="3" width={e > 0 ? x(e - 1) - X0 : 0} class="progres" />
    <!-- semaine de lecture -->
    <g class="lecture" style="transform: translate({xLecture}px, 70px)">
      <rect x="-22" y="-12" width="44" height="24" />
      <text y="-24" class="lib">lecture</text>
    </g>
    {#each S as s, i}
      {@const on = e === i + 1}
      {@const fait = e > i + 1}
      <g class="noeud p{s.p}" class:on class:fait style="transform: translate({x(i)}px, 70px)">
        <circle r={on ? 20 : 11} />
        <text y={on ? 7 : 5} class="n">{s.n}</text>
        <text y="44" class="date">{s.c}</text>
      </g>
    {/each}
    <!-- parties -->
    <g class="parties">
      <line x1={x(0)} y1="130" x2={x(4)} y2="130" class="p1" /><text x={(x(0) + x(4)) / 2} y="154" class="pl">1 · Concepts de base</text>
      <line x1={x(6)} y1="130" x2={x(9)} y2="130" class="p2" /><text x={(x(6) + x(9)) / 2} y="154" class="pl">2 · Régression</text>
      <line x1={x(10)} y1="130" x2={x(13)} y2="130" class="p3" /><text x={(x(10) + x(13)) / 2} y="154" class="pl">3 · Inférence causale</text>
    </g>
  </svg>

  {#if cur}
    {#key e}
      <div class="fiche">
        <div class="texte">
          <span class="num">{String(cur.n).padStart(2, '0')}</span>
          <span class="dt">{cur.d}{cur.p ? ' · partie ' + cur.p + ' · ' + PARTIES[cur.p] : ''}</span>
          <h2>{cur.t}</h2>
          <p class="quoi">{cur.q}</p>
          {#if cur.note}<p class="note">{cur.note}</p>{/if}
        </div>
        <div class="glyphe"><Glyphe n={cur.n} /></div>
      </div>
    {/key}
  {:else}
    <div class="fiche vue">
      <div class="texte">
        <span class="num">14</span>
        <span class="dt">du 3 septembre au 10 décembre</span>
        <h2>Quatorze séances, trois parties</h2>
        <p class="quoi">Décrire, relier, puis expliquer. Une semaine de lecture au milieu, une semaine de rencontres avant. Cliquez : une séance à la fois.</p>
      </div>
      <div class="glyphe"><Glyphe n={1} /></div>
    </div>
  {/if}
</div>

<style>
  .session { display: flex; flex-direction: column; gap: 0.6em; }
  .ligne { width: 100%; height: auto; display: block; }
  .rail { stroke: var(--dk-filet); stroke-width: 6; stroke-linecap: round; }
  .progres { fill: var(--dk-accent); transition: width 0.7s cubic-bezier(0.65, 0, 0.25, 1); }
  .lecture rect { fill: var(--dk-fond-2); stroke: var(--dk-filet); stroke-width: 2; }
  .lecture .lib { font-family: var(--dk-mono); font-size: 12px; letter-spacing: 0.12em; text-anchor: middle; fill: var(--dk-gris-2); }
  .noeud circle { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: r 0.4s, fill 0.4s, stroke 0.4s; }
  .noeud.p2 circle { stroke: var(--dk-gris); }
  .noeud.p3 circle { stroke: var(--dk-accent); }
  .noeud.p0 circle { stroke-dasharray: 5 4; }
  .noeud.fait circle { fill: var(--dk-encre); }
  .noeud.fait.p3 circle { fill: var(--dk-accent); }
  .noeud.on circle { fill: var(--dk-accent); stroke: var(--dk-accent); }
  .noeud .n { font-family: var(--dk-mono); font-size: 14px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); transition: font-size 0.4s, fill 0.4s; }
  .noeud.fait .n, .noeud.on .n { fill: var(--dk-fond); }
  .noeud.on .n { font-size: 22px; }
  .noeud .date { font-family: var(--dk-mono); font-size: 12px; text-anchor: middle; fill: var(--dk-gris); }
  .noeud.on .date { fill: var(--dk-accent); font-weight: 600; }
  .parties line { stroke-width: 5; stroke-linecap: round; }
  .parties .p1 { stroke: var(--dk-encre); } .parties .p2 { stroke: var(--dk-gris); } .parties .p3 { stroke: var(--dk-accent); }
  .pl { font-family: var(--dk-mono); font-size: 13px; letter-spacing: 0.1em; text-anchor: middle; fill: var(--dk-gris); }
  .fiche { display: grid; grid-template-columns: 1.25fr 1fr; gap: 2em; align-items: center; animation: entre 0.45s both; min-height: 15em; }
  @keyframes entre { from { opacity: 0; transform: translateY(0.6em); } to { opacity: 1; transform: none; } }
  .texte { display: flex; flex-direction: column; gap: 0.25em; }
  .num { font-family: var(--dk-mono); font-size: 3.6em; line-height: 1; font-weight: 600; color: var(--dk-accent); }
  .dt { font-size: 0.7em; letter-spacing: 0.14em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; }
  .texte h2 { margin: 0.1em 0 0.2em; font-size: 1.45em; line-height: 1.15; }
  .quoi { margin: 0; font-size: 1em; line-height: 1.45; max-width: 24em; }
  .note { margin: 0.4em 0 0; font-size: 0.78em; color: var(--dk-accent); font-weight: 600; }
  .glyphe { max-height: 40vh; }
  .glyphe :global(svg) { max-height: 40vh; width: 100%; height: auto; }
</style>
