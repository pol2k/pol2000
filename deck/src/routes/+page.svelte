<script>
  /**
   * pol2000.com — la page du cours. Une seule page, dans la langue du deck:
   * bandeau, grand titre, la figure de l'arc, ce qui compte cette semaine,
   * la session, les évaluations, les outils, Datacamp, l'équipe.
   */
  import { base } from '$app/paths';
  import { COURS, LIENS } from '$lib/data/cours.js';
  import Bandeau from '$lib/site/Bandeau.svelte';
  import Arc from '$lib/site/Arc.svelte';
  import Semaine from '$lib/site/Semaine.svelte';
  import Frise from '$lib/site/Frise.svelte';
  import Evaluations from '$lib/site/Evaluations.svelte';
  import Outils from '$lib/site/Outils.svelte';
  import Datacamp from '$lib/site/Datacamp.svelte';
  import Equipe from '$lib/site/Equipe.svelte';
  import Pied from '$lib/site/Pied.svelte';

  const LIENS_NAV = [
    { href: '#seances', texte: 'Séances' },
    { href: '#evaluations', texte: 'Évaluations' },
    { href: '#outils', texte: 'Outils' },
    { href: '#datacamp', texte: 'Datacamp' },
    { href: '#equipe', texte: 'Équipe' },
    { href: `${base}/syllabus/`, texte: 'Plan de cours', phare: true }
  ];
  const DESCRIPTION = "POL-2000 Méthodologie quantitative, Université Laval, automne 2026. Décrire, relier, inférer, raisonner sur la causalité, avec R et Positron. Aucune mathématique au-delà du secondaire.";
</script>

<svelte:head>
  <title>POL-2000 · Méthodologie quantitative · Université Laval · Automne 2026</title>
  <meta name="description" content={DESCRIPTION} />
  <meta property="og:type" content="website" />
  <meta property="og:url" content={COURS.site} />
  <meta property="og:title" content="POL-2000 · Méthodologie quantitative" />
  <meta property="og:description" content={DESCRIPTION} />
  <meta property="og:image" content="{COURS.site}/img/pol2000_logo.svg" />
  <link rel="icon" type="image/svg+xml" href="{base}/img/pol2000_logo.svg" />
</svelte:head>

<Bandeau liens={LIENS_NAV} />

<main>
  <header class="masthead">
    <div class="texte">
      <p class="sur monte">Université Laval · Département de science politique · {COURS.session}</p>
      <h1>
        <span class="l1 monte">Méthodologie</span>
        <span class="l2 monte">quantitative</span>
      </h1>
      <hr class="filet monte" />
      <p class="lead monte">Décrire une variable. Relier deux variables. Tirer des conclusions sur une population à partir d'un échantillon. Raisonner sur la cause, et sur ses limites.</p>
      <p class="lead monte">Avec R et Positron, à partir de zéro. Aucune mathématique au-delà du secondaire.</p>
      <div class="faits monte">
        <span class="etiq encre">{COURS.sigle} · NRC {COURS.nrc}</span>
        <span class="etiq encre">{COURS.jour} {COURS.heures}</span>
        <span class="etiq encre">{COURS.pavillon} · {COURS.local}</span>
        <span class="etiq encre">{COURS.credits} crédits</span>
      </div>
      <div class="actions monte">
        <a class="bouton plein" href="#seances">La session <span class="fl">↓</span></a>
        <a class="bouton" href="{base}/syllabus/">Plan de cours <span class="fl">→</span></a>
        <a class="bouton" href="{LIENS.syllabusPdf}" rel="noopener">PDF</a>
      </div>
    </div>
    <div class="figure monte">
      <Arc />
    </div>
  </header>

  <section class="bloc" aria-labelledby="t-semaine">
    <h2 class="surtitre" id="t-semaine"><span class="n">00</span> Maintenant</h2>
    <Semaine />
  </section>

  <section class="bloc" id="seances" aria-labelledby="t-seances">
    <h2 class="surtitre" id="t-seances"><span class="n">01</span> La session</h2>
    <div class="entete">
      <h3 class="grand">Quatorze séances, trois parties.</h3>
      <p class="lead">Du 3 septembre au 10 décembre, le jeudi. Les diapositives paraissent ici au fil de la session.</p>
    </div>
    <Frise />
  </section>

  <section class="bloc" id="evaluations" aria-labelledby="t-evaluations">
    <h2 class="surtitre" id="t-evaluations"><span class="n">02</span> Les évaluations</h2>
    <div class="entete">
      <h3 class="grand">Trois examens, deux travaux, Datacamp.</h3>
      <p class="lead">Un seul projet de recherche, en deux temps : un devis à la mi-session, l'analyse complète à la fin. Les examens 2 et 3 s'écrivent en classe, sur papier, en fin de séance : le cours d'abord, une pause, puis une heure d'examen.</p>
    </div>
    <Evaluations />
  </section>

  <section class="bloc" id="outils" aria-labelledby="t-outils">
    <h2 class="surtitre" id="t-outils"><span class="n">03</span> Les outils</h2>
    <div class="entete">
      <h3 class="grand">R, Positron, Slack, et un livre.</h3>
      <p class="lead">Installez R et Positron avant la séance 2. Un blocage ? Écrivez avant le jeudi : un ordinateur qui ne marche pas en classe, c'est une séance perdue.</p>
    </div>
    <Outils />
  </section>

  <section class="bloc" id="datacamp" aria-labelledby="t-datacamp">
    <h2 class="surtitre" id="t-datacamp"><span class="n">04</span> Datacamp</h2>
    <div class="entete">
      <h3 class="grand">Un exercice par semaine, chez vous.</h3>
      <p class="lead">Gratuit pour le cours, corrigé sur-le-champ. Comme celui-ci.</p>
    </div>
    <Datacamp />
  </section>

  <section class="bloc" id="equipe" aria-labelledby="t-equipe">
    <h2 class="surtitre" id="t-equipe"><span class="n">05</span> L'équipe</h2>
    <Equipe />
  </section>
</main>

<Pied />

<style>
  main { max-width: var(--largeur); margin: 0 auto; padding: 0 var(--marge); }

  /* ---------- Masthead ---------- */
  .masthead { display: grid; grid-template-columns: minmax(0, 1.05fr) minmax(0, 1fr); gap: clamp(2rem, 5vw, 4.5rem); align-items: center; padding: clamp(40px, 8vh, 88px) 0 clamp(40px, 7vh, 72px); }
  .texte { display: flex; flex-direction: column; gap: 1.1rem; }
  .sur { font-size: 0.66rem; letter-spacing: 0.16em; text-transform: uppercase; color: var(--gris); }
  h1 { display: grid; font-size: clamp(2.6rem, 6.4vw, 5.4rem); line-height: 0.96; letter-spacing: -0.05em; }
  h1 span { display: block; }
  h1 .l2 { color: var(--accent); }
  .l1 { animation-delay: 0.05s; } .l2 { animation-delay: 0.13s; }
  .filet { animation-delay: 0.2s; }
  .lead { animation-delay: 0.28s; }
  .lead + .lead { animation-delay: 0.34s; color: var(--gris); }
  .faits { display: flex; flex-wrap: wrap; gap: 0.5rem 1.2rem; animation-delay: 0.4s; }
  .actions { display: flex; flex-wrap: wrap; gap: 0.7rem; margin-top: 0.4rem; animation-delay: 0.48s; }
  .figure { animation-delay: 0.3s; min-width: 0; }

  /* ---------- Sections ---------- */
  .bloc { margin-top: clamp(56px, 9vh, 104px); scroll-margin-top: 4rem; display: flex; flex-direction: column; gap: 1.4rem; }
  .entete { display: grid; grid-template-columns: minmax(0, 1fr) minmax(0, 1fr); gap: 1rem 3rem; align-items: end; }
  .grand { font-size: clamp(1.6rem, 3.2vw, 2.4rem); line-height: 1.05; letter-spacing: -0.04em; }
  .entete .lead { font-size: 0.95rem; color: var(--gris); }

  @media (max-width: 56rem) {
    .masthead { grid-template-columns: 1fr; }
    .entete { grid-template-columns: 1fr; }
  }
</style>
