<script>
  /**
   * POL-2000 — Séance 4 · Préparer ses données avec R
   * Jeudi 24 septembre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine : moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine et bouge.
   *
   * Le fil : l'Étude électorale canadienne 2025, les données du travail de
   * session, arrive brute. Une échelle de 0 à 10 y a une moyenne de -11,44.
   * On range (les données tidy), on lit (le codebook), on recode
   * (mutate + case_when), on traite le vide (-99, « ne sait pas », NA), et on
   * sauvegarde une base propre. La syntaxe est celle du tidyverse seulement,
   * dans la suite des séances 2 et 3.
   *
   * Sources. Le cours 4 d'Adrien Cloutier (hiver 2024) : le codebook comme
   * « dictionnaire », na.rm, les opérateurs logiques (le bol de fruits), le
   * recodage par condition. Le cours 4 de FAS1001 (2025) : les données tidy
   * et leurs cinq problèmes (Wickham 2014), le codebook de l'Étude électorale
   * de 1993, le chemin du brut au propre, l'anatomie d'une ligne de recodage
   * et sa traduction en langage naturel.
   *
   * Rien n'est inventé pour une sortie de R ni pour une figure : tout vient
   * de src/lib/data/seance4.js, généré par outils/seance4_data.R.
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Code from '$lib/deck/Code.svelte';
  import Citation from '$lib/deck/Citation.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import Console from '$lib/deck/visuels/Console.svelte';
  import Tidy from '$lib/deck/visuels/Tidy.svelte';
  import QuatreVingts from '$lib/deck/visuels/QuatreVingts.svelte';
  import Nettoyage from '$lib/deck/visuels/Nettoyage.svelte';
  import CinqProblemes from '$lib/deck/visuels/CinqProblemes.svelte';
  import Probleme from '$lib/deck/visuels/Probleme.svelte';
  import Codebook1993 from '$lib/deck/visuels/Codebook1993.svelte';
  import FicheCodebook from '$lib/deck/visuels/FicheCodebook.svelte';
  import Operateurs from '$lib/deck/visuels/Operateurs.svelte';
  import CaseWhen from '$lib/deck/visuels/CaseWhen.svelte';
  import Recodage from '$lib/deck/visuels/Recodage.svelte';
  import Inverser from '$lib/deck/visuels/Inverser.svelte';
  import TroisVides from '$lib/deck/visuels/TroisVides.svelte';
  import Mystere from '$lib/deck/visuels/Mystere.svelte';
  import Pertes from '$lib/deck/visuels/Pertes.svelte';
  import BrutPropre from '$lib/deck/visuels/BrutPropre.svelte';
  import Examen1 from '$lib/deck/visuels/Examen1.svelte';
  import AvantS5 from '$lib/deck/visuels/AvantS5.svelte';
  import { CONSOLES, TIDY } from '$lib/data/seance4.js';

  const TOTAL = 48;
  const D = 'POL-2000 · séance 4 · jeu 24 sept';

  // Les consoles viennent de R telles quelles; seules les notes sont d'ici.
  const avec = (cle, notes = []) => CONSOLES[cle].map((l, i) => ({ ...l, note: notes[i] || '' }));
  const c_mystere = avec('mystere', ['Une échelle de 0 à 10. Une moyenne de -11,44 ?']);
  const c_codebook = avec('codebook');
  const c_scolarite = avec('scolarite');
  const c_satisfaction = avec('satisfaction');
  const c_piege = avec('piege', ['', '', 'Les 132 « ne sait pas » sont devenus des 0.']);
  const c_corrige = avec('corrige', ['', 'Sans règle, case_when() laisse NA.']);
  const c_na = avec('na', ['', 'Un seul NA, et la moyenne devient NA.', '', '']);
  const c_propre = avec('propre');
  const c_pertes = avec('pertes');

  // Les cinq problèmes : le code affiché est celui que R a exécuté.
  const code = (cle, ...i) => i.map((k) => CONSOLES[cle][k].in).join('\n');
  const T = TIDY;

  const script = `# POL-2000 · séance 4 · Préparer ses données avec R
# À refaire chez vous, ligne par ligne, Ctrl + Entrée.

library(ces)
library(dplyr)
library(tidyr)
library(haven)

df <- readRDS("ces2025.rds")   # sauvegardé à la séance 2 ; sinon : df <- get_ces("2025")

# 1. Le codebook, dans R
attr(df$cps25_demsat, "label")
count(df, cps25_demsat)

# 2. Recoder en trois catégories
d <- df |>
  mutate(scolarite = case_when(
    cps25_education <= 5  ~ "Secondaire ou moins",
    cps25_education <= 7  ~ "Collégial",
    cps25_education <= 11 ~ "Universitaire"
  ))
count(d, cps25_education, scolarite)   # toujours vérifier

# 3. Inverser une échelle, de 0 à 1
d <- d |>
  mutate(satisfaction = case_when(
    cps25_demsat == 1 ~ 1,
    cps25_demsat == 2 ~ 0.67,
    cps25_demsat == 3 ~ 0.33,
    cps25_demsat == 4 ~ 0
  ))
count(d, satisfaction)

# 4. Oui, non, et « ne sait pas »
d <- d |>
  mutate(ne_canada = case_when(
    cps25_bornin_canada == 1 ~ 1,
    cps25_bornin_canada == 2 ~ 0
  ))
count(d, ne_canada)

# 5. Les valeurs manquantes
d <- d |> mutate(gauche_droite = na_if(cps25_lr_scale_bef_1, -99))
mean(d$gauche_droite, na.rm = TRUE)
sum(is.na(d$gauche_droite))

# 6. Une base propre, sauvegardée
df_propre <- d |>
  mutate(age = as.numeric(cps25_age_in_years),
         vote = as_factor(cps25_votechoice)) |>
  select(age, scolarite, gauche_droite, satisfaction, ne_canada, vote)
saveRDS(df_propre, "ces2025_propre.rds")

# 7. Des données tidy
relig_income |>
  pivot_longer(!religion, names_to = "revenu", values_to = "n")

# 8. À vous : cps25_interest_gen_1 a aussi des -99. Recodez-les, puis sa moyenne.`;
  // Trop long pour une diapo à taille lisible : coupé avant « 2. », « 4. » et « 6. ».
  const coupes = ['\n# 2. ', '\n# 4. ', '\n# 6. '].map((c) => script.indexOf(c));
  const [script1, script2, script3, script4] = [0, ...coupes].map((d, i, t) => script.slice(i ? d + 1 : 0, t[i + 1]));
</script>

<svelte:head>
  <title>POL-2000 · Séance 4 — Préparer ses données avec R</title>
</svelte:head>

<Deck total={TOTAL} logo="{base}/img/ulaval-logo.png">
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->
    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre">
        <p class="surtitre e">POL-2000 · Méthodologie quantitative</p>
        <h1 class="e">Préparer ses données avec R</h1>
        <hr class="filet" />
        <p class="lead e">Séance 4 · jeudi 24 septembre 2026</p>
      </div>
      <div class="entete-ul e">
        <img src="{base}/img/ulaval-logo.png" alt="Université Laval" />
        <span class="sep"></span>
        <span class="dept">Département de science politique<br />Faculté des sciences sociales</span>
        <span class="session">Automne 2026</span>
      </div>
    </Slide>

    <Slide bandeau="Où on en est" droite={D}>
      <Session ici={4} />
    </Slide>

    <Slide bandeau="Un tour de salle" droite={D}>
      <h2 class="e">À main levée</h2>
      <ol class="mains e">
        <li><span>Avez-vous refait le script de la séance 3 ?</span></li>
        <li><span>Avez-vous fait le Datacamp de la semaine ?</span></li>
        <li><span>Avez-vous déjà ouvert un codebook ?</span></li>
      </ol>
    </Slide>

    <Slide bandeau="Un mystère" droite={D}>
      <h2 class="e">Gauche ou droite, de 0 à 10</h2>
      <Console lignes={c_mystere} />
    </Slide>

    <Slide fond="encre" bandeau="Votre travail" droite={D}>
      <p class="surtitre e">Les données de votre travail</p>
      <h1 class="e">L’Étude électorale canadienne 2025</h1>
      <hr class="filet" />
      <p class="lead e">Aujourd’hui, on la prépare.</p>
    </Slide>

    <Slide bandeau="Préparer" droite={D}>
      <h2 class="e">Le vrai travail</h2>
      <QuatreVingts />
    </Slide>

    <Slide bandeau="Préparer" droite={D}>
      <h2 class="e">Du brut au propre</h2>
      <Nettoyage />
    </Slide>

    <!-- ================= 1 · DES DONNÉES TIDY ================= -->
    <Slide fond="encre" bandeau="Des données tidy" droite={D}>
      <p class="surtitre e">1 de 3</p>
      <h1 class="e">Des données tidy</h1>
      <hr class="filet" />
      <div class="e">
        <Citation source="Hadley Wickham, « Tidy Data », 2014">« Les jeux de données bien rangés se ressemblent tous ; chaque jeu de données désordonné l’est à sa façon. »</Citation>
      </div>
    </Slide>

    <Slide bandeau="Des données tidy" droite={D}>
      <h2 class="e">Trois règles, déjà vues</h2>
      <Tidy />
    </Slide>

    <Slide bandeau="Des données tidy" droite={D}>
      <h2 class="e">Cinq problèmes communs</h2>
      <CinqProblemes />
    </Slide>

    <Slide bandeau="Des données tidy · 1 de 5" droite={D}>
      <h2 class="e">Des valeurs dans les en-têtes</h2>
      <Probleme
        avant={[{ ...T.relig.avant, suite: `… ${T.relig.nAvant[1]} colonnes` }]}
        marque={['<$10k', '$10-20k', '$20-30k']}
        code={code('relig', 1)}
        apres={[{ ...T.relig.apres, suite: `… ${T.relig.nApres[0]} lignes` }]}
        explication="Les tranches de revenu sont des valeurs, pas des variables."
        source="Revenu et religion aux États-Unis, Pew Research Center · tidyr::relig_income" />
    </Slide>

    <Slide bandeau="Des données tidy · 2 de 5" droite={D}>
      <h2 class="e">Plusieurs variables dans une colonne</h2>
      <Probleme
        avant={[{ ...T.who.avant, suite: `… ${T.who.nAvant[1]} colonnes` }]}
        marque={['sp_m_014', 'sp_m_1524', 'sp_f_014', 'sp_f_1524']}
        code={code('who', 0)}
        apres={[{ ...T.who.apres, suite: `… ${T.who.nApres[0].toLocaleString('fr-CA')} lignes` }]}
        explication="sp_m_014 cache trois variables : le diagnostic, le sexe, l’âge."
        source="Cas de tuberculose, Canada 2010, Organisation mondiale de la santé · tidyr::who2" />
    </Slide>

    <Slide bandeau="Des données tidy · 3 de 5" droite={D}>
      <h2 class="e">Des variables dans les lignes et les colonnes</h2>
      <Probleme
        avant={[T.meteo.avant]}
        marque={['mesure', 'd1', 'd2', 'd3', 'd4']}
        code={code('meteo', 1)}
        apres={[T.meteo.apres]}
        explication="Les jours sont en colonnes, les deux températures en lignes."
        source="Station météo MX17004, février 2010 · Wickham (2014), tableau 11" />
    </Slide>

    <Slide bandeau="Des données tidy · 4 de 5" droite={D}>
      <h2 class="e">Deux types d’observations dans un tableau</h2>
      <Probleme
        avant={[{ ...T.billboard.avant, suite: `… ${T.billboard.nAvant[1]} colonnes` }]}
        marque={['wk1', 'wk2', 'wk3']}
        code={code('billboard', 0, 1)}
        apres={[{ titre: 'chansons', ...T.billboard.chansons }, { titre: 'classement', ...T.billboard.classement }]}
        explication="Une chanson, et chacune de ses semaines au palmarès : deux choses, deux tableaux."
        source="Palmarès Billboard, 2000 · tidyr::billboard" />
    </Slide>

    <Slide bandeau="Des données tidy · 5 de 5" droite={D}>
      <h2 class="e">Une observation dans plusieurs tableaux</h2>
      <Probleme
        avant={[{ titre: 'sieges_2021', ...T.sieges.a2021 }, { titre: 'sieges_2025', ...T.sieges.a2025 }]}
        marque={[]}
        code={code('sieges', 1)}
        apres={[T.sieges.apres]}
        explication="Mêmes partis, mêmes colonnes, un fichier par élection."
        source="Sièges à la Chambre des communes, élections de 2021 et 2025 · Élections Canada" />
    </Slide>

    <!-- ================= 2 · LE CODEBOOK ================= -->
    <Slide fond="encre" bandeau="Le codebook" droite={D}>
      <p class="surtitre e">2 de 3</p>
      <h1 class="e">Le codebook</h1>
      <hr class="filet" />
      <p class="lead e">Le dictionnaire des données.</p>
    </Slide>

    <Slide bandeau="Le codebook" droite={D}>
      <h2 class="e">Des codes illisibles</h2>
      <Codebook1993 />
    </Slide>

    <Slide bandeau="Le codebook" droite={D}>
      <h2 class="e">Lire une entrée</h2>
      <FicheCodebook />
    </Slide>

    <Slide bandeau="En direct · le codebook" droite={D}>
      <h2 class="e">Le codebook, dans R</h2>
      <Console lignes={c_codebook} />
    </Slide>

    <!-- ================= PAUSE ================= -->
    <Slide fond="encre" bandeau="Pause" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <p class="lead e">Quinze minutes.</p>
    </Slide>

    <!-- ================= 3 · RECODER ================= -->
    <Slide fond="encre" bandeau="Recoder" droite={D}>
      <p class="surtitre e">3 de 3</p>
      <h1 class="e">Recoder</h1>
      <hr class="filet" />
      <p class="lead e">Des codes du sondage aux catégories de votre question.</p>
    </Slide>

    <Slide bandeau="Recoder" droite={D}>
      <h2 class="e">Poser une question à R</h2>
      <Operateurs />
    </Slide>

    <Slide bandeau="Recoder" droite={D}>
      <h2 class="e">Si…, alors…</h2>
      <CaseWhen />
    </Slide>

    <Slide bandeau="En direct · recoder" droite={D}>
      <h2 class="e">Trois catégories</h2>
      <Console lignes={c_scolarite} />
    </Slide>

    <Slide bandeau="Recoder" droite={D}>
      <h2 class="e">Toujours vérifier</h2>
      <Recodage />
    </Slide>

    <Slide bandeau="Recoder" droite={D}>
      <h2 class="e">Inverser une échelle</h2>
      <Inverser />
    </Slide>

    <Slide bandeau="En direct · recoder" droite={D}>
      <h2 class="e">De 0 à 1, dans R</h2>
      <Console lignes={c_satisfaction} />
    </Slide>

    <Slide bandeau="En direct · recoder" droite={D}>
      <h2 class="e">Le piège de if_else()</h2>
      <Console lignes={c_piege} />
    </Slide>

    <Slide bandeau="En direct · recoder" droite={D}>
      <h2 class="e">case_when(), encore</h2>
      <Console lignes={c_corrige} />
    </Slide>

    <!-- ================= LES VALEURS MANQUANTES ================= -->
    <Slide fond="encre" bandeau="Les valeurs manquantes" droite={D}>
      <h1 class="e">Les valeurs manquantes</h1>
      <hr class="filet" />
      <p class="lead e">Un trou n’est pas un zéro.</p>
    </Slide>

    <Slide bandeau="Les valeurs manquantes" droite={D}>
      <h2 class="e">Trois sortes de vide</h2>
      <TroisVides />
    </Slide>

    <Slide bandeau="Les valeurs manquantes" droite={D}>
      <h2 class="e">Le mystère du -99</h2>
      <Mystere />
    </Slide>

    <Slide bandeau="En direct · les valeurs manquantes" droite={D}>
      <h2 class="e">na_if(), puis na.rm</h2>
      <Console lignes={c_na} />
    </Slide>

    <Slide bandeau="Les valeurs manquantes" droite={D}>
      <h2 class="e">Chaque variable coûte des lignes</h2>
      <Pertes />
    </Slide>

    <!-- ================= UNE BASE PROPRE ================= -->
    <Slide fond="encre" bandeau="Une base propre" droite={D}>
      <h1 class="e">Une base propre</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Une base propre" droite={D}>
      <h2 class="e">Six personnes, avant et après</h2>
      <BrutPropre />
    </Slide>

    <Slide bandeau="En direct · une base propre" droite={D}>
      <h2 class="e">Garder, nommer, sauvegarder</h2>
      <Console lignes={c_propre} />
    </Slide>

    <Slide bandeau="En direct · une base propre" droite={D}>
      <h2 class="e">Combien de lignes complètes ?</h2>
      <Console lignes={c_pertes} />
    </Slide>

    <Slide bandeau="En direct · le script" droite={D}>
      <h2 class="e">Le script entier, 1 de 4</h2>
      <Code src={script1} titre="seance4.R · à refaire chez vous" />
    </Slide>

    <Slide bandeau="En direct · le script" droite={D}>
      <h2 class="e">Le script entier, 2 de 4</h2>
      <Code src={script2} titre="seance4.R · la suite" />
    </Slide>

    <Slide bandeau="En direct · le script" droite={D}>
      <h2 class="e">Le script entier, 3 de 4</h2>
      <Code src={script3} titre="seance4.R · la suite" />
    </Slide>

    <Slide bandeau="En direct · le script" droite={D}>
      <h2 class="e">Le script entier, 4 de 4</h2>
      <Code src={script4} titre="seance4.R · la fin" />
    </Slide>

    <!-- ================= L'EXAMEN 1 ================= -->
    <Slide fond="encre" bandeau="Examen 1" droite={D}>
      <h1 class="e">L’examen 1 ouvre aujourd’hui</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Examen 1" droite={D}>
      <h2 class="e">Examen 1</h2>
      <Examen1 />
    </Slide>

    <!-- ================= AVANT JEUDI PROCHAIN ================= -->
    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Avant jeudi prochain</h1>
      <hr class="filet" />
    </Slide>

    <Slide bandeau="Avant jeudi prochain" droite={D}>
      <h2 class="e">Deux choses</h2>
      <AvantS5 />
    </Slide>

    <Slide fond="encre" bandeau="Avant jeudi prochain" droite={D}>
      <h1 class="e">Jeudi prochain</h1>
      <hr class="filet" />
      <p class="lead e">L’inférence statistique.</p>
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
