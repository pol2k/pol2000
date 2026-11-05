<script>
  /**
   * POL-2000 — Séance 9 · Les variables latentes
   * Jeudi 5 novembre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine : moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine et bouge.
   *
   * Le fil (pol-83j). La séance 8 a fait tout le chemin de la question au
   * tableau de régression, à la main, avec des variables prises toutes
   * faites dans un article. Ce qu'elle a sauté, c'est le pas que le travail
   * final exige : du concept dans l'hypothèse à la colonne dans df_clean.
   * 1. Mesurer un concept qu'on ne voit pas, d'après le cours 5 de FAS1001
   * (variable latente, échelle, fiabilité et validité, l'examen d'histoire,
   * les trois chiffres de l'analyse factorielle), puis pour vrai sur la
   * confiance envers dix institutions (CES 2025) avec sondr::topdown_fa() :
   * la religion organisée détonne, on la retire, on construit l'échelle, on
   * la met dans une régression. 2. Ce qu'est un modèle de langue, huit diapos reprises
   * de « L'IA en recherche » (EIOM 2026, Foisy) : prédire le jeton suivant,
   * les jetons, pas une base de connaissances, l'hallucination, les biais,
   * la formule d'un prompt, la confidentialité. On termine sur la règle du
   * cours. Les agents d'IA attendent la dernière séance.
   *
   * Sources. FAS1001, cours 5 (Foisy, Université de Montréal). Merkley, E.
   * (2022), « Polarization Eh? Ideological Divergence and Partisan Sorting
   * in the Canadian Mass Public », Public Opinion Quarterly 86(4). Le
   * paquet sondr (clessnverse/sondr). EIOM 2026, séance 1.
   *
   * Données. Rien n'est inventé pour une sortie de R ni pour une figure :
   * tout vient de src/lib/data/seance9.js et static/img/s9-*.png, générés par
   * outils/seance9_data.R. L'examen d'histoire et les cibles sont des
   * schémas, dits tels quels.
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Code from '$lib/deck/Code.svelte';
  import Carte from '$lib/deck/Carte.svelte';
  import Deux from '$lib/deck/Deux.svelte';
  import Citation from '$lib/deck/Citation.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import Aujourdhui9 from '$lib/deck/visuels/Aujourdhui9.svelte';
  import M9Arbre from '$lib/deck/visuels/M9Arbre.svelte';
  import M9Instruments from '$lib/deck/visuels/M9Instruments.svelte';
  import M9Items from '$lib/deck/visuels/M9Items.svelte';
  import M9Cible from '$lib/deck/visuels/M9Cible.svelte';
  import M9Examen from '$lib/deck/visuels/M9Examen.svelte';
  import M9TroisChiffres from '$lib/deck/visuels/M9TroisChiffres.svelte';
  import M9Saturations from '$lib/deck/visuels/M9Saturations.svelte';
  import M9Regle from '$lib/deck/visuels/M9Regle.svelte';
  import M8Image from '$lib/deck/visuels/M8Image.svelte';
  import Console from '$lib/deck/visuels/Console.svelte';
  import AvantS10 from '$lib/deck/visuels/AvantS10.svelte';
  import Generation from '$lib/deck/demos/Generation.svelte';
  import Tokeniseur from '$lib/deck/demos/Tokeniseur.svelte';
  import Connaissances from '$lib/deck/demos/Connaissances.svelte';
  import Hallucination from '$lib/deck/demos/Hallucination.svelte';
  import Biais from '$lib/deck/demos/Biais.svelte';
  import Anatomie from '$lib/deck/demos/Anatomie.svelte';
  import Donnees from '$lib/deck/demos/Donnees.svelte';
  import Cite from '$lib/deck/Cite.svelte';
  import Frise from '$lib/deck/demos/Frise.svelte';
  import Arbre from '$lib/deck/demos/Arbre.svelte';
  import Corpus from '$lib/deck/demos/Corpus.svelte';
  import Poids from '$lib/deck/demos/Poids.svelte';
  import Api from '$lib/deck/demos/Api.svelte';
  import Centre from '$lib/deck/demos/Centre.svelte';
  import Contexte from '$lib/deck/demos/Contexte.svelte';
  import Fiches from '$lib/deck/demos/Fiches.svelte';
  import Temperature from '$lib/deck/demos/Temperature.svelte';
  import Minuterie from '$lib/deck/demos/Minuterie.svelte';
  import MurAvis from '$lib/deck/demos/MurAvis.svelte';
  import Dictionnaire from '$lib/deck/demos/Dictionnaire.svelte';
  import Classifieur from '$lib/deck/demos/Classifieur.svelte';
  import Extractions from '$lib/deck/demos/Extractions.svelte';
  import Modeles from '$lib/deck/demos/Modeles.svelte';
  import Prix from '$lib/deck/demos/Prix.svelte';
  import Arena from '$lib/deck/demos/Arena.svelte';
  import Echantillon from '$lib/deck/demos/Echantillon.svelte';
  import Mesures from '$lib/deck/demos/Mesures.svelte';
  import { REFERENCES, ORDRE_BIBLIO } from '$lib/data/references.js';
  import { CREDITS_IMAGES } from '$lib/data/credits-images.js';
  import { FOURNISSEUR, FOURNISSEUR_SECOURS } from '$lib/data/config.js';
  import { ATELIER, FA1, FA2, HIST, REG, SATURATIONS, SCRIPT } from '$lib/data/seance9.js';

  const TOTAL = 84;
  const D = 'POL-2000 · séance 9 · jeu 5 nov';
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const f = (v, k = 2) => v.toFixed(k).replace('.', ',');

  // L'arbre de l'attitude politique (figures du cours 5 de FAS1001).
  const ATTITUDE = {
    racine: 'Attitude politique', sous: 'le concept',
    dims: [
      { nom: 'Immigration', qs: [{ q: 'Politique\nmigratoire', r: 'en accueillir +' }, { q: 'Intégration', r: 'favorable' }] },
      { nom: 'Économie', qs: [{ q: 'Impôts', r: 'les hausser' }, { q: 'Rôle de\nl’État', r: 'plus d’État' }] },
      { nom: 'Environnement', qs: [{ q: 'Climat', r: 'enjeu majeur' }, { q: 'Réglementation', r: 'plus de règles' }] }
    ]
  };
  const MERKLEY = {
    racine: 'Idéologie', sous: 'Merkley (2022)',
    dims: [
      { nom: 'Dimension sociale', qs: [{ q: 'Assimilation' }, { q: 'Admission\nd’immigrants' }, { q: 'Droits\négaux' }, { q: 'Mariage\nhomosexuel' }] },
      { nom: 'Dimension économique', qs: [{ q: 'Niveau\nde vie' }, { q: 'Inégalités\nde revenus' }, { q: 'Responsabilité\nindividuelle' }, { q: 'Environnement\nvs emplois' }] }
    ]
  };

  // Le plan du code : des commentaires d'abord (comme à la séance 8).
  const PLAN = "# 1. Charger ces2025.rds, créer df_clean\n# 2. Regarder une institution\n# 3. Les dix institutions, de 1-4 à 1-0 ; ne sait pas devient NA\n# 4. Vérifier le sens\n# 5. Installer sondr, une seule fois\n# 6. L'analyse factorielle : les dix\n# 7. Sans celle qui détonne\n# 8. L'échelle : la moyenne\n# 9. L'appliquer : lm(confiance ~ scolarité)\n# 10. Sauvegarder df_clean";
  const [SCRIPT_A, SCRIPT_B, SCRIPT_C] = (() => { const i = SCRIPT.indexOf('# 4.'), j = SCRIPT.indexOf('# 7.'); return [SCRIPT.slice(0, i).trimEnd(), SCRIPT.slice(i, j).trimEnd(), SCRIPT.slice(j)]; })();

  // Les trois blocs de code de la partie IA, repris tels quels du deck EIOM 2026.
  const c_capitale = `library(ellmer)

chat <- chat_openrouter(
  model = "google/gemini-3.5-flash-lite",
  echo  = "none"
)

chat$chat("Quelle est la capitale de la France ?")
#> La capitale de la France est **Paris**.`;

  const c_boucle = `library(ellmer)
library(jsonlite)

pays      <- c("France", "Japon", "Bresil")
capitales <- character(length(pays))

for (i in seq_along(pays)) {
  prompt <- paste0(
    "Quelle est la capitale de ", pays[i], " ? ",
    'Reponds uniquement par {"capitale": "..."}'
  )
  chat <- chat_openrouter(model = "google/gemini-3.5-flash-lite", echo = "none")
  reponse <- chat$chat(prompt)
  capitales[i] <- fromJSON(reponse)$capitale
}

data.frame(pays, capitales)
#>     pays capitales
#> 1 France     Paris
#> 2  Japon     Tokyo
#> 3 Bresil  Brasilia`;

  const c_renviron = `# Dans la console R
usethis::edit_r_environ()

# Le fichier s'ouvre. On y ajoute UNE des deux lignes:
GEMINI_API_KEY=votre_cle_ici
# OU
OPENROUTER_API_KEY=votre_cle_ici

# Puis: Session > Restart R
# Sans redemarrage, R ne verra rien.`;

  // Les consoles viennent de R telles quelles; seules les notes sont d'ici.
  const avec = (cle, notes = []) => ATELIER[cle].map((l, i) => ({ ...l, note: notes[i] || '' }));
  const c_charger = avec('charger', ['', 'haven : pour lire les codes de la CES', 'ces2025.rds, sauvegardé à la séance 2', 'df_raw ne change jamais']);
  const c_item = avec('item', ['pes25 : après l’élection, à la moitié des répondant.e.s. 1 = beaucoup … 4 = pas du tout, 5 = ne sait pas']);
  const c_echelle = avec('echelle', ['une fonction : 1 (beaucoup) devient 1, 4 (pas du tout) devient 0, le reste NA', 'la même recette, dix fois', '', '', '', '', '', '', '', '', '', 'NA : pas de réponse après l’élection, l’autre moitié du sondage, ou ne sait pas']);
  const c_echelle_a = c_echelle.slice(0, 6), c_echelle_b = c_echelle.slice(6);
  const c_sens = avec('sens', ['positif : qui fait confiance au fédéral fait confiance aux tribunaux. Même direction, pas de retournement']);
  const c_sondr = [...avec('installer', ['', 'sondr n’est pas sur CRAN : on l’installe depuis GitHub']), ...avec('preparer', ['', 'na.omit : seulement les gens qui ont répondu aux dix', `${nb(SATURATIONS.n)} personnes : la moitié du sondage postélectoral`])];
  const c_construire = avec('construire', ['la moyenne des neuf qu’on garde, ligne par ligne', 'de 0 à 1 ; NA : au moins une institution sans réponse']);
  const c_regression = avec('regression', ['universitaire : a fréquenté l’université (8 à 11) ou non (1 à 7)', '', `${f(REG.pente, 3)} : sur une échelle de 0 à 1, les universitaires sont ${f(Math.abs(REG.pente), 2)} plus ${REG.pente >= 0 ? 'haut' : 'bas'}`]);
</script>

<svelte:head>
  <title>POL-2000 · Séance 9 · Les variables latentes</title>
</svelte:head>

<Deck total={TOTAL} logo="{base}/img/ulaval-logo.png">
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->

    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre">
        <p class="surtitre e">POL-2000 · Méthodologie quantitative</p>
        <h1 class="e">Les variables latentes</h1>
        <hr class="filet" />
        <p class="lead e">Séance 9 · jeudi 5 novembre 2026</p>
      </div>
      <div class="entete-ul e">
        <img src="{base}/img/ulaval-logo.png" alt="Université Laval" />
        <span class="sep"></span>
        <span class="dept">Département de science politique<br />Faculté des sciences sociales</span>
        <span class="session">Automne 2026</span>
      </div>
    </Slide>

    <Slide bandeau="Où on en est" droite={D}>
      <Session ici={9} />
    </Slide>

    <Slide bandeau="Aujourd’hui" droite={D}>
      <h2 class="e">Aujourd’hui</h2>
      <Aujourdhui9 />
    </Slide>

    <!-- ================= MESURER UN CONCEPT ================= -->

    <Slide fond="encre" bandeau="Mesurer un concept" droite={D}>
      <h1 class="e">Mesurer un concept</h1>
      <hr class="filet" />
      <p class="lead e">On veut étudier des choses qu’on ne voit pas.</p>
    </Slide>

    <Slide bandeau="Mesurer un concept · vos questions" droite={D}>
      <h2 class="e">Vos questions de recherche</h2>
      <ul class="dqm e">
        <li><em>Dans quelle mesure</em> la scolarité influence-t-elle l’intérêt pour la politique ?</li>
        <li><em>Dans quelle mesure</em> gagner une élection rend-il plus satisfait de la démocratie ?</li>
        <li><em>Dans quelle mesure</em> la scolarité augmente-t-elle la confiance envers les institutions ?</li>
      </ul>
      <p class="grande-q e dqm-q">Mesure ? Pourquoi ce mot-là ?</p>
    </Slide>

    <Slide bandeau="Mesurer un concept · mesurer" droite={D}>
      <h2 class="e">Mesurer, ça veut dire quoi ?</h2>
      <M9Instruments />
    </Slide>

    <Slide bandeau="Mesurer un concept · mesurer" droite={D}>
      <h2 class="e">Mesurer un concept</h2>
      <div class="chemin e">
        <div class="etape"><span class="n">1</span><strong>Une chose</strong><span>Une longueur. Un poids. La confiance.</span></div>
        <span class="fl">→</span>
        <div class="etape"><span class="n">2</span><strong>Un instrument</strong><span>Une règle. Une balance. Une question de sondage.</span></div>
        <span class="fl">→</span>
        <div class="etape"><span class="n">3</span><strong>Un nombre</strong><span>14 cm. 68 kg. 0,72 sur une échelle de 0 à 1.</span></div>
        <span class="fl">→</span>
        <div class="etape rouge"><span class="n">4</span><strong>Calculer</strong><span>Une moyenne, un écart, une régression.</span></div>
      </div>
      <p class="petit-dit e chemin-dit">Les données, ce sont des nombres mis sur des concepts. Tout le reste du cours calcule avec.</p>
    </Slide>

    <Slide bandeau="Mesurer un concept · le problème" droite={D}>
      <p class="grande-q e">Comment mesurer ce qu’on ne peut pas voir ?</p>
      <div class="exemples e">
        <span>l’idéologie</span><span>la confiance</span><span>l’intérêt politique</span><span>l’intelligence</span>
      </div>
      <p class="petit-dit e">Aucune de ces choses n’est une colonne dans un sondage.</p>
    </Slide>

    <Slide bandeau="Mesurer un concept · la variable latente" droite={D}>
      <h2 class="e">Un concept, des facettes, des questions, des réponses</h2>
      <M9Arbre arbre={ATTITUDE} />
    </Slide>

    <Slide bandeau="Mesurer un concept · un exemple publié" droite={D}>
      <h2 class="e">L’échelle d’idéologie de Merkley (2022)</h2>
      <M9Arbre arbre={MERKLEY} reponses={false} />
      <p class="credits e">Merkley, E. (2022). Polarization Eh? Ideological Divergence and Partisan Sorting in the Canadian Mass Public. <em>Public Opinion Quarterly</em>, 86(4). Huit questions de la CES, deux dimensions, un score.</p>
    </Slide>

    <Slide bandeau="Mesurer un concept · la marche à suivre" droite={D}>
      <h2 class="e">Comment procéder</h2>
      <div class="chemin e">
        <div class="etape"><span class="n">1</span><strong>Le concept</strong><span>Ce qu’on veut mesurer. Invisible.</span></div>
        <span class="fl">→</span>
        <div class="etape"><span class="n">2</span><strong>Les indicateurs</strong><span>Des questions précises, une par facette.</span></div>
        <span class="fl">→</span>
        <div class="etape"><span class="n">3</span><strong>L’échelle</strong><span>Les réponses combinées en un score.</span></div>
        <span class="fl">→</span>
        <div class="etape rouge"><span class="n">4</span><strong>Vérifier</strong><span>Fiabilité ? Validité ?</span></div>
      </div>
    </Slide>

    <Slide bandeau="Mesurer un concept · notre concept" droite={D}>
      <h2 class="e">Notre concept : la confiance envers les institutions</h2>
      <p class="grande-q e">La scolarité augmente-t-elle la confiance envers les institutions ?</p>
      <div class="hyp">
        <p class="e">Personne ne répond à la question « faites-vous confiance aux institutions ? ».</p>
        <p class="e"><strong>Mais la CES 2025 demande la confiance envers dix institutions</strong>, une à la fois, après l’élection.</p>
      </div>
    </Slide>

    <Slide bandeau="Mesurer un concept · dix institutions" droite={D}>
      <h2 class="e">Dix institutions, une seule question</h2>
      <M9Items />
    </Slide>

    <Slide bandeau="Mesurer un concept · la qualité" droite={D}>
      <h2 class="e">Fiabilité, validité</h2>
      <M9Cible />
    </Slide>

    <!-- ================= L'EXAMEN D'HISTOIRE ================= -->

    <Slide fond="encre" bandeau="L’examen d’histoire" droite={D}>
      <h1 class="e">L’examen d’histoire</h1>
      <hr class="filet" />
      <p class="lead e">Comment savoir si une question mesure ce qu’elle prétend mesurer ?</p>
    </Slide>

    <Slide bandeau="L’examen d’histoire · cinq questions" droite={D}>
      <h2 class="e">Cinq questions, vingt-quatre élèves</h2>
      <M9Examen />
      <p class="credits e">Données fictives : un schéma.</p>
    </Slide>

    <Slide bandeau="L’examen d’histoire · ce que fait l’analyse factorielle" droite={D}>
      <p class="grande-q e">L’analyse factorielle compare toutes les questions et repère celle qui ne bouge pas avec les autres.</p>
      <p class="petit-dit e">Pour un examen comme pour un concept : les questions qui mesurent la même chose répondent ensemble.</p>
    </Slide>

    <Slide bandeau="L’examen d’histoire · trois chiffres" droite={D}>
      <h2 class="e">Trois chiffres, trois seuils</h2>
      <M9TroisChiffres />
    </Slide>

    <!-- ================= SUR LES DONNÉES, POUR VRAI ================= -->

    <Slide fond="encre" bandeau="Pratique dans R" droite={D}>
      <h1 class="e">La confiance, pour vrai</h1>
      <hr class="filet" />
      <p class="lead e">Dix institutions de la CES 2025, une échelle, une régression.</p>
    </Slide>

    <Slide bandeau="Pratique dans R · le plan" droite={D}>
      <h2 class="e">Planifions notre code</h2>
      <div class="plan">
        <Code src={PLAN} titre="seance9.R" />
        <p class="e petit-dit">D’abord les commentaires. Le code vient ensuite, sous chacun.</p>
      </div>
    </Slide>

    <Slide bandeau="Pratique dans R · regarder" droite={D}>
      <h2 class="e">Une institution, telle que la CES la code</h2>
      <Console lignes={c_item} />
    </Slide>

    <Slide bandeau="Pratique dans R · recoder" droite={D}>
      <h2 class="e">De 1 à 4 vers 1 à 0 : beaucoup = 1. Ne sait pas devient NA</h2>
      <Console lignes={c_echelle_a} />
    </Slide>

    <Slide bandeau="Pratique dans R · recoder" droite={D}>
      <h2 class="e">Les cinq autres, puis regarder</h2>
      <Console lignes={c_echelle_b} />
    </Slide>

    <Slide bandeau="Pratique dans R · le sens" droite={D}>
      <h2 class="e">Le sens : deux institutions, la même direction</h2>
      <Console lignes={c_sens} />
      <p class="petit-dit e">Si une question avait dit le contraire des autres, il aurait fallu la retourner : 1 − x.</p>
    </Slide>

    <Slide bandeau="Pratique dans R · sondr" droite={D}>
      <h2 class="e">sondr, puis les gens qui ont répondu aux dix</h2>
      <Console lignes={c_sondr} />
    </Slide>

    <Slide bandeau="Pratique dans R · l’analyse factorielle" droite={D}>
      <M8Image code={FA1.code} img={FA1.img} l={FA1.l} h={FA1.h} px={110} dit="une ligne : alpha, valeur propre, saturations" alt="Le graphique de topdown_fa : les coefficients de saturation des dix institutions en barres, de 0,73 pour le gouvernement fédéral à 0,23 pour la religion organisée, seule sous le seuil de 0,3. Alpha de Cronbach 0,85, première valeur propre 4,43." />
    </Slide>

    <Slide bandeau="Pratique dans R · lire" droite={D}>
      <h2 class="e">Une institution détonne</h2>
      <M9Saturations />
    </Slide>

    <Slide bandeau="Pratique dans R · lire" droite={D}>
      <h2 class="e">Le cigare de Churchill de la CES</h2>
      <M9Items marquer={['religion']} raisons={{ religion: 'faire confiance à une Église, ce n’est pas faire confiance à l’État' }} echelle={false} />
    </Slide>

    <Slide bandeau="Pratique dans R · recommencer" droite={D}>
      <M8Image code={FA2.code} img={FA2.img} l={FA2.l} h={FA2.h} px={110} nouveau={[0]} dit="sans la religion organisée : alpha 0,86, tout au-dessus du seuil" alt="Le graphique de topdown_fa sans la religion organisée : neuf barres, toutes au-dessus de 0,3, de 0,48 à 0,73. Alpha de Cronbach 0,86, première valeur propre 4,36." />
    </Slide>

    <Slide bandeau="Pratique dans R · la validité" droite={D}>
      <h2 class="e">La fiabilité, oui. La validité ?</h2>
      <Deux ratio="1fr 1fr">
        <Carte ton="ciel" titre="Concordance avec la théorie">
          <p>Les neuf institutions sont-elles bien celles dont parle la littérature sur la confiance politique ? L’État, les tribunaux, la police, oui. Une Église, non.</p>
        </Carte>
        <Carte ton="vert" titre="Concordance avec d’autres mesures">
          <p>L’échelle se comporte-t-elle comme on s’y attend ? Plus de confiance chez qui est satisfait de la démocratie (séance 8), moins chez qui a voté pour un parti perdant.</p>
        </Carte>
      </Deux>
      <p class="petit-dit e">La fiabilité est statistique : les chiffres la vérifient. La validité est théorique : c’est vous qui la défendez.</p>
    </Slide>

    <Slide bandeau="Pratique dans R · l’échelle" droite={D}>
      <h2 class="e">L’échelle : la moyenne des neuf</h2>
      <Console lignes={c_construire} />
    </Slide>

    <Slide bandeau="Pratique dans R · l’échelle" droite={D}>
      <M8Image code={HIST.code} img={HIST.img} l={HIST.l} h={HIST.h} px={100} dit="une variable comme une autre, de 0 à 1" alt="L'histogramme de l'échelle de confiance envers les institutions, de 0 à 1." />
    </Slide>

    <Slide bandeau="Pratique dans R · l’appliquer" droite={D}>
      <h2 class="e">La scolarité augmente-t-elle la confiance ?</h2>
      <Console lignes={c_regression} />
    </Slide>

    <Slide bandeau="Mesurer un concept · retenir" droite={D}>
      <h2 class="e">Retenir</h2>
      <ol class="retenir e">
        <li><span>Un concept ne se voit pas. On le mesure par ses indicateurs.</span></li>
        <li><span>Plusieurs questions valent mieux qu’une, si elles répondent ensemble.</span></li>
        <li><span>Même sens, même échelle, pas de « ne sait pas » caché dans un chiffre.</span></li>
        <li><span>La fiabilité est statistique, les chiffres la vérifient. La validité est théorique, c’est votre argument.</span></li>
      </ol>
    </Slide>

    <!-- ================= CE QU'EST UN MODÈLE DE LANGUE =================
         Diapositives 6 à 45 du deck EIOM 2026 « L'IA en recherche », reprises
         telles quelles. Seuls le bandeau de droite et deux renvois à la semaine
         de l'École d'été ont changé. -->

    <Slide fond="encre" bandeau="Définir l’IA" droite={D}>
      <h1 class="e">Qu’est-ce que l’IA ?</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Définir l’IA" droite={D}>
      <h2 class="e">Il y a plusieurs définitions de l’IA</h2>
      <hr class="filet" />
      <ul class="defs e">
        <li class="retenue">
          <span class="lettre">A</span>
          <span class="q">Est-ce que le système peut décider et agir ? <Cite k="russell2020" /></span>
        </li>
        <li>
          <span class="lettre">B</span>
          <span class="q">Est-ce que le système peut passer pour un humain ? <Cite k="turing1950" /></span>
        </li>
        <li>
          <span class="lettre">C</span>
          <span class="q">Est-ce que le système décide par la logique ? <Cite k="jordan2015" /></span>
        </li>
      </ul>
      <p class="e">
        Aucun consensus : beaucoup plus de définitions recensées.
        <Cite k="legg2007" /> <Cite k="wang2019" />
      </p>
    </Slide>

    <Slide fond="encre" bandeau="Définir l’IA" droite={D}>
      <h2 class="e">Les grands modèles de langue répondent aux trois</h2>
      <hr class="filet" />
      <ul class="defs e">
        <li class="retenue">
          <span class="lettre">A</span>
          <span class="q">Ils décident et agissent</span>
        </li>
        <li class="retenue">
          <span class="lettre">B</span>
          <span class="q">Ils passent pour des humains <Cite k="jones2025" /></span>
        </li>
        <li class="retenue">
          <span class="lettre">C</span>
          <span class="q">Ils prédisent le prochain jeton par la statistique</span>
        </li>
      </ul>
    </Slide>

    <Slide bandeau="Une histoire de l’IA" droite={D}>
      <h2 class="e">Histoire de l’IA</h2>
      <Frise />
    </Slide>

    <Slide bandeau="Situer les familles" droite={D}>
      <h2 class="e">Arbre généalogique de l’IA</h2>
      <Arbre />
      <p class="e credits">
        Schéma original, inspiré de l’arbre évolutif des LLM de <Cite k="yang2023" />.
      </p>
    </Slide>

    <Slide fond="encre" bandeau="Les modèles de langage" droite={D}>
      <h1 class="e">Comment fonctionne<br />un modèle de langage</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Les données d’entraînement" droite={D}>
      <h2 class="e">Les données d’entraînement</h2>
      <Corpus />
      <p class="e credits">
        Parts et époques : corpus d’entraînement de LLaMA, tableau 1 <Cite k="touvron2023" />.
        Sites les plus représentés de C4 <Cite k="dodge2021" />.
      </p>
    </Slide>

    <Slide bandeau="Mécanique" droite={D}>
      <h2 class="e">Tout ce qu’il fait, c’est prédire le jeton suivant</h2>
      <Generation />
    </Slide>

    <Slide bandeau="Mécanique" droite={D}>
      <h2 class="e">Le modèle ne voit pas des mots</h2>
      <p class="e">La phrase qu’il vient d’écrire, telle qu’il l’a vue :</p>
      <Tokeniseur />
      <p class="e credits">
        Le surcoût vaut pour toutes les langues éloignées de l’anglais, et la qualité y baisse
        aussi <Cite k="ahia2023" />.
      </p>
    </Slide>

    <Slide bandeau="Ce qu’un LLM n’est pas" droite={D}>
      <h2 class="e">Ce n’est pas une base de connaissances</h2>
      <Connaissances />
      <Citation source="Le principe à retenir">
        Une référence bibliographique produite par un modèle est une <em>hypothèse de référence</em>
        jusqu’à ce que vous l’ayez vérifiée dans un catalogue.
      </Citation>
    </Slide>

    <Slide bandeau="Poids ouverts" droite={D}>
      <h2 class="e">Un poids, c’est la force d’un lien</h2>
      <Poids />
      <p class="e credits">
        Poids réels de <code>q_proj</code>, couche 0, lus dans le fichier <code>model.safetensors</code>
        de Qwen2.5-0.5B. Modèle ouvert : on peut le télécharger et tout lister.
      </p>
    </Slide>

    <Slide bandeau="Reformulation" droite={D}>
      <h2 class="e">L’hallucination n’est pas un bug</h2>
      <Hallucination />
      <p class="e credits">
        Sortie contrainte · vérification externe · validation sur vérité terrain : les trois parades.
      </p>
    </Slide>

    <Slide fond="encre" bandeau="Les biais" droite={D}>
      <h1 class="e">Les biais</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Trois entrées, une seule chaîne" droite={D}>
      <h2 class="e">Le biais entre à trois endroits</h2>
      <Biais />
      <p class="e credits">
        Composition du corpus d’entraînement de LLaMA <Cite k="touvron2023" />.
      </p>
    </Slide>

    <Slide fond="encre" bandeau="Deuxième temps" droite={D}>
      <h1 class="e">Pourquoi ne pas utiliser le chat classique<br />mais l’API ?</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Situer la chose" droite={D}>
      <h2 class="e">Un API, c’est une adresse à qui on écrit</h2>
      <Api />
      <p class="e">
        Le modèle ne s’installe pas sur votre poste. Votre script lui envoie du texte&nbsp;; il en
        renvoie. Un API, c’est ce point d’entrée&nbsp;: une adresse à qui on écrit, et qui répond.
      </p>
    </Slide>

    <Slide bandeau="Où c’est, physiquement" droite={D}>
      <h2 class="e">Les LLMs sont tangibles</h2>
      <Centre />
      <p class="e credits">
        Colossus, à Memphis : nombre de GPU <Cite k="nvidia2024" />, turbines
        <Cite k="techcrunch2025" />. Équivalent en foyers calculé d’après la fiche technique du
        H100 SXM et la consommation résidentielle moyenne d’Hydro-Québec. Eau <Cite k="li2023" />.
      </p>
    </Slide>

    <Slide bandeau="Le contexte" droite={D}>
      <h2 class="e">Chat vs API</h2>
      <Contexte />
    </Slide>

    <Slide bandeau="La fiche de méthode" droite={D}>
      <h2 class="e">Ce que l’API rend possible</h2>
      <Fiches />
    </Slide>

    <Slide bandeau="Le paramètre qui compte" droite={D}>
      <h2 class="e">La température</h2>
      <Temperature />
    </Slide>

    <Slide fond="encre" bandeau="Pause" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <Minuterie minutes={15} />
      <p class="lead e">Pendant la pause, allez chercher votre clé.</p>
      <ul class="cmd-liste e">
        <li>aistudio.google.com/apikey<span class="lieu">un compte Google suffit · aucune carte de crédit</span></li>
      </ul>
    </Slide>

    <Slide fond="encre" bandeau="Troisième temps" droite={D}>
      <h1 class="e">Premier appel,<br />sur de vraies données</h1>
      <hr class="filet" />
      <p class="lead e">De la réponse en texte libre à la variable exploitable.</p>
    </Slide>

    <Slide bandeau="Le corpus" droite={D}>
      <h2 class="e">La Ligne Rouge</h2>
      <MurAvis />
    </Slide>

    <Slide bandeau="L’ancienne façon" droite={D}>
      <h2 class="e">Avant : Utilisation de dictionnaires</h2>
      <Dictionnaire />
    </Slide>

    <Slide bandeau="La nouvelle façon" droite={D}>
      <h2 class="e">Maintenant : Utilisation de LLMs</h2>
      <Classifieur />
    </Slide>

    <Slide bandeau="La même donnée, d’autres questions" droite={D}>
      <h2 class="e">On ne change pas la donnée, on change la consigne</h2>
      <Extractions />
      <p class="e credits">
        Six appels réels à <code>gemini-3.5-flash-lite</code>, température 0, sortie JSON imposée.
      </p>
    </Slide>

    <Slide bandeau="Outillage" droite={D}>
      <div class="ell e">
        <figure class="ell-logo">
          <img src="{base}/img/ellmer.png" alt="Logo du package R ellmer" />
        </figure>
        <div class="ell-txt">
          <h2 class="e">ellmer</h2>
          <p class="ell-sous">Un package R pour parler aux modèles de langage.</p>
          <ul class="ell-pts">
            <li><strong>Vingt-trois fournisseurs</strong>, une seule syntaxe</li>
            <li>Changer de modèle tient sur une ligne</li>
            <li>Maintenu par l’équipe de tidyverse</li>
          </ul>
          <p class="ell-cmd">install.packages("ellmer")</p>
        </div>
      </div>
      <Code
        petit
        src={`chat_openrouter(model = "${FOURNISSEUR_SECOURS.modele}")
chat_google_gemini(model = "${FOURNISSEUR.modele}")
chat_openai(model  = "gpt-4o-mini")
chat_anthropic(model = "claude-sonnet-5")
chat_ollama(model = "gemma3")     # sur VOTRE machine`}
      />
    </Slide>

    <Slide bandeau="Le plus petit appel possible" droite={D}>
      <h2 class="e">Poser une question, obtenir du texte</h2>
      <Code src={c_capitale} />
    </Slide>

    <Slide d={0.86} bandeau="La boucle" droite={D}>
      <h2 class="e">Le même geste, sur un vecteur</h2>
      <Code src={c_boucle} />
    </Slide>

    <Slide bandeau="Le catalogue" droite={D}>
      <h2 class="e">Comment choisir son modèle ?</h2>
      <Modeles />
      <p class="e credits">Catalogue OpenRouter relevé le 24 août 2026.</p>
    </Slide>

    <Slide bandeau="Le prix, en vrai" droite={D}>
      <h2 class="e">Comment interpréter le coût</h2>
      <Prix />
      <p class="e credits">
        Tarifs relevés sur anthropic.com/pricing le 24 août 2026. Jetons comptés sur les 551 avis
        réels du corpus; les prix d’Anthropic s’appliquent à leur propre tokeniseur, l’ordre de
        grandeur tient.
      </p>
    </Slide>

    <Slide bandeau="Un classement par duels" droite={D}>
      <h2 class="e">LM Arena</h2>
      <Arena />
      <p class="e credits">
        Méthode et volume de votes <Cite k="chiang2024" />.
      </p>
    </Slide>

    <Slide bandeau="Sécurité" droite={D}>
      <h2 class="e">La clé se dépose dans .Renviron</h2>
      <Code src={c_renviron} />
      <Deux>
        <Carte ton="rose" titre="Jamais">
          <p>Jamais dans un script. Jamais dans un dépôt Git. Jamais dans une capture d’écran de diapositive.</p>
        </Carte>
      </Deux>
    </Slide>

    <Slide bandeau="La marche à suivre" droite={D}>
      <h2 class="e">D’abord un échantillon, ensuite tout le corpus</h2>
      <Echantillon />
    </Slide>

    <Slide fond="encre" bandeau="Quatrième temps" droite={D}>
      <h1 class="e">Concevoir un prompt</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="La formule" droite={D}>
      <h2 class="e">Rôle → Tâche → Contraintes → Format</h2>
      <Anatomie />
    </Slide>

    <Slide bandeau="Avant / après" droite={D}>
      <h2 class="e">Le même besoin, deux prompts</h2>
      <div class="compare-p e">
        <div class="p faible">
          <span class="et">FAIBLE</span>
          <p class="txt">Analyse ce texte et dis-moi ce que tu en penses.</p>
          <p class="pourquoi">Aucun critère, aucun format. La sortie change à chaque appel.</p>
        </div>
        <div class="p solide">
          <span class="et">SOLIDE</span>
          <p class="txt">
            Tu codes des avis de restaurant pour une recherche en sciences sociales. Attribue la note
            en étoiles que l’auteur a le plus vraisemblablement laissée. Fonde-toi sur le jugement
            global, pas sur le nombre de mots positifs. Réponds selon le schéma fourni.
          </p>
          <p class="pourquoi">Rôle, tâche, critère de décision, format. Les quatre y sont.</p>
        </div>
      </div>
    </Slide>

    <Slide bandeau="Un conseil qui surprend" droite={D}>
      <h2 class="e">Demandez à l’IA d’écrire le prompt</h2>
      <Deux ratio="1fr 1fr">
        <Carte ton="ciel" titre="Ce que vous écrivez">
          <p>
            « Je veux classer des avis de restaurant sur une échelle de −1 à +1. Écris-moi le prompt
            système qui fera ça, avec un format de sortie strict. »
          </p>
        </Carte>
        <Carte ton="vert" titre="Ce que vous obtenez">
          <p>
            Un prompt mieux structuré que le vôtre, en quelques secondes. Vous le lisez, vous le
            corrigez, vous le gardez dans votre script.
          </p>
        </Carte>
      </Deux>
    </Slide>

    <Slide bandeau="Mesurer" droite={D}>
      <h2 class="e">La précision du modèle n’est pas toujours la bonne mesure</h2>
      <Mesures />
    </Slide>

    <Slide bandeau="Confidentialité" droite={D}>
      <h2 class="e">Confidentialité des données</h2>
      <Donnees />
      <p class="e credits">
        Règles de l’API relevées dans la documentation d’OpenAI le 24 août 2026.
      </p>
    </Slide>

    <Slide bandeau="La règle du cours" droite={D}>
      <h2 class="e">La règle du cours</h2>
      <M9Regle />
    </Slide>

    <!-- ================= AVANT LE 12 NOVEMBRE ================= -->

    <Slide bandeau="Avant le 12 novembre" droite={D}>
      <h2 class="e">Trois choses</h2>
      <AvantS10 />
      <p class="greve e"><strong>Grève le 12 novembre.</strong> Je serai sur place. S’il y a piquetage, le cours et l’examen 2 pourraient être reportés. Surveillez votre courriel.</p>
    </Slide>

    <Slide fond="encre" bandeau="Avant le 12 novembre" droite={D}>
      <h1 class="e">Jeudi 12 novembre</h1>
      <hr class="filet" />
      <p class="lead e">Le problème fondamental de l’inférence causale. Puis l’examen 2.</p>
      <p class="lead e greve-encre">Sous réserve de la grève : s’il y a piquetage, je vous écris.</p>
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

    <!-- ================= ANNEXE : TOUT LE CODE ================= -->

    <Slide fond="encre" bandeau="Annexe" droite={D}>
      <h1 class="e">Annexe : tout le code</h1>
      <hr class="filet" />
      <p class="lead e">La confiance envers les institutions dans la CES 2025, étape par étape. À refaire chez vous.</p>
    </Slide>

    <Slide bandeau="Annexe · charger" droite={D}>
      <h2 class="e">Avant de commencer, dans Positron</h2>
      <Console lignes={c_charger} />
    </Slide>

    <Slide bandeau="Annexe · le script 1/3" droite={D}>
      <div class="plan">
        <Code src={SCRIPT_A} titre="seance9.R" />
      </div>
    </Slide>

    <Slide bandeau="Annexe · le script 2/3" droite={D}>
      <div class="plan">
        <Code src={SCRIPT_B} titre="seance9.R" />
      </div>
    </Slide>

    <Slide bandeau="Annexe · le script 3/3" droite={D}>
      <div class="plan">
        <Code src={SCRIPT_C} titre="seance9.R" />
      </div>
    </Slide>

    <Slide bandeau="Annexe · sources" droite={D}>
      <h2 class="e">Sources de la partie IA</h2>
      <hr class="filet" />
      <div class="biblio-boite e">
        <ul class="biblio">
        {#each ORDRE_BIBLIO as k}
          <li>
            <span class="b-auteurs">{REFERENCES[k].auteurs}</span>,
            <span class="b-titre">{REFERENCES[k].titre}</span>.
            <span class="b-detail">{REFERENCES[k].detail}</span>
          </li>
        {/each}
        </ul>
      </div>
      <p class="e credits">
        Images d’archives, Wikimedia Commons :
        {#each Object.values(CREDITS_IMAGES) as c, i}{i > 0 ? ' · ' : ''}{c.auteur} ({c.licence}){/each}
      </p>
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

.plan { max-width: 46em; margin: 1em auto 0; display: flex; flex-direction: column; gap: 0.8em; }
.petit-dit { margin: 0; color: var(--dk-gris); font-size: 0.85em; }
.grande-q { font-size: 2em; line-height: 1.3; max-width: 22em; margin-top: 1.2em; }
.dqm { list-style: none; margin: 1.2em 0 0; padding: 0; display: flex; flex-direction: column; gap: 0.9em; font-size: 1.25em; line-height: 1.35; max-width: 30em; }
.dqm em { font-style: normal; font-weight: 700; color: var(--dk-accent); }
.dqm-q { margin-top: 1.4em; }
.chemin-dit { text-align: center; margin-top: 1.4em; font-size: 1em; }
.exemples { display: flex; flex-wrap: wrap; gap: 0.8em 1.6em; margin: 1.2em 0 1em; font-size: 1.4em; font-weight: 600; color: var(--dk-accent); }
.hyp { margin-top: 1.6em; display: flex; flex-direction: column; gap: 0.5em; font-size: 1.25em; }
.hyp p { margin: 0; }

.chemin { display: grid; grid-template-columns: 1fr auto 1fr auto 1fr auto 1fr; gap: 0.8em; align-items: center; max-width: 64em; margin: 1.6em auto 0; }
.etape { border: 3px solid var(--dk-encre); padding: 1em 1.1em 1.1em; display: flex; flex-direction: column; gap: 0.3em; min-height: 9em; }
.etape.rouge { border-color: var(--dk-accent); }
.etape .n { font-size: 0.7em; letter-spacing: 0.14em; color: var(--dk-gris); font-weight: 600; }
.etape strong { font-size: 1.2em; line-height: 1.2; }
.etape.rouge strong { color: var(--dk-accent); }
.etape span:last-child { font-size: 0.8em; color: var(--dk-gris); line-height: 1.35; }
.chemin .fl { font-size: 1.6em; font-weight: 700; color: var(--dk-gris-2); }

.retenir { margin: 1.4em 0 0; padding-left: 1.6em; font-size: 1.3em; line-height: 1.4; display: flex; flex-direction: column; gap: 0.6em; max-width: 30em; }
.retenir li::marker { color: var(--dk-accent); font-weight: 700; }
.greve { max-width: 64em; margin: 1.2em auto 0; font-size: 0.95em; border-left: 8px solid var(--dk-accent); padding-left: 0.9em; }
.greve strong { color: var(--dk-accent); }
.greve-encre { margin-top: 1em; color: var(--dk-accent-clair); font-size: 1.05em; }
</style>
