<script>
  /**
   * POL-2000 — Séance 7 · La régression linéaire simple
   * Jeudi 15 octobre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine : moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine et bouge.
   *
   * Le fil (brouillon du prof, 14 octobre 2026, pol-5a0.9) : l'examen 1, puis
   * le travail de mi-session en sept étapes (avec la recherche d'articles,
   * pol-5a0.9.1). Puis la régression, de la droite qui passe le
   * plus près des points jusqu'au tableau et au graphique des coefficients.
   * Pause après la variable confondante. Le hasard (l'erreur type, t, p,
   * l'intervalle) reprend le dispositif de la
   * séance 5 et nomme enfin la valeur p (pol-vjv).
   *
   * L'exemple fil rouge (choisi par le prof le 14 octobre) : un classique,
   * la scolarité (cinq niveaux) et l'intérêt pour la politique (le curseur de
   * 0 à 10), dans la CES 2025, tout recodé de 0 à 1. Les 20 180 répondant.e.s
   * servent de population d'exercice,
   * comme à la séance 5 :
   * on connaît la vraie droite, et « notre sondage » tire 1 000 personnes
   * parmi les 20 180 (graine 62). Rien n'est pondéré.
   *
   * Rien n'est inventé pour une sortie de R ni pour une figure : tout vient
   * de src/lib/data/seance7*.js, générés par outils/seance7*.R. Seule la
   * crème glacée est fictive, et la diapo le dit.
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import AvantS8 from '$lib/deck/visuels/AvantS8.svelte';
  import TmExamen1 from '$lib/deck/visuels/TmExamen1.svelte';
  import TmConsignes from '$lib/deck/visuels/TmConsignes.svelte';
  import TmParcours from '$lib/deck/visuels/TmParcours.svelte';
  import TmQuestion from '$lib/deck/visuels/TmQuestion.svelte';
  import TmRisque from '$lib/deck/visuels/TmRisque.svelte';
  import TmTrouver from '$lib/deck/visuels/TmTrouver.svelte';
  import TmHypothese from '$lib/deck/visuels/TmHypothese.svelte';
  import TmQuestionSondage from '$lib/deck/visuels/TmQuestionSondage.svelte';
  import TmVd from '$lib/deck/visuels/TmVd.svelte';
  import TmEtAlors from '$lib/deck/visuels/TmEtAlors.svelte';
  import TmContribution from '$lib/deck/visuels/TmContribution.svelte';
  import TmPourVous from '$lib/deck/visuels/TmPourVous.svelte';
  import TmLisez from '$lib/deck/visuels/TmLisez.svelte';
  import RegTitre from '$lib/deck/visuels/RegTitre.svelte';
  import RegPourquoi from '$lib/deck/visuels/RegPourquoi.svelte';
  import RegMoindres from '$lib/deck/visuels/RegMoindres.svelte';
  import RegEnMots from '$lib/deck/visuels/RegEnMots.svelte';
  import DroiteReglable from '$lib/deck/visuels/DroiteReglable.svelte';
  import LireLaPente from '$lib/deck/visuels/LireLaPente.svelte';
  import D7VraieDroite from '$lib/deck/visuels/D7VraieDroite.svelte';
  import D7Recommencer from '$lib/deck/visuels/D7Recommencer.svelte';
  import D7Epsilon from '$lib/deck/visuels/D7Epsilon.svelte';
  import D7ErreurType from '$lib/deck/visuels/D7ErreurType.svelte';
  import D7UnSeul from '$lib/deck/visuels/D7UnSeul.svelte';
  import GlaceNuage from '$lib/deck/visuels/GlaceNuage.svelte';
  import GrapheEpsilon from '$lib/deck/visuels/GrapheEpsilon.svelte';
  import TiersPente from '$lib/deck/visuels/TiersPente.svelte';
  import { TIERS, VARS } from '$lib/data/seance7.js';
  import PenteMelange from '$lib/deck/visuels/PenteMelange.svelte';
  import PenteMondeH0 from '$lib/deck/visuels/PenteMondeH0.svelte';
  import PenteRegle from '$lib/deck/visuels/PenteRegle.svelte';
  import PenteValeurP from '$lib/deck/visuels/PenteValeurP.svelte';
  import PenteEtoiles from '$lib/deck/visuels/PenteEtoiles.svelte';
  import CeQuePNestPasPente from '$lib/deck/visuels/CeQuePNestPasPente.svelte';
  import ImportancePente from '$lib/deck/visuels/ImportancePente.svelte';
  import PenteIC from '$lib/deck/visuels/PenteIC.svelte';
  import VingtPentes from '$lib/deck/visuels/VingtPentes.svelte';
  import TabDeuxHabits from '$lib/deck/visuels/TabDeuxHabits.svelte';
  import TabEquation from '$lib/deck/visuels/TabEquation.svelte';
  import TabDroite from '$lib/deck/visuels/TabDroite.svelte';
  import TabEtoiles from '$lib/deck/visuels/TabEtoiles.svelte';
  import TabN from '$lib/deck/visuels/TabN.svelte';
  import TabR2 from '$lib/deck/visuels/TabR2.svelte';
  import TabQuatre from '$lib/deck/visuels/TabQuatre.svelte';
  import TabSuite from '$lib/deck/visuels/TabSuite.svelte';
  import CoefDuTableau from '$lib/deck/visuels/CoefDuTableau.svelte';
  import CoefAnatomie from '$lib/deck/visuels/CoefAnatomie.svelte';
  import CoefPlusieurs from '$lib/deck/visuels/CoefPlusieurs.svelte';
  import CoefTroisQuestions from '$lib/deck/visuels/CoefTroisQuestions.svelte';

  import MsDefaut from '$lib/deck/visuels/MsDefaut.svelte';
  import MsBeau from '$lib/deck/visuels/MsBeau.svelte';
  import MsDeux from '$lib/deck/visuels/MsDeux.svelte';
  import MsExport from '$lib/deck/visuels/MsExport.svelte';
  import Code from '$lib/deck/Code.svelte';
  import CoefNiveaux from '$lib/deck/visuels/CoefNiveaux.svelte';
  import CoefGabarit from '$lib/deck/visuels/CoefGabarit.svelte';
  import { GABARIT } from '$lib/data/seance7_h.js';

  import ClEtude from '$lib/deck/visuels/ClEtude.svelte';
  import ClFin from '$lib/deck/visuels/ClFin.svelte';

  import SondageDansLaCes from '$lib/deck/visuels/SondageDansLaCes.svelte';

  import RegCarres from '$lib/deck/visuels/RegCarres.svelte';
  const CLASSIQUES = ['galton', 'mincer', 'ace', 'blais', 'guerre', 'mobilite'];

  const TOTAL = 77;
  const D = 'POL-2000 · séance 7 · jeu 15 oct';
</script>

<svelte:head>
  <title>POL-2000 · Séance 7 · La régression linéaire simple</title>
</svelte:head>

<Deck total={TOTAL} logo="{base}/img/ulaval-logo.png">
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->
    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre">
        <p class="surtitre e">POL-2000 · Méthodologie quantitative</p>
        <h1 class="e">La régression linéaire simple</h1>
        <hr class="filet" />
        <p class="lead e">Séance 7 · jeudi 15 octobre 2026</p>
      </div>
      <div class="entete-ul e">
        <img src="{base}/img/ulaval-logo.png" alt="Université Laval" />
        <span class="sep"></span>
        <span class="dept">Département de science politique<br />Faculté des sciences sociales</span>
        <span class="session">Automne 2026</span>
      </div>
    </Slide>

    <Slide bandeau="Où on en est" droite={D}>
      <Session ici={7} />
    </Slide>

    <!-- ================= L’EXAMEN 1 ================= -->
    <Slide bandeau="Examen 1" droite={D}>
      <h2 class="e">L’examen 1</h2>
      <TmExamen1 />
    </Slide>

    <!-- ================= LE TRAVAIL DE MI-SESSION ================= -->
    <Slide fond="encre" bandeau="Travail de mi-session" droite={D}>
      <h1 class="e">Le travail de mi-session</h1>
      <hr class="filet" />
      <p class="lead e">Sept étapes, une à la fois.</p>
    </Slide>

    <Slide bandeau="Travail de mi-session" droite={D}>
      <h2 class="e">Les consignes</h2>
      <TmConsignes />
    </Slide>

    <Slide bandeau="Travail de mi-session · étape 1" droite={D}>
      <TmParcours ici={1} />
      <h2 class="e">Une question claire, précise, mesurable</h2>
      <TmQuestion />
    </Slide>

    <Slide bandeau="Travail de mi-session · étape 2" droite={D}>
      <TmParcours ici={2} />
      <h2 class="e">La littérature, comme à Risk</h2>
      <TmRisque />
    </Slide>

    <Slide bandeau="Travail de mi-session · étape 2" droite={D}>
      <TmParcours ici={2} />
      <h2 class="e">Trouver les bons articles</h2>
      <TmTrouver />
    </Slide>

    <Slide bandeau="Travail de mi-session · étape 3" droite={D}>
      <TmParcours ici={3} />
      <h2 class="e">Une hypothèse dérivée de la littérature</h2>
      <TmHypothese />
    </Slide>

    <Slide bandeau="Travail de mi-session · étape 4" droite={D}>
      <TmParcours ici={4} />
      <h2 class="e">La question fait la variable</h2>
      <TmQuestionSondage />
    </Slide>

    <Slide bandeau="Travail de mi-session · étape 4" droite={D}>
      <TmParcours ici={4} />
      <h2 class="e">Votre Y, la variable dépendante</h2>
      <TmVd />
    </Slide>

    <Slide bandeau="Travail de mi-session · étape 5" droite={D}>
      <TmParcours ici={5} />
      <h2 class="e">La pertinence&#8239;: ok, donc&#8239;?</h2>
      <TmEtAlors />
    </Slide>

    <Slide bandeau="Travail de mi-session · étape 6" droite={D}>
      <TmParcours ici={6} />
      <h2 class="e">La contribution</h2>
      <TmContribution />
    </Slide>

    <Slide bandeau="Travail de mi-session · étape 7" droite={D}>
      <TmParcours ici={7} />
      <h2 class="e">Et vous, pourquoi ce sujet&#8239;?</h2>
      <TmPourVous />
    </Slide>

    <Slide bandeau="Travail de mi-session" droite={D}>
      <h2 class="e">Lisez les consignes.</h2>
      <TmLisez />
    </Slide>

  

    <!-- ================= LA RÉGRESSION LINÉAIRE ================= -->
    <Slide fond="encre" bandeau="La régression linéaire" droite={D}>
      <h1 class="e">La régression linéaire</h1>
      <hr class="filet" />
      <p class="lead e">Une droite pour résumer une relation.</p>
      <RegTitre />
    </Slide>

    <!-- ================= LA RÉGRESSION EST PARTOUT ================= -->
    <!-- ================= LA RÉGRESSION EST PARTOUT ================= -->
    <Slide bandeau="La régression est partout" droite={D}>
      <h2 class="e">La taille des enfants dépend-elle de celle de leurs parents ?</h2>
      <ClEtude id="galton" />
    </Slide>

    <Slide bandeau="La régression est partout" droite={D}>
      <h2 class="e">Combien rapporte une année d’école de plus ?</h2>
      <ClEtude id="mincer" />
    </Slide>

    <Slide bandeau="La régression est partout" droite={D}>
      <h2 class="e">Une enfance difficile mène-t-elle à la dépression ?</h2>
      <ClEtude id="ace" />
    </Slide>

    <Slide bandeau="La régression est partout" droite={D}>
      <h2 class="e">Pourquoi vote-t-on davantage dans certains pays ?</h2>
      <ClEtude id="blais" />
    </Slide>

    <Slide bandeau="La régression est partout" droite={D}>
      <h2 class="e">Guerre civile : cupidité ou griefs ?</h2>
      <ClEtude id="guerre" />
    </Slide>

    <Slide bandeau="La régression est partout" droite={D}>
      <h2 class="e">Le revenu des parents prédit-il celui de leurs enfants ?</h2>
      <ClEtude id="mobilite" />
    </Slide>

    <Slide bandeau="La régression est partout" droite={D}>
      <h2 class="e">La même méthode depuis 140 ans</h2>
      <ClFin ids={CLASSIQUES} />
    </Slide>


    <Slide bandeau="La régression linéaire" droite={D}>
      <h2 class="e">Pourquoi la régression ?</h2>
      <RegPourquoi />
    </Slide>

    <Slide bandeau="La régression linéaire" droite={D}>
      <h2 class="e">Comment ça marche ?</h2>
      <RegMoindres />
    </Slide>

    <Slide bandeau="La régression linéaire" droite={D}>
      <h2 class="e">Pourquoi des carrés ?</h2>
      <RegCarres />
    </Slide>

    <Slide bandeau="La régression linéaire" droite={D}>
      <h2 class="e">L’équation, en mots</h2>
      <RegEnMots />
    </Slide>

  

    <Slide bandeau="Notre sondage de 1&#8239;000" droite={D}>
      <h2 class="e">Dans la vraie vie, on a un sondage</h2>
      <SondageDansLaCes />
    </Slide>

    <Slide bandeau="La droite · notre sondage de 1 000" droite={D}>
      <h2 class="e">Jouer avec la droite</h2>
      <DroiteReglable />
    </Slide>

    <Slide bandeau="La droite · notre sondage de 1 000" droite={D}>
      <h2 class="e">Lire la pente</h2>
      <LireLaPente />
    </Slide>

  

    <!-- ================= LE BIAIS (diapo 19) ================= -->
    <Slide bandeau="Hasard et biais" droite={D}>
      <h2 class="e">La vraie droite</h2>
      <D7VraieDroite />
    </Slide>

    <Slide bandeau="Hasard et biais" droite={D}>
      <h2 class="e">Et si on recommençait&#8239;?</h2>
      <D7Recommencer />
    </Slide>

    <Slide bandeau="Hasard et biais" droite={D}>
      <h2 class="e">Ce qui reste&#8239;: ε</h2>
      <D7Epsilon />
    </Slide>

    <!-- ================= LA VARIABLE CONFONDANTE (diapo 20) ================= -->
    <Slide bandeau="La variable confondante" droite={D}>
      <h2 class="e">Plus de crème glacée, plus de noyades</h2>
      <GlaceNuage mode="naif" />
    </Slide>

    <Slide bandeau="La variable confondante" droite={D}>
      <h2 class="e">Ce qui se cache dans ε</h2>
      <GrapheEpsilon />
    </Slide>

    <Slide bandeau="La variable confondante" droite={D}>
      <h2 class="e">À chaleur égale</h2>
      <GlaceNuage mode="tranches" />
    </Slide>

    <Slide bandeau="La variable confondante" droite={D}>
      <h2 class="e">Et dans la CES ?</h2>
      <GrapheEpsilon x="scolarité" y="intérêt" xEq={VARS.x.nom} yEq={VARS.y.nom} z="l’âge" autres={['le revenu', 'le genre', 'la région']} alerte={['l’âge', 'touche aussi x']} etiqY="plus d’intérêt" etiqX="moins de scolarité" b1={TIERS.b1_seul} pied="le graphe est une hypothèse · séance 11" />
    </Slide>

    <Slide bandeau="La variable confondante" droite={D}>
      <h2 class="e">À âge égal</h2>
      <TiersPente />
    </Slide>

  

    <!-- ================= PAUSE ================= -->
    <Slide fond="encre" bandeau="Pause" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <p class="lead e">Quinze minutes.</p>
    </Slide>

    <!-- ================= L'ERREUR TYPE (diapo 21) ================= -->
    <Slide bandeau="L’erreur type" droite={D}>
      <h2 class="e">L’erreur type</h2>
      <D7ErreurType />
    </Slide>

    <Slide bandeau="L’erreur type" droite={D}>
      <h2 class="e">Et avec un seul sondage&#8239;?</h2>
      <D7UnSeul />
    </Slide>

    <Slide bandeau="Est-ce le hasard ? · la statistique t" droite={D}>
      <h2 class="e">Et si H0 était vraie ?</h2>
      <PenteMelange />
    </Slide>

    <Slide bandeau="Est-ce le hasard ? · la statistique t" droite={D}>
      <h2 class="e">La cloche, posée sur 0</h2>
      <PenteMondeH0 />
    </Slide>

    <Slide bandeau="Est-ce le hasard ? · la statistique t" droite={D}>
      <h2 class="e">La statistique t</h2>
      <PenteRegle />
    </Slide>

    <!-- ================= LA VALEUR p ================= -->
    <Slide bandeau="Est-ce le hasard ? · la valeur p" droite={D}>
      <h2 class="e">Vous connaissez l’idée. Voici son nom.</h2>
      <PenteValeurP />
    </Slide>

    <Slide bandeau="Est-ce le hasard ? · la valeur p" droite={D}>
      <h2 class="e">Les étoiles</h2>
      <PenteEtoiles />
    </Slide>

    <Slide bandeau="Est-ce le hasard ? · la valeur p" droite={D}>
      <h2 class="e">Ce que p ne dit pas</h2>
      <CeQuePNestPasPente />
    </Slide>

    <Slide bandeau="Est-ce le hasard ? · la valeur p" droite={D}>
      <h2 class="e">Significatif n’est pas important</h2>
      <ImportancePente />
    </Slide>

    <!-- ================= L'INTERVALLE DE CONFIANCE ================= -->
    <Slide bandeau="Est-ce le hasard ? · l’intervalle" droite={D}>
      <h2 class="e">L’intervalle de confiance</h2>
      <PenteIC />
    </Slide>

    <Slide bandeau="Est-ce le hasard ? · l’intervalle" droite={D}>
      <h2 class="e">19 fois sur 20</h2>
      <VingtPentes />
    </Slide>

  

    <!-- ================= LIRE UN TABLEAU DE RÉGRESSION ================= -->
    <Slide fond="encre" bandeau="Lire un tableau" droite={D}>
      <h1 class="e">Lire un tableau de régression</h1>
      <hr class="filet" />
      <p class="lead e">Les mêmes chiffres, deux habits.</p>
    </Slide>

    <Slide bandeau="Lire un tableau" droite={D}>
      <h2 class="e">Deux habits, les mêmes chiffres</h2>
      <TabDeuxHabits />
    </Slide>

    <Slide bandeau="Lire un tableau" droite={D}>
      <h2 class="e">Le tableau, c’est l’équation remplie</h2>
      <TabEquation />
    </Slide>

    <Slide bandeau="Lire un tableau · le coefficient" droite={D}>
      <h2 class="e">La constante et la pente dessinent la droite</h2>
      <TabDroite />
    </Slide>

    <Slide bandeau="Lire un tableau · les étoiles" droite={D}>
      <h2 class="e">Les étoiles, la valeur p en raccourci</h2>
      <TabEtoiles />
    </Slide>

    <Slide bandeau="Lire un tableau · N" droite={D}>
      <h2 class="e">N = 981. Pourquoi pas 1&#8239;000&#8239;?</h2>
      <TabN />
    </Slide>

    <Slide bandeau="Lire un tableau · R²" droite={D}>
      <h2 class="e">R² = 0,04</h2>
      <TabR2 />
    </Slide>

    <Slide bandeau="Lire un tableau" droite={D}>
      <h2 class="e">Lire un tableau en 4 questions</h2>
      <TabQuatre />
    </Slide>

    <!-- ================= FAIRE SON TABLEAU · modelsummary ================= -->
    <!-- ================= FAIRE SON TABLEAU (modelsummary) ================= -->
    <Slide bandeau="Faire son tableau · modelsummary" droite={D}>
      <h2 class="e">Une ligne, un tableau</h2>
      <MsDefaut />
    </Slide>

    <Slide bandeau="Faire son tableau · modelsummary" droite={D}>
      <h2 class="e">Un argument à la fois</h2>
      <MsBeau />
    </Slide>

    <Slide bandeau="Faire son tableau · modelsummary" droite={D}>
      <h2 class="e">Deux modèles côte à côte</h2>
      <MsDeux />
    </Slide>

    <Slide bandeau="Faire son tableau · modelsummary" droite={D}>
      <h2 class="e">Du tableau au PDF</h2>
      <MsExport />
    </Slide>

  

  

    <!-- ================= LE GRAPHIQUE DES COEFFICIENTS ================= -->
    <Slide fond="encre" bandeau="Le graphique des coefficients" droite={D}>
      <h1 class="e">Le graphique des coefficients</h1>
      <hr class="filet" />
      <p class="lead e">Le tableau, en image.</p>
    </Slide>

    <Slide bandeau="Le graphique des coefficients" droite={D}>
      <h2 class="e">Du tableau au graphique</h2>
      <CoefDuTableau />
    </Slide>

    <Slide bandeau="Le graphique des coefficients" droite={D}>
      <h2 class="e">Morceau par morceau</h2>
      <CoefAnatomie />
    </Slide>

    <Slide bandeau="Aperçu de la semaine prochaine" droite={D}>
      <h2 class="e">Plusieurs variables à la fois</h2>
      <CoefPlusieurs mode="signif" />
    </Slide>

    <Slide bandeau="Aperçu de la semaine prochaine" droite={D}>
      <h2 class="e">Attention aux unités</h2>
      <CoefPlusieurs mode="unites" />
    </Slide>

    <Slide bandeau="Le graphique des coefficients" droite={D}>
      <h2 class="e">Lire le graphique en 3 questions</h2>
      <CoefTroisQuestions />
    </Slide>

    <!-- ================= 95, 99, 99,9 % · UN GABARIT ================= -->
    <Slide bandeau="Le graphique des coefficients" droite={D}>
      <h2 class="e">95&#8239;%, 99&#8239;%, 99,9&#8239;%</h2>
      <CoefNiveaux />
    </Slide>

    <Slide bandeau="Un gabarit pour vos travaux" droite={D}>
      <h2 class="e">Un graphique à réutiliser</h2>
      <CoefGabarit vue="resultat" />
    </Slide>

    <Slide bandeau="Un gabarit pour vos travaux" droite={D}>
      <h2 class="e">1. Préparer les coefficients</h2>
      <Code src={GABARIT.preparer} titre="gabarit.R · après votre lm()" />
    </Slide>

    <Slide bandeau="Un gabarit pour vos travaux" droite={D}>
      <h2 class="e">2. Dessiner et enregistrer</h2>
      <Code src={GABARIT.dessiner + '\n\n' + GABARIT.enregistrer} titre="gabarit.R · la suite" />
    </Slide>

    <Slide bandeau="Un gabarit pour vos travaux" droite={D}>
      <h2 class="e">Plus court&#8239;: modelplot()</h2>
      <CoefGabarit vue="modelplot" />
    </Slide>

  

  

    <Slide bandeau="La semaine prochaine" droite={D}>
      <h2 class="e">La semaine prochaine : plusieurs variables</h2>
      <TabSuite />
    </Slide>

    <!-- ================= FIN ================= -->
    <Slide bandeau="Avant le 22 octobre" droite={D}>
      <h2 class="e">Trois choses</h2>
      <AvantS8 />
    </Slide>

    <Slide fond="encre" bandeau="Avant le 22 octobre" droite={D}>
      <h1 class="e">Jeudi 22 octobre</h1>
      <hr class="filet" />
      <p class="lead e">La régression linéaire multiple.</p>
    </Slide>

    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre merci">
        <h1 class="e">Merci.</h1>
        <hr class="filet" />
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
  .titre { padding-bottom: 5.2em; }
  .merci h1 { font-size: 3.4em; }
  .entete-ul { position: absolute; left: 0; right: 0; bottom: 0; display: flex; align-items: center; gap: 1.2em;
    background: #fff; color: var(--dk-encre); padding: 0.8em 2.6em 0.8em 2.6em; border-top: 6px solid var(--dk-accent); }
  .entete-ul img { height: 2.6em; width: auto; display: block; }
  .entete-ul .sep { width: 2px; align-self: stretch; background: var(--dk-encre); }
  .entete-ul .dept { font-size: 0.62em; letter-spacing: 0.12em; text-transform: uppercase; line-height: 1.45; font-weight: 600; }
  .entete-ul .session { margin-left: auto; font-size: 0.72em; letter-spacing: 0.16em; text-transform: uppercase; color: var(--dk-accent); font-weight: 600; }

  /* Le retour sur la semaine : une seule question, très grande. */
  .d-un-bloc { white-space: nowrap; }
  .grande-q { font-size: 2.6em; line-height: 1.2; max-width: 16em; margin-top: 1.4em; }
</style>
