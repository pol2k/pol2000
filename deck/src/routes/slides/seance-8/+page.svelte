<script>
  /**
   * POL-2000 — Séance 8 · La régression linéaire multiple
   * Jeudi 22 octobre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine : moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine et bouge.
   *
   * Le fil (pol-7ds). La dernière séance avant la semaine de lecture, après
   * une semaine d'examens : trois blocs, du concret. 1. Citer (une vingtaine
   * de minutes) : le slogan de Google Scholar, d'où il vient, pourquoi
   * citer, deux trucs de Scholar, Zotero; on ajoute Blais et Gélineau
   * (2007) par son DOI. 2. Ajouter des variables, à la manière d'Arel-Bundock : deux
   * droites parallèles, à âge égal, ce que le modèle met de côté, et une
   * seule ligne se lit (on ne lit jamais les contrôles : le piège de la
   * table 2). 3. Après la pause, Blais et Gélineau (2007) : d'abord leur
   * article raconté comme un TP 1 (les sept étapes de TmParcours, M8LeurTP),
   * leurs vrais tableaux 1 et 2 (découpés du PDF, outils/seance8_tableaux.sh),
   * puis testés en 2025 : leur tableau 1 (la satisfaction envers la démocratie avant et après
   * l'élection de 1997), puis deux variables nettoyées en classe, lentement
   * (Y : la satisfaction après; X : gagnant), le contrôle (la même question,
   * avant), le tableau, jusque dans Word, et 1997 contre 2025. Le Y n'est
   * pas binaire (consigne des TP).
   *
   * Sources. Le cours 9 d'Adrien Cloutier (hiver 2024) et Arel-Bundock
   * (2021), chapitre 5. Blais, A. et F. Gélineau (2007), Political Studies
   * 55(2), 425-441, doi:10.1111/j.1467-9248.2007.00659.x (CES 1997; le
   * tableau 1 et une ligne du tableau 2 recopiés dans BG).
   * Westreich et Greenland (2013), « The Table 2 Fallacy », American
   * Journal of Epidemiology 177(4). Le chemin Obtenir@ULaval : les guides
   * de la Bibliothèque (bibl.ulaval.ca).
   *
   * Données. Avant la pause : notre sondage de la séance 7 (1 000 parmi les
   * 20 180, graine 62), pour retrouver les mêmes chiffres. Blais et
   * Gélineau en 2025 : toute la CES. Rien n'est inventé pour une sortie de R ni pour une
   * figure : tout vient de src/lib/data/seance8.js et static/img/s8-*.png,
   * générés par outils/seance8_data.R.
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Code from '$lib/deck/Code.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import Aujourdhui8 from '$lib/deck/visuels/Aujourdhui8.svelte';
  import TabSuite from '$lib/deck/visuels/TabSuite.svelte';
  import GrapheEpsilon from '$lib/deck/visuels/GrapheEpsilon.svelte';
  import M8Geants from '$lib/deck/visuels/M8Geants.svelte';
  import M8Citer from '$lib/deck/visuels/M8Citer.svelte';
  import M8Scholar from '$lib/deck/visuels/M8Scholar.svelte';
  import M8Zotero from '$lib/deck/visuels/M8Zotero.svelte';
  import M8Paralleles from '$lib/deck/visuels/M8Paralleles.svelte';
  import M8Tranches from '$lib/deck/visuels/M8Tranches.svelte';
  import M8Venn from '$lib/deck/visuels/M8Venn.svelte';
  import M8Raisons from '$lib/deck/visuels/M8Raisons.svelte';
  import M8Escalier from '$lib/deck/visuels/M8Escalier.svelte';
  import M8Phrase from '$lib/deck/visuels/M8Phrase.svelte';
  import M8UneLigne from '$lib/deck/visuels/M8UneLigne.svelte';
  import M8Limites from '$lib/deck/visuels/M8Limites.svelte';
  import M8Gelineau from '$lib/deck/visuels/M8Gelineau.svelte';
  import M8Tableau2 from '$lib/deck/visuels/M8Tableau2.svelte';
  import M8LeurTP from '$lib/deck/visuels/M8LeurTP.svelte';
  import TmParcours from '$lib/deck/visuels/TmParcours.svelte';
  import M8Etapes from '$lib/deck/visuels/M8Etapes.svelte';
  import M8Image from '$lib/deck/visuels/M8Image.svelte';
  import M8AvantApres from '$lib/deck/visuels/M8AvantApres.svelte';
  import M8Ecarts from '$lib/deck/visuels/M8Ecarts.svelte';
  import Console from '$lib/deck/visuels/Console.svelte';
  import AvantS9 from '$lib/deck/visuels/AvantS9.svelte';
  import { TIERS, VARS } from '$lib/data/seance7.js';
  import { MULTI, BG, ATELIER, TABLEAU, WORD, COEFS, SCRIPT } from '$lib/data/seance8.js';

  const TOTAL = 59;
  const D = 'POL-2000 · séance 8 · jeu 22 oct';

  // Les consoles viennent de R telles quelles; seules les notes sont d'ici.
  const avec = (cle, notes = []) => ATELIER[cle].map((l, i) => ({ ...l, note: notes[i] || '' }));
  const nb = (v) => v.toLocaleString('fr-CA').replace(/\s/g, ' ');
  const coef = (m, t) => m.find((c) => c.terme === t).b;
  const N = COEFS.n;

  const c_charger = avec('charger', ['', 'haven : pour lire les codes de la CES', 'ces2025.rds, sauvegardé à la séance 2', `vous devriez voir ${nb(COEFS.n_ces)}`, 'df_raw ne change jamais']);
  const c_question = avec('question', ['pes25 : le sondage après l’élection, aux mêmes personnes']);
  const c_apres = avec('apres', ['la recette de la séance 4', 'NA : pas de réponse après l’élection, ou « ne sait pas »']);
  const c_vote = avec('vote', ['les libéraux ont formé le gouvernement']);
  const c_gagnant = avec('gagnant', ['', 'NA : n’a pas voté, vote annulé, ne sait pas']);
  const c_avant = avec('avant', ['cps25 : la même question, pendant la campagne', '']);
  const c_moyennes = avec('moyennes', ['le tableau 1 de l’article, en 2025']);
  const c_modeles = avec('modeles', ['', 'à satisfaction égale avant l’élection', `vous devriez voir ${nb(N.modele1)}`, '']);
  const c_perdants = avec('perdants', ['les numéros fixent l’ordre : « 1. Gagnant » est la référence', '', '']);

  // Les noms affichés pour les tableaux à une ligne.
  const NOMS7 = { scolarite: 'Scolarité', age: 'Âge', femme: 'Femme', revenu: 'Revenu', quebec: 'Québec' };
  const NOMS8 = { gagnant: 'Gagnant', avant: 'Satisfaction avant l’élection' };

  // Le script complet : SCRIPT, vérifié dans une session R vierge (outils/seance8_data.R).
  const TITRES = ['seance8.R · à refaire chez vous', 'seance8.R · la suite', 'seance8.R · modèles et tableau', 'seance8.R · si on a le temps'];
  const G2 = coef(COEFS.modele2, 'gagnant');
  const cran = (G2 / 0.33).toLocaleString('fr-CA', { maximumFractionDigits: 1 });
  const C3 = (t) => COEFS.modele3.find((c) => c.terme === t);
  const v3 = (t) => (C3(t).b < 0 ? '−' : '+') + Math.abs(C3(t).b).toLocaleString('fr-CA', { minimumFractionDigits: 3, maximumFractionDigits: 3 }) + C3(t).etoiles;
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

    <!-- ================= CITER ================= -->
    <Slide fond="encre" bandeau="Citer" droite={D}>
      <h1 class="e">Citer</h1>
      <hr class="filet" />
      <p class="lead e">Google Scholar, puis Zotero.</p>
    </Slide>

    <Slide bandeau="Citer" droite={D}>
      <p class="slogan e">« Sur les épaules d’un géant »</p>
      <p class="grande-q e">Pourquoi Google Scholar écrit-il ça sur sa page d’accueil ?</p>
    </Slide>

    <Slide bandeau="Citer · les géants" droite={D}>
      <h2 class="e">Une phrase de 900 ans</h2>
      <M8Geants />
    </Slide>

    <Slide bandeau="Citer · pourquoi" droite={D}>
      <h2 class="e">Pourquoi citer ?</h2>
      <M8Citer />
    </Slide>

    <Slide bandeau="Citer · Google Scholar" droite={D}>
      <h2 class="e">Deux trucs de Google Scholar</h2>
      <M8Scholar />
    </Slide>

    <Slide bandeau="Citer · Zotero" droite={D}>
      <h2 class="e">Zotero : chercher, garder, citer</h2>
      <M8Zotero doi={BG.doi} />
    </Slide>

    <!-- ================= AJOUTER DES VARIABLES ================= -->
    <Slide bandeau="La semaine passée" droite={D}>
      <h2 class="e">Vous l’avez vu. Aujourd’hui, on le lit.</h2>
      <TabSuite />
    </Slide>

    <Slide bandeau="La semaine passée" droite={D}>
      <h2 class="e">Une seule variable, et tout le reste dans ε</h2>
      <GrapheEpsilon x="scolarité" y="intérêt" xEq={VARS.x.nom} yEq={VARS.y.nom} z="l’âge" autres={['le revenu', 'le genre', 'la région']} alerte={['l’âge', 'touche aussi x']} etiqY="plus d’intérêt" etiqX="moins de scolarité" b1={TIERS.b1_seul} pied="le graphe est une hypothèse · séance 11" />
    </Slide>

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
      <h2 class="e">Pourquoi ajouter des variables ?</h2>
      <M8Raisons />
    </Slide>

    <Slide bandeau="Ajouter des variables" droite={D}>
      <h2 class="e">Une variable à la fois</h2>
      <M8Escalier />
    </Slide>

    <Slide bandeau="Ajouter des variables · lire" droite={D}>
      <h2 class="e">La phrase à retenir</h2>
      <M8Phrase autres="âge, genre, revenu et région" mouvement="passer de « secondaire non terminé » à « maîtrise, doctorat »" b={coef(MULTI.coefs, 'scolarite')} />
    </Slide>

    <Slide bandeau="Ajouter des variables · lire" droite={D}>
      <h2 class="e">Une seule ligne se lit</h2>
      <M8UneLigne coefs={MULTI.coefs} noms={NOMS7} cle="scolarite" n={MULTI.n_modele} titre="notre sondage de la séance 7 · Y = l’intérêt pour la politique" />
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

    <!-- ================= BLAIS ET GÉLINEAU EN 2025 ================= -->
    <Slide fond="encre" bandeau="Blais et Gélineau (2007), en 2025" droite={D}>
      <h1 class="e">Blais et Gélineau (2007), en 2025</h1>
      <hr class="filet" />
      <p class="lead e">André Blais (Montréal) et François Gélineau (Laval, votre département). Leur TP 1, puis leur test, en 2025.</p>
    </Slide>

    <Slide bandeau="Leur TP 1" droite={D}>
      <h2 class="e">Et si Blais et Gélineau remettaient votre TP 1 ?</h2>
      <TmParcours />
      <M8LeurTP etape={0} />
    </Slide>

    <Slide bandeau="Leur TP 1 · étape 1" droite={D}>
      <TmParcours ici={1} />
      <h2 class="e">Une question claire</h2>
      <M8LeurTP etape={1} />
    </Slide>

    <Slide bandeau="Leur TP 1 · étape 2" droite={D}>
      <TmParcours ici={2} />
      <h2 class="e">La littérature et une théorie</h2>
      <M8LeurTP etape={2} />
    </Slide>

    <Slide bandeau="Leur TP 1 · étape 3" droite={D}>
      <TmParcours ici={3} />
      <h2 class="e">Une hypothèse et son hypothèse nulle</h2>
      <M8LeurTP etape={3} />
    </Slide>

    <Slide bandeau="Leur TP 1 · étape 4" droite={D}>
      <TmParcours ici={4} />
      <h2 class="e">Les données et les variables</h2>
      <M8LeurTP etape={4} />
    </Slide>

    <Slide bandeau="Leur TP 1 · étape 5" droite={D}>
      <TmParcours ici={5} />
      <h2 class="e">La pertinence : ok, donc ?</h2>
      <M8LeurTP etape={5} />
    </Slide>

    <Slide bandeau="Leur TP 1 · étape 6" droite={D}>
      <TmParcours ici={6} />
      <h2 class="e">La contribution</h2>
      <M8LeurTP etape={6} />
    </Slide>

    <Slide bandeau="Leur TP 1 · étape 7" droite={D}>
      <TmParcours ici={7} />
      <h2 class="e">Et eux, pourquoi ce sujet ?</h2>
      <M8LeurTP etape={7} />
    </Slide>

    <Slide bandeau="Leur TP 1 · et le travail final" droite={D}>
      <h2 class="e">Ce que le travail final ajoute</h2>
      <M8LeurTP etape={8} />
    </Slide>

    <Slide bandeau="Blais et Gélineau (2007) · leur tableau 1" droite={D}>
      <h2 class="e">Gagner une élection rend-il plus satisfait de la démocratie ?</h2>
      <M8Gelineau />
    </Slide>

    <Slide bandeau="Blais et Gélineau (2007) · leur tableau 2" droite={D}>
      <M8Tableau2 />
    </Slide>

    <Slide bandeau="Blais et Gélineau (2007)" droite={D}>
      <h2 class="e">Leur conclusion</h2>
      <p class="grande-q e">À satisfaction égale avant l’élection, les gagnants deviennent plus satisfaits que les perdants.</p>
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025" droite={D}>
      <h2 class="e">Notre question</h2>
      <p class="grande-q e">Après l’élection du 28 avril 2025, les gagnants sont-ils plus satisfaits de la démocratie que les perdants ?</p>
      <div class="hyp">
        <p class="e"><strong>Hypothèse :</strong> oui, à satisfaction égale avant l’élection.</p>
        <p class="e"><strong>Hypothèse nulle :</strong> aucune différence.</p>
      </div>
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025" droite={D}>
      <h2 class="e">Six étapes, lentement</h2>
      <M8Etapes />
      <div class="avant">
        <p class="e">Dans votre projet Positron :</p>
        <Code src={'# un nouveau fichier : seance8.R\ninstall.packages(c("modelsummary", "pandoc"))   # une seule fois'} titre="seance8.R" />
        <p class="e petit-dit">ces2025.rds doit être dans le dossier du projet (séance 2).</p>
      </div>
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · charger" droite={D}>
      <M8Etapes ici={1} />
      <h2 class="e">Charger, et préparer df_clean</h2>
      <Console lignes={c_charger} />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · Y" droite={D}>
      <M8Etapes ici={2} />
      <h2 class="e">Y : satisfait de la démocratie, après l’élection ?</h2>
      <Console lignes={c_question} />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · Y" droite={D}>
      <M8Etapes ici={2} />
      <h2 class="e">Y : de 0 (pas du tout) à 1 (très)</h2>
      <Console lignes={c_apres} />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · X" droite={D}>
      <M8Etapes ici={3} />
      <h2 class="e">X : pour qui avez-vous voté ?</h2>
      <Console lignes={c_vote} />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · X" droite={D}>
      <M8Etapes ici={3} />
      <h2 class="e">X : gagnant (1) ou perdant (0)</h2>
      <Console lignes={c_gagnant} />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · contrôle" droite={D}>
      <M8Etapes ici={4} />
      <h2 class="e">Le contrôle : la même question, avant</h2>
      <Console lignes={c_avant} />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · regarder" droite={D}>
      <M8Etapes ici={4} />
      <h2 class="e">Avant, après : leur tableau 1, en 2025</h2>
      <Console lignes={c_moyennes} />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · regarder" droite={D}>
      <h2 class="e">1997 et 2025</h2>
      <M8AvantApres />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · modéliser" droite={D}>
      <M8Etapes ici={5} />
      <h2 class="e">Deux modèles : seul, puis à satisfaction égale avant</h2>
      <Console lignes={c_modeles} />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · tableau" droite={D}>
      <M8Etapes ici={6} />
      <M8Image code={TABLEAU.code} img={TABLEAU.img} l={TABLEAU.l} h={TABLEAU.h} px={100} nouveau={[5, 6]} dit="deux modèles = deux colonnes" alt="Le tableau de modelsummary : le modèle « gagnant seul » et le modèle à satisfaction égale avant l’élection, côte à côte, avec Num.Obs. et R2." />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · lire" droite={D}>
      <h2 class="e">Une seule ligne se lit, encore</h2>
      <M8UneLigne coefs={COEFS.modele2} noms={NOMS8} cle="gagnant" n={N.modele2} titre="CES 2025 · Y = satisfaction envers la démocratie après l’élection (0 à 1)" />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · Word" droite={D}>
      <M8Etapes ici={6} />
      <h2 class="e">Le même tableau, dans Word</h2>
      <div class="avant">
        <Code src={WORD.code} titre="seance8.R" />
        <p class="e petit-dit">gagnants2025.docx apparaît dans le dossier du projet. Copiez-le dans votre travail.</p>
        <p class="e petit-dit">Si R se plaint de pandoc : <code>pandoc::pandoc_install()</code>, une seule fois.</p>
      </div>
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · lire" droite={D}>
      <h2 class="e">La phrase, pour notre seule ligne</h2>
      <M8Phrase autres="satisfaction avant l’élection" mouvement="avoir voté pour le parti gagnant plutôt que pour un perdant" b={G2} y="de satisfaction" fin={`Soit ${cran} « cran » de l’échelle (un cran = 0,33).`} />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · honnêtement" droite={D}>
      <h2 class="e">Un test, pas une réplication</h2>
      <M8Ecarts />
    </Slide>

    <Slide bandeau="Blais et Gélineau, en 2025 · si on a le temps" droite={D}>
      <h2 class="e">Les perdants sont-ils tous pareils ?</h2>
      <Console lignes={c_perdants} />
      <p class="e petit-dit">À satisfaction égale avant : conservateurs {v3('camp2. Conservateur')}, autres partis {v3('camp3. Autre parti')}. Perdre fait plus mal quand on pouvait gagner, comme en 1997 (leur tableau 4).</p>
    </Slide>

    <!-- ================= LE SCRIPT ================= -->
    {#each SCRIPT as bout, i}
      <Slide bandeau="Le script complet" droite={D}>
        <Code src={bout} titre={TITRES[i]} />
      </Slide>
    {/each}

    <!-- ================= FIN ================= -->
    <Slide bandeau="Après la semaine de lecture" droite={D}>
      <h2 class="e">Le 5 novembre : votre question, à la main, puis avec l’IA</h2>
      <p class="grande-q e">Aujourd’hui, on a testé la question de Blais et Gélineau. La prochaine fois, c’est la vôtre.</p>
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
.slogan { font-size: 3.2em; line-height: 1.2; margin: 1.4em 0 0; color: var(--dk-accent); font-weight: 600; }
.hyp { margin-top: 1.6em; display: flex; flex-direction: column; gap: 0.5em; font-size: 1.25em; }
.hyp p { margin: 0; }
</style>
