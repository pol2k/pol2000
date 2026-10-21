<script>
  /**
   * POL-2000 — Séance 8 · La régression linéaire multiple
   * Jeudi 22 octobre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine : moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine et bouge.
   *
   * Le fil (pol-7ds) : deux moitiés. Avant la pause, comprendre : la séance 7
   * s'est arrêtée sur un tableau à deux colonnes, on le lit maintenant.
   * Ajouter une variable (deux droites parallèles), « à âge égal » tranche
   * par tranche, ce que le modèle met de côté (le diagramme d'Arel-Bundock),
   * pourquoi ajouter des variables, puis la phrase pour lire chaque
   * coefficient : continu, binaire, sans étoile, catégoriel, la constante et
   * des profils. Ce que contrôler ne fait pas. Après la pause, coder :
   * l'atelier, de la CES brute au tableau et au graphique, puis un exercice.
   *
   * Sources. Le cours 9 d'Adrien Cloutier (hiver 2024, la régression
   * multiple : l'équation, les variables de contrôle, lire un tableau) et son
   * cours 10 (tout en R : lm(), deux modèles, modelsummary). Arel-Bundock
   * (2021), chapitre 5 : la taille de la mère et « femme » (fig. 5.4), la
   * variation commune (fig. 5.5), précision et biais. Les formules restent
   * hors des diapos.
   *
   * Données. Avant la pause : notre sondage de la séance 7 (1 000 parmi les
   * 20 180, graine 62), pour retrouver les mêmes chiffres. L'atelier : toute
   * la CES, comme dans le travail. Rien n'est inventé pour une sortie de R ni
   * pour une figure : tout vient de src/lib/data/seance8.js et
   * static/img/s8-*.png, générés par outils/seance8_data.R. Les profils
   * (Camille, Robert) sont fictifs, leurs prédictions viennent de R.
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Code from '$lib/deck/Code.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import Aujourdhui8 from '$lib/deck/visuels/Aujourdhui8.svelte';
  import TabSuite from '$lib/deck/visuels/TabSuite.svelte';
  import GrapheEpsilon from '$lib/deck/visuels/GrapheEpsilon.svelte';
  import CoefPlusieurs from '$lib/deck/visuels/CoefPlusieurs.svelte';
  import M8Paralleles from '$lib/deck/visuels/M8Paralleles.svelte';
  import M8Tranches from '$lib/deck/visuels/M8Tranches.svelte';
  import M8Venn from '$lib/deck/visuels/M8Venn.svelte';
  import M8Raisons from '$lib/deck/visuels/M8Raisons.svelte';
  import M8Escalier from '$lib/deck/visuels/M8Escalier.svelte';
  import M8Phrase from '$lib/deck/visuels/M8Phrase.svelte';
  import M8Categorie from '$lib/deck/visuels/M8Categorie.svelte';
  import M8Profils from '$lib/deck/visuels/M8Profils.svelte';
  import M8Limites from '$lib/deck/visuels/M8Limites.svelte';
  import M8Etapes from '$lib/deck/visuels/M8Etapes.svelte';
  import M8Image from '$lib/deck/visuels/M8Image.svelte';
  import M8AVous from '$lib/deck/visuels/M8AVous.svelte';
  import Console from '$lib/deck/visuels/Console.svelte';
  import AvantS9 from '$lib/deck/visuels/AvantS9.svelte';
  import { TIERS, VARS } from '$lib/data/seance7.js';
  import { MULTI, ATELIER, TABLEAU, GRAPHIQUE, EXERCICE, COEFS } from '$lib/data/seance8.js';

  const TOTAL = 49;
  const D = 'POL-2000 · séance 8 · jeu 22 oct';

  // Les consoles viennent de R telles quelles; seules les notes sont d'ici.
  const avec = (cle, notes = []) => ATELIER[cle].map((l, i) => ({ ...l, note: notes[i] || '' }));
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const coef = (m, t) => m.find((c) => c.terme === t).b;
  const N = COEFS.n;

  const c_charger = avec('charger', ['', 'ces2025.rds, sauvegardé à la séance 2', `vous devriez voir ${COEFS.n_ces}`, 'df_raw ne change jamais']);
  const c_interet = avec('interet', ['-99 : « préfère ne pas répondre »', '', '-99 est devenu NA']);
  const c_scolarite = avec('scolarite', ['', 'code 12 (ne sait pas) : NA']);
  const c_age = avec('age', ['', 'on enlève 18 ans, on divise par 78 : 18 ans donne 0, 96 ans donne 1', '']);
  const c_femme = avec('femme', ['', 'non binaire, autre : NA (trop peu pour une catégorie)']);
  const c_revenu = avec('revenu', ['9 : « ne sait pas, préfère ne pas répondre »', 'même recette : la tranche 1 donne 0, la tranche 8 donne 1', '']);
  const c_quebec = avec('quebec', ['', 'aucun NA : tout le monde a une province']);
  const c_verifier = avec('verifier', [`le revenu : ${nb(COEFS.manquants.revenu)} vides. C’est là que N baisse.`]);
  const c_modeles = avec('modeles', ['', '', '', `vous devriez voir ${N.modele1}`, '', 'une personne sans revenu déclaré sort du modèle 3']);
  const c_categorie = avec('categorie', ['les numéros fixent l’ordre : la première catégorie est la référence', '', 'pas de ligne pour « 1. Secondaire non terminé » : c’est la référence']);
  const c_satisfaction = avec('satisfaction', ['la recette de la séance 4', '']);

  // Le script complet, tel qu'exécuté par R (outils/seance8_data.R).
  const ins = (cle) => ATELIER[cle].map((l) => l.in).join('\n');
  const SCRIPT_1 = `# POL-2000 · séance 8 · l'atelier
# À refaire chez vous, ligne par ligne, Ctrl + Entrée.

${ins('charger')}

# Y : l'intérêt pour la politique
${ATELIER.interet[1].in}

# Les variables explicatives
${ATELIER.scolarite[0].in}`;
  const SCRIPT_2 = `${ATELIER.age[1].in}
${ATELIER.femme[0].in}
${ATELIER.revenu[1].in}
${ATELIER.quebec[0].in}

colSums(is.na(df_clean))   # toujours vérifier

${ATELIER.modeles.slice(0, 3).map((l) => l.in).join('\n')}`;
  const SCRIPT_3 = `${TABLEAU.code}

${GRAPHIQUE.code}
${GRAPHIQUE.enregistrer}`;

  // Les phrases : les coefficients de la séance 7 (notre sondage, MULTI).
  const MC = MULTI.coefs;
  // L'exercice : la satisfaction (toute la CES, modele5).
  const S5 = COEFS.modele5;
</script>

<svelte:head>
  <title>POL-2000 · Séance 8 · La régression linéaire multiple</title>
</svelte:head>

<Deck total={TOTAL} logo="{base}/img/ulaval-logo.png">
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->
    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre">
        <p class="surtitre e">POL-2000 · Méthodologie quantitative</p>
        <h1 class="e">La régression linéaire multiple</h1>
        <hr class="filet" />
        <p class="lead e">Séance 8 · jeudi 22 octobre 2026</p>
      </div>
      <div class="entete-ul e">
        <img src="{base}/img/ulaval-logo.png" alt="Université Laval" />
        <span class="sep"></span>
        <span class="dept">Département de science politique<br />Faculté des sciences sociales</span>
        <span class="session">Automne 2026</span>
      </div>
    </Slide>

    <Slide bandeau="Où on en est" droite={D}>
      <Session ici={8} />
    </Slide>

    <Slide bandeau="Aujourd’hui" droite={D}>
      <h2 class="e">Aujourd’hui</h2>
      <Aujourdhui8 />
    </Slide>

    <!-- ================= LE RETOUR ================= -->
    <Slide bandeau="La semaine passée" droite={D}>
      <h2 class="e">Vous l’avez vu. Aujourd’hui, on le lit.</h2>
      <TabSuite />
    </Slide>

    <Slide bandeau="La semaine passée" droite={D}>
      <h2 class="e">Une seule variable, et tout le reste dans ε</h2>
      <GrapheEpsilon x="scolarité" y="intérêt" xEq={VARS.x.nom} yEq={VARS.y.nom} z="l’âge" autres={['le revenu', 'le genre', 'la région']} alerte={['l’âge', 'touche aussi x']} etiqY="plus d’intérêt" etiqX="moins de scolarité" b1={TIERS.b1_seul} pied="le graphe est une hypothèse · séance 11" />
    </Slide>

    <!-- ================= AJOUTER DES VARIABLES ================= -->
    <Slide fond="encre" bandeau="Ajouter des variables" droite={D}>
      <h1 class="e">Ajouter des variables</h1>
      <hr class="filet" />
      <p class="lead e">Sortir une variable du bruit, et la mettre dans le modèle.</p>
    </Slide>

    <Slide bandeau="Ajouter des variables" droite={D}>
      <h2 class="e">Deux droites parallèles</h2>
      <M8Paralleles />
    </Slide>

    <Slide bandeau="Ajouter des variables · à âge égal" droite={D}>
      <h2 class="e">À âge égal, tranche par tranche</h2>
      <M8Tranches />
    </Slide>

    <Slide bandeau="Ajouter des variables · à âge égal" droite={D}>
      <h2 class="e">Ce que le modèle met de côté</h2>
      <M8Venn />
    </Slide>

    <Slide bandeau="Ajouter des variables" droite={D}>
      <h2 class="e">Pourquoi ajouter des variables&#8239;?</h2>
      <M8Raisons />
    </Slide>

    <Slide bandeau="Ajouter des variables" droite={D}>
      <h2 class="e">Une variable à la fois</h2>
      <M8Escalier />
    </Slide>

    <!-- ================= LIRE CHAQUE COEFFICIENT ================= -->
    <Slide fond="encre" bandeau="Lire chaque coefficient" droite={D}>
      <h1 class="e">Lire chaque coefficient</h1>
      <hr class="filet" />
      <p class="lead e">Une phrase, toujours la même.</p>
    </Slide>

    <Slide bandeau="Lire chaque coefficient · la phrase" droite={D}>
      <h2 class="e">La phrase à retenir</h2>
      <M8Phrase autres="âge, genre, revenu et région" mouvement="passer de « secondaire non terminé » à « maîtrise, doctorat »" b={coef(MC, 'scolarite')} />
    </Slide>

    <Slide bandeau="Lire chaque coefficient · continue" droite={D}>
      <h2 class="e">Une variable continue&#8239;: l’âge</h2>
      <M8Phrase autres="scolarité, genre, revenu et région" mouvement="passer de 18 à {MULTI.age_max} ans" b={coef(MC, 'age')} />
    </Slide>

    <Slide bandeau="Lire chaque coefficient · binaire" droite={D}>
      <h2 class="e">Une variable binaire&#8239;: femme</h2>
      <M8Phrase autres="scolarité, âge, revenu et région" mouvement="être une femme plutôt qu’un homme" b={coef(MC, 'femme')} />
    </Slide>

    <Slide bandeau="Lire chaque coefficient · sans étoile" droite={D}>
      <h2 class="e">Et le Québec&#8239;?</h2>
      <CoefPlusieurs mode="signif" />
    </Slide>

    <Slide bandeau="Lire chaque coefficient · catégorielle" droite={D}>
      <h2 class="e">Une variable catégorielle&#8239;: une référence</h2>
      <M8Categorie />
    </Slide>

    <Slide bandeau="Lire chaque coefficient · la constante" droite={D}>
      <h2 class="e">La constante, puis des profils</h2>
      <M8Profils />
    </Slide>

    <Slide bandeau="Ajouter des variables · les limites" droite={D}>
      <h2 class="e">Ce que contrôler ne fait pas</h2>
      <M8Limites />
    </Slide>

    <!-- ================= PAUSE ================= -->
    <Slide fond="encre" bandeau="Pause" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <p class="lead e">Quinze minutes. Au retour, ouvrez Positron.</p>
    </Slide>

    <!-- ================= L'ATELIER ================= -->
    <Slide fond="encre" bandeau="Atelier" droite={D}>
      <h1 class="e">Atelier&#8239;: du brut au tableau</h1>
      <hr class="filet" />
      <p class="lead e">Toute la CES, comme dans votre travail.</p>
    </Slide>

    <Slide bandeau="Atelier" droite={D}>
      <h2 class="e">Six étapes</h2>
      <M8Etapes />
      <div class="avant">
        <p class="e">Dans votre projet Positron&#8239;:</p>
        <Code src={'# un nouveau fichier : seance8.R\ninstall.packages("modelsummary")   # une seule fois'} titre="seance8.R" />
        <p class="e petit-dit">ces2025.rds doit être dans le dossier du projet (séance 2).</p>
      </div>
    </Slide>

    <Slide bandeau="Atelier · charger" droite={D}>
      <M8Etapes ici={1} />
      <h2 class="e">Charger, et préparer df_clean</h2>
      <Console lignes={c_charger} />
    </Slide>

    <Slide bandeau="Atelier · nettoyer" droite={D}>
      <M8Etapes ici={2} />
      <h2 class="e">Y&#8239;: l’intérêt, de 0 à 1</h2>
      <Console lignes={c_interet} />
    </Slide>

    <Slide bandeau="Atelier · nettoyer" droite={D}>
      <M8Etapes ici={2} />
      <h2 class="e">La scolarité, en cinq niveaux</h2>
      <Console lignes={c_scolarite} />
    </Slide>

    <Slide bandeau="Atelier · nettoyer" droite={D}>
      <M8Etapes ici={2} />
      <h2 class="e">L’âge, de 18 à 96 ans → de 0 à 1</h2>
      <Console lignes={c_age} />
    </Slide>

    <Slide bandeau="Atelier · nettoyer" droite={D}>
      <M8Etapes ici={2} />
      <h2 class="e">Femme&#8239;: oui ou non</h2>
      <Console lignes={c_femme} />
    </Slide>

    <Slide bandeau="Atelier · nettoyer" droite={D}>
      <M8Etapes ici={2} />
      <h2 class="e">Le revenu, huit tranches → de 0 à 1</h2>
      <Console lignes={c_revenu} />
    </Slide>

    <Slide bandeau="Atelier · nettoyer" droite={D}>
      <M8Etapes ici={2} />
      <h2 class="e">Québec&#8239;: oui ou non</h2>
      <Console lignes={c_quebec} />
    </Slide>

    <Slide bandeau="Atelier · vérifier" droite={D}>
      <M8Etapes ici={3} />
      <h2 class="e">Combien de vides&#8239;?</h2>
      <Console lignes={c_verifier} />
    </Slide>

    <Slide bandeau="Atelier · modéliser" droite={D}>
      <M8Etapes ici={4} />
      <h2 class="e">Trois modèles, de plus en plus riches</h2>
      <Console lignes={c_modeles} />
    </Slide>

    <Slide bandeau="Atelier · tableau" droite={D}>
      <M8Etapes ici={5} />
      <M8Image code={TABLEAU.code} img={TABLEAU.img} l={TABLEAU.l} h={TABLEAU.h} px={100} nouveau={[6, 7]} dit="trois modèles = trois colonnes" alt="Le tableau de modelsummary : trois modèles côte à côte, la constante, la scolarité, l’âge, femme, le revenu et Québec, puis Num.Obs. et R2." />
    </Slide>

    <Slide bandeau="Atelier · graphique" droite={D}>
      <M8Etapes ici={6} />
      <M8Image code={GRAPHIQUE.code + '\n' + GRAPHIQUE.enregistrer} img={GRAPHIQUE.img} l={GRAPHIQUE.l} h={GRAPHIQUE.h} px={68} nouveau={[0]} dit="sans la première ligne : un graphique vide" alt="Le graphique de modelplot : les coefficients des trois modèles et leurs intervalles de confiance à 95 %." />
    </Slide>

    <Slide bandeau="Atelier · lire" droite={D}>
      <h2 class="e">Toute la CES&#8239;: la phrase</h2>
      <M8Phrase autres="âge, genre, revenu et région" mouvement="passer de « secondaire non terminé » à « maîtrise, doctorat »" b={coef(COEFS.modele3, 'scolarite')} />
    </Slide>

    <Slide bandeau="Atelier · catégorielle" droite={D}>
      <h2 class="e">Le diplôme en catégories</h2>
      <Console lignes={c_categorie.slice(0, 1)} />
    </Slide>

    <Slide bandeau="Atelier · catégorielle" droite={D}>
      <h2 class="e">Une ligne par catégorie, sauf la référence</h2>
      <Console lignes={c_categorie.slice(1)} />
    </Slide>

    <!-- ================= À VOUS ================= -->
    <Slide fond="encre" bandeau="À vous" droite={D}>
      <h1 class="e">À vous</h1>
      <hr class="filet" />
      <p class="lead e">La satisfaction envers la démocratie.</p>
    </Slide>

    <Slide bandeau="À vous" droite={D}>
      <h2 class="e">Même recette, autre Y</h2>
      <M8AVous />
    </Slide>

    <Slide bandeau="À vous · la réponse" droite={D}>
      <h2 class="e">1. Recoder</h2>
      <Console lignes={c_satisfaction} />
    </Slide>

    <Slide bandeau="À vous · la réponse" droite={D}>
      <M8Image code={EXERCICE.code} img={EXERCICE.img} l={EXERCICE.l} h={EXERCICE.h} px={100} nouveau={[1, 2]} dit="deux Y, deux colonnes" alt="Deux modèles côte à côte : l’intérêt et la satisfaction envers la démocratie, avec les mêmes cinq variables." />
    </Slide>

    <Slide bandeau="À vous · la réponse" droite={D}>
      <h2 class="e">Femme, à tout le reste égal</h2>
      <M8Phrase autres="scolarité, âge, revenu et région" mouvement="être une femme plutôt qu’un homme" b={coef(S5, 'femme')} y="de satisfaction" etoiles={false} />
    </Slide>

    <Slide bandeau="À vous · la réponse" droite={D}>
      <h2 class="e">Québec, à tout le reste égal</h2>
      <M8Phrase autres="scolarité, âge, genre et revenu" mouvement="vivre au Québec plutôt qu’ailleurs au Canada" b={coef(S5, 'quebec')} y="de satisfaction" />
    </Slide>

    <!-- ================= LE SCRIPT ================= -->
    <Slide bandeau="Le script complet" droite={D}>
      <Code src={SCRIPT_1} titre="seance8.R · à refaire chez vous" />
    </Slide>

    <Slide bandeau="Le script complet" droite={D}>
      <Code src={SCRIPT_2} titre="seance8.R · la suite" />
    </Slide>

    <Slide bandeau="Le script complet" droite={D}>
      <Code src={SCRIPT_3} titre="seance8.R · la fin" />
    </Slide>

    <!-- ================= FIN ================= -->
    <Slide bandeau="Après la semaine de lecture" droite={D}>
      <h2 class="e">Le 5 novembre&#8239;: votre question, à la main, puis avec l’IA</h2>
      <p class="grande-q e">Aujourd’hui, tout le monde avait les mêmes variables. La prochaine fois, ce sont les vôtres.</p>
    </Slide>

    <Slide bandeau="Avant le 5 novembre" droite={D}>
      <h2 class="e">Trois choses</h2>
      <AvantS9 />
    </Slide>

    <Slide fond="encre" bandeau="Avant le 5 novembre" droite={D}>
      <h1 class="e">Jeudi 5 novembre</h1>
      <hr class="filet" />
      <p class="lead e">De la question au tableau de régression.</p>
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

  .avant { max-width: 44em; margin: 1.6em auto 0; display: flex; flex-direction: column; gap: 0.8em; }
  .petit-dit { margin: 0; color: var(--dk-gris); font-size: 0.85em; }
  .grande-q { font-size: 2em; line-height: 1.3; max-width: 22em; margin-top: 1.2em; }
</style>
