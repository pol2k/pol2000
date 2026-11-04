<script>
  /**
   * POL-2000 — Séance 9 · Mesurer l'invisible
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
   * (variable latente, échelle, fidélité et validité, l'examen d'histoire,
   * les trois chiffres de l'analyse factorielle), puis pour vrai sur la
   * batterie de populisme de la CES 2025 avec sondr::topdown_fa() : deux
   * énoncés détonnent, on les retire, on construit l'échelle, on la met dans
   * une régression. 2. Ce qu'est un modèle de langue, huit diapos reprises
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
  import { ATELIER, FA1, FA2, HIST, REG, SATURATIONS, SCRIPT } from '$lib/data/seance9.js';

  const TOTAL = 51;
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
  const PLAN = "# 1. Charger ces2025.rds, créer df_clean\n# 2. Regarder un énoncé\n# 3. Les huit énoncés, de 1-5 à 0-1 ; ne sait pas devient NA\n# 4. Retourner l'énoncé qui dit le contraire\n# 5. Installer sondr, une seule fois\n# 6. L'analyse factorielle : tous les énoncés\n# 7. Sans ceux qui détonnent\n# 8. L'échelle : la moyenne\n# 9. L'appliquer : lm(populisme ~ scolarité)\n# 10. Sauvegarder df_clean";
  const [SCRIPT_A, SCRIPT_B, SCRIPT_C] = (() => { const i = SCRIPT.indexOf('# 4.'), j = SCRIPT.indexOf('# 7.'); return [SCRIPT.slice(0, i).trimEnd(), SCRIPT.slice(i, j).trimEnd(), SCRIPT.slice(j)]; })();

  // Les consoles viennent de R telles quelles; seules les notes sont d'ici.
  const avec = (cle, notes = []) => ATELIER[cle].map((l, i) => ({ ...l, note: notes[i] || '' }));
  const c_charger = avec('charger', ['', 'haven : pour lire les codes de la CES', 'ces2025.rds, sauvegardé à la séance 2', 'df_raw ne change jamais']);
  const c_item = avec('item', ['pes25 : le sondage après l’élection. Un code de 1 à 5, et 6 = ne sait pas']);
  const c_echelle = avec('echelle', ['une fonction : de 1-5 à 0-1, tout le reste devient NA', 'la même recette, huit fois', '', '', '', '', '', '', '', 'NA : pas de réponse après l’élection, ou ne sait pas']);
  const c_echelle_a = c_echelle.slice(0, 5), c_echelle_b = c_echelle.slice(5);
  const c_inverser = avec('inverser', ['négatif : pop4 va dans l’autre sens que pop3', '1 devient 0, 0 devient 1', 'le même lien, dans le bon sens']);
  const c_sondr = [...avec('installer', ['', 'sondr n’est pas sur CRAN : on l’installe depuis GitHub']), ...avec('preparer', ['', 'na.omit : seulement les gens qui ont répondu aux huit', `${nb(SATURATIONS.n)} personnes`])];
  const c_construire = avec('construire', ['la moyenne des six qu’on garde', 'de 0 à 1 ; NA : au moins un énoncé sans réponse']);
  const c_regression = avec('regression', ['universitaire : a fréquenté l’université (8 à 11) ou non (1 à 7)', '', `${f(REG.pente, 3)} : sur une échelle de 0 à 1, les universitaires sont ${f(Math.abs(REG.pente), 2)} plus bas`]);
</script>

<svelte:head>
  <title>POL-2000 · Séance 9 · Mesurer l’invisible</title>
</svelte:head>

<Deck total={TOTAL} logo="{base}/img/ulaval-logo.png">
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->

    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre">
        <p class="surtitre e">POL-2000 · Méthodologie quantitative</p>
        <h1 class="e">Mesurer l’invisible</h1>
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

    <Slide bandeau="Mesurer un concept · le problème" droite={D}>
      <p class="grande-q e">Comment mesurer ce qu’on ne peut pas voir ?</p>
      <div class="exemples e">
        <span>l’idéologie</span><span>le populisme</span><span>la confiance</span><span>l’intelligence</span>
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
        <div class="etape rouge"><span class="n">4</span><strong>Vérifier</strong><span>Fidèle ? Valide ?</span></div>
      </div>
    </Slide>

    <Slide bandeau="Mesurer un concept · notre concept" droite={D}>
      <h2 class="e">Notre concept : le populisme</h2>
      <p class="grande-q e">La scolarité réduit-elle le populisme ?</p>
      <div class="hyp">
        <p class="e">Personne ne répond à la question « êtes-vous populiste ? ».</p>
        <p class="e"><strong>Mais la CES 2025 pose huit énoncés</strong>, après l’élection, aux mêmes personnes.</p>
      </div>
    </Slide>

    <Slide bandeau="Mesurer un concept · huit énoncés" droite={D}>
      <h2 class="e">Les huit énoncés de la CES 2025</h2>
      <M9Items />
    </Slide>

    <Slide bandeau="Mesurer un concept · la qualité" droite={D}>
      <h2 class="e">Fidèle ? Valide ?</h2>
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
      <p class="petit-dit e">Pour un examen comme pour un concept : les énoncés qui mesurent la même chose répondent ensemble.</p>
    </Slide>

    <Slide bandeau="L’examen d’histoire · trois chiffres" droite={D}>
      <h2 class="e">Trois chiffres, trois seuils</h2>
      <M9TroisChiffres />
    </Slide>

    <!-- ================= SUR LES DONNÉES, POUR VRAI ================= -->

    <Slide fond="encre" bandeau="Pratique dans R" droite={D}>
      <h1 class="e">Le populisme, pour vrai</h1>
      <hr class="filet" />
      <p class="lead e">Huit énoncés de la CES 2025, une échelle, une régression.</p>
    </Slide>

    <Slide bandeau="Pratique dans R · le plan" droite={D}>
      <h2 class="e">Planifions notre code</h2>
      <div class="plan">
        <Code src={PLAN} titre="seance9.R" />
        <p class="e petit-dit">D’abord les commentaires. Le code vient ensuite, sous chacun.</p>
      </div>
    </Slide>

    <Slide bandeau="Pratique dans R · regarder" droite={D}>
      <h2 class="e">Un énoncé, tel que la CES le code</h2>
      <Console lignes={c_item} />
    </Slide>

    <Slide bandeau="Pratique dans R · recoder" droite={D}>
      <h2 class="e">De 1 à 5 vers 0 à 1. Ne sait pas devient NA</h2>
      <Console lignes={c_echelle_a} />
    </Slide>

    <Slide bandeau="Pratique dans R · recoder" droite={D}>
      <h2 class="e">Les quatre autres, puis regarder</h2>
      <Console lignes={c_echelle_b} />
    </Slide>

    <Slide bandeau="Pratique dans R · le sens" droite={D}>
      <h2 class="e">Lequel dit le contraire des autres ?</h2>
      <M9Items marquer={[4]} raisons={{ 4: 'd’accord = moins populiste. Tous les autres : d’accord = plus populiste.' }} echelle={false} />
    </Slide>

    <Slide bandeau="Pratique dans R · retourner" droite={D}>
      <h2 class="e">Retourner l’énoncé 4</h2>
      <Console lignes={c_inverser} />
    </Slide>

    <Slide bandeau="Pratique dans R · sondr" droite={D}>
      <h2 class="e">sondr, puis les gens qui ont répondu aux huit</h2>
      <Console lignes={c_sondr} />
    </Slide>

    <Slide bandeau="Pratique dans R · l’analyse factorielle" droite={D}>
      <M8Image code={FA1.code} img={FA1.img} l={FA1.l} h={FA1.h} px={110} dit="une ligne : alpha, valeur propre, saturations" alt="Le graphique de topdown_fa : les coefficients de saturation des huit énoncés en barres, pop3 en tête à 0,83, pop6 à 0,16 sous le seuil de 0,3, et pop1 sans barre. Alpha de Cronbach 0,74, première valeur propre 3,28." />
    </Slide>

    <Slide bandeau="Pratique dans R · lire" droite={D}>
      <h2 class="e">Deux énoncés détonnent</h2>
      <M9Saturations />
    </Slide>

    <Slide bandeau="Pratique dans R · lire" droite={D}>
      <h2 class="e">Les cigares de Churchill de la CES</h2>
      <M9Items marquer={[1, 6]} raisons={{ 1: 'se sentir compétent en politique : l’efficacité, pas le populisme', 6: 'un chef qui contourne les règles : l’autoritarisme, un autre concept' }} echelle={false} />
    </Slide>

    <Slide bandeau="Pratique dans R · recommencer" droite={D}>
      <M8Image code={FA2.code} img={FA2.img} l={FA2.l} h={FA2.h} px={110} nouveau={[0]} dit="sans pop1 ni pop6 : alpha 0,83, tout au-dessus du seuil" alt="Le graphique de topdown_fa sans pop1 ni pop6 : six barres, toutes au-dessus de 0,3, de 0,52 à 0,83. Alpha de Cronbach 0,83, première valeur propre 3,25." />
    </Slide>

    <Slide bandeau="Pratique dans R · la validité" droite={D}>
      <h2 class="e">Fidèle, oui. Valide ?</h2>
      <Deux ratio="1fr 1fr">
        <Carte ton="ciel" titre="Concordance avec la théorie">
          <p>Les six énoncés parlent-ils bien du populisme tel que la littérature le définit ? Le peuple contre les élites, oui. L’autoritarisme, non.</p>
        </Carte>
        <Carte ton="vert" titre="Concordance avec d’autres mesures">
          <p>L’échelle se comporte-t-elle comme on s’y attend ? Plus de populisme chez qui vote pour un parti populiste, moins chez qui fait confiance aux institutions.</p>
        </Carte>
      </Deux>
      <p class="petit-dit e">Les chiffres vérifient la fidélité. La validité, c’est vous qui la défendez.</p>
    </Slide>

    <Slide bandeau="Pratique dans R · l’échelle" droite={D}>
      <h2 class="e">L’échelle : la moyenne des six</h2>
      <Console lignes={c_construire} />
    </Slide>

    <Slide bandeau="Pratique dans R · l’échelle" droite={D}>
      <M8Image code={HIST.code} img={HIST.img} l={HIST.l} h={HIST.h} px={100} dit="une variable comme une autre, de 0 à 1" alt="L'histogramme de l'échelle de populisme, de 0 à 1 : une bosse autour de 0,5, une queue vers 0, un pic vers 0,7." />
    </Slide>

    <Slide bandeau="Pratique dans R · l’appliquer" droite={D}>
      <h2 class="e">La scolarité réduit-elle le populisme ?</h2>
      <Console lignes={c_regression} />
    </Slide>

    <Slide bandeau="Mesurer un concept · retenir" droite={D}>
      <h2 class="e">Retenir</h2>
      <ol class="retenir e">
        <li><span>Un concept ne se voit pas. On le mesure par ses indicateurs.</span></li>
        <li><span>Plusieurs énoncés valent mieux qu’un, s’ils répondent ensemble.</span></li>
        <li><span>Même sens, même échelle, pas de « ne sait pas » caché dans un chiffre.</span></li>
        <li><span>Les chiffres vérifient la fidélité. La validité, c’est votre argument.</span></li>
      </ol>
    </Slide>

    <!-- ================= CE QU'EST UN MODÈLE DE LANGUE ================= -->

    <Slide fond="encre" bandeau="Ce qu’est un modèle de langue" droite={D}>
      <h1 class="e">Ce qu’est un modèle de langue</h1>
      <hr class="filet" />
      <p class="lead e">ChatGPT, Claude, Gemini, Copilot : une seule mécanique.</p>
    </Slide>

    <Slide bandeau="Mécanique" droite={D}>
      <h2 class="e">Tout ce qu’il fait, c’est prédire le jeton suivant</h2>
      <Generation />
    </Slide>

    <Slide bandeau="Mécanique" droite={D}>
      <h2 class="e">Le modèle ne voit pas des mots</h2>
      <p class="e">La phrase qu’il vient d’écrire, telle qu’il l’a vue :</p>
      <Tokeniseur />
      <p class="e credits">Le surcoût vaut pour toutes les langues éloignées de l’anglais, et la qualité y baisse aussi (Ahia et al., 2023).</p>
    </Slide>

    <Slide bandeau="Ce qu’un modèle n’est pas" droite={D}>
      <h2 class="e">Ce n’est pas une base de connaissances</h2>
      <Connaissances />
      <Citation source="Le principe à retenir">
        Une référence bibliographique produite par un modèle est une <em>hypothèse de référence</em> jusqu’à ce que vous l’ayez vérifiée dans un catalogue.
      </Citation>
    </Slide>

    <Slide bandeau="L’hallucination" droite={D}>
      <h2 class="e">L’hallucination n’est pas un bug</h2>
      <Hallucination />
      <p class="e credits">C’est la mécanique normale. D’où la règle : vérifier, toujours.</p>
    </Slide>

    <Slide bandeau="Les biais" droite={D}>
      <h2 class="e">Le biais entre à trois endroits</h2>
      <Biais />
      <p class="e credits">Composition du corpus d’entraînement de LLaMA (Touvron et al., 2023).</p>
    </Slide>

    <Slide bandeau="S’en servir · la formule" droite={D}>
      <h2 class="e">Rôle → Tâche → Contraintes → Format</h2>
      <Anatomie />
    </Slide>

    <Slide bandeau="S’en servir · avant, après" droite={D}>
      <h2 class="e">Le même besoin, deux prompts</h2>
      <div class="compare-p e">
        <div class="p faible">
          <span class="et">FAIBLE</span>
          <p class="txt">Mon code marche pas, corrige-le.</p>
          <p class="pourquoi">Aucun contexte, aucune limite. Il réécrit tout, et vous ne savez plus ce qui a changé.</p>
        </div>
        <div class="p solide">
          <span class="et">SOLIDE</span>
          <p class="txt">
            Je suis étudiant.e en science politique et je débute en R, dans Positron. Voici mon code et le message d’erreur. Explique-moi la cause de l’erreur en une phrase, puis propose la correction en changeant le moins de lignes possible. Ne réécris pas le reste.
          </p>
          <p class="pourquoi">Rôle, tâche, contraintes, format. Les quatre y sont. Et vous restez l’auteur.e du code.</p>
        </div>
      </div>
    </Slide>

    <Slide bandeau="S’en servir · un conseil qui surprend" droite={D}>
      <h2 class="e">Demandez à l’IA d’écrire le prompt</h2>
      <Deux ratio="1fr 1fr">
        <Carte ton="ciel" titre="Ce que vous écrivez">
          <p>« Je veux comprendre ce que fait chaque ligne d’un script R que je n’ai pas écrit. Écris-moi le prompt qui te fera l’expliquer ligne par ligne, sans le modifier. »</p>
        </Carte>
        <Carte ton="vert" titre="Ce que vous obtenez">
          <p>Un prompt mieux structuré que le vôtre, en quelques secondes. Vous le lisez, vous le corrigez, vous le gardez.</p>
        </Carte>
      </Deux>
    </Slide>

    <Slide bandeau="S’en servir · confidentialité" droite={D}>
      <h2 class="e">Ce qui sort de chez vous</h2>
      <Donnees />
      <p class="e credits">Règles relevées dans la documentation d’OpenAI le 24 août 2026. Vos données de la CES sont publiques. Votre travail, lui, ne l’est pas.</p>
    </Slide>

    <Slide bandeau="S’en servir · la règle du cours" droite={D}>
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
      <p class="lead e">Le populisme dans la CES 2025, étape par étape. À refaire chez vous.</p>
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
