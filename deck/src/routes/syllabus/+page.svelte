<script>
  import { base } from '$app/paths';
  import { COURS, LIENS } from '$lib/data/cours.js';
  import Bandeau from '$lib/site/Bandeau.svelte';
  import Pied from '$lib/site/Pied.svelte';

  let { data } = $props();
  const LIENS_NAV = [
    { href: `${base}/#seances`, texte: 'Séances' },
    { href: `${base}/#evaluations`, texte: 'Évaluations' },
    { href: `${base}/${LIENS.syllabusPdf}`, texte: 'PDF', phare: true }
  ];
</script>

<svelte:head>
  <title>Plan de cours · POL-2000 · Automne 2026</title>
  <meta name="description" content="Plan de cours POL-2000 Méthodologie quantitative, Université Laval, automne 2026." />
  <link rel="icon" type="image/svg+xml" href="{base}/img/pol2000_logo.svg" />
</svelte:head>

<Bandeau liens={LIENS_NAV} retour />

<main>
  <header class="tete">
    <p class="sur monte">{COURS.sigle} · {COURS.session} · NRC {COURS.nrc}</p>
    <h1 class="monte">Plan de cours</h1>
    <hr class="filet monte" />
    <p class="lead monte">{COURS.titre}. Université Laval, Faculté des sciences sociales, Département de science politique. Le {COURS.jour}, de {COURS.heures}, au {COURS.local}.</p>
    <div class="actions monte">
      <a class="bouton plein" href="{base}/{LIENS.syllabusPdf}" rel="noopener">Télécharger le PDF <span class="fl">↓</span></a>
      <a class="bouton" href="{base}/">Retour au site <span class="fl">→</span></a>
    </div>
  </header>

  <div class="corps">
    <nav class="sommaire" aria-label="Sommaire">
      <p class="etiq gris">Sommaire</p>
      <ol>
        {#each data.toc as t}<li><a href="#{t.id}">{t.text}</a></li>{/each}
      </ol>
    </nav>
    <article class="prose">
      {@html data.html}
    </article>
  </div>
</main>

<Pied />

<style>
  main { max-width: var(--largeur); margin: 0 auto; padding: 0 var(--marge); }
  .tete { display: flex; flex-direction: column; gap: 1rem; padding: clamp(36px, 7vh, 72px) 0 clamp(28px, 5vh, 48px); border-bottom: var(--trait); }
  .sur { font-size: 0.66rem; letter-spacing: 0.16em; text-transform: uppercase; color: var(--gris); }
  h1 { font-size: clamp(2.4rem, 6vw, 4.6rem); line-height: 0.96; letter-spacing: -0.05em; }
  .actions { display: flex; gap: 0.7rem; flex-wrap: wrap; margin-top: 0.4rem; }
  .corps { display: grid; grid-template-columns: 15rem minmax(0, 1fr); gap: 3rem; padding-top: 2rem; align-items: start; }
  .sommaire { position: sticky; top: 4rem; display: flex; flex-direction: column; gap: 0.6rem; }
  .sommaire ol { list-style: none; padding: 0; margin: 0; counter-reset: s; border-top: var(--trait); }
  .sommaire li { counter-increment: s; border-bottom: var(--trait-fin); }
  .sommaire a { display: grid; grid-template-columns: 1.6rem 1fr; gap: 0.4rem; padding: 0.5rem 0; font-size: 0.78rem; color: var(--encre); line-height: 1.3; }
  .sommaire a::before { content: counter(s, decimal-leading-zero); color: var(--accent); font-weight: 600; }
  .sommaire a:hover { color: var(--accent); text-decoration: none; }

  .prose { max-width: 46rem; font-size: 0.92rem; line-height: 1.65; }
  .prose :global(h2) { font-size: 1.55rem; margin: 2.6rem 0 0.9rem; padding-top: 1rem; border-top: var(--trait); scroll-margin-top: 4.5rem; }
  .prose :global(h2:first-child) { margin-top: 0; border-top: 0; padding-top: 0; }
  .prose :global(h3) { font-size: 1.1rem; margin: 1.8rem 0 0.5rem; scroll-margin-top: 4.5rem; }
  .prose :global(h4) { font-size: 0.92rem; margin: 1.4rem 0 0.4rem; color: var(--accent); scroll-margin-top: 4.5rem; }
  .prose :global(p) { margin: 0 0 0.9rem; }
  .prose :global(ul), .prose :global(ol) { margin: 0 0 0.9rem; padding-left: 0; list-style: none; }
  .prose :global(li) { padding-left: 1.4em; text-indent: -1.4em; margin-bottom: 0.3rem; }
  .prose :global(ul li::before) { content: '> '; color: var(--accent); font-weight: 600; }
  .prose :global(ol) { counter-reset: o; }
  .prose :global(ol li) { counter-increment: o; }
  .prose :global(ol li::before) { content: counter(o) '. '; color: var(--accent); font-weight: 600; }
  .prose :global(hr) { border: 0; height: 2px; background: var(--encre); margin: 2rem 0; }
  .prose :global(strong) { font-weight: 600; }
  .prose :global(em) { font-style: italic; }
  .prose :global(a) { color: var(--accent); }
  .prose :global(table) { width: 100%; border-collapse: collapse; margin: 0.6rem 0 1.2rem; font-size: 0.82rem; display: block; overflow-x: auto; }
  .prose :global(th) { text-align: left; font-weight: 500; font-size: 0.66rem; letter-spacing: 0.12em; text-transform: uppercase; color: var(--gris); border-top: var(--trait); border-bottom: 1px solid var(--gris-2); padding: 0.5rem 0.8rem 0.45rem 0; }
  .prose :global(td) { padding: 0.45rem 0.8rem 0.45rem 0; border-bottom: var(--trait-fin); vertical-align: top; }
  .prose :global(tr:last-child td) { border-bottom: 0; }
  .prose :global(thead:empty), .prose :global(th:empty) { display: none; }
  .prose :global(code) { background: var(--fond-2); padding: 0.05em 0.3em; font-size: 0.94em; }
  .prose :global(blockquote) { border-left: 0.34rem solid var(--accent); padding-left: 0.9rem; color: var(--gris); margin: 0 0 0.9rem; }

  @media (max-width: 52rem) {
    .corps { grid-template-columns: 1fr; gap: 1.5rem; }
    .sommaire { position: static; }
  }
</style>
