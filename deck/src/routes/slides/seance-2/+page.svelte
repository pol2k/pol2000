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
   * une Console vient d'un vrai R 4.6.1 sur l'Étude électorale canadienne
   * 2025, chargée par le package ces ; les figures dessinent les vraies
   * valeurs (src/lib/data/ces2025.js, généré par outils/ces_data.R).
   *
   * Remaniée le 10 septembre 2026 d'après les notes diapo par diapo de
   * l'enseignant (épique beads pol-hqn).
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
  import Pipe from '$lib/deck/visuels/Pipe.svelte';
  import Prompt from '$lib/deck/visuels/Prompt.svelte';
  import Tangible from '$lib/deck/visuels/Tangible.svelte';
  import DeuxChoses from '$lib/deck/visuels/DeuxChoses.svelte';
  import HistoCes from '$lib/deck/visuels/HistoCes.svelte';
  import BarresCes from '$lib/deck/visuels/BarresCes.svelte';
  import Vecteur from '$lib/deck/visuels/Vecteur.svelte';
  import Structures from '$lib/deck/visuels/Structures.svelte';

  const TOTAL = 52;
  const D = 'POL-2000 · séance 2 · jeu 10 sept';

  // ---- Imports à ajouter (Histo et Nuage ne servent plus dans ce bloc ; retirer
  //      leurs imports si plus rien ne les utilise). ----

  // ---- Le bloc « Un jeu de données » : l'Étude électorale canadienne 2025, par le
  //      package ces. Sorties copiées de R 4.6.1 à options(width = 100), jamais tapées
  //      à la main ; les figures lisent src/lib/data/ces2025.js (outils/ces_data.R). ----

  // get_ces() télécharge 57,6 Mo depuis le Dataverse de Harvard ; les quatre lignes montrées sont extraites, mot pour mot, de son vrai message.
  const d_charger = [
    { in: 'library(ces)', out: '', note: 'Le package de tantôt. Installé une fois avec install.packages("ces"), chargé à chaque session avec library().' },
    { in: 'library(dplyr)\nlibrary(haven)', out: '', note: 'dplyr manipule les tableaux ; haven lit les étiquettes des sondages (« 2 = Conservative Party »). Les deux viennent avec le tidyverse.' },
    { in: 'df <- get_ces("2025")', out: 'trying URL \'https://dataverse.harvard.edu/api/access/datafile/13958997\'\ndownloaded 57.6 MB\nData loaded successfully: 20180 rows and 1440 columns\nCES 2025 (web) dataset ready for use', note: '' },
    { in: 'saveRDS(df, "ces2025.rds")', out: '', note: '' }
  ];

  const d_explorer = [
    { in: 'nrow(df)', out: '[1] 20180', note: 'Une ligne, une personne qui a répondu au sondage.' },
    { in: 'ncol(df)', out: '[1] 1440', note: 'Une colonne, une question. Mille quatre cent quarante.' },
    { in: 'names(df)[1:8]', out: '[1] "cps25_time"           "cps25_consent"        "cps25_citizenship"    "cps25_citizen_other" \n[5] "cps25_citizen_other2" "cps25_citizen_other3" "cps25_age_in_years"   "cps25_genderid"      ', note: 'Les huit premiers noms sur 1 440. cps25 : « campaign period survey », la vague pendant la campagne de 2025.' }
  ];

  const d_regarder = [
    { in: 'df |> select(cps25_age_in_years, cps25_province, cps25_votechoice) |> head()', out: '# A tibble: 6 × 3\n  cps25_age_in_years cps25_province           cps25_votechoice         \n  <dbl+lbl>          <dbl+lbl>                <dbl+lbl>                \n1 69 [69. 69]         2 [2. British Columbia] 2 [2. Conservative Party]\n2 61 [61. 61]         1 [1. Alberta]          3 [3. NDP]               \n3 54 [54. 54]        11 [11. Quebec]          2 [2. Conservative Party]\n4 28 [28. 28]         9 [9. Ontario]          1 [1. Liberal Party]     \n5 63 [63. 63]         9 [9. Ontario]          1 [1. Liberal Party]     \n6 28 [28. 28]         2 [2. British Columbia] 2 [2. Conservative Party]', note: 'select() choisit trois colonnes sur 1 440, head() garde six lignes ; on y revient dans un instant. Une ligne, une personne. Une case : un code et, entre crochets, ce qu’il veut dire.' },
    { in: 'View(df)', out: '', note: 'S’ouvre dans l’onglet Données de Positron. Le tableau entier, à faire défiler : 20 180 lignes, 1 440 colonnes.' }
  ];

  const d_variable = [
    { in: 'length(df$cps25_age_in_years)', out: '[1] 20180', note: 'Le $ sort une colonne du tableau. Une colonne, c’est un vecteur : 20 180 âges. (Ne l’affichez pas tout seul : R les déverse tous.)' },
    { in: 'mean(df$cps25_age_in_years)', out: '[1] 49.71511' },
    { in: 'summary(df$cps25_age_in_years)', out: '   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. \n  18.00   35.00   50.00   49.72   64.00   96.00 ', note: 'Six chiffres pour une variable.' }
  ];

  const d_codes = [
    { in: 'table(df$cps25_votechoice)', out: '\n   1    2    3    4    5    6    7    8 \n6528 4644 1258 1011  317   82 1887  182 ', note: 'Pour qui comptez-vous voter ? Un effectif par code. Qui est le 2 ?' },
    { in: 'levels(as_factor(df$cps25_votechoice))', out: '[1] "1. Liberal Party"                    "2. Conservative Party"              \n[3] "3. NDP"                              "4. Bloc Québécois"                  \n[5] "5. Green Party"                      "6. Another party (please specify)"  \n[7] "7. Don\'t know/ Prefer not to answer" "8. People\'s Party"                  ', note: 'as_factor(), de haven, lit l’étiquette collée à chaque code. 1 libéral, 2 conservateur, 3 NPD, 4 Bloc, 5 vert ; 6, 7 et 8 : autre, ne sait pas, PPC.' }
  ];

  const d_dplyr = [
    { in: 'df |> select(cps25_age_in_years, cps25_province, cps25_votechoice) |> head(3)', out: '# A tibble: 3 × 3\n  cps25_age_in_years cps25_province           cps25_votechoice         \n  <dbl+lbl>          <dbl+lbl>                <dbl+lbl>                \n1 69 [69. 69]         2 [2. British Columbia] 2 [2. Conservative Party]\n2 61 [61. 61]         1 [1. Alberta]          3 [3. NDP]               \n3 54 [54. 54]        11 [11. Quebec]          2 [2. Conservative Party]', note: 'select() choisit des colonnes. Trois sur 1 440.' },
    { in: 'df |> filter(cps25_province == 11) |> nrow()', out: '[1] 4906', note: 'filter() garde des lignes. Le code 11, c’est le Québec : 4 906 répondant.e.s sur 20 180.' }
  ];

  const d_enchainer = [
    { in: 'df |>\n  filter(cps25_province == 11) |>\n  select(cps25_age_in_years, cps25_province, cps25_votechoice) |>\n  head(3)', out: '# A tibble: 3 × 3\n  cps25_age_in_years cps25_province  cps25_votechoice         \n  <dbl+lbl>          <dbl+lbl>       <dbl+lbl>                \n1 54 [54. 54]        11 [11. Quebec] 2 [2. Conservative Party]\n2 60 [60. 60]        11 [11. Quebec] 1 [1. Liberal Party]     \n3 46 [46. 46]        11 [11. Quebec] 2 [2. Conservative Party]', note: 'Trois verbes à la suite : le pipe passe le tableau de l’un au suivant. Une étape par ligne, ça se lit comme une recette.' }
  ];

  const d_groupe = [
    { in: 'df |>\n  filter(cps25_votechoice %in% 1:5) |>\n  mutate(parti = as_factor(cps25_votechoice)) |>\n  group_by(parti) |>\n  summarise(age = mean(cps25_age_in_years), n = n())', out: '# A tibble: 5 × 3\n  parti                   age     n\n  <fct>                 <dbl> <int>\n1 1. Liberal Party       52.6  6528\n2 2. Conservative Party  49.7  4644\n3 3. NDP                 44.7  1258\n4 4. Bloc Québécois      52.9  1011\n5 5. Green Party         45.8   317', note: 'filter() garde les cinq grands partis ; mutate() crée une colonne ; group_by() sépare ; summarise() résume chaque groupe. Une question : l’âge moyen change-t-il d’un parti à l’autre ? Le NPD et les verts recrutent plus jeune.' }
  ];

  const d_lm = [
    { in: 'd2 <- df |>\n  filter(cps25_votechoice %in% c(1:5, 8), cps25_income <= 8) |>\n  mutate(conservateur = cps25_votechoice == 2)', out: '', note: 'Un parti nommé, un revenu donné. conservateur vaut TRUE ou FALSE : R compte 1 ou 0.' },
    { in: 'mean(d2$conservateur)', out: '[1] 0.3305243', note: 'La moyenne de vrais et de faux, c’est une proportion : 33 % comptent voter conservateur.' },
    { in: 'lm(conservateur ~ cps25_income, data = d2)', out: 'Call:\nlm(formula = conservateur ~ cps25_income, data = d2)\n\nCoefficients:\n (Intercept)  cps25_income  \n     0.28364       0.01001  ', note: '' }
  ];


  const script_ces = `# POL-2000 · séance 2 · Introduction à R et à Positron
# À refaire chez vous, ligne par ligne, Ctrl + Entrée.

# 1. Les boîtes à outils (installées une fois : install.packages(c("ces", "tidyverse")))
library(ces)       # l'Étude électorale canadienne, de 1965 à 2025
library(dplyr)     # manipuler des tableaux
library(haven)     # lire les étiquettes des sondages
library(ggplot2)   # dessiner

# 2. L'Étude électorale canadienne 2025 : 20 180 personnes, 1 440 questions
df <- get_ces("2025")          # Internet, une trentaine de secondes
saveRDS(df, "ces2025.rds")     # la prochaine fois : df <- readRDS("ces2025.rds")
nrow(df)
ncol(df)
names(df)[1:8]
df |> select(cps25_age_in_years, cps25_province, cps25_votechoice) |> head()

# 3. Une variable
mean(df$cps25_age_in_years)
summary(df$cps25_age_in_years)
hist(df$cps25_age_in_years)
table(df$cps25_votechoice)
levels(as_factor(df$cps25_votechoice))

# 4. Choisir des colonnes, garder des lignes, résumer par groupe
df |> select(cps25_age_in_years, cps25_province, cps25_votechoice) |> head(3)
df |> filter(cps25_province == 11) |> nrow()
df |>
  filter(cps25_votechoice %in% 1:5) |>
  mutate(parti = as_factor(cps25_votechoice)) |>
  group_by(parti) |>
  summarise(age = mean(cps25_age_in_years), n = n())

# 5. Un graphique, couche par couche
d <- df |>
  filter(cps25_votechoice %in% 1:5, cps25_education <= 11) |>
  mutate(parti = as_factor(cps25_votechoice),
         scolarite = cut(cps25_education, c(0, 5, 7, 11),
                         labels = c("Secondaire ou moins", "Collégial", "Universitaire"))) |>
  count(scolarite, parti) |>
  group_by(scolarite) |>
  mutate(part = n / sum(n))
ggplot(d, aes(x = scolarite, y = part, fill = parti)) +
  geom_col(position = "dodge") +
  labs(x = "Scolarité", y = "Part des intentions de vote", fill = "Parti",
       title = "Étude électorale canadienne 2025") +
  theme_minimal()

# 6. Une ligne, un résultat
d2 <- df |>
  filter(cps25_votechoice %in% c(1:5, 8), cps25_income <= 8) |>
  mutate(conservateur = cps25_votechoice == 2)
lm(conservateur ~ cps25_income, data = d2)

# 7. À vous : remplacez cps25_income par cps25_education, partout. Que change-t-il ?`;
  // Trop long pour une seule diapo à taille lisible : trois diapos, coupées
  // avant « 3. Une variable » et avant « 5. Un graphique ».
  const coupe_a = script_ces.indexOf('\n# 3. ');
  const coupe_b = script_ces.indexOf('\n# 5. ');
  const coupe_c = script_ces.indexOf('\n# 6. ');
  const script_ces1 = script_ces.slice(0, coupe_a);
  const script_ces2 = script_ces.slice(coupe_a + 1, coupe_b);
  const script_ces3 = script_ces.slice(coupe_b + 1, coupe_c);
  const script_ces4 = script_ces.slice(coupe_c + 1);

  // ---- Les consoles du bloc « En direct ». Sorties copiées de R 4.6.1, jamais tapées à la main. ----
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
      <figure class="cran e">
        <img src="{base}/img/cran-ces-haut.png" alt="Le haut de la page du package ces sur le CRAN : Access to Canadian Election Study Data, version 1.1.0, auteur et mainteneur Laurence-Olivier M. Foisy." />
      </figure>
      <div class="cran-txt e">
        <p class="surtitre">cran.r-project.org/package=ces</p>
        <p class="lead">Le package <code>ces</code> : les données de l’Étude électorale canadienne, de 1965 à 2025, en une ligne de R.</p>
        <p class="lead pale">Publié sur le dépôt officiel de R.</p>
        <Code src={'install.packages("ces")'} />
      </div>
    </Slide>

    <Slide bandeau="Pourquoi R" droite={D}>
      <h2 class="e">Ça s’apprend, et gratuitement</h2>
      <Ressources />
    </Slide>

    <Slide fond="plein" bandeau="Pourquoi R" droite={D}>
      <figure class="capture plein e">
        <img src="{base}/img/ggplot-ces.png" alt="Graphique à barres : intention de vote selon l’âge à l’élection fédérale de 2025, cinq partis par groupe d’âge." />
        <figcaption>Les plus beaux graphiques : ggplot2 · l’Étude électorale canadienne 2025</figcaption>
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
    <!-- ================= 3 · EN DIRECT, LA CONSOLE ================= -->
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
      <h2 class="e">Plusieurs valeurs, un seul objet</h2>
      <Vecteur />
    </Slide>

    <Slide bandeau="En direct · les vecteurs" droite={D}>
      <h2 class="e">Quatre types de variables</h2>
      <Types />
    </Slide>

    <Slide bandeau="En direct · les données" droite={D}>
      <h2 class="e">Structure des données : 1D vs 2D</h2>
      <Structures />
    </Slide>

    <Slide bandeau="En direct · les fonctions" droite={D}>
      <h2 class="e">Une fonction, c’est une machine</h2>
      <Machine />
    </Slide>

    <Slide bandeau="En direct · les erreurs" droite={D}>
      <h2 class="e">Les erreurs classiques</h2>
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
      <h2 class="e">L’Étude électorale canadienne 2025</h2>
      <Deux ratio="1fr 1.6fr">
        <div class="chiffres">
          <Grand valeur="20 180" legende="personnes sondées pendant la campagne fédérale de 2025" />
          <Grand valeur="1 440" legende="colonnes : une par question" />
          <p class="pale">Le grand sondage universitaire de chaque élection fédérale depuis 1965. Une ligne par personne, un code par réponse. Il arrive dans R par le package <code>ces</code> ; rien à télécharger à la main.</p>
        </div>
        <dl class="vars e">
          <dt>cps25_votechoice</dt><dd>pour quel parti la personne compte voter (codes 1 à 8)</dd>
          <dt>cps25_age_in_years</dt><dd>âge, en années</dd>
          <dt>cps25_education</dt><dd>plus haut niveau de scolarité (codes 1 à 11)</dd>
          <dt>cps25_province</dt><dd>province ou territoire (11 = Québec)</dd>
          <dt>cps25_income</dt><dd>revenu du ménage, par tranche (codes 1 à 8)</dd>
          <dt>cps25_genderid</dt><dd>identité de genre</dd>
        </dl>
      </Deux>
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Charger</h2>
      <Console lignes={d_charger} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Explorer</h2>
      <Console lignes={d_explorer} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Regarder</h2>
      <Console lignes={d_regarder} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Une variable</h2>
      <Console lignes={d_variable} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Des codes et leurs étiquettes</h2>
      <Console lignes={d_codes} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Sa forme</h2>
      <HistoCes />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Choisir des colonnes, garder des lignes</h2>
      <Console lignes={d_dplyr} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Le pipe : « et ensuite »</h2>
      <Pipe />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Enchaîner</h2>
      <Console lignes={d_enchainer} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Résumer par groupe</h2>
      <Console lignes={d_groupe} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Un graphique, couche par couche</h2>
      <BarresCes />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Une ligne, un résultat</h2>
      <Console lignes={d_lm} />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Le script entier, 1 de 4</h2>
      <Code src={script_ces1} titre="seance2.R · à refaire chez vous, puis à modifier" />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Le script entier, 2 de 4</h2>
      <Code src={script_ces2} titre="seance2.R · la suite" />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Le script entier, 3 de 4</h2>
      <Code src={script_ces3} titre="seance2.R · la fin" />
    </Slide>

    <Slide bandeau="Un jeu de données" droite={D}>
      <h2 class="e">Le script entier, 4 de 4</h2>
      <Code src={script_ces4} titre="seance2.R · la fin" />
    </Slide>

    <!-- ================= 5 · L'IA ================= -->
    <!-- ================= 5 · L'IA ================= -->
    <Slide fond="encre" bandeau="L'assistant d'IA" droite={D}>
      <h1 class="e">Utiliser l’IA pour coder</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="L'assistant d'IA" droite={D}>
      <h2 class="e">Le contrat, rappel</h2>
      <IA sousTitre={false} />
    </Slide>

    <!-- Ce que ça coûte : la position de l'enseignant, puis les chiffres. -->
    <Slide fond="encre" bandeau="L'assistant d'IA" droite={D}>
      <p class="surtitre e">Ce que ça coûte</p>
      <h1 class="e">Je suis biaisé.</h1>
      <hr class="filet" />
      <p class="lead e">Ma carrière repose sur l’IA. Je pense que vous devez l’apprendre pour vous placer dans un monde qui change vite.</p>
    </Slide>

    <!-- Un clic : les deux dégâts humains apparaissent sous les six chiffres. -->
    <Slide bandeau="L'assistant d'IA · ce que ça coûte" droite={D}>
      <h2 class="e">L’IA est tangible</h2>
      <Tangible />
    </Slide>

    <Slide bandeau="L'assistant d'IA" droite={D}>
      <h2 class="e">La bonne question</h2>
      <Prompt />
    </Slide>

    <!-- ================= 6 · AVANT JEUDI PROCHAIN ================= -->
    <!-- ================= 6 · AVANT JEUDI PROCHAIN ================= -->
    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Avant jeudi prochain</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Avant jeudi prochain" droite={D}>
      <h2 class="e">Deux choses</h2>
      <DeuxChoses />
    </Slide>

    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Jeudi prochain</h1>
      <hr class="filet" />
      <p class="lead e">Les statistiques descriptives et la visualisation des données.</p>
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
  .pale { color: var(--dk-gris); }
  /* Un titre qui doit tenir sur une ligne, guillemet fermant compris. */
  .une-ligne { white-space: nowrap; font-size: 2.6em; }
  /* Le package ces: le haut de la page du CRAN en pleine largeur, le mot dessous, une ligne chacun.
     Les règles :global restent en colonne 0 : la passe d'espacement français remplace l'espace
     devant « : » par U+202F, ce qui casse le sélecteur compilé. */
:global(.diapo-in:has(> .cran)) { max-width: 64em; }
  .cran { margin: 0; width: 100%; }
  .cran img { display: block; width: 100%; height: auto; border: 3px solid var(--dk-accent); }
  .cran-txt { display: flex; flex-direction: column; gap: 0.45em; margin-top: 1em; width: 100%; }
  .cran-txt .lead { font-size: 0.9em; margin: 0; max-width: none; }
  .cran-txt .surtitre { margin: 0; }
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
