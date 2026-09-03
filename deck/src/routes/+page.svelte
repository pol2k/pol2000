<script>
  /**
   * pol2000.com — la page du cours. Une seule page, dans la langue du deck:
   * bandeau, grand titre, ce qui compte cette semaine, la session, les
   * évaluations, les rencontres, Datacamp, l'équipe. Le moins de texte possible:
   * les titres, les dates, les figures. Le reste est dans le plan de cours.
   */
  import { base } from '$app/paths';
  import { COURS, LIENS } from '$lib/data/cours.js';
  import Bandeau from '$lib/site/Bandeau.svelte';
  import Semaine from '$lib/site/Semaine.svelte';
  import Frise from '$lib/site/Frise.svelte';
  import Evaluations from '$lib/site/Evaluations.svelte';
  import Rencontres from '$lib/site/Rencontres.svelte';
  import Datacamp from '$lib/site/Datacamp.svelte';
  import Equipe from '$lib/site/Equipe.svelte';
  import Pied from '$lib/site/Pied.svelte';

  const LIENS_NAV = [
    { href: '#seances', texte: 'Séances' },
    { href: '#evaluations', texte: 'Évaluations' },
    { href: '#rencontres', texte: 'Rencontres' },
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
    </div>
  </header>

  <section class="bloc" aria-labelledby="t-semaine">
    <h2 class="surtitre" id="t-semaine"><span class="n">00</span> Maintenant</h2>
    <Semaine />
  </section>

  <section class="bloc" id="seances" aria-labelledby="t-seances">
    <h2 class="surtitre" id="t-seances"><span class="n">01</span> La session</h2>
    <Frise />
  </section>

  <section class="bloc" id="evaluations" aria-labelledby="t-evaluations">
    <h2 class="surtitre" id="t-evaluations"><span class="n">02</span> Évaluations et remises</h2>
    <Evaluations />
  </section>

  <section class="bloc" id="rencontres" aria-labelledby="t-rencontres">
    <h2 class="surtitre" id="t-rencontres"><span class="n">03</span> Rencontres individuelles</h2>
    <Rencontres />
  </section>

  <section class="bloc" id="datacamp" aria-labelledby="t-datacamp">
    <h2 class="surtitre" id="t-datacamp"><span class="n">04</span> Exercices Datacamp</h2>
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
  .masthead { padding: clamp(48px, 10vh, 112px) 0 clamp(32px, 6vh, 64px); }
  .texte { display: flex; flex-direction: column; gap: 1.1rem; }
  .sur { font-size: 0.66rem; letter-spacing: 0.16em; text-transform: uppercase; color: var(--gris); }
  h1 { display: grid; font-size: clamp(2.6rem, 6.4vw, 5.4rem); line-height: 0.96; letter-spacing: -0.05em; }
  h1 span { display: block; }
  h1 .l2 { color: var(--accent); }
  .l1 { animation-delay: 0.05s; } .l2 { animation-delay: 0.13s; }
  .filet { animation-delay: 0.2s; }

  /* ---------- Sections ---------- */
  .bloc { margin-top: clamp(56px, 9vh, 104px); scroll-margin-top: 4rem; display: flex; flex-direction: column; gap: 1.4rem; }
  .bloc { gap: 1.8rem; }
</style>
