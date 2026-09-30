<script>
  /**
   * POL-2000 — Séance 5 · L'inférence statistique
   * Jeudi 1er octobre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine : moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine et bouge.
   *
   * Le fil (remanié le 30 septembre 2026, pol-3ti) : R fait les calculs, la
   * diapo montre l'idée. Pas de test t ici, il vient avec la régression.
   * Avant la pause : l'échantillon et la population, la courbe normale et
   * le quiz « Normale ou pas ? » sur de vraies données, les moyennes
   * d'échantillons qui forment une cloche même quand les données n'en font
   * pas une, le biais, la marge d'erreur (« 19 fois sur 20 »), puis « Est-ce
   * le hasard ? » (H0, la pomicultrice, la valeur p en mots). Après la
   * pause, ggplot2 couche par couche, puis tout ça en direct dans R.
   *
   * Le dispositif : les 20 180 répondant.e.s de l'Étude électorale
   * canadienne 2025 servent de population d'exercice. On connaît donc la
   * vraie réponse et on tire des échantillons dedans. Les diapos le disent.
   * Rien n'est pondéré.
   *
   * Sources. Arel-Bundock (2021), chapitre 4 (p. 61-76), pour le
   * vocabulaire, la pomicultrice, les huit étapes, la cible, le lancer
   * d'anneaux et les deux études de la fin. Le cours 5 d'Adrien Cloutier
   * (hiver 2024) pour le plan : échantillon probabiliste, variance
   * échantillonnale, t, p, intervalle, « significatif n'est pas causal ».
   * Squire (1988) pour le Literary Digest. Wickham (2010) pour la grammaire
   * des graphiques.
   *
   * Rien n'est inventé pour une sortie de R ni pour une figure : tout vient
   * de src/lib/data/seance5.js et de static/img/s5-*.png, générés par
   * outils/seance5_data.R.
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Code from '$lib/deck/Code.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import Console from '$lib/deck/visuels/Console.svelte';
  import Inference from '$lib/deck/visuels/Inference.svelte';
  import QuelGraphique from '$lib/deck/visuels/QuelGraphique.svelte';
  import Aujourdhui5 from '$lib/deck/visuels/Aujourdhui5.svelte';
  import Vocabulaire from '$lib/deck/visuels/Vocabulaire.svelte';
  import Aleatoire from '$lib/deck/visuels/Aleatoire.svelte';
  import Digest1936 from '$lib/deck/visuels/Digest1936.svelte';
  import Leger2025 from '$lib/deck/visuels/Leger2025.svelte';
  import PileFace from '$lib/deck/visuels/PileFace.svelte';
  import TroisTirages from '$lib/deck/visuels/TroisTirages.svelte';
  import MilleEchantillons from '$lib/deck/visuels/MilleEchantillons.svelte';
  import QuatreTailles from '$lib/deck/visuels/QuatreTailles.svelte';
  import Cible from '$lib/deck/visuels/Cible.svelte';
  import BiaisEchantillon from '$lib/deck/visuels/BiaisEchantillon.svelte';
  import Pomicultrice from '$lib/deck/visuels/Pomicultrice.svelte';
  import DeuxHypotheses from '$lib/deck/visuels/DeuxHypotheses.svelte';
  import Proces from '$lib/deck/visuels/Proces.svelte';
  import MondeH0 from '$lib/deck/visuels/MondeH0.svelte';
  import CeQuePNestPas from '$lib/deck/visuels/CeQuePNestPas.svelte';
  import Importance from '$lib/deck/visuels/Importance.svelte';
  import Grammaire from '$lib/deck/visuels/Grammaire.svelte';
  import GabaritGg from '$lib/deck/visuels/GabaritGg.svelte';
  import Couches from '$lib/deck/visuels/Couches.svelte';
  import DansHorsAes from '$lib/deck/visuels/DansHorsAes.svelte';
  import ErreursGg from '$lib/deck/visuels/ErreursGg.svelte';
  import DeuxIC from '$lib/deck/visuels/DeuxIC.svelte';
  import MiSession from '$lib/deck/visuels/MiSession.svelte';
  import AvantS7 from '$lib/deck/visuels/AvantS7.svelte';
  import Cloche from '$lib/deck/visuels/Cloche.svelte';
  import NormaleOuPas from '$lib/deck/visuels/NormaleOuPas.svelte';
  import NycMoyennes from '$lib/deck/visuels/NycMoyennes.svelte';
  import DixNeufSurVingt from '$lib/deck/visuels/DixNeufSurVingt.svelte';
  import { CONSOLES } from '$lib/data/seance5.js';
  import { GGPLOT_NORMALE } from '$lib/data/seance5_normale.js';

  const TOTAL = 65;
  const D = 'POL-2000 · séance 5 · jeu 1er oct';

  // Les consoles viennent de R telles quelles; seules les notes sont d'ici.
  const avec = (cle, notes = [], garder = null) =>
    CONSOLES[cle].map((l, i) => ({ ...l, note: notes[i] || '' })).filter((_, i) => !garder || garder.includes(i));
  const c_echantillon = avec('echantillon', ['', 'Le vôtre sera différent.']);
  const c_mille = avec('mille', [], [0, 1]);
  const c_partis_def = avec('partis', ['Les codes 1 à 5\u202F: les cinq grands partis.'], [0]);
  const c_partis = avec('partis', ['', 'et\u202F: R calcule de combien chaque moyenne peut bouger.'], [1, 2]);
  const c_sauver = avec('sauver');

  const script = `# POL-2000 · séance 5 · L'inférence statistique, et ggplot2
# À refaire chez vous, ligne par ligne, Ctrl + Entrée.

library(dplyr)
library(ggplot2)

# 0. La base propre de la séance 4
df_clean <- readRDS("ces2025_clean.rds")

# Pas de fichier ? Enlevez les # et refaites-la depuis le sondage.
# library(ces)
# library(haven)
# df_raw <- get_ces("2025")
# df_clean <- data.frame(id = 1:nrow(df_raw))
# df_clean$gauche_droite <- na_if(df_raw$cps25_lr_scale_bef_1, -99)
# df_clean$ne_canada <- case_when(
#   df_raw$cps25_bornin_canada == 1 ~ 1,
#   df_raw$cps25_bornin_canada == 2 ~ 0
# )
# df_clean$age <- as.numeric(df_raw$cps25_age_in_years)
# df_clean$vote <- as_factor(df_raw$cps25_votechoice)

# 1. ggplot2, couche par couche
ggplot(df_clean, aes(x = age, y = gauche_droite)) +
  geom_jitter(alpha = 0.1) +
  geom_smooth() +
  labs(title = "L'âge et la position gauche-droite",
       x = "Âge",
       y = "Gauche (0) à droite (10)",
       caption = "Source : Étude électorale canadienne 2025") +
  theme_minimal()

# 2. Une couleur par parti
partis <- df_clean |>
  filter(as.numeric(vote) <= 5, !is.na(gauche_droite))
ggplot(partis, aes(x = age, y = gauche_droite, colour = vote)) +
  geom_smooth() +
  labs(x = "Âge", y = "Gauche (0) à droite (10)", colour = NULL) +
  theme_minimal()

# 3. Normale ou pas ?
ggplot(faithful, aes(x = waiting)) +
  geom_histogram(binwidth = 4)
ggplot(morley, aes(x = Speed + 299000)) +
  geom_histogram(binwidth = 40)

# 4. Un échantillon de 50 (le vôtre sera différent)
echantillon <- slice_sample(df_clean, n = 50)
mean(echantillon$age)
mean(df_clean$age)

# 5. Mille échantillons
moyennes <- replicate(1000, mean(slice_sample(df_clean, n = 50)$age))
mean(moyennes)
ggplot(data.frame(moyennes), aes(x = moyennes)) +
  geom_histogram(binwidth = 0.5)

# 6. Une moyenne par parti, avec sa marge d'erreur
moyennes_partis <- partis |>
  group_by(vote) |>
  summarise(moyenne = mean(gauche_droite),
            et = sd(gauche_droite) / sqrt(n()),
            n = n())
ggplot(moyennes_partis, aes(x = moyenne, y = vote)) +
  geom_pointrange(aes(xmin = moyenne - 1.96 * et,
                      xmax = moyenne + 1.96 * et)) +
  xlim(0, 10) +
  labs(x = "Gauche (0) à droite (10)", y = NULL)
ggsave("gauche_droite_partis.png", width = 8, height = 5)

# 7. À vous : la même chose, avec l'âge au lieu de la position gauche-droite.`;
  // Trop long pour une diapo à taille lisible : coupé avant le secours et
  // avant « 1. », « 2. », « 3. », « 4. » et « 6. ».
  const coupes = ['\n# Pas de fichier', '\n# 1. ', '\n# 2. ', '\n# 3. ', '\n# 4. ', '\n# 6. '].map((c) => script.indexOf(c));
  if (coupes.includes(-1)) throw new Error('seance-5 : une coupe du script est introuvable');
  const scripts = [0, ...coupes].map((d, i, t) => script.slice(i ? d + 1 : 0, t[i + 1]));
</script>

<svelte:head>
  <title>POL-2000 · Séance 5 · L’inférence statistique</title>
</svelte:head>

<Deck total={TOTAL} logo="{base}/img/ulaval-logo.png">
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->
    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre">
        <p class="surtitre e">POL-2000 · Méthodologie quantitative</p>
        <h1 class="e">L’inférence statistique</h1>
        <hr class="filet" />
        <p class="lead e">Séance 5 · jeudi 1er octobre 2026</p>
      </div>
      <div class="entete-ul e">
        <img src="{base}/img/ulaval-logo.png" alt="Université Laval" />
        <span class="sep"></span>
        <span class="dept">Département de science politique<br />Faculté des sciences sociales</span>
        <span class="session">Automne 2026</span>
      </div>
    </Slide>

    <Slide bandeau="Où on en est" droite={D}>
      <Session ici={5} />
    </Slide>

    <Slide bandeau="Retour" droite={D}>
      <h2 class="e grande-q">Des questions sur la semaine dernière ?</h2>
    </Slide>

    <Slide bandeau="Aujourd’hui" droite={D}>
      <h2 class="e">Aujourd’hui</h2>
      <Aujourdhui5 />
    </Slide>

    <!-- ================= 1 · L'INFÉRENCE ================= -->
    <Slide fond="encre" bandeau="L’inférence" droite={D}>
      <h1 class="e">L’inférence statistique</h1>
      <hr class="filet" />
      <p class="lead e">Dire quelque chose du grand à partir du petit.</p>
    </Slide>

    <Slide bandeau="L’inférence · rappel" droite={D}>
      <h2 class="e">Le but : l’inférence</h2>
      <Inference />
    </Slide>

    <Slide bandeau="L’inférence" droite={D}>
      <h2 class="e">Quatre mots</h2>
      <Vocabulaire />
    </Slide>

    <Slide bandeau="L’échantillon" droite={D}>
      <h2 class="e">Au hasard</h2>
      <Aleatoire />
    </Slide>

    <Slide bandeau="L’échantillon" droite={D}>
      <h2 class="e">1936 : 2,3 millions de réponses</h2>
      <Digest1936 />
    </Slide>

    <Slide bandeau="L’échantillon" droite={D}>
      <h2 class="e">Et l’Étude électorale canadienne ?</h2>
      <Leger2025 />
    </Slide>

    <!-- ================= LA COURBE NORMALE ================= -->
    <Slide bandeau="La courbe normale" droite={D}>
      <h2 class="e">D’où vient la cloche</h2>
      <Cloche />
    </Slide>

    <Slide bandeau="La courbe normale · quiz" droite={D}>
      <h2 class="e">Normale ou pas ?</h2>
      <NormaleOuPas cle="michelson" />
    </Slide>

    <Slide bandeau="La courbe normale · quiz" droite={D}>
      <h2 class="e">Normale ou pas ?</h2>
      <NormaleOuPas cle="nyc" />
    </Slide>

    <Slide bandeau="La courbe normale · quiz" droite={D}>
      <h2 class="e">Normale ou pas ?</h2>
      <NormaleOuPas cle="bebes" />
    </Slide>

    <Slide bandeau="La courbe normale · quiz" droite={D}>
      <h2 class="e">Normale ou pas ?</h2>
      <NormaleOuPas cle="rivieres" />
    </Slide>

    <Slide bandeau="La courbe normale · quiz" droite={D}>
      <h2 class="e">Normale ou pas ?</h2>
      <NormaleOuPas cle="geyser" />
    </Slide>

    <Slide bandeau="La courbe normale · quiz" droite={D}>
      <h2 class="e">Normale ou pas ?</h2>
      <NormaleOuPas cle="age" />
    </Slide>

    <Slide bandeau="Le hasard" droite={D}>
      <h2 class="e">La loi des grands nombres</h2>
      <PileFace />
    </Slide>

    <Slide bandeau="Le hasard" droite={D}>
      <h2 class="e">Trois échantillons, trois moyennes</h2>
      <TroisTirages />
    </Slide>

    <Slide bandeau="Le hasard" droite={D}>
      <h2 class="e">Mille échantillons</h2>
      <MilleEchantillons />
    </Slide>

    <Slide bandeau="Le hasard" droite={D}>
      <h2 class="e">Plus l’échantillon est grand…</h2>
      <QuatreTailles />
    </Slide>

    <Slide bandeau="Le hasard" droite={D}>
      <h2 class="e">Même les bâtiments de New York</h2>
      <NycMoyennes />
    </Slide>

    <Slide bandeau="Le biais" droite={D}>
      <h2 class="e">Le biais et la variance</h2>
      <Cible />
    </Slide>

    <Slide bandeau="Le biais" droite={D}>
      <h2 class="e">Ne sonder que les passionné.e.s</h2>
      <BiaisEchantillon />
    </Slide>

    <Slide bandeau="La marge d’erreur" droite={D}>
      <h2 class="e">19 fois sur 20</h2>
      <DixNeufSurVingt />
    </Slide>

    <!-- ================= 2 · LE TEST D'HYPOTHÈSE NULLE ================= -->
    <Slide fond="encre" bandeau="Est-ce le hasard ?" droite={D}>
      <h1 class="e">Le test d’hypothèse nulle</h1>
      <hr class="filet" />
      <p class="lead e">Mon résultat, est-ce le hasard ?</p>
    </Slide>

    <Slide bandeau="Est-ce le hasard ?" droite={D}>
      <h2 class="e">La pomicultrice</h2>
      <Pomicultrice />
    </Slide>

    <Slide bandeau="Est-ce le hasard ?" droite={D}>
      <h2 class="e">Deux hypothèses</h2>
      <DeuxHypotheses />
    </Slide>

    <Slide bandeau="Est-ce le hasard ?" droite={D}>
      <h2 class="e">Présumée vraie</h2>
      <Proces />
    </Slide>

    <Slide bandeau="La valeur p" droite={D}>
      <h2 class="e">Si H0 était vraie…</h2>
      <MondeH0 />
    </Slide>

    <Slide bandeau="Les limites" droite={D}>
      <h2 class="e">Ce que p ne dit pas</h2>
      <CeQuePNestPas />
    </Slide>

    <Slide bandeau="Les limites" droite={D}>
      <h2 class="e">Significatif n’est pas important</h2>
      <Importance />
    </Slide>

    <!-- ================= PAUSE ================= -->
    <Slide fond="encre" bandeau="Pause" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <p class="lead e">Quinze minutes.</p>
    </Slide>

    <!-- ================= 3 · GGPLOT2 ================= -->
    <Slide fond="encre" bandeau="ggplot2" droite={D}>
      <h1 class="e">ggplot2</h1>
      <hr class="filet" />
      <p class="lead e">Un graphique se construit en couches.</p>
    </Slide>

    <Slide bandeau="ggplot2" droite={D}>
      <h2 class="e">La grammaire des graphiques</h2>
      <Grammaire />
    </Slide>

    <Slide bandeau="ggplot2" droite={D}>
      <h2 class="e">Le gabarit</h2>
      <GabaritGg />
    </Slide>

    <Slide bandeau="ggplot2 · couche par couche" droite={D}>
      <h2 class="e">Les données, puis les axes</h2>
      <Couches etapes={['vide', 'axes']} />
    </Slide>

    <Slide bandeau="ggplot2 · couche par couche" droite={D}>
      <h2 class="e">Les géométries</h2>
      <Couches etapes={['points', 'jitter', 'smooth']} depart="axes" />
    </Slide>

    <Slide bandeau="ggplot2 · couche par couche" droite={D}>
      <h2 class="e">L’habillage</h2>
      <Couches etapes={['labs', 'theme']} depart="smooth" />
    </Slide>

    <Slide bandeau="En direct · ggplot2" droite={D}>
      <h2 class="e">Les cinq grands partis</h2>
      <Console lignes={c_partis_def} />
    </Slide>

    <Slide bandeau="ggplot2 · couche par couche" droite={D}>
      <h2 class="e">Une troisième variable : la couleur</h2>
      <Couches etapes={['couleur']} depart="theme" />
    </Slide>

    <Slide bandeau="ggplot2" droite={D}>
      <h2 class="e">Dans aes(), ou hors de aes() ?</h2>
      <DansHorsAes />
    </Slide>

    <Slide bandeau="ggplot2" droite={D}>
      <h2 class="e">Deux erreurs classiques</h2>
      <ErreursGg />
    </Slide>

    <Slide bandeau="ggplot2 · rappel" droite={D}>
      <h2 class="e">Quel graphique ?</h2>
      <QuelGraphique />
    </Slide>

    <!-- ================= 4 · EN DIRECT ================= -->
    <Slide fond="encre" bandeau="En direct" droite={D}>
      <h1 class="e">L’inférence, dans R</h1>
      <hr class="filet" />
      <p class="lead e">Ordinateurs ouverts.</p>
    </Slide>

    <Slide bandeau="En direct · normale ou pas" droite={D}>
      <h2 class="e">Normale ou pas, dans R</h2>
      <Couches etapes={['geyser', 'michelson']} source={GGPLOT_NORMALE} />
    </Slide>

    <Slide bandeau="En direct · échantillonner" droite={D}>
      <h2 class="e">Votre échantillon de 50</h2>
      <Console lignes={c_echantillon} />
    </Slide>

    <Slide bandeau="En direct · échantillonner" droite={D}>
      <h2 class="e">Mille échantillons, en une ligne</h2>
      <Console lignes={c_mille} />
    </Slide>

    <Slide bandeau="En direct · échantillonner" droite={D}>
      <h2 class="e">Les dessiner</h2>
      <Couches etapes={['histo']} />
    </Slide>

    <Slide bandeau="En direct · marge d’erreur" droite={D}>
      <h2 class="e">Une moyenne par parti</h2>
      <Console lignes={c_partis} />
    </Slide>

    <Slide bandeau="En direct · marge d’erreur" droite={D}>
      <h2 class="e">Même code, deux tailles d’échantillon</h2>
      <DeuxIC />
    </Slide>

    <Slide bandeau="En direct · marge d’erreur" droite={D}>
      <h2 class="e">Sauvegarder le graphique</h2>
      <Console lignes={c_sauver} />
    </Slide>

    {#each scripts as bout, i}
      <Slide bandeau="En direct · le script" droite={D}>
        <h2 class="e">Le script entier, {i + 1} de {scripts.length}</h2>
        <Code src={bout} titre={i === 0 ? 'seance5.R · à refaire chez vous' : i === scripts.length - 1 ? 'seance5.R · la fin' : 'seance5.R · la suite'} />
      </Slide>
    {/each}

    <!-- ================= LE TRAVAIL DE MI-SESSION ================= -->
    <Slide fond="encre" bandeau="Mi-session" droite={D}>
      <h1 class="e">Le travail de <span class="d-un-bloc">mi-session</span></h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Mi-session" droite={D}>
      <h2 class="e">Le travail de mi-session</h2>
      <MiSession />
    </Slide>

    <!-- ================= AVANT LE 15 OCTOBRE ================= -->
    <Slide fond="encre" bandeau="Avant le 15 octobre" droite={D}>
      <h1 class="e">Avant le 15 octobre</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Avant le 15 octobre" droite={D}>
      <h2 class="e">Trois choses</h2>
      <AvantS7 />
    </Slide>

    <Slide fond="encre" bandeau="Avant le 15 octobre" droite={D}>
      <h1 class="e">Jeudi 15 octobre</h1>
      <hr class="filet" />
      <p class="lead e">La régression linéaire simple.</p>
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
