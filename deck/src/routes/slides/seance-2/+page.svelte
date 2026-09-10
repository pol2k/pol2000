<script>
  /**
   * POL-2000 — Séance 2 · Introduction à R et à Positron
   * Jeudi 10 septembre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine: moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine. La séance se donne en direct : la
   * salle tape sur son propre ordinateur ce que le projecteur montre.
   *
   * Rien n'est inventé pour une sortie de R. Chaque réponse affichée dans
   * une Console vient d'un vrai R 4.6.1, avec le jeu `swiss` livré avec R
   * (47 provinces suisses, 1888) ; les figures dessinent les vraies valeurs
   * (src/lib/data/swiss.js, généré par outils/swiss_data.R).
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Deux from '$lib/deck/Deux.svelte';
  import Grand from '$lib/deck/Grand.svelte';
  import Code from '$lib/deck/Code.svelte';
  import RPositron from '$lib/deck/visuels/RPositron.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import IA from '$lib/deck/visuels/IA.svelte';
  import Console from '$lib/deck/visuels/Console.svelte';
  import Logiciels from '$lib/deck/visuels/Logiciels.svelte';
  import RaisonsR from '$lib/deck/visuels/RaisonsR.svelte';
  import Ressources from '$lib/deck/visuels/Ressources.svelte';
  import Organisations from '$lib/deck/visuels/Organisations.svelte';
  import Positron from '$lib/deck/visuels/Positron.svelte';
  import Arborescence from '$lib/deck/visuels/Arborescence.svelte';
  import Chemins from '$lib/deck/visuels/Chemins.svelte';
  import Charger from '$lib/deck/visuels/Charger.svelte';
  import Mentalite from '$lib/deck/visuels/Mentalite.svelte';
  import Anatomie from '$lib/deck/visuels/Anatomie.svelte';
  import Types from '$lib/deck/visuels/Types.svelte';
  import Machine from '$lib/deck/visuels/Machine.svelte';
  import Syntaxe from '$lib/deck/visuels/Syntaxe.svelte';
  import Erreurs from '$lib/deck/visuels/Erreurs.svelte';
  import Packages from '$lib/deck/visuels/Packages.svelte';
  import Histo from '$lib/deck/visuels/Histo.svelte';
  import Pipe from '$lib/deck/visuels/Pipe.svelte';
  import Nuage from '$lib/deck/visuels/Nuage.svelte';
  import Prompt from '$lib/deck/visuels/Prompt.svelte';
  import Verifier from '$lib/deck/visuels/Verifier.svelte';
  import Empreinte from '$lib/deck/visuels/Empreinte.svelte';
  import Etudes from '$lib/deck/visuels/Etudes.svelte';

  const TOTAL = 50;
  const D = 'POL-2000 · séance 2 · jeu 10 sept';

  // ---- Les consoles. Sorties copiées de R 4.6.1, jamais tapées à la main. ----
  const c_calc = [
    { in: '2 + 2', out: '[1] 4' },
    { in: '10 / 3', out: '[1] 3.333333' },
    { in: '2^10', out: '[1] 1024' },
    { in: '1:30', out: ' [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22\n[23] 23 24 25 26 27 28 29 30', note: 'Le [1] et le [23] : la position du premier élément de chaque ligne. R répond toujours par une liste, même d’un seul nombre.' }
  ];
  const c_objet = [
    { in: 'age <- 25', out: '', note: 'Rien ne s’affiche. R a rangé 25 dans age. Regardez « Variables ».' },
    { in: 'age', out: '[1] 25' },
    { in: 'age + 1', out: '[1] 26' },
    { in: 'age', out: '[1] 25', note: 'Toujours 25. Calculer n’est pas ranger : sans flèche, rien ne change.' },
    { in: 'age <- age + 1\nage', out: '[1] 26' }
  ];
  const c_vecteur = [
    { in: 'ages <- c(24, 30, 19, 45)\nages', out: '[1] 24 30 19 45', note: 'c() pour « combiner ». Quatre nombres, un seul objet : un vecteur.' },
    { in: 'mean(ages)', out: '[1] 29.5' },
    { in: 'length(ages)', out: '[1] 4' },
    { in: 'ages > 25', out: '[1] FALSE  TRUE FALSE  TRUE', note: 'Une question posée à chacun. Quatre réponses.' },
    { in: 'sum(ages > 25)', out: '[1] 2', note: 'TRUE compte pour 1. Combien ont plus de 25 ans : deux.' }
  ];
  const c_na = [
    { in: 'mean(c(24, NA, 30))', out: '[1] NA', note: 'Un seul manquant, et R refuse de répondre. Il a raison : il ne sait pas.' },
    { in: 'mean(c(24, NA, 30), na.rm = TRUE)', out: '[1] 27', note: 'na.rm = TRUE : « ignore les manquants ». Vous le taperez des centaines de fois.' }
  ];
  const c_explorer = [
    { in: 'df <- swiss', out: '', note: 'swiss est livré avec R. On le copie dans df, le nom qu’on donnera à tous nos tableaux.' },
    { in: 'nrow(df)', out: '[1] 47' },
    { in: 'ncol(df)', out: '[1] 6' },
    { in: 'names(df)', out: '[1] "Fertility"        "Agriculture"      "Examination"      "Education"        "Catholic"        \n[6] "Infant.Mortality"' },
    { in: 'head(df)', out: '             Fertility Agriculture Examination Education Catholic Infant.Mortality\nCourtelary        80.2        17.0          15        12     9.96             22.2\nDelemont          83.1        45.1           6         9    84.84             22.2\nFranches-Mnt      92.5        39.7           5         5    93.40             20.2\nMoutier           85.8        36.5          12         7    33.77             20.3\nNeuveville        76.9        43.5          17        15     5.16             20.6\nPorrentruy        76.1        35.3           9         7    90.57             26.6', note: 'Une ligne, une province. Une colonne, une variable. Les données bien rangées de jeudi dernier.' },
    { in: 'View(df)', out: '', note: 'S’ouvre dans l’onglet Données de Positron. Le tableau entier, à faire défiler.' }
  ];
  const c_variable = [
    { in: 'df$Fertility', out: ' [1] 80.2 83.1 92.5 85.8 76.9 76.1 83.8 92.4 82.4 82.9 87.1 64.1 66.9\n[14] 68.9 61.7 68.3 71.7 55.7 54.3 65.1 65.5 65.0 56.6 57.4 72.5 74.2\n[27] 72.0 60.5 58.3 65.4 75.5 69.3 77.3 70.5 79.4 65.0 92.2 79.3 70.4\n[40] 65.7 72.7 64.4 77.6 67.6 35.0 44.7 42.8', note: 'Le $ sort une colonne du tableau. Une colonne, c’est un vecteur : tout ce qu’on sait faire aux vecteurs marche.' },
    { in: 'mean(df$Fertility)', out: '[1] 70.14255' },
    { in: 'summary(df$Fertility)', out: '   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. \n  35.00   64.70   70.40   70.14   78.45   92.50 ', note: 'Six chiffres pour une variable. Jeudi prochain, on apprend à les lire.' }
  ];
  const c_dplyr = [
    { in: 'library(dplyr)', out: '', note: 'La boîte à outils pour manipuler des tableaux. Elle vient avec le tidyverse.' },
    { in: 'df |> select(Fertility, Education) |> head(3)', out: '             Fertility Education\nCourtelary        80.2        12\nDelemont          83.1         9\nFranches-Mnt      92.5         5', note: 'select() choisit des colonnes.' },
    { in: 'df |> filter(Education > 20)', out: '             Fertility Agriculture Examination Education Catholic Infant.Mortality\nLausanne          55.7        19.4          26        28    12.11             20.2\nNeuchatel         64.4        17.6          35        32    16.92             23.0\nV. De Geneve      35.0         1.2          37        53    42.34             18.0\nRive Droite       44.7        46.6          16        29    50.43             18.2\nRive Gauche       42.8        27.7          22        29    58.33             19.3', note: 'filter() garde des lignes. Cinq provinces sur 47 dépassent 20 % de scolarité. Les villes.' }
  ];
  const c_groupe = [
    { in: 'df |>\n  mutate(catholique = Catholic > 50) |>\n  group_by(catholique) |>\n  summarise(fertilite = mean(Fertility), n = n())', out: '# A tibble: 2 × 3\n  catholique fertilite     n\n  <lgl>          <dbl> <int>\n1 FALSE           66.2    29\n2 TRUE            76.5    18', note: 'mutate() crée une colonne ; group_by() sépare ; summarise() résume chaque groupe. Trois verbes, une question : la fécondité diffère-t-elle selon la religion ?' }
  ];
  const c_lm = [
    { in: 'cor(df$Education, df$Fertility)', out: '[1] -0.6637889', note: 'Une corrélation négative : plus de scolarité, moins de fécondité. Séance 3.' },
    { in: 'lm(Fertility ~ Education, data = df)', out: '\nCall:\nlm(formula = Fertility ~ Education, data = df)\n\nCoefficients:\n(Intercept)    Education  \n    79.6101      -0.8624  ', note: 'La même ligne que jeudi dernier. Chaque point de scolarité en plus : 0,86 de fécondité en moins. Séance 7.' }
  ];

  const script = `# POL-2000 · séance 2 · Introduction à R et à Positron
# À refaire chez vous, ligne par ligne, Ctrl + Entrée.

# 1. Charger la boîte à outils (installée une fois : install.packages("tidyverse"))
library(dplyr)
library(ggplot2)

# 2. Un jeu de données livré avec R : 47 provinces suisses, 1888
df <- swiss
nrow(df)
names(df)
head(df)

# 3. Une variable
mean(df$Fertility)
summary(df$Fertility)
hist(df$Fertility)

# 4. Choisir des colonnes, garder des lignes, résumer par groupe
df |> select(Fertility, Education) |> head()
df |> filter(Education > 20)
df |>
  mutate(catholique = Catholic > 50) |>
  group_by(catholique) |>
  summarise(fertilite = mean(Fertility), n = n())

# 5. Un graphique, couche par couche
ggplot(df, aes(x = Education, y = Fertility)) +
  geom_point() +
  labs(x = "Scolarité au-delà du primaire (%)", y = "Indice de fécondité",
       title = "47 provinces suisses, 1888") +
  geom_smooth(method = "lm")

# 6. Une ligne, un résultat
lm(Fertility ~ Education, data = df)

# 7. À vous : remplacez Education par Agriculture, partout. Que change-t-il ?`;
  // Trop long pour une seule diapo à taille lisible: deux diapos, coupées
  // entre l'exploration (1 à 3) et la manipulation (4 à 7).
  const coupe = script.indexOf('\n# 4. ');
  const script1 = script.slice(0, coupe);
  const script2 = script.slice(coupe + 1);
  // Même raison pour l'exploration du tableau: les compteurs d'un côté,
  // le tableau lui-même de l'autre.
  const c_explorer1 = c_explorer.slice(0, 4);
  const c_regarder = c_explorer.slice(4);
</script>

<svelte:head>
  <title>POL-2000 · Séance 2 — Introduction à R et à Positron</title>
</svelte:head>

<Deck total={TOTAL} logo="{base}/img/ulaval-logo.png">
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->
    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre">
        <p class="surtitre e">POL-2000 · Méthodologie quantitative</p>
        <h1 class="e">Introduction à R et à Positron</h1>
        <hr class="filet" />
        <p class="lead e">Séance 2 · jeudi 10 septembre 2026</p>
      </div>
      <div class="entete-ul e">
        <img src="{base}/img/ulaval-logo.png" alt="Université Laval" />
        <span class="sep"></span>
        <span class="dept">Département de science politique<br />Faculté des sciences sociales</span>
        <span class="session">Automne 2026</span>
      </div>
    </Slide>

    <Slide bandeau="Où on en est" droite={D}>
      <Session ici={2} />
    </Slide>

    <Slide bandeau="Un tour de salle" droite={D}>
      <h2 class="e">À main levée</h2>
      <ol class="mains e">
        <li><span>R et Positron sont installés ?</span></li>
        <li><span>Vous avez ouvert Positron au moins une fois ?</span></li>
        <li><span>Avez-vous accepté l’invitation à Slack ?</span></li>
        <li><span>Avez-vous accepté l’invitation à Datacamp ?</span></li>
      </ol>
    </Slide>

    <!-- ================= 1 · POURQUOI R ================= -->
    <Slide fond="encre" bandeau="Pourquoi R" droite={D}>
      <h1 class="e une-ligne">« Pourquoi pas Excel ? »</h1>
      <hr class="filet" />
      <p class="lead e">Parce qu’un clic ne laisse pas de trace.</p>
    </Slide>

    <Slide bandeau="Pourquoi R" droite={D}>
      <h2 class="e">Pourquoi R ?</h2>
      <RaisonsR />
    </Slide>

    <Slide bandeau="Pourquoi R" droite={D}>
      <h2 class="e">Vous pouvez même créer le vôtre</h2>
      <div class="cran e">
        <figure>
          <img src="{base}/img/cran-ces.png" alt="La page du package ces sur le CRAN : Access to Canadian Election Study Data, version 1.1.0, auteur Laurence-Olivier M. Foisy." />
        </figure>
        <div class="cran-txt">
          <p class="surtitre">cran.r-project.org/package=ces</p>
          <p class="lead">Le package <code>ces</code> : les données de l’Étude électorale canadienne, de 1965 à 2025, en une ligne de R.</p>
          <p class="lead">Écrit par votre prof. Publié sur le dépôt officiel. Vous l’utiliserez tout à l’heure.</p>
          <Code src={'install.packages("ces")'} />
        </div>
      </div>
    </Slide>

    <Slide bandeau="Pourquoi R" droite={D}>
      <h2 class="e">Ça s’apprend, et gratuitement</h2>
      <Ressources />
    </Slide>

    <Slide fond="plein" bandeau="Pourquoi R" droite={D}>
      <figure class="capture plein e">
        <img src="{base}/img/ggplot-ces.png" alt="Graphique à barres : intention de vote selon l’âge à l’élection fédérale de 2025, cinq partis par groupe d’âge." />
        <figcaption>Les plus beaux graphiques : ggplot2 · l’Étude électorale canadienne 2025 · vous en ferez un aujourd’hui</figcaption>
      </figure>
    </Slide>

    <Slide bandeau="Pourquoi R" droite={D}>
      <h2 class="e">Ils l’utilisent aussi</h2>
      <Organisations />
    </Slide>

    <Slide bandeau="Pourquoi R" droite={D}>
      <h2 class="e">Les logiciels d’analyse</h2>
      <Logiciels />
    </Slide>
    <Slide bandeau="Le bureau" droite={D}>
      <h2 class="e">Les deux outils du semestre</h2>
      <RPositron />
    </Slide>

    <Slide fond="plein" bandeau="Le bureau" droite={D}>
      <h2 class="e">Positron, zone par zone</h2>
      <Positron />
    </Slide>

    <Slide bandeau="Avant de commencer" droite={D}>
      <h2 class="e">Avant de commencer : l’arborescence des fichiers</h2>
      <Arborescence />
    </Slide>

    <Slide bandeau="Avant de commencer" droite={D}>
      <h2 class="e">Deux façons d’écrire un chemin</h2>
      <Chemins />
    </Slide>

    <Slide bandeau="Avant de commencer" droite={D}>
      <h2 class="e">Charger ses propres données</h2>
      <Charger />
    </Slide>

    <Slide bandeau="Le bureau" droite={D}>
      <h2 class="e">Avant de commencer : la mentalité à adopter</h2>
      <Mentalite />
    </Slide>

    <!-- ================= 3 · EN DIRECT, LA CONSOLE ================= -->
    <Slide fond="encre" bandeau="En direct" droite={D}>
      <h1 class="e">En direct</h1>
      <hr class="filet" />
      <p class="lead e">Tapez avec moi. Une ligne à la fois, dans la console.</p>
      <p class="lead e">Une erreur ? C’est prévu. On la lit ensemble.</p>
    </Slide>

    <Slide bandeau="En direct · la console" droite={D}>
      <h2 class="e">Une calculatrice</h2>
      <Console lignes={c_calc} />
    </Slide>

    <Slide bandeau="En direct · les objets" droite={D}>
      <h2 class="e">Ranger un résultat</h2>
      <Console lignes={c_objet} />
    </Slide>

    <Slide bandeau="En direct · les objets" droite={D}>
      <h2 class="e">L’anatomie d’une ligne</h2>
      <Anatomie />
    </Slide>

    <Slide bandeau="En direct · les vecteurs" droite={D}>
      <h2 class="e">Plusieurs valeurs, un objet</h2>
      <Console lignes={c_vecteur} />
    </Slide>

    <Slide bandeau="En direct · les vecteurs" droite={D}>
      <h2 class="e">Quatre sortes de valeurs</h2>
      <Types />
    </Slide>

    <Slide bandeau="En direct · les vecteurs" droite={D}>
      <h2 class="e">Le manquant</h2>
      <Console lignes={c_na} />
    </Slide>

    <Slide bandeau="En direct · les fonctions" droite={D}>
      <h2 class="e">Une fonction, c’est une machine</h2>
      <Machine />
    </Slide>

    <Slide bandeau="En direct · les erreurs" droite={D}>
      <h2 class="e">Trois façons de se tromper</h2>
      <Syntaxe />
    </Slide>

    <Slide bandeau="En direct · les erreurs" droite={D}>
      <h2 class="e">Lire une erreur</h2>
      <Erreurs />
    </Slide>



    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Les packages : la boîte à outils</h2>
      <Packages />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e"><code>swiss</code> : 47 provinces, 1888</h2>
      <Deux ratio="1fr 1.6fr">
        <div class="chiffres">
          <Grand valeur="47" legende="provinces francophones de Suisse" />
          <Grand valeur="6" legende="variables, toutes des nombres" />
          <p class="pale">Livré avec R, donc sur chaque ordinateur de la salle. Aucun fichier à télécharger aujourd’hui ; ça, c’est la séance 4.</p>
        </div>
        <dl class="vars e">
          <dt>Fertility</dt><dd>indice de fécondité, standardisé</dd>
          <dt>Agriculture</dt><dd>% d’hommes travaillant en agriculture</dd>
          <dt>Examination</dt><dd>% de conscrits avec la meilleure note à l’examen de l’armée</dd>
          <dt>Education</dt><dd>% de conscrits scolarisés au-delà du primaire</dd>
          <dt>Catholic</dt><dd>% de catholiques</dd>
          <dt>Infant.Mortality</dt><dd>% de bébés morts avant un an</dd>
        </dl>
      </Deux>
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Explorer</h2>
      <Console lignes={c_explorer1} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Regarder</h2>
      <Console lignes={c_regarder} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Une variable</h2>
      <Console lignes={c_variable} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Sa forme</h2>
      <Histo />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Choisir des colonnes, garder des lignes</h2>
      <Console lignes={c_dplyr} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Le pipe : « et ensuite »</h2>
      <Pipe />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Résumer par groupe</h2>
      <Console lignes={c_groupe} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Un graphique, couche par couche</h2>
      <Nuage />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Une ligne, un résultat</h2>
      <Console lignes={c_lm} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Le script entier, 1 de 2</h2>
      <Code src={script1} titre="seance2.R · à refaire chez vous, puis à modifier" />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Le script entier, 2 de 2</h2>
      <Code src={script2} titre="seance2.R · la suite" />
    </Slide>

    <!-- ================= 5 · L'IA ================= -->
    <Slide fond="encre" bandeau="L'assistant d'IA" droite={D}>
      <h1 class="e">Un assistant d’IA pour apprendre R</h1>
      <hr class="filet" />
      <p class="lead e">Un tuteur disponible à 2 h du matin. Qui se trompe avec assurance.</p>
    </Slide>

    <Slide bandeau="L'assistant d'IA" droite={D}>
      <h2 class="e">Le contrat, rappel</h2>
      <IA />
    </Slide>

    <!-- L'empreinte environnementale: position, chiffres, études. -->
    <Slide fond="encre" bandeau="L'assistant d'IA" droite={D}>
      <p class="surtitre e">Ce que ça coûte</p>
      <h1 class="e">Je suis partial.</h1>
      <hr class="filet" />
      <p class="lead e">Ma carrière repose sur l’IA. Je pense que vous devez l’apprendre pour vous placer dans un monde qui change vite.</p>
      <p class="lead e">Mais elle a un prix, et ce ne sont pas ceux qui la vendent qui le paient. Voici ce que disent les études, pas moi.</p>
    </Slide>

    <Slide bandeau="L'assistant d'IA · l'empreinte" droite={D}>
      <h2 class="e">Six chiffres, trois sources</h2>
      <Empreinte />
    </Slide>

    <Slide bandeau="L'assistant d'IA · l'empreinte" droite={D}>
      <h2 class="e">Les sources, et ce qu’on a écarté</h2>
      <Etudes />
    </Slide>

    <Slide bandeau="L'assistant d'IA" droite={D}>
      <h2 class="e">La bonne question</h2>
      <Prompt />
    </Slide>

    <Slide bandeau="L'assistant d'IA" droite={D}>
      <h2 class="e">Vérifier</h2>
      <Verifier />
    </Slide>

    <!-- ================= 6 · AVANT JEUDI PROCHAIN ================= -->
    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Avant jeudi prochain</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Avant jeudi prochain" droite={D}>
      <h2 class="e">Trois choses</h2>
      <div class="trois e">
        <div>
          <strong>Refaire le script</strong>
          <span>Seul.e, dans Positron, ligne par ligne. Puis remplacez Education par Agriculture. Ce qui casse vous apprend plus que ce qui marche.</span>
          <em>une heure</em>
        </div>
        <div>
          <strong>Datacamp</strong>
          <span>Cours « Introduction to R », chapitre « Vectors ». Et « Intro to basics » si ce n’est pas déjà fait. Les mêmes objets, à votre rythme.</span>
          <em>obligatoire · 10 % de la note</em>
        </div>
        <div>
          <strong>Slack · #aide-metho</strong>
          <span>Un blocage ? Le message d’erreur et le code, collés en entier. Avant jeudi, pas jeudi.</span>
          <em>les auxiliaires répondent</em>
        </div>
      </div>
    </Slide>

    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Jeudi prochain</h1>
      <hr class="filet" />
      <p class="lead e">Les statistiques descriptives et la visualisation des données.</p>
      <p class="lead e">Décrire une variable, puis la dessiner. Avec ce que vous savez depuis aujourd’hui.</p>
    </Slide>

    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre merci">
        <h1 class="e">Merci.</h1>
        <hr class="filet" />
        <p class="lead e">Des questions ? Maintenant, ou sur Slack.</p>
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
  .titre { padding-bottom: 5.2em; }
  .merci h1 { font-size: 3.4em; }
  .entete-ul { position: absolute; left: 0; right: 0; bottom: 0; display: flex; align-items: center; gap: 1.2em;
    background: #fff; color: var(--dk-encre); padding: 0.8em 2.6em 0.8em 2.6em; border-top: 6px solid var(--dk-accent); }
  .entete-ul img { height: 2.6em; width: auto; display: block; }
  .entete-ul .sep { width: 2px; align-self: stretch; background: var(--dk-encre); }
  .entete-ul .dept { font-size: 0.62em; letter-spacing: 0.12em; text-transform: uppercase; line-height: 1.45; font-weight: 600; }
  .entete-ul .session { margin-left: auto; font-size: 0.72em; letter-spacing: 0.16em; text-transform: uppercase; color: var(--dk-accent); font-weight: 600; }
  .pale { color: var(--dk-gris); }
  /* Un titre qui doit tenir sur une ligne, guillemet fermant compris. */
  .une-ligne { white-space: nowrap; font-size: 2.6em; }
  /* Le package ces: capture du CRAN à gauche, le mot à droite. */
  .cran { display: grid; grid-template-columns: 1.3fr 1fr; gap: 1.6em; align-items: center; }
  .cran figure { margin: 0; }
  .cran img { display: block; width: 100%; height: auto; border: 2px solid var(--dk-encre); }
  .cran-txt { display: flex; flex-direction: column; gap: 0.7em; }
  .cran-txt .lead { font-size: 1em; }
  :global(.diapo-in:has(> .cran)) { max-width: 62em; }
  .capture { margin: 0; }
  .capture img { display: block; width: 100%; height: auto; border: 2px solid var(--dk-encre); }
  .capture.plein { display: flex; flex-direction: column; height: 100%; }
  .capture.plein img { flex: 1; min-height: 0; object-fit: contain; object-position: top; }
  .capture.plein figcaption { font-size: 0.85em; color: var(--dk-encre); padding: 0.3em 0; }

  /* À main levée: quatre questions, très grandes. */
  .mains { list-style: none; padding: 0; margin: 0; counter-reset: m; display: flex; flex-direction: column; gap: 0.5em; }
  .mains li { counter-increment: m; display: grid; grid-template-columns: 1.4em 1fr; gap: 0.6em; align-items: baseline; font-size: 1.7em; line-height: 1.25; }
  .mains li::before { content: counter(m); color: var(--dk-accent); font-weight: 600; }

  /* La fiche de swiss. */
  .chiffres { display: flex; flex-direction: column; gap: 1em; justify-content: center; }
  .chiffres p { font-size: 0.8em; margin-top: 0.4em; }
  .vars { display: grid; grid-template-columns: auto 1fr; gap: 0.5em 1.2em; margin: 0; align-content: center; border-left: 3px solid var(--dk-encre); padding-left: 1.2em; }
  .vars dt { font-family: var(--dk-mono); font-weight: 600; font-size: 0.95em; }
  .vars dd { margin: 0; font-size: 0.85em; color: var(--dk-gris); }

  /* Trois choses: pleine largeur, comme un visuel. */
  :global(.diapo-in:has(> .trois)) { max-width: 60em; }
  .trois { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; }
  .trois > div { border: 2px solid var(--dk-encre); padding: 1.1em 1em 1em; display: flex; flex-direction: column; gap: 0.4em; }
  .trois > div:first-child { border: 3px solid var(--dk-accent); }
  .trois strong { font-size: 1.3em; }
  .trois span { font-size: 0.8em; color: var(--dk-gris); line-height: 1.45; }
  .trois em { margin-top: auto; padding-top: 0.5em; font-size: 0.72em; font-style: normal; font-weight: 600; color: var(--dk-accent); letter-spacing: 0.06em; }
</style>
