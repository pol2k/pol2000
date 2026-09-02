<script>
  /**
   * POL-2000 — Séance 1 · Introduction et les éléments fondamentaux de la recherche
   * Jeudi 3 septembre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine héritée du deck EIOM: la question avant l'outil, le mot avant la
   * technologie, aucune valeur inventée pour la figure. Le tableau de régression
   * de l'ouverture est volontairement vide — les étudiant.e.s le rempliront
   * eux-mêmes en novembre.
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

  const TOTAL = 44;
  const D = 'POL-2000 · séance 1 · jeu 3 sept';

  // Noms de variables réels de l'Étude électorale canadienne 2025 (Dataverse
  // de Harvard, fichier Stata). Montrés pour leur forme, pas pour leurs valeurs.
  const c_variables = `cps25_lr_scale_bef_1   placement gauche-droite, de 0 à 10
cps25_education        plus haut niveau de scolarité atteint
cps25_age_in_years     âge, en années
cps25_income           revenu du ménage`;

  const c_verif = `R.version.string
# [1] "R version 4.x.x (2026-..-..)"

install.packages("tidyverse")
# ... beaucoup de texte, puis :
# * DONE (tidyverse)`;
</script>

<svelte:head>
  <title>POL-2000 · Séance 1 — Introduction et les éléments fondamentaux de la recherche</title>
</svelte:head>

<Deck total={TOTAL}>
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->
    <Slide fond="encre" droite={D}>
      <p class="surtitre e">POL-2000 · Méthodologie quantitative · Automne 2026</p>
      <h1 class="e">Introduction et les éléments fondamentaux de la recherche</h1>
      <hr class="filet" />
      <p class="lead e">Séance 1 · jeudi 3 septembre 2026</p>
      <p class="lead e">Laurence-Olivier M. Foisy · Université Laval</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Qui suis-je</h2>
      <ul class="e">
        <li><strong>Laurence-Olivier M. Foisy</strong> — chargé de ce cours au Département de science politique.</li>
        <li>J'ai donné deux fois <em>Introduction à l'analyse des mégadonnées</em> (FAS1001) à l'Université de Montréal.</li>
        <li>La semaine dernière : le parcours <em>L'intelligence artificielle et la recherche</em> de l'EIOM, ici à Laval.</li>
        <li>Courriel : <code>mail@mfoisy.com</code> — pour les deux premières semaines. Ensuite, Slack.</li>
      </ul>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Et vous ?</h2>
      <p class="lead e">À main levée.</p>
      <ul class="qs e">
        <li>Qui a suivi un cours de statistiques au cégep ?</li>
        <li>Qui a déjà écrit une ligne de code, n'importe laquelle ?</li>
        <li>Qui utilise ChatGPT, Claude ou Gemini au moins une fois par semaine ?</li>
        <li>Qui redoute ce cours ?</li>
      </ul>
      <p class="e">Retenez vos réponses. On y revient en décembre.</p>
    </Slide>


    <!-- ================= 1 · UNE QUESTION ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Une question, pour commencer</h1>
      <hr class="filet" />
      <p class="lead e">Avant toute méthode, une curiosité.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">L'éducation rend-elle plus à gauche ?</h2>
      <div class="compare-p e">
        <div class="p"><span class="et">OUI</span><p class="txt">L'université expose à des idées, à des gens et à des débats qui déplacent vers la gauche.</p></div>
        <div class="p"><span class="et">NON</span><p class="txt">Les diplômé.e.s gagnent plus, et le revenu tire vers la droite. L'effet net serait nul, ou inverse.</p></div>
      </div>
      <div class="compare-p e" style="margin-top:0.6em">
        <div class="p solide"><span class="et">C'EST PLUS COMPLIQUÉ</span><p class="txt">Les plus scolarisé.e.s sont aussi plus jeunes. Est-ce l'école, ou l'âge ?</p></div>
        <div class="p"><span class="et">ET SURTOUT</span><p class="txt"><strong>Comment le saurait-on ?</strong> Avec quoi, mesuré comment, chez qui ?</p></div>
      </div>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Ce qu'il faudrait pour répondre</h2>
      <p class="lead e">L'<strong>Étude électorale canadienne 2025</strong> : des milliers de répondant.e.s, interrogé.e.s pendant la campagne. Quatre colonnes nous intéressent.</p>
      <Code src={c_variables} brut />
      <p class="e">Ces noms sont réels. Vous les manipulerez vous-mêmes.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Ce tableau, vous le produirez en novembre</h2>
      <table class="e tableau-vide">
        <thead><tr><th>Placement gauche-droite (0–10)</th><th>Coefficient</th><th>Erreur-type</th><th>p</th></tr></thead>
        <tbody>
          <tr><td>Scolarité</td><td>?</td><td>?</td><td>?</td></tr>
          <tr><td>Âge</td><td>?</td><td>?</td><td>?</td></tr>
          <tr><td>Revenu</td><td>?</td><td>?</td><td>?</td></tr>
          <tr><td>Constante</td><td>?</td><td>?</td><td>?</td></tr>
        </tbody>
      </table>
      <p class="lead e">En décembre, vous saurez <strong>le lire</strong>, <strong>le produire</strong> — et dire pourquoi il <strong>ne prouve pas</strong> ce qu'on croit.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Le parcours, en trois temps</h2>
      <div class="trois e">
        <Carte ton="ciel" titre="1 · Décrire">Une variable à la fois. Qu'est-ce qu'une distribution, une moyenne, un écart ? Et comment les calculer dans R.</Carte>
        <Carte ton="ambre" titre="2 · Relier">Deux variables, puis plusieurs. La régression : la ligne qui résume une relation, et ce que ses chiffres veulent dire.</Carte>
        <Carte ton="accent" titre="3 · Causer">Quand une relation est-elle une cause ? Le problème fondamental, les graphes, les biais — et les expériences.</Carte>
      </div>
      <p class="e">Chaque temps répond à une question qu'on se posait déjà au temps précédent.</p>
    </Slide>


    <!-- ================= 2 · LA MAUVAISE RÉPUTATION ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Parlons-en : ce cours a mauvaise réputation</h1>
      <hr class="filet" />
      <p class="lead e">Trois raisons, et ce qu'on fait autrement.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Pourquoi on le redoute</h2>
      <Deux>
        <div>
          <p class="surtitre">LES RAISONS</p>
          <ol class="qs-num serre">
            <li><span>Des mathématiques que personne n'a demandées.</span></li>
            <li><span>Un logiciel qu'on découvre la semaine de l'examen.</span></li>
            <li><span>Des chiffres sans question derrière.</span></li>
          </ol>
        </div>
        <div>
          <p class="surtitre">CETTE SESSION</p>
          <ol class="qs-num serre">
            <li><span><strong>Aucune formule à dériver.</strong> Le seul préalable est le secondaire.</span></li>
            <li><span><strong>R dès jeudi prochain</strong>, et à presque toutes les séances ensuite.</span></li>
            <li><span><strong>Chaque technique part d'une question</strong> — comme celle d'il y a trois diapos.</span></li>
          </ol>
        </div>
      </Deux>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Ce que je vous demande en échange</h2>
      <ul class="e">
        <li><strong>L'ordinateur, à chaque séance.</strong> Vous suivez les démonstrations sur votre propre machine.</li>
        <li><strong>Les Datacamp, chaque semaine.</strong> C'est là que R devient un réflexe, pas en classe.</li>
        <li><strong>Les questions « bêtes ».</strong> Elles ne le sont pas, et cent personnes ont la même.</li>
        <li><strong>Me dire quand ça décroche.</strong> En classe, sur Slack, en rencontre. Tôt.</li>
      </ul>
    </Slide>


    <!-- ================= 3 · LE PLAN DE COURS ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Le plan de cours</h1>
      <hr class="filet" />
      <p class="lead e">Vous pouvez le contester aujourd'hui. Ensuite, il devient le contrat.</p>
      <p class="lead e"><code>pol2000.com/syllabus</code></p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Identification</h2>
      <div class="etiqs e">
        <Etiquette ton="accent">POL-2000</Etiquette>
        <Etiquette>NRC 87892</Etiquette>
        <Etiquette>3 crédits · 3-0-6</Etiquette>
        <Etiquette>Jeudi 15h30–18h20</Etiquette>
        <Etiquette>DKN-3159</Etiquette>
        <Etiquette ton="ambre">En présentiel</Etiquette>
      </div>
      <p class="lead e" style="margin-top:0.9em">Quatorze séances, du 3 septembre au 10 décembre. Aucune ne tombe un jour férié. Semaine de lecture du 26 au 30 octobre.</p>
      <p class="e">Préalable mathématique : <strong>aucun</strong> au-delà du secondaire.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Au terme du cours, vous serez en mesure de</h2>
      <ol class="qs-num e">
        <li><span>Maîtriser les concepts et techniques propres à l'analyse statistique;</span></li>
        <li><span>Utiliser les fonctions de base de R et de Positron pour le traitement de données;</span></li>
        <li><span>Comprendre et critiquer des articles scientifiques qui font appel à ces techniques;</span></li>
        <li><span>Comprendre la logique de l'analyse causale — et ses limites;</span></li>
        <li><span>Concevoir et réaliser votre propre projet de recherche.</span></li>
      </ol>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Trois parties</h2>
      <table class="e">
        <thead><tr><th>Partie</th><th>Séances</th><th>Ce qu'on apprend</th></tr></thead>
        <tbody>
          <tr><td><strong>1 · Concepts de base</strong></td><td>1 à 5</td><td>Opérationnaliser une question, les types de variables, décrire une distribution, et l'inférence : de l'échantillon à la population.</td></tr>
          <tr><td><strong>2 · Régression</strong></td><td>7 à 10</td><td>La logique de la régression linéaire, lire des coefficients et leur signification, une puis plusieurs variables explicatives — dans R.</td></tr>
          <tr><td><strong>3 · Inférence causale</strong></td><td>11 à 14</td><td>Le problème fondamental, quelles variables contrôler (ou pas), les graphes orientés acycliques, les biais, les expériences.</td></tr>
        </tbody>
      </table>
    </Slide>

    <Slide droite={D} d={0.92}>
      <h2 class="e">Calendrier · première moitié</h2>
      <table class="e calendrier">
        <tbody>
          <tr><td>1</td><td>3 sept.</td><td>Introduction et les éléments fondamentaux de la recherche</td></tr>
          <tr><td>2</td><td>10 sept.</td><td><strong>Introduction à R et à Positron</strong> — apportez l'ordinateur, installé</td></tr>
          <tr><td>3</td><td>17 sept.</td><td>Les statistiques descriptives et la visualisation des données</td></tr>
          <tr><td>4</td><td>24 sept.</td><td>Préparer ses données avec R · <em>ouverture de l'examen 1</em></td></tr>
          <tr><td>5</td><td>1<sup>er</sup> oct.</td><td>L'inférence statistique · <em>examen 1 à remettre le dim. 4 oct.</em></td></tr>
          <tr><td>6</td><td>8 oct.</td><td>Rencontres individuelles — aucun cours magistral</td></tr>
          <tr><td>7</td><td>15 oct.</td><td>La régression linéaire simple</td></tr>
          <tr><td>8</td><td>22 oct.</td><td><strong>Examen 2</strong> (15h30–16h30), puis atelier de préparation au travail de mi-session</td></tr>
          <tr><td>—</td><td>29 oct.</td><td>Semaine de lecture — aucun cours</td></tr>
        </tbody>
      </table>
    </Slide>

    <Slide droite={D} d={0.92}>
      <h2 class="e">Calendrier · seconde moitié</h2>
      <table class="e calendrier">
        <tbody>
          <tr><td>9</td><td>5 nov.</td><td>La régression linéaire multiple</td></tr>
          <tr><td>10</td><td>12 nov.</td><td>De la question au tableau de régression : à la main, puis avec l'IA</td></tr>
          <tr><td>11</td><td>19 nov.</td><td>Les graphes orientés acycliques (GOA)</td></tr>
          <tr><td>12</td><td>26 nov.</td><td>Le problème fondamental de l'inférence causale</td></tr>
          <tr><td>13</td><td>3 déc.</td><td>Les biais</td></tr>
          <tr><td>14</td><td>10 déc.</td><td>Les expériences et révision · <strong>Examen 3</strong> (15h30–16h30)</td></tr>
          <tr><td>—</td><td>18 déc.</td><td><em>Travail final et Datacamp à remettre, 23h59</em></td></tr>
        </tbody>
      </table>
    </Slide>

    <Slide droite={D} d={0.94}>
      <h2 class="e">Les évaluations</h2>
      <table class="e">
        <thead><tr><th>Évaluation</th><th>Quand</th><th>Où</th><th>Poids</th></tr></thead>
        <tbody>
          <tr><td>Examen 1 — Analyser des données avec R</td><td>24 sept. → dim. 4 oct., 23h59</td><td>Chez vous, boîte de dépôt</td><td>15 %</td></tr>
          <tr><td>Examen 2 — Statistiques descriptives</td><td>jeu. 22 oct., 15h30–16h30</td><td>En classe, papier-crayon</td><td>15 %</td></tr>
          <tr><td>Travail de mi-session</td><td>dim. 25 oct., 23h59</td><td>PDF, boîte de dépôt</td><td>20 %</td></tr>
          <tr><td>Datacamp, 1<sup>re</sup> partie</td><td>dim. 25 oct., 23h59</td><td>datacamp.com</td><td>5 %</td></tr>
          <tr><td>Examen 3 — Régressions simple et multiple</td><td>jeu. 10 déc., 15h30–16h30</td><td>En classe, papier-crayon</td><td>15 %</td></tr>
          <tr><td>Travail final</td><td>ven. 18 déc., 23h59</td><td>PDF, boîte de dépôt</td><td>25 %</td></tr>
          <tr><td>Datacamp, 1<sup>re</sup> + 2<sup>e</sup> parties</td><td>ven. 18 déc., 23h59</td><td>datacamp.com</td><td>5 %</td></tr>
        </tbody>
      </table>
      <p class="e">Examens 45 % · travaux 45 % · exercices 10 %. Une échelle de A+ à E, détaillée dans le plan.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Trois examens, deux formes</h2>
      <div class="trois e">
        <Carte ton="ciel" titre="Examen 1 · à distance">Ouvre le 24 septembre, se remet le 4 octobre. Sur ordinateur, avec R : importer, manipuler, décrire des données. Vous aurez eu deux séances de R.</Carte>
        <Carte ton="ambre" titre="Examen 2 · en classe">22 octobre, une heure, papier et crayon. Les statistiques descriptives. Pas de centre d'examen à réserver : c'est ici, à l'heure du cours.</Carte>
        <Carte ton="ambre" titre="Examen 3 · en classe">10 décembre, une heure, papier et crayon. Les régressions simple et multiple. Le reste de la séance : les expériences, et la révision.</Carte>
      </div>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Deux travaux, un seul projet</h2>
      <Deux>
        <Carte ton="ciel" titre="Mi-session · 20 % · 25 octobre">Un <strong>devis de recherche</strong> : une question qui relie une variable dépendante et une variable indépendante, une courte revue de la littérature, des hypothèses (et leur nulle), la base de données et les variables choisies. Vous recevez une rétroaction avant de continuer.</Carte>
        <Carte ton="accent" titre="Final · 25 % · 18 décembre">Le même projet, mené à terme sur une banque de données fournie : un graphe orienté acyclique, des statistiques descriptives, une régression et son tableau, l'interprétation, les biais et les limites. <strong>Positron obligatoire.</strong></Carte>
      </Deux>
      <p class="e">Le mi-session n'est pas un travail de plus : c'est la première moitié du final, corrigée à temps pour la deuxième.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Datacamp · 10 %</h2>
      <Deux ratio="1fr 1.4fr">
        <Grand valeur="10 %" legende="en deux moitiés de 5 %" />
        <div>
          <ul>
            <li>Des devoirs partagés <strong>chaque semaine</strong>, à faire chez vous.</li>
            <li>Tous ceux de la première moitié : <strong>dimanche 25 octobre</strong>, 23h59.</li>
            <li>Tous ceux de la session, première moitié incluse : <strong>vendredi 18 décembre</strong>, 23h59.</li>
            <li>C'est là que R s'apprend vraiment : par répétition, à votre rythme, avec une correction immédiate.</li>
          </ul>
        </div>
      </Deux>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Retards</h2>
      <Deux ratio="1fr 1.4fr">
        <Grand valeur="−10 %" legende="par jour de retard" />
        <div>
          <p class="lead">De la note obtenue, pour toute évaluation remise en retard sans justification valable.</p>
          <p class="lead">Après <strong>trois jours</strong>, la note est 0.</p>
          <p>Une demande de délai se fait <strong>avant</strong> l'échéance, avec les motifs. Une absence à un examen relève de la politique du Département.</p>
        </div>
      </Deux>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">L'intelligence artificielle générative</h2>
      <p class="lead e">Ce cours ne l'interdit pas. Il vous apprend à vous en servir correctement.</p>
      <div class="trois e">
        <Carte ton="vert" titre="Permis, si déclaré">Obtenir de l'aide pour <strong>écrire, comprendre ou déboguer du code R</strong>.</Carte>
        <Carte ton="accent" titre="Non permis">L'<strong>interprétation</strong> des résultats et la <strong>rédaction</strong> des travaux. Ce que vous affirmez, vous devez pouvoir le défendre.</Carte>
        <Carte ton="ambre" titre="Selon l'évaluation">Chaque examen et chaque travail précise ses propres consignes. Lisez-les.</Carte>
      </div>
      <Citation source="La question à se poser, chaque fois">L'aurais-je accepté d'un assistant humain sans vérifier son travail ?</Citation>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Matériel</h2>
      <Deux>
        <div>
          <p class="surtitre">OBLIGATOIRE</p>
          <ul>
            <li><strong>R</strong> — <code>cran.r-project.org</code></li>
            <li><strong>Positron</strong> — <code>positron.posit.co</code></li>
            <li>Un <strong>ordinateur portable</strong>, à chaque séance.</li>
          </ul>
        </div>
        <div>
          <p class="surtitre">OUVRAGE DE RÉFÉRENCE · NON OBLIGATOIRE</p>
          <p>Arel-Bundock, Vincent. 2021. <em>Analyse causale et méthodes quantitatives</em>. Presses de l'Université de Montréal.</p>
          <p>Gratuit en PDF. Il couvre toute la matière, dans le même ordre : quand une notion vous échappe, c'est là qu'elle est expliquée une deuxième fois, autrement.</p>
        </div>
      </Deux>
      <p class="e">Pas d'ordinateur ? Écrivez-moi dès cette semaine : des solutions existent.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Encadrement</h2>
      <ul class="e">
        <li><strong>Slack</strong> est le canal du cours. Je réponds aux courriels pendant deux semaines; ensuite, Slack et Slack seulement.</li>
        <li><strong>Auxiliaires d'enseignement :</strong> Jules Piral et Marc-Antoine Dupuis. <strong>Tuteur :</strong> Adam Ménard. Vous pouvez leur écrire en tout temps.</li>
        <li><strong>Rencontres individuelles</strong> le jeudi 8 octobre, avec moi, les auxiliaires et le tuteur — pour le travail de mi-session, et pour quiconque décroche.</li>
        <li><strong>Rendez-vous</strong> dans les plages publiées sur <code>pol2000.com</code>.</li>
      </ul>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Enregistrement et diffusion</h2>
      <p class="lead e">Les séances ne sont <strong>ni enregistrées ni diffusées</strong>. Ce cours se donne en classe, et c'est un choix.</p>
      <p class="lead e">Une version <strong>en ligne, asynchrone</strong> du cours est offerte à la session d'hiver. Si le présentiel ne vous convient pas, c'est là qu'il faut aller.</p>
      <p class="e">Aucun point n'est retiré pour la qualité de la langue. Mais elle reste le premier indice de la qualité d'un travail, et j'en tiens compte.</p>
    </Slide>

    <Slide fond="encre" droite={D}>
      <h1 class="e">Des objections ?</h1>
      <hr class="filet" />
      <p class="lead e">Sur les dates, les pondérations, les règles. C'est maintenant : ce qu'on convient aujourd'hui, on le garde.</p>
    </Slide>


    <!-- ================= PAUSE ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <p class="lead e">Quinze minutes.</p>
      <p class="e">Au retour : ce qu'il faut savoir avant de toucher à une seule donnée.</p>
    </Slide>


    <!-- ================= 4 · LES ÉLÉMENTS FONDAMENTAUX ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Les éléments fondamentaux de la recherche</h1>
      <hr class="filet" />
      <p class="lead e">Le vocabulaire qu'on utilisera jusqu'en décembre.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">De la curiosité à la question</h2>
      <div class="trois e">
        <Carte ton="gris" titre="Un sujet">« La participation électorale des jeunes. »<br /><span class="petit">On ne peut pas y répondre. On peut seulement en parler.</span></Carte>
        <Carte ton="ambre" titre="Une question">« Pourquoi les jeunes votent-ils moins ? »<br /><span class="petit">Mieux. Mais « pourquoi » ouvre sur mille réponses.</span></Carte>
        <Carte ton="accent" titre="Une question testable">« L'âge est-il associé à la probabilité de voter, chez les électeur.rice.s du Québec en 2022 ? »<br /><span class="petit">Deux choses à mesurer, une population, un lien à vérifier.</span></Carte>
      </div>
      <p class="e">Une question testable dit <strong>quoi</strong> mesurer, <strong>chez qui</strong>, et <strong>quel lien</strong> on cherche.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Variable dépendante, variable indépendante</h2>
      <Deux>
        <Carte ton="accent" titre="Dépendante · Y">Ce qu'on veut <strong>expliquer</strong>. Elle « dépend » du reste.<br /><br />Voter ou non. Le placement gauche-droite. Le taux de chômage d'une région.</Carte>
        <Carte ton="ciel" titre="Indépendante · X">Ce qui, selon nous, <strong>explique</strong>. Elle varie d'elle-même.<br /><br />L'âge. La scolarité. Le parti au pouvoir.</Carte>
      </Deux>
      <p class="lead e">Une question de recherche, c'est au minimum <strong>un X et un Y</strong>. Le travail de mi-session commence exactement là.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Une variable varie</h2>
      <p class="lead e">Ça semble évident. C'est l'erreur la plus fréquente dans un premier devis.</p>
      <Deux>
        <div>
          <p class="surtitre">VARIABLE</p>
          <p>Prend des valeurs <strong>différentes</strong> d'un cas à l'autre dans <em>vos</em> données.</p>
          <p>Dans un sondage pancanadien : la province.</p>
        </div>
        <div>
          <p class="surtitre">CONSTANTE</p>
          <p>Prend la <strong>même</strong> valeur pour tous les cas observés.</p>
          <p>Dans un sondage mené auprès d'étudiant.e.s de l'Université Laval : « être inscrit.e à Laval ». On ne peut rien en tirer.</p>
        </div>
      </Deux>
      <p class="e">On n'explique jamais une variable par une constante.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Population et échantillon</h2>
      <Deux>
        <Carte ton="ciel" titre="La population">Tous les cas qui nous intéressent. Tou.te.s les électeur.rice.s du Québec. Tous les pays membres de l'ONU. Tous les tweets d'une campagne.</Carte>
        <Carte ton="accent" titre="L'échantillon">Les cas qu'on a <strong>réellement observés</strong>. Deux mille répondant.e.s. Quarante pays. Dix mille tweets.</Carte>
      </Deux>
      <p class="lead e">Toute la statistique inférentielle tient dans une question : <strong>ce que je vois dans l'échantillon, puis-je le dire de la population ?</strong></p>
      <p class="e">Séance 5. On y passera un après-midi entier.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">L'unité d'analyse</h2>
      <p class="lead e">De <em>quoi</em> chaque ligne de vos données est-elle faite ?</p>
      <table class="e">
        <thead><tr><th>Unité</th><th>Une ligne =</th><th>Exemple de Y</th></tr></thead>
        <tbody>
          <tr><td>Individu</td><td>une personne sondée</td><td>a voté, ou non</td></tr>
          <tr><td>Pays</td><td>un pays, une année</td><td>indice de démocratie</td></tr>
          <tr><td>Parti</td><td>un parti à une élection</td><td>part des voix</td></tr>
          <tr><td>Texte</td><td>un discours, un tweet</td><td>ton, positif ou négatif</td></tr>
        </tbody>
      </table>
      <p class="e">Mélanger les unités est une faute qu'aucun logiciel ne signale.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Les niveaux de mesure</h2>
      <table class="e">
        <thead><tr><th>Niveau</th><th>Ce que les valeurs permettent</th><th>Exemple</th></tr></thead>
        <tbody>
          <tr><td><strong>Nominal</strong></td><td>Distinguer des catégories. Aucun ordre.</td><td>Le parti pour lequel on a voté</td></tr>
          <tr><td><strong>Ordinal</strong></td><td>Ordonner. Mais les écarts ne sont pas égaux.</td><td>Niveau de scolarité : secondaire, collégial, universitaire</td></tr>
          <tr><td><strong>Intervalle / ratio</strong></td><td>Ordonner <em>et</em> mesurer des écarts égaux. On peut calculer.</td><td>L'âge en années; un revenu; une échelle de 0 à 10</td></tr>
        </tbody>
      </table>
      <p class="lead e">Le niveau de mesure décide de <strong>ce qu'on a le droit de calculer</strong>. Une moyenne de partis politiques n'existe pas.</p>
      <p class="e">Séance 3.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Hypothèse, et hypothèse nulle</h2>
      <Deux>
        <Carte ton="accent" titre="L'hypothèse · H₁">Ce qu'on s'attend à observer, dans une direction. « Plus une personne est âgée, plus elle est susceptible de voter. »</Carte>
        <Carte ton="gris" titre="L'hypothèse nulle · H₀">Il n'y a <strong>aucune relation</strong>. L'âge ne change rien à la participation.</Carte>
      </Deux>
      <p class="lead e">On ne prouve jamais H₁. On demande aux données si elles suffisent à <strong>rejeter H₀</strong>. La nuance est toute la séance 5.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Opérationnaliser : du concept à la mesure</h2>
      <div class="chaine e">
        <div><span class="et">CONCEPT</span><strong>« Être à gauche »</strong></div>
        <div class="fl">→</div>
        <div><span class="et">DÉFINITION</span><strong>Se situer soi-même sur un axe gauche-droite</strong></div>
        <div class="fl">→</div>
        <div><span class="et">MESURE</span><strong>Une échelle de 0 (gauche) à 10 (droite)</strong></div>
      </div>
      <p class="lead e">Chaque flèche perd quelque chose. Une bonne mesure dit <strong>ce qu'elle perd</strong>.</p>
      <p class="e">Quelqu'un qui se place à 5 est-il centriste, indifférent, ou mal à l'aise avec la question ? Le chiffre ne le dit pas.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">La fiche d'une recherche</h2>
      <Deux>
        <div class="fiche vide">
          <p class="surtitre">VIDE</p>
          <dl>
            <dt>Question</dt><dd>—</dd>
            <dt>Variable dépendante</dt><dd>—</dd>
            <dt>Variable indépendante</dt><dd>—</dd>
            <dt>Population</dt><dd>—</dd>
            <dt>Unité d'analyse</dt><dd>—</dd>
            <dt>Niveaux de mesure</dt><dd>—</dd>
            <dt>Hypothèse · H₀</dt><dd>—</dd>
          </dl>
        </div>
        <div class="fiche pleine">
          <p class="surtitre">REMPLIE</p>
          <dl>
            <dt>Question</dt><dd>L'éducation rend-elle plus à gauche ?</dd>
            <dt>Variable dépendante</dt><dd>Placement gauche-droite</dd>
            <dt>Variable indépendante</dt><dd>Scolarité</dd>
            <dt>Population</dt><dd>Électeur.rice.s canadien.ne.s, 2025</dd>
            <dt>Unité d'analyse</dt><dd>La personne sondée</dd>
            <dt>Niveaux de mesure</dt><dd>Y : échelle 0–10 · X : ordinal</dd>
            <dt>Hypothèse · H₀</dt><dd>Plus scolarisé, plus à gauche · aucune relation</dd>
          </dl>
        </div>
      </Deux>
      <p class="lead e">Votre travail de mi-session, c'est cette fiche — remplie, et justifiée.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">À vous : trois questions, à voix haute</h2>
      <p class="lead e">Proposez une question de recherche en science politique. Pour chacune, on cherche ensemble :</p>
      <ul class="qs e">
        <li>la variable dépendante, la variable indépendante;</li>
        <li>l'unité d'analyse et la population;</li>
        <li>le niveau de mesure de chaque variable;</li>
        <li>l'hypothèse — et sa nulle.</li>
      </ul>
      <p class="e">Si l'une des quatre résiste, la question n'est pas encore testable. C'est normal : c'est le travail.</p>
    </Slide>


    <!-- ================= 5 · AVANT JEUDI PROCHAIN ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Avant jeudi prochain</h1>
      <hr class="filet" />
      <p class="lead e">Trois choses à faire. La première est la seule qui compte.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">1 · Installer R, puis Positron</h2>
      <ol class="qs-num serre e">
        <li><span><strong>R</strong> d'abord — <code>cran.r-project.org</code>. Choisissez votre système; sous Windows, prenez « base ».</span></li>
        <li><span><strong>Positron</strong> ensuite — <code>positron.posit.co/download.html</code>. C'est l'éditeur; R est le moteur.</span></li>
        <li><span>Ouvrez Positron. En bas à droite, il doit avoir trouvé R tout seul.</span></li>
      </ol>
      <Carte ton="accent" titre="Le piège classique">Installer Positron <em>avant</em> R. Positron s'ouvre, ne trouve rien, et tout semble cassé. Refaites l'ordre : R, puis Positron.</Carte>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">2 · Vérifier que ça marche</h2>
      <p class="lead e">Dans la <strong>console</strong> de Positron, tapez ceci, une ligne à la fois, puis Entrée.</p>
      <Code src={c_verif} brut />
      <Carte ton="vert" titre="Points bonis · 2 points sur la note finale">Une capture d'écran de ces deux résultats, envoyée <strong>avant le jeudi 17 septembre, 23h59</strong>. Ça n'a rien de difficile : c'est exactement pour ça que ça vaut des points.</Carte>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">3 · Rejoindre le cours</h2>
      <ul class="e">
        <li><strong>Slack</strong> — le lien d'invitation arrive par courriel cette semaine. Rejoignez-le avant jeudi.</li>
        <li><strong>Datacamp</strong> — l'invitation aussi. Le premier devoir sera prêt pour la semaine 2.</li>
        <li><strong>pol2000.com</strong> — le plan de cours, le calendrier à jour, les diapositives de chaque séance.</li>
      </ul>
      <p class="lead e">Un blocage à l'installation ? Écrivez <strong>avant</strong> jeudi, pas jeudi. Un ordinateur qui ne marche pas à la séance 2, c'est une séance perdue.</p>
    </Slide>

    <Slide fond="encre" droite={D}>
      <h1 class="e">Jeudi prochain</h1>
      <hr class="filet" />
      <p class="lead e">R et Positron, à partir de zéro.</p>
      <p class="lead e">Apportez l'ordinateur. <strong>Installé.</strong></p>
    </Slide>

  {/snippet}
</Deck>

<style>
  /* Trois cartes côte à côte, poids égal. */
  .trois { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.9em; align-items: stretch; }
  .etiqs { display: flex; flex-wrap: wrap; gap: 0.5em; }
  .petit { font-size: 0.8em; color: var(--dk-gris); }
  /* Liste numérotée serrée: trois items de deux lignes tiennent dans une colonne. */
  :global(.qs-num.serre li) { font-size: 1.02em; line-height: 1.35; }
  :global(.qs-num.serre) { gap: 0.5em; }
  /* Le thème ignore les tons; on ne garde qu'une distinction: la carte qui compte. */
  :global(.carte-d.accent) { border-color: var(--dk-accent); }
  :global(.carte-d.accent h4) { color: var(--dk-accent); }

  /* Le tableau de l'ouverture: des cases vides, volontairement. */
  .tableau-vide td:not(:first-child) { text-align: center; color: var(--dk-gris-2); font-weight: 600; }

  /* Calendrier: numéro et date serrés, titre qui respire. */
  .calendrier td:first-child { width: 2.2em; color: var(--dk-accent); font-weight: 600; text-align: right; }
  .calendrier td:nth-child(2) { width: 5.5em; white-space: nowrap; color: var(--dk-gris); }

  /* Chaîne concept → définition → mesure. */
  .chaine { display: grid; grid-template-columns: 1fr auto 1fr auto 1fr; gap: 0.6em; align-items: stretch; margin: 0.6em 0 0.9em; }
  .chaine > div:not(.fl) { border: 2px solid var(--dk-filet); padding: 0.6em 0.8em; display: flex; flex-direction: column; gap: 0.35em; }
  .chaine > div:last-child { border-color: var(--dk-accent); }
  .chaine .et { font-size: 0.58em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .chaine .fl { display: flex; align-items: center; font-size: 1.6em; color: var(--dk-accent); }

  /* La fiche: vide contre remplie. */
  .fiche { border: 2px solid var(--dk-filet); padding: 0.7em 0.9em; }
  .fiche.pleine { border-color: var(--dk-accent); }
  .fiche dl { display: grid; grid-template-columns: auto 1fr; gap: 0.25em 0.9em; margin: 0.3em 0 0; font-size: 0.78em; }
  .fiche dt { color: var(--dk-gris); font-weight: 600; white-space: nowrap; }
  .fiche dd { margin: 0; }
  .fiche.vide dd { color: var(--dk-gris-2); }
</style>
