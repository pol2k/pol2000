<script>
  /**
   * POL-2000 — Séance 3 · Les statistiques descriptives et la visualisation des données
   * Jeudi 17 septembre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine: moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine et bouge. Trois questions pour une
   * variable (la forme, le centre, la dispersion), puis la dessiner.
   *
   * Adapté du cours 3 d'Adrien Cloutier (hiver 2024) : le vecteur
   * c(2, 2, 2, 3, 106), les quartiles, l'écart type, la boîte à moustaches,
   * le tableau croisé du Titanic. La probabilité et la loi des grands
   * nombres vont à la séance 5, la corrélation à la séance 7.
   *
   * Rien n'est inventé pour une sortie de R ni pour une figure : tout vient
   * de src/lib/data/seance3.js, généré par outils/seance3_data.R sur l'Étude
   * électorale canadienne 2025, datasets::anscombe et le Titanic. Les
   * schémas sont dits tels.
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Code from '$lib/deck/Code.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import Console from '$lib/deck/visuels/Console.svelte';
  import TroisQuestions from '$lib/deck/visuels/TroisQuestions.svelte';
  import Empiler from '$lib/deck/visuels/Empiler.svelte';
  import Formes from '$lib/deck/visuels/Formes.svelte';
  import Bascule from '$lib/deck/visuels/Bascule.svelte';
  import Menage from '$lib/deck/visuels/Menage.svelte';
  import QuelCentre from '$lib/deck/visuels/QuelCentre.svelte';
  import Etalement from '$lib/deck/visuels/Etalement.svelte';
  import Quartiles from '$lib/deck/visuels/Quartiles.svelte';
  import EcartType from '$lib/deck/visuels/EcartType.svelte';
  import Cloche from '$lib/deck/visuels/Cloche.svelte';
  import Anscombe from '$lib/deck/visuels/Anscombe.svelte';
  import QuelGraphique from '$lib/deck/visuels/QuelGraphique.svelte';
  import Geoms from '$lib/deck/visuels/Geoms.svelte';
  import BoitesPartis from '$lib/deck/visuels/BoitesPartis.svelte';
  import Titanic from '$lib/deck/visuels/Titanic.svelte';
  import AxeMenteur from '$lib/deck/visuels/AxeMenteur.svelte';
  import AvantS4 from '$lib/deck/visuels/AvantS4.svelte';
  import { CONSOLES } from '$lib/data/seance3.js';

  const TOTAL = 35;
  const D = 'POL-2000 · séance 3 · jeu 17 sept';

  const script = `# POL-2000 · séance 3 · Les statistiques descriptives et la visualisation
# À refaire chez vous, ligne par ligne, Ctrl + Entrée.

library(ces)
library(dplyr)
library(haven)
library(ggplot2)

df <- readRDS("ces2025.rds")   # sauvegardé à la séance 2 ; sinon : df <- get_ces("2025")

# 1. Le centre
mean(df$cps25_age_in_years)
median(df$cps25_age_in_years)
summary(df$cps25_age_in_years)
table(df$cps25_demsat)

# 2. Une valeur extrême
summary(df$cps25_household)
sort(df$cps25_household, decreasing = TRUE)[1:3]

# 3. La dispersion
sd(df$cps25_age_in_years)
quantile(df$cps25_age_in_years)
IQR(df$cps25_age_in_years)

# 4. Dessiner une variable
ggplot(df, aes(x = cps25_age_in_years)) +
  geom_histogram(binwidth = 5, boundary = 15)
ggplot(df, aes(x = cps25_age_in_years)) +
  geom_boxplot()
ggplot(df, aes(x = cps25_age_in_years)) +
  geom_density()

# 5. L'âge, parti par parti
d <- df |>
  filter(cps25_votechoice %in% 1:5) |>
  mutate(parti = as_factor(cps25_votechoice),
         age = as.numeric(cps25_age_in_years))
ggplot(d, aes(x = age, y = parti)) +
  geom_boxplot()

# 6. À vous : refaites 1, 3 et 4 avec cps25_interest_gen_1. Regardez le minimum.`;
  // Trop long pour une diapo à taille lisible : coupé avant « 2. » et avant « 4. ».
  const coupe_a = script.indexOf('\n# 2. ');
  const coupe_b = script.indexOf('\n# 4. ');
  const script1 = script.slice(0, coupe_a);
  const script2 = script.slice(coupe_a + 1, coupe_b);
  const script3 = script.slice(coupe_b + 1);
</script>

<svelte:head>
  <title>POL-2000 · Séance 3 — Les statistiques descriptives et la visualisation des données</title>
</svelte:head>

<Deck total={TOTAL} logo="{base}/img/ulaval-logo.png">
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->
    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre">
        <p class="surtitre e">POL-2000 · Méthodologie quantitative</p>
        <h1 class="e">Les statistiques descriptives et la visualisation des données</h1>
        <hr class="filet" />
        <p class="lead e">Séance 3 · jeudi 17 septembre 2026</p>
      </div>
      <div class="entete-ul e">
        <img src="{base}/img/ulaval-logo.png" alt="Université Laval" />
        <span class="sep"></span>
        <span class="dept">Département de science politique<br />Faculté des sciences sociales</span>
        <span class="session">Automne 2026</span>
      </div>
    </Slide>

    <Slide bandeau="Où on en est" droite={D}>
      <Session ici={3} />
    </Slide>

    <Slide bandeau="Un tour de salle" droite={D}>
      <h2 class="e">À main levée</h2>
      <ol class="mains e">
        <li><span>Le script de la séance 2, refait chez vous ?</span></li>
        <li><span>Le chapitre Datacamp, terminé ?</span></li>
        <li><span>Positron est ouvert, là, maintenant ?</span></li>
      </ol>
    </Slide>

    <Slide fond="encre" bandeau="Décrire" droite={D}>
      <h1 class="e">Décrire avant d’expliquer</h1>
      <hr class="filet" />
      <p class="lead e">20 180 personnes. Une phrase.</p>
    </Slide>

    <Slide bandeau="Décrire" droite={D}>
      <h2 class="e">Trois questions pour une variable</h2>
      <TroisQuestions />
    </Slide>

    <!-- ================= 1 · LA FORME ================= -->
    <Slide fond="encre" bandeau="La forme" droite={D}>
      <p class="surtitre e">1 de 3</p>
      <h1 class="e">La forme</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="La forme" droite={D}>
      <h2 class="e">Une distribution</h2>
      <Empiler />
    </Slide>

    <Slide bandeau="La forme" droite={D}>
      <h2 class="e">Quatre formes</h2>
      <Formes />
    </Slide>

    <!-- ================= 2 · LE CENTRE ================= -->
    <Slide fond="encre" bandeau="Le centre" droite={D}>
      <p class="surtitre e">2 de 3</p>
      <h1 class="e">Le centre</h1>
      <hr class="filet" />
      <p class="lead e">Un seul chiffre pour tout le monde.</p>
    </Slide>

    <Slide bandeau="Le centre" droite={D}>
      <h2 class="e">Mode, médiane, moyenne</h2>
      <Bascule />
    </Slide>

    <Slide bandeau="Le centre" droite={D}>
      <h2 class="e">Dans les vraies données</h2>
      <Menage />
    </Slide>

    <Slide bandeau="Le centre" droite={D}>
      <h2 class="e">Quel centre, pour quelle variable ?</h2>
      <QuelCentre />
    </Slide>

    <Slide bandeau="En direct · le centre" droite={D}>
      <h2 class="e">Le centre, dans R</h2>
      <Console lignes={CONSOLES.resume} />
    </Slide>

    <!-- ================= 3 · LA DISPERSION ================= -->
    <Slide fond="encre" bandeau="La dispersion" droite={D}>
      <p class="surtitre e">3 de 3</p>
      <h1 class="e">La dispersion</h1>
      <hr class="filet" />
      <p class="lead e">Même centre, autre histoire.</p>
    </Slide>

    <Slide bandeau="La dispersion" droite={D}>
      <h2 class="e">Même moyenne</h2>
      <Etalement />
    </Slide>

    <Slide bandeau="La dispersion" droite={D}>
      <h2 class="e">Couper en quatre</h2>
      <Quartiles />
    </Slide>

    <Slide bandeau="La dispersion" droite={D}>
      <h2 class="e">L’écart type</h2>
      <EcartType />
    </Slide>

    <Slide bandeau="La dispersion" droite={D}>
      <h2 class="e">68, 95, 99,7</h2>
      <Cloche />
    </Slide>

    <Slide bandeau="En direct · la dispersion" droite={D}>
      <h2 class="e">La dispersion, dans R</h2>
      <Console lignes={CONSOLES.dispersion} />
    </Slide>

    <!-- ================= PAUSE ================= -->
    <Slide fond="encre" bandeau="Pause" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <p class="lead e">Quinze minutes.</p>
    </Slide>

    <!-- ================= 4 · DESSINER ================= -->
    <Slide fond="encre" bandeau="Dessiner" droite={D}>
      <h1 class="e">Dessiner</h1>
      <hr class="filet" />
      <p class="lead e">Toujours regarder avant de résumer.</p>
    </Slide>

    <Slide bandeau="Dessiner" droite={D}>
      <h2 class="e">Mêmes chiffres, quatre dessins</h2>
      <Anscombe />
    </Slide>

    <Slide bandeau="Dessiner" droite={D}>
      <h2 class="e">Quel graphique ?</h2>
      <QuelGraphique />
    </Slide>

    <Slide bandeau="Dessiner" droite={D}>
      <h2 class="e">Une variable, trois dessins</h2>
      <Geoms />
    </Slide>

    <Slide bandeau="Dessiner" droite={D}>
      <h2 class="e">L’âge, parti par parti</h2>
      <BoitesPartis />
    </Slide>

    <Slide bandeau="Dessiner" droite={D}>
      <h2 class="e">Deux catégorielles : le tableau croisé</h2>
      <Titanic />
    </Slide>

    <Slide bandeau="Dessiner" droite={D}>
      <h2 class="e">Un axe qui ment</h2>
      <AxeMenteur />
    </Slide>

    <!-- ================= 5 · EN DIRECT ================= -->
    <Slide bandeau="En direct · une catégorielle" droite={D}>
      <h2 class="e">Des codes, pas des nombres</h2>
      <Console lignes={CONSOLES.categ} />
    </Slide>

    <Slide bandeau="En direct · le script" droite={D}>
      <h2 class="e">Le script entier, 1 de 3</h2>
      <Code src={script1} titre="seance3.R · à refaire chez vous" />
    </Slide>

    <Slide bandeau="En direct · le script" droite={D}>
      <h2 class="e">Le script entier, 2 de 3</h2>
      <Code src={script2} titre="seance3.R · la suite" />
    </Slide>

    <Slide bandeau="En direct · le script" droite={D}>
      <h2 class="e">Le script entier, 3 de 3</h2>
      <Code src={script3} titre="seance3.R · la fin" />
    </Slide>

    <!-- ================= AVANT JEUDI PROCHAIN ================= -->
    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Avant jeudi prochain</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Avant jeudi prochain" droite={D}>
      <h2 class="e">Deux choses</h2>
      <AvantS4 />
    </Slide>

    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Jeudi prochain</h1>
      <hr class="filet" />
      <p class="lead e">Préparer ses données avec R.</p>
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

  /* À main levée : trois questions, très grandes. */
  .mains { list-style: none; padding: 0; margin: 0; counter-reset: m; display: flex; flex-direction: column; gap: 0.5em; }
  .mains li { counter-increment: m; display: grid; grid-template-columns: 1.4em 1fr; gap: 0.6em; align-items: baseline; font-size: 1.7em; line-height: 1.25; }
  .mains li::before { content: counter(m); color: var(--dk-accent); font-weight: 600; }
</style>
