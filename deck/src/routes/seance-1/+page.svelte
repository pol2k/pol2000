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
  import Seance from '$lib/deck/visuels/Seance.svelte';
  import Evaluations from '$lib/deck/visuels/Evaluations.svelte';
  import Retard from '$lib/deck/visuels/Retard.svelte';
  import Examens from '$lib/deck/visuels/Examens.svelte';
  import Projet from '$lib/deck/visuels/Projet.svelte';
  import Datacamp from '$lib/deck/visuels/Datacamp.svelte';
  import Equipe from '$lib/deck/visuels/Equipe.svelte';
  import Entonnoir from '$lib/deck/visuels/Entonnoir.svelte';
  import Points from '$lib/deck/visuels/Points.svelte';
  import Niveaux from '$lib/deck/visuels/Niveaux.svelte';
  import Hypotheses from '$lib/deck/visuels/Hypotheses.svelte';
  import Varie from '$lib/deck/visuels/Varie.svelte';
  import Ordre from '$lib/deck/visuels/Ordre.svelte';

  const TOTAL = 48;
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
            <li>Enseignement du parcours <em>L'intelligence artificielle et la recherche</em><span class="lieu">Université Laval · EIOM 2026</span></li>
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

    <!-- ================= 1 · UNE QUESTION ================= -->

    <Slide bandeau="Une question" droite={D}>
      <h2 class="e">Le revenu affecte-t-il l'idéologie politique ?</h2>
      <Revenu />
    </Slide>

    <Slide bandeau="Une question" droite={D}>
      <h2 class="e">Comment le saurait-on ?</h2>
      <Reponses />
    </Slide>

    <Slide bandeau="Une question" droite={D}>
      <h2 class="e">Compter : 20 180 personnes, deux colonnes</h2>
      <figure class="capture e">
        <img src="{base}/img/ces-viewer.png" alt="Les premières lignes de l'Étude électorale canadienne 2025, telles qu'elles apparaissent dans un visualiseur de données : âge, scolarité, revenu, placement gauche-droite." />
        <figcaption>Étude électorale canadienne 2025 · 20 180 répondant.e.s · 1 440 colonnes, dont ces quatre</figcaption>
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
      <Seance n={1} titre="Introduction et les éléments fondamentaux de la recherche" date="jeudi 3 septembre" quoi="Une question, les mots pour la poser, et ce qu'il faut installer." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={2} titre="Introduction à R et à Positron" date="jeudi 10 septembre" quoi="R à partir de zéro, en direct, sur votre ordinateur." note="Apportez l'ordinateur — installé." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={3} titre="Les statistiques descriptives et la visualisation des données" date="jeudi 17 septembre" quoi="Décrire une variable : la forme d'une distribution, son centre, sa dispersion. Et la dessiner." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={4} titre="Préparer ses données avec R" date="jeudi 24 septembre" quoi="Lire un codebook, recoder, gérer les valeurs manquantes. Le vrai travail." note="L'examen 1 ouvre aujourd'hui." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={5} titre="L'inférence statistique" date="jeudi 1er octobre" quoi="Ce que je vois dans un échantillon, puis-je le dire de toute la population ?" note="Examen 1 à remettre dimanche 4 octobre." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={6} titre="Rencontres individuelles" date="jeudi 8 octobre" quoi="Pas de cours magistral : on se voit, un.e à la fois, avec les auxiliaires et le tuteur." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={7} titre="La régression linéaire simple" date="jeudi 15 octobre" quoi="Une droite qui résume une relation — et ce que ses chiffres veulent dire." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={8} titre="Examen 2, puis atelier de mi-session" date="jeudi 22 octobre" quoi="Une heure d'examen sur papier, puis on travaille votre devis, ensemble." note="Mi-session à remettre dimanche 25 octobre." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={9} titre="La régression linéaire multiple" date="jeudi 5 novembre" quoi="Plusieurs variables explicatives à la fois. Ce que « contrôler pour » veut dire." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={10} titre="De la question au tableau de régression : à la main, puis avec l'IA" date="jeudi 12 novembre" quoi="Le travail final, du début à la fin. D'abord vous, puis un agent d'IA — et on le vérifie." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={11} titre="Les graphes orientés acycliques (GOA)" date="jeudi 19 novembre" quoi="Dessiner ses hypothèses causales. Décider quoi contrôler — ou pas." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={12} titre="Le problème fondamental de l'inférence causale" date="jeudi 26 novembre" quoi="On ne voit jamais les deux mondes à la fois. Tout part de là." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={13} titre="Les biais" date="jeudi 3 décembre" quoi="Variable omise, sélection, mesure, simultanéité : ce qui fausse une régression." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <Seance n={14} titre="Les expériences, et révision" date="jeudi 10 décembre" quoi="Le hasard comme méthode. Puis on revoit tout." note="Examen 3 en classe · travail final vendredi 18 décembre." />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Les évaluations</h2>
      <Evaluations />
    </Slide>




    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Les examens : sur papier, exprès</h2>
      <Examens />
      <p class="e">Les modèles de langue ne passent pas l'examen à votre place. Vos notes, oui. L'IA, c'est pour les travaux.</p>
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Un seul projet, en deux temps</h2>
      <Projet />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Datacamp</h2>
      <Datacamp />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Un retard</h2>
      <Retard />
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">L'intelligence artificielle</h2>
      <div class="feux e">
        <div class="feu ok"><span class="signe">✓</span><strong>Le code R</strong><small>permis, si déclaré</small></div>
        <div class="feu non"><span class="signe">✗</span><strong>L'interprétation. La rédaction.</strong><small>jamais</small></div>
        <div class="feu selon"><span class="signe">≈</span><strong>Chaque évaluation</strong><small>ses propres consignes</small></div>
      </div>
      <Citation source="La question, chaque fois">L'aurais-je accepté d'un assistant humain sans vérifier son travail ?</Citation>
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">Matériel</h2>
      <div class="materiel e">
        <div class="item"><span class="grosR">R</span><strong>gratuit</strong></div>
        <div class="item"><span class="grosP">Positron</span><strong>gratuit</strong></div>
        <div class="item"><Picto nom="terminal" taille="2.8em" /><strong>votre portable</strong></div>
        <div class="item livre"><span class="couv">Arel-Bundock<br />2021</span><strong>référence, gratuit en PDF</strong><small>rien d'obligatoire à lire</small></div>
      </div>
    </Slide>

    <Slide bandeau="Le plan de cours" droite={D}>
      <h2 class="e">L'équipe</h2>
      <Equipe />
      <p class="e">Rencontres individuelles le <strong>8 octobre</strong>. Rendez-vous : <code>pol2000.com</code>.</p>
    </Slide>

    <Slide fond="encre" bandeau="Le plan de cours" droite={D}>
      <div class="deuxgrands e">
        <div><span class="signe non">✗</span><strong>Enregistrement</strong><small>ce cours se donne ici</small></div>
        <div><span class="signe">↻</span><strong>Hiver</strong><small>la version en ligne, asynchrone</small></div>
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
      <div class="xy e">
        <div class="x"><span class="lettre">X</span><strong>indépendante</strong><small>ce qui explique</small><em>l'âge</em></div>
        <div class="fl">→</div>
        <div class="y"><span class="lettre">Y</span><strong>dépendante</strong><small>ce qu'on explique</small><em>voter</em></div>
      </div>
      <p class="lead e centre">Une question de recherche, c'est au minimum un X et un Y.</p>
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">Une variable varie</h2>
      <Varie />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">Population, échantillon</h2>
      <Points />
      <p class="e">Ce que je vois ici, puis-je le dire de tout ça ? <span class="pale">Séance 5.</span></p>
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">Une ligne, c'est quoi ?</h2>
      <div class="unites e">
        <div><Picto nom="humain" taille="2.4em" /><strong>une personne</strong><span>a voté, ou non</span></div>
        <div><span class="glyphe-u">◯</span><strong>un pays, une année</strong><span>indice de démocratie</span></div>
        <div><span class="glyphe-u">▣</span><strong>un parti, une élection</strong><span>part des voix</span></div>
        <div><span class="glyphe-u">❝</span><strong>un discours, un tweet</strong><span>ton positif ou négatif</span></div>
      </div>
      <p class="e">L'unité d'analyse. On ne les mélange pas — et aucun logiciel ne vous le dira.</p>
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">Ce que les chiffres permettent</h2>
      <Niveaux />
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">L'hypothèse, et sa nulle</h2>
      <Hypotheses />
      <p class="e">On ne prouve jamais H₁. On demande aux données de <strong>rejeter H₀</strong>.</p>
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">Opérationnaliser</h2>
      <div class="chaine e">
        <div><span class="et">CONCEPT</span><strong>« Être à gauche »</strong></div>
        <div class="fl">→</div>
        <div><span class="et">DÉFINITION</span><strong>Se situer soi-même sur un axe</strong></div>
        <div class="fl">→</div>
        <div><span class="et">MESURE</span><strong>0 ······ 5 ······ 10</strong></div>
      </div>
      <p class="lead e">Chaque flèche perd quelque chose.</p>
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">La fiche</h2>
      <Deux>
        <div class="fiche vide">
          <dl>
            <dt>Question</dt><dd>—</dd>
            <dt>Y</dt><dd>—</dd>
            <dt>X</dt><dd>—</dd>
            <dt>Population</dt><dd>—</dd>
            <dt>Unité</dt><dd>—</dd>
            <dt>Mesure</dt><dd>—</dd>
            <dt>H₁ · H₀</dt><dd>—</dd>
          </dl>
        </div>
        <div class="fiche pleine">
          <dl>
            <dt>Question</dt><dd>L'éducation rend-elle plus à gauche ?</dd>
            <dt>Y</dt><dd>placement gauche-droite</dd>
            <dt>X</dt><dd>scolarité</dd>
            <dt>Population</dt><dd>électeur.rice.s, Canada, 2025</dd>
            <dt>Unité</dt><dd>la personne sondée</dd>
            <dt>Mesure</dt><dd>Y : 0–10 · X : ordinal</dd>
            <dt>H₁ · H₀</dt><dd>plus scolarisé, plus à gauche · aucune relation</dd>
          </dl>
        </div>
      </Deux>
      <p class="lead e">Votre mi-session, c'est la fiche de droite.</p>
    </Slide>

    <Slide bandeau="Les éléments fondamentaux" droite={D}>
      <h2 class="e">À vous</h2>
      <p class="lead e">Une question de recherche. On remplit la fiche ensemble.</p>
      <div class="fiche pleine e grande">
        <dl>
          <dt>Question</dt><dd>&nbsp;</dd>
          <dt>Y</dt><dd>&nbsp;</dd>
          <dt>X</dt><dd>&nbsp;</dd>
          <dt>Population · unité</dt><dd>&nbsp;</dd>
          <dt>Mesure</dt><dd>&nbsp;</dd>
          <dt>H₁ · H₀</dt><dd>&nbsp;</dd>
        </dl>
      </div>
    </Slide>

    <!-- ================= 5 · AVANT JEUDI PROCHAIN ================= -->
    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Avant jeudi prochain</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Avant jeudi prochain" droite={D}>
      <h2 class="e">Dans cet ordre</h2>
      <Ordre />
    </Slide>

    <Slide bandeau="Avant jeudi prochain" droite={D}>
      <h2 class="e">Trois liens</h2>
      <div class="liens e">
        <div><strong>Slack</strong><span>l'invitation arrive par courriel</span></div>
        <div><strong>Datacamp</strong><span>idem · premier devoir en semaine 2</span></div>
        <div><strong>pol2000.com</strong><span>plan, calendrier, diapositives</span></div>
      </div>
      <p class="lead e">Un blocage ? Écrivez <strong>avant</strong> jeudi.</p>
    </Slide>

    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Jeudi prochain</h1>
      <hr class="filet" />
      <p class="lead e">R et Positron, à partir de zéro.</p>
      <p class="lead e">Apportez l'ordinateur. <strong>Installé.</strong></p>
    </Slide>

  {/snippet}
</Deck>

<style>
  /* Bande d'identité en pied du titre: sol clair pour la marque, séparateur
     rouge, département en petites capitales. */
  .titre { padding-bottom: 5.2em; }
  .entete-ul { position: absolute; left: 0; right: 0; bottom: 0; display: flex; align-items: center; gap: 1.2em;
    background: var(--dk-fond); color: var(--dk-encre); padding: 0.8em 2.6em 0.8em 2.6em; border-top: 6px solid var(--dk-accent); }
  .entete-ul img { height: 2.6em; width: auto; display: block; }
  .entete-ul .sep { width: 2px; align-self: stretch; background: var(--dk-encre); }
  .entete-ul .dept { font-size: 0.62em; letter-spacing: 0.12em; text-transform: uppercase; line-height: 1.45; font-weight: 600; }
  .entete-ul .session { margin-left: auto; font-size: 0.72em; letter-spacing: 0.16em; text-transform: uppercase; color: var(--dk-accent); font-weight: 600; }
  .capture { margin: 0; }
  .capture img { display: block; width: 100%; height: auto; border: 2px solid var(--dk-encre); }
  .capture figcaption { margin-top: 0.4em; font-size: 0.7em; color: var(--dk-gris); }
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
