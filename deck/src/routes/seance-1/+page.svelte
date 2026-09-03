<script>
  /**
   * POL-2000 — Séance 1 · Introduction et les éléments fondamentaux de la recherche
   * Jeudi 3 septembre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine: moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine. Rien n'est inventé pour une figure —
   * les visuels sont schématiques et dits tels; les dates et pondérations
   * viennent du plan de cours A26. Le tableau de régression de l'ouverture
   * est vide, volontairement.
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Carte from '$lib/deck/Carte.svelte';
  import Deux from '$lib/deck/Deux.svelte';
  import Etiquette from '$lib/deck/Etiquette.svelte';
  import Grand from '$lib/deck/Grand.svelte';
  import Citation from '$lib/deck/Citation.svelte';
  import Code from '$lib/deck/Code.svelte';
  import Picto from '$lib/deck/Picto.svelte';
  import Revenu from '$lib/deck/visuels/Revenu.svelte';
  import Reponses from '$lib/deck/visuels/Reponses.svelte';
  import Regression from '$lib/deck/visuels/Regression.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import Evaluations from '$lib/deck/visuels/Evaluations.svelte';
  import Retard from '$lib/deck/visuels/Retard.svelte';
  import Examens from '$lib/deck/visuels/Examens.svelte';
  import IA from '$lib/deck/visuels/IA.svelte';
  import Materiel from '$lib/deck/visuels/Materiel.svelte';
  import Projet from '$lib/deck/visuels/Projet.svelte';
  import DatacampLight from '$lib/deck/visuels/DatacampLight.svelte';
  import Outils from '$lib/deck/visuels/Outils.svelte';
  import Tidy from '$lib/deck/visuels/Tidy.svelte';
  import Equipe from '$lib/deck/visuels/Equipe.svelte';
  import Entonnoir from '$lib/deck/visuels/Entonnoir.svelte';
  import XY from '$lib/deck/visuels/XY.svelte';
  import Unites from '$lib/deck/visuels/Unites.svelte';
  import Chaine from '$lib/deck/visuels/Chaine.svelte';
  import Fiche from '$lib/deck/visuels/Fiche.svelte';
  import Points from '$lib/deck/visuels/Points.svelte';
  import Niveaux from '$lib/deck/visuels/Niveaux.svelte';
  import Hypotheses from '$lib/deck/visuels/Hypotheses.svelte';
  import Varie from '$lib/deck/visuels/Varie.svelte';
  import Liens from '$lib/deck/visuels/Liens.svelte';
  import Raisons from '$lib/deck/visuels/Raisons.svelte';
  import Site from '$lib/deck/visuels/Site.svelte';

  const TOTAL = 46;
  const D = 'POL-2000 · séance 1 · jeu 3 sept';

  const c_verif = `R.version.string
# [1] "R version 4.x.x (2026-..-..)"

install.packages("tidyverse")
# ... beaucoup de texte, puis :
# * DONE (tidyverse)`;
</script>

<svelte:head>
  <title>POL-2000 · Séance 1 — Introduction et les éléments fondamentaux de la recherche</title>
</svelte:head>

<Deck total={TOTAL} logo="{base}/img/ulaval-logo.png">
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->
    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre">
        <p class="surtitre e">POL-2000 · Méthodologie quantitative</p>
        <h1 class="e">Introduction et les éléments fondamentaux de la recherche</h1>
        <hr class="filet" />
        <p class="lead e">Séance 1 · jeudi 3 septembre 2026</p>
      </div>
      <!-- La marque ne se recolore pas: on lui donne son propre sol, une bande
           claire en pied de diapo, comme un en-tête de lettre. -->
      <div class="entete-ul e">
        <img src="{base}/img/ulaval-logo.png" alt="Université Laval" />
        <span class="sep"></span>
        <span class="dept">Département de science politique<br />Faculté des sciences sociales</span>
        <span class="session">Automne 2026</span>
      </div>
    </Slide>

    <Slide bandeau="À propos de moi" droite={D}>
      <Deux ratio="1.85fr 1fr">
        <div>
          <h2 class="e">À propos de moi</h2>
          <p class="lead e">Laurence-Olivier M. Foisy</p>
          <hr class="filet" />
          <ul class="cmd-liste e">
            <li>Enseignement du parcours L'intelligence artificielle et la recherche<span class="lieu">Université Laval · EIOM 2026</span></li>
            <li>Enseignement du cours Introduction aux mégadonnées en sciences sociales<span class="lieu">Université de Montréal · FAS-1001</span></li>
            <li>Doctorat en science politique, en cours<span class="lieu">Université Laval</span></li>
            <li>Maîtrise en études de la paix internationale<span class="lieu">Université Soka, Japon</span></li>
            <li>Baccalauréat en études est-asiatiques<span class="lieu">Université de Montréal</span></li>
          </ul>
          <p class="e" style="margin-top: 1em"><code>mail@mfoisy.com</code> — deux semaines. Ensuite, Slack.</p>
        </div>
        <figure class="portrait">
          <img src="{base}/img/portrait-lomf.jpg" alt="Portrait de Laurence-Olivier M. Foisy" />
        </figure>
      </Deux>
    </Slide>

    <Slide bandeau="Un tour de salle" droite={D}>
      <h2 class="e">À main levée</h2>
      <ol class="mains e">
        <li><span>Un cours de statistiques au cégep ?</span></li>
        <li><span>Une ligne de code, n'importe laquelle ?</span></li>
        <li><span>Qui paye pour un abonnement IA ?</span></li>
        <li><span>Ce cours vous fait peur ?</span></li>
      </ol>
    </Slide>

    <!-- ================= 0 · POURQUOI ================= -->
    <Slide fond="encre" bandeau="Pourquoi ce cours" droite={D}>
      <p class="surtitre e">La vraie question</p>
      <h1 class="e">« Pourquoi est-ce que je suis obligé de suivre ce maudit cours là ? »</h1>
      <hr class="filet" />
      <p class="lead e">« Je ne veux même pas faire de recherche. »</p>
    </Slide>

    <Slide bandeau="Pourquoi ce cours" droite={D}>
      <h2 class="e">Onze réponses</h2>
      <Raisons />
    </Slide>

    <!-- ================= 0b · AU CLESSN ================= -->
    <Slide bandeau="La CLESSN" droite={D}>
      <div class="clessn e">
        <img src="{base}/img/logo_clessn.png" alt="CLESSN" />
        <div>
          <p class="surtitre">Ce qu'on fait avec ça, concrètement</p>
          <h1>La CLESSN</h1>
          <hr class="filet" />
          <p class="lead">Chaire de leadership en enseignement des sciences sociales numériques · Université Laval</p>
          <p class="lead">Trois projets en ligne, en ce moment.</p>
        </div>
      </div>
    </Slide>

    <Slide fond="plein" bandeau="La CLESSN" droite={D}>
      <Site plein url="https://quebec.datagotchi.com" titre="Datagotchi" sous="Québec 2026 · un sondage illustré qui prédit votre vote d'après vos habitudes de vie" capture="site-datagotchi.png" />
    </Slide>

    <Slide fond="plein" bandeau="La CLESSN" droite={D}>
      <Site plein url="https://vitrinedemocratique.com" titre="La Vitrine démocratique" sous="avec le CAPP · médias et discours politiques du Québec, analysés six fois par jour" capture="site-vitrine.png" />
    </Slide>

    <Slide fond="plein" bandeau="La CLESSN" droite={D}>
      <Site plein url="https://prof-datagotchi.com" titre="Prof. Datagotchi" sous="un assistant fondé sur 153 entrevues des cinq partis — mot pour mot, horodatage à l'appui" capture="site-prof-datagotchi.png" />
    </Slide>

    <!-- ================= 1 · UNE QUESTION ================= -->

    <Slide bandeau="Une question" droite={D}>
      <h2 class="e">Le revenu influence-t-il le vote ?</h2>
      <Revenu />
    </Slide>

    <Slide bandeau="Une question" droite={D}>
      <h2 class="e">Comment le saurait-on ?</h2>
      <Reponses />
    </Slide>

    <Slide fond="plein" bandeau="Une question" droite={D}>
      <figure class="capture plein e">
        <img src="{base}/img/ces-viewer.png" alt="Les premières lignes de l'Étude électorale canadienne 2025, telles qu'elles apparaissent dans un visualiseur de données : âge, scolarité, revenu, intention de vote." />
        <figcaption>Compter : l'Étude électorale canadienne 2025 · 20 180 répondant.e.s · 1 440 colonnes, dont ces quatre</figcaption>
      </figure>
    </Slide>

    <Slide bandeau="Une question" droite={D}>
      <h2 class="e">Une ligne de R</h2>
      <p class="lead e">Pas de panique : vous n'avez pas à faire le calcul. Seulement à savoir que la fonction existe.</p>
      <Regression />
    </Slide>

    <!-- ================= 3 · LE PLAN DE COURS ================= -->
    <Slide fond="encre" bandeau="Le plan de cours" droite={D}>
      <h1 class="e">Le plan de cours</h1>
      <hr class="filet" />
      <p class="lead e"><code>pol2000.com/syllabus</code></p>
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Session />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Les évaluations</h2>
      <Evaluations />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Les examens : sur papier</h2>
      <Examens />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Un seul projet, en deux temps</h2>
      <Projet />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Datacamp</h2>
      <DatacampLight />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Un retard</h2>
      <Retard />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">L'intelligence artificielle</h2>
      <IA />
    </Slide>

    <Slide bandeau="Le matériel" droite={D}>
      <h2 class="e">Positron</h2>
      <Outils quoi="positron" />
    </Slide>

    <Slide bandeau="Le matériel" droite={D}>
      <h2 class="e">L'ordinateur</h2>
      <Outils quoi="ordi" />
    </Slide>

    <Slide bandeau="Le matériel" droite={D}>
      <h2 class="e">Slack</h2>
      <Outils quoi="slack" />
    </Slide>

    <Slide bandeau="Le matériel" droite={D}>
      <h2 class="e">Le livre</h2>
      <Materiel quoi="livre" />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">L'équipe</h2>
      <Equipe />
    </Slide>

    <Slide fond="encre" bandeau="Le plan de cours" droite={D}>
      <div class="enreg e">
        <svg viewBox="0 0 120 80" class="camera" aria-hidden="true">
          <rect x="8" y="22" width="70" height="44" rx="4" /><path d="M 78 36 L 110 24 L 110 64 L 78 52 Z" /><circle cx="43" cy="44" r="12" class="obj" />
          <line x1="6" y1="8" x2="114" y2="76" class="barre" />
        </svg>
        <p class="l1">Ce cours n'est pas enregistré.</p>
        <p class="l2">Il se donne ici, le jeudi, à 15h30.</p>
        <p class="l3">La version en ligne, asynchrone, existe — <strong>à l'hiver</strong>.</p>
      </div>
    </Slide>

    <Slide fond="encre" bandeau="Le plan de cours" droite={D}>
      <h1 class="e">Des objections ?</h1>
      <hr class="filet" />
      <p class="lead e">C'est maintenant.</p>
    </Slide>

    <!-- ================= PAUSE ================= -->
    <Slide fond="encre" bandeau="Pause" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <p class="lead e">Quinze minutes.</p>
    </Slide>

    <!-- ================= 4 · LES ÉLÉMENTS FONDAMENTAUX ================= -->
    <Slide fond="encre" bandeau="Les éléments fondamentaux" droite={D}>
      <h1 class="e">Les éléments fondamentaux</h1>
      <hr class="filet" />
      <p class="lead e">Le vocabulaire d'ici décembre.</p>
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">De la curiosité à la question</h2>
      <Entonnoir />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">X, et Y</h2>
      <XY />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <Varie />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">Population, échantillon</h2>
      <Points />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">Des données bien rangées</h2>
      <Tidy />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">Une ligne, c'est quoi ?</h2>
      <Unites />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">Ce que les chiffres permettent</h2>
      <Niveaux />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">L'hypothèse, et sa nulle</h2>
      <Hypotheses />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">Opérationnaliser</h2>
      <Chaine />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">La fiche</h2>
      <Fiche mode="remplie" />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">À vous</h2>
      <Fiche mode="vide" />
    </Slide>

    <!-- ================= 5 · AVANT JEUDI PROCHAIN ================= -->
    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Avant jeudi prochain</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Avant jeudi prochain" droite={D}>
      <h2 class="e">R et Positron : lequel fait quoi ?</h2>
      <Outils quoi="rvs" />
    </Slide>

    <Slide bandeau="Avant jeudi prochain" droite={D}>
      <h2 class="e">Trois liens</h2>
      <Liens />
      <p class="lead e">Un blocage ? Écrivez <strong>avant</strong> jeudi. Un ordinateur qui ne marche pas à la séance 2, c'est une séance perdue.</p>
    </Slide>

    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Jeudi prochain</h1>
      <hr class="filet" />
      <p class="lead e">R et Positron, à partir de zéro.</p>
      <p class="lead e">Apportez l'ordinateur. <strong>Installé.</strong></p>
    </Slide>

    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre merci">
        <h1 class="e">Merci.</h1>
        <hr class="filet" />
        <p class="lead e">Des questions ? Maintenant, ou sur Slack.</p>
        <p class="lead e"><code>pol2000.com</code></p>
      </div>
      <div class="entete-ul e">
        <img src="{base}/img/ulaval-logo.png" alt="Université Laval" />
        <span class="sep"></span>
        <span class="dept">Département de science politique<br />Faculté des sciences sociales</span>
        <span class="session">POL-2000 · Automne 2026</span>
      </div>
    </Slide>

  {/snippet}
</Deck>

<style>
  /* Bande d'identité en pied du titre: sol clair pour la marque, séparateur
     rouge, département en petites capitales. */
  .titre { padding-bottom: 5.2em; }
  .clessn { display: grid; grid-template-columns: auto 1fr; gap: 2.2em; align-items: center; }
  .clessn img { width: 13em; height: auto; }
  .clessn h1 { margin: 0.1em 0 0.2em; }
  .merci h1 { font-size: 3.4em; }
  .entete-ul { position: absolute; left: 0; right: 0; bottom: 0; display: flex; align-items: center; gap: 1.2em;
    background: #fff; color: var(--dk-encre); padding: 0.8em 2.6em 0.8em 2.6em; border-top: 6px solid var(--dk-accent); }
  .entete-ul img { height: 2.6em; width: auto; display: block; }
  .entete-ul .sep { width: 2px; align-self: stretch; background: var(--dk-encre); }
  .entete-ul .dept { font-size: 0.62em; letter-spacing: 0.12em; text-transform: uppercase; line-height: 1.45; font-weight: 600; }
  .entete-ul .session { margin-left: auto; font-size: 0.72em; letter-spacing: 0.16em; text-transform: uppercase; color: var(--dk-accent); font-weight: 600; }
  .capture { margin: 0; }
  .capture img { display: block; width: 100%; height: auto; border: 2px solid var(--dk-encre); }
  .capture figcaption { margin-top: 0.4em; font-size: 0.7em; color: var(--dk-gris); }
  .capture.plein { display: flex; flex-direction: column; height: 100%; }
  .capture.plein img { flex: 1; min-height: 0; object-fit: contain; object-position: top; }
  .capture.plein figcaption { font-size: 0.85em; color: var(--dk-encre); padding: 0.3em 0; }
  .trois { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.9em; align-items: stretch; }
  .etiqs { display: flex; flex-wrap: wrap; gap: 0.6em; font-size: 1.15em; }
  .pale { color: var(--dk-gris); }
  .centre { text-align: center; max-width: none; }
  :global(.carte-d.accent) { border-color: var(--dk-accent); }
  :global(.carte-d.accent h4) { color: var(--dk-accent); }
  :global(.qs-num li) { font-size: 1.5em; }

  /* Qui suis-je: trois étapes. */
  .frise-moi { display: grid; grid-template-columns: 1fr auto 1fr auto 1fr; gap: 0.8em; align-items: stretch; margin-bottom: 1em; }
  .frise-moi > div:not(.fl) { border: 2px solid var(--dk-filet); padding: 0.7em 0.9em; display: flex; flex-direction: column; gap: 0.2em; }
  .frise-moi .ici { border: 3px solid var(--dk-accent); }
  .frise-moi .an { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .frise-moi strong { font-size: 1.15em; }
  .frise-moi span:last-child { font-size: 0.75em; color: var(--dk-gris); }
  .fl { align-self: center; font-size: 2em; color: var(--dk-accent); }

  /* À main levée: quatre questions, très grandes. */
  .mains { list-style: none; padding: 0; margin: 0; counter-reset: m; display: flex; flex-direction: column; gap: 0.5em; }
  .mains li { counter-increment: m; display: grid; grid-template-columns: 1.4em 1fr; gap: 0.6em; align-items: baseline; font-size: 1.7em; line-height: 1.25; }
  .mains li::before { content: counter(m); color: var(--dk-accent); font-weight: 600; }

  /* Tableau vide. */
  .tableau-vide td:not(:first-child) { text-align: center; color: var(--dk-gris-2); font-weight: 600; font-size: 1.3em; }

  /* Peurs. */
  .peurs { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; }
  .peur { display: flex; flex-direction: column; gap: 0.3em; border: 2px solid var(--dk-encre); padding: 0.7em 0.8em; }
  .glyphe { font-family: var(--dk-mono); font-size: 2.2em; line-height: 1; color: var(--dk-gris-2); margin-bottom: 0.3em; }
  .glyphe.barre { text-decoration: line-through; text-decoration-color: var(--dk-accent); text-decoration-thickness: 4px; }
  .glyphe s { text-decoration-color: var(--dk-accent); text-decoration-thickness: 4px; }
  .glyphe strong { color: var(--dk-accent); }
  .fix { font-size: 1.1em; font-weight: 600; }
  .peur small { font-size: 0.72em; color: var(--dk-gris); }

  /* Quatre pictos. */
  .quatre, .unites { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1em; }
  .quatre > div, .unites > div { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.35em; border: 2px solid var(--dk-encre); padding: 1em 0.6em; }
  .quatre strong, .unites strong { font-size: 1em; }
  .quatre span, .unites span:not(.glyphe-u) { font-size: 0.72em; color: var(--dk-gris); }
  .glyphe-u { font-size: 2.4em; line-height: 1; color: var(--dk-encre); }

  /* Un projet en deux temps. */
  .croissance { display: grid; grid-template-columns: 1fr auto 1.4fr; gap: 1em; align-items: end; }
  .doc { border: 2px solid var(--dk-encre); padding: 0.7em 0.9em; }
  .grand-doc { border: 3px solid var(--dk-accent); }
  .doc .et { display: block; font-size: 0.58em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); margin-bottom: 0.4em; }
  .doc .et.acc { color: var(--dk-accent); }
  .doc ul { margin: 0; padding: 0; list-style: none; }
  .doc li { font-size: 0.85em; line-height: 1.5; }
  .doc li.plus { color: var(--dk-accent); font-weight: 600; }

  /* Datacamp: quatorze semaines. */
  .dc .semaines { display: flex; gap: 0.35em; }
  .dc .semaines i { flex: 1; height: 1.4em; background: var(--dk-gris-2); }
  .dc .semaines i.jalon { background: var(--dk-accent); }
  .dc .jalons { display: flex; justify-content: space-between; font-size: 0.65em; color: var(--dk-accent); font-weight: 600; margin: 0.25em 0 0.6em; padding-left: 47%; }
  .dc p { font-size: 0.95em; }

  /* IA: trois feux. */
  .feux { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; margin-bottom: 0.8em; }
  .feu { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.2em; padding: 0.9em 0.6em; border: 2px solid var(--dk-encre); }
  .feu .signe { font-family: var(--dk-mono); font-size: 3em; line-height: 1; font-weight: 600; }
  .feu.ok .signe { color: var(--dk-encre); }
  .feu.non { border-color: var(--dk-accent); border-width: 3px; }
  .feu.non .signe { color: var(--dk-accent); }
  .feu.selon .signe { color: var(--dk-gris); }
  .feu small { font-size: 0.72em; color: var(--dk-gris); }

  /* Matériel. */
  .materiel { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1em; }
  .item { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.4em; border: 2px solid var(--dk-encre); padding: 1em 0.6em; justify-content: flex-end; }
  .grosR { font-family: var(--dk-mono); font-size: 3.4em; line-height: 1; font-weight: 600; color: var(--dk-accent); }
  .grosP { font-family: var(--dk-mono); font-size: 1.4em; line-height: 1; font-weight: 600; padding: 0.5em 0.4em; border: 3px solid var(--dk-encre); }
  .couv { display: flex; align-items: center; justify-content: center; text-align: center; width: 4.2em; height: 5.4em; border: 3px solid var(--dk-encre); font-size: 0.62em; font-weight: 600; line-height: 1.3; }
  .item small { font-size: 0.68em; color: var(--dk-gris); }
  .item strong { font-size: 0.9em; }

  /* Enregistrement: une caméra barrée, trois lignes. */
  .enreg { display: flex; flex-direction: column; align-items: flex-start; gap: 0.5em; }
  .camera { width: 6em; height: auto; margin-bottom: 0.6em; }
  .camera rect, .camera path { fill: none; stroke: var(--dk-fond); stroke-width: 4; stroke-linejoin: round; }
  .camera .obj { fill: none; stroke: var(--dk-fond); stroke-width: 3; }
  .camera .barre { stroke: var(--dk-accent); stroke-width: 6; stroke-linecap: round; }
  .enreg p { margin: 0; }
  .l1 { font-size: 2em; font-weight: 600; line-height: 1.15; }
  .l2 { font-size: 1.2em; }
  .l3 { font-size: 1.2em; opacity: 0.85; }
  .l3 strong { color: var(--dk-accent-clair); }
  /* Deux grands, sur encre. */
  .deuxgrands { display: grid; grid-template-columns: 1fr 1fr; gap: 2em; }
  .deuxgrands > div { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.3em; }
  .deuxgrands .signe { font-family: var(--dk-mono); font-size: 5em; line-height: 1; font-weight: 600; color: var(--dk-accent-clair); }
  .deuxgrands .signe.non { color: var(--dk-accent); }
  .deuxgrands strong { font-size: 1.8em; }
  .deuxgrands small { font-size: 0.85em; opacity: 0.8; }

  /* X → Y. */
  .xy { display: grid; grid-template-columns: 1fr auto 1fr; gap: 1.2em; align-items: center; margin: 0.6em 0 1em; }
  .xy > div:not(.fl) { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.15em; border: 3px solid var(--dk-encre); padding: 1em; }
  .xy .y { border-color: var(--dk-accent); }
  .xy .lettre { font-family: var(--dk-mono); font-size: 5em; line-height: 1; font-weight: 600; }
  .xy .y .lettre { color: var(--dk-accent); }
  .xy strong { font-size: 1.2em; }
  .xy small { font-size: 0.75em; color: var(--dk-gris); }
  .xy em { font-size: 0.85em; color: var(--dk-accent); font-style: normal; font-weight: 600; margin-top: 0.3em; }
  .xy .fl { font-size: 4em; }

  /* Chaîne concept → mesure. */
  .chaine { display: grid; grid-template-columns: 1fr auto 1fr auto 1fr; gap: 0.6em; align-items: stretch; margin: 0.6em 0 0.9em; }
  .chaine > div:not(.fl) { border: 2px solid var(--dk-filet); padding: 0.7em 0.9em; display: flex; flex-direction: column; gap: 0.35em; }
  .chaine > div:last-child { border-color: var(--dk-accent); border-width: 3px; }
  .chaine .et { font-size: 0.58em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .chaine strong { font-size: 1.05em; }
  .chaine .fl { font-size: 1.8em; }

  /* La fiche. */
  .fiche { border: 2px solid var(--dk-filet); padding: 0.8em 1em; }
  .fiche.pleine { border: 3px solid var(--dk-accent); }
  .fiche dl { display: grid; grid-template-columns: auto 1fr; gap: 0.35em 1em; margin: 0; font-size: 0.85em; }
  .fiche dt { color: var(--dk-gris); font-weight: 600; white-space: nowrap; }
  .fiche dd { margin: 0; }
  .fiche.vide dd { color: var(--dk-gris-2); }
  .fiche.grande dl { font-size: 1.05em; gap: 0.7em 1.2em; }
  .fiche.grande dd { border-bottom: 2px dotted var(--dk-filet); min-height: 1.4em; }

  /* Bonus. */
  .bonus { display: flex; flex-direction: column; gap: 0.6em; justify-content: center; }
  .bonus p { font-size: 0.9em; margin: 0; }

  /* Trois liens. */
  .liens { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; margin-bottom: 1em; }
  .liens > div { border: 2px solid var(--dk-encre); padding: 1em 0.9em; display: flex; flex-direction: column; gap: 0.25em; }
  .liens strong { font-size: 1.3em; }
  .liens span { font-size: 0.75em; color: var(--dk-gris); }
</style>
