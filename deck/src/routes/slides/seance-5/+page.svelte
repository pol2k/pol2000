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
   * le hasard ? » (H0 et H1, le procès, le monde où H0 est vraie). Ni test t
   * ni le mot « valeur p » : ils viennent avec la régression. Après la
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
  import Session from '$lib/deck/visuels/Session.svelte';
  import Console from '$lib/deck/visuels/Console.svelte';
  import QuelGraphique from '$lib/deck/visuels/QuelGraphique.svelte';
  import Aujourdhui5 from '$lib/deck/visuels/Aujourdhui5.svelte';
  import Vocabulaire from '$lib/deck/visuels/Vocabulaire.svelte';
  import Aleatoire from '$lib/deck/visuels/Aleatoire.svelte';
  import DigestVerdict from '$lib/deck/visuels/DigestVerdict.svelte';
  import DigestHistoire from '$lib/deck/visuels/DigestHistoire.svelte';
  import DigestFiltres from '$lib/deck/visuels/DigestFiltres.svelte';
  import Leger2025 from '$lib/deck/visuels/Leger2025.svelte';
  import Pomicultrice from '$lib/deck/visuels/Pomicultrice.svelte';
  import DeuxHypotheses from '$lib/deck/visuels/DeuxHypotheses.svelte';
  import Proces from '$lib/deck/visuels/Proces.svelte';
  import PourquoiH0 from '$lib/deck/visuels/PourquoiH0.svelte';
  import MargeErreur from '$lib/deck/visuels/MargeErreur.svelte';
  import EcartTypeNormale from '$lib/deck/visuels/EcartTypeNormale.svelte';
  import EcartTypeCes from '$lib/deck/visuels/EcartTypeCes.svelte';
  import TroisIngredients from '$lib/deck/visuels/TroisIngredients.svelte';
  import TheoremeCentral from '$lib/deck/visuels/TheoremeCentral.svelte';
  import EecCanada from '$lib/deck/visuels/EecCanada.svelte';
  import Ponderation from '$lib/deck/visuels/Ponderation.svelte';
  import PoidsColonne from '$lib/deck/visuels/PoidsColonne.svelte';
  import PaniersH0 from '$lib/deck/visuels/PaniersH0.svelte';
  import Grammaire from '$lib/deck/visuels/Grammaire.svelte';
  import GabaritGg from '$lib/deck/visuels/GabaritGg.svelte';
  import Couches from '$lib/deck/visuels/Couches.svelte';
  import DansHorsAes from '$lib/deck/visuels/DansHorsAes.svelte';
  import ErreursGg from '$lib/deck/visuels/ErreursGg.svelte';
  import AvantS7 from '$lib/deck/visuels/AvantS7.svelte';
  import Galton from '$lib/deck/visuels/Galton.svelte';
  import ClasseTaille from '$lib/deck/visuels/ClasseTaille.svelte';
  import DeuxEcarts from '$lib/deck/visuels/DeuxEcarts.svelte';
  import DefiInference from '$lib/deck/visuels/DefiInference.svelte';
  import BudgetIntro from '$lib/deck/visuels/BudgetIntro.svelte';
  import EchantillonsFaciles from '$lib/deck/visuels/EchantillonsFaciles.svelte';
  import Recommencer from '$lib/deck/visuels/Recommencer.svelte';
  import BudgetTailles from '$lib/deck/visuels/BudgetTailles.svelte';
  import CourbeNormale from '$lib/deck/visuels/CourbeNormale.svelte';
  import NormaleOuPas from '$lib/deck/visuels/NormaleOuPas.svelte';
  import DixNeufSurVingt from '$lib/deck/visuels/DixNeufSurVingt.svelte';
  import { GG, GG_CONSOLE } from '$lib/data/seance5_ggplot.js';

  const TOTAL = 57;
  const D = 'POL-2000 · séance 5 · jeu 1er oct';

  // La console vient de R telle quelle (outils/seance5_ggplot.R); seules les notes sont d'ici.
  const NOTES_GAP = [
    '-99 veut dire « pas de réponse » : on l’écarte. as.numeric() retire la question anglaise collée à la colonne.',
    'Notre budget : 1 000 répondant.e.s, tiré.e.s au hasard.',
    'Deux notes de 0 à 100, et le vote.'
  ];
  const c_gapminder = GG_CONSOLE.map((l, i) => ({ ...l, note: NOTES_GAP[i] || '' }));
  const c_donnees = c_gapminder.slice(0, 1);
  const c_mille = c_gapminder.slice(1);

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

    <Slide bandeau="L’inférence" droite={D}>
      <h2 class="e">Le défi de l’inférence</h2>
      <DefiInference />
    </Slide>

    <Slide bandeau="L’échantillon · 1936" droite={D}>
      <h2 class="e">1936 : le plus gros sondage de son temps</h2>
      <DigestHistoire />
    </Slide>

    <Slide bandeau="L’échantillon · 1936" droite={D}>
      <h2 class="e">La prévision, puis la réalité</h2>
      <DigestVerdict />
    </Slide>

    <Slide bandeau="L’échantillon · 1936" droite={D}>
      <h2 class="e">Quel était le problème ?</h2>
      <DigestFiltres />
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
      <h2 class="e">Et l’Étude électorale canadienne ?</h2>
      <Leger2025 />
    </Slide>

    <Slide bandeau="L’échantillon" droite={D}>
      <h2 class="e">La CES ressemble-t-elle au Canada ?</h2>
      <EecCanada />
    </Slide>

    <Slide bandeau="L’échantillon" droite={D}>
      <h2 class="e">Pondérer</h2>
      <Ponderation />
    </Slide>

    <Slide bandeau="L’échantillon" droite={D}>
      <h2 class="e">Le poids, dans nos données</h2>
      <PoidsColonne />
    </Slide>

    <Slide bandeau="Notre budget" droite={D}>
      <h2 class="e">Notre budget : 1 000 personnes</h2>
      <BudgetIntro />
    </Slide>

    <Slide bandeau="Notre budget" droite={D}>
      <h2 class="e">Facile, ou au hasard ?</h2>
      <EchantillonsFaciles />
    </Slide>

    <Slide bandeau="Notre budget" droite={D}>
      <h2 class="e">Et si on recommençait ?</h2>
      <Recommencer />
    </Slide>

    <Slide bandeau="Notre budget" droite={D}>
      <h2 class="e">Et si le budget changeait ?</h2>
      <BudgetTailles />
    </Slide>

    <!-- ================= LA COURBE NORMALE ================= -->
    <Slide bandeau="La courbe normale" droite={D}>
      <h2 class="e">La planche de Galton</h2>
      <Galton />
    </Slide>

    <Slide bandeau="La courbe normale" droite={D}>
      <h2 class="e">Une personne, une classe</h2>
      <ClasseTaille />
    </Slide>

    <Slide bandeau="La courbe normale" droite={D}>
      <h2 class="e">La courbe normale</h2>
      <CourbeNormale />
    </Slide>

    <Slide bandeau="La courbe normale · quiz" droite={D}>
      <h2 class="e">Les données ou leurs moyennes ?</h2>
      <NormaleOuPas cle="hommes" />
    </Slide>

    <Slide bandeau="La courbe normale · quiz" droite={D}>
      <h2 class="e">Les données ou leurs moyennes ?</h2>
      <NormaleOuPas cle="poilievre" />
    </Slide>

    <Slide bandeau="La courbe normale · quiz" droite={D}>
      <h2 class="e">Les données ou leurs moyennes ?</h2>
      <NormaleOuPas cle="nyc" />
    </Slide>

    <Slide bandeau="La courbe normale · quiz" droite={D}>
      <h2 class="e">Les données ou leurs moyennes ?</h2>
      <NormaleOuPas cle="age" />
    </Slide>

    <Slide bandeau="Le hasard" droite={D}>
      <h2 class="e">Le théorème central limite</h2>
      <TheoremeCentral />
    </Slide>

    <Slide bandeau="L’écart type" droite={D}>
      <h2 class="e">L’écart type</h2>
      <EcartTypeCes />
    </Slide>

    <Slide bandeau="La marge d’erreur" droite={D}>
      <h2 class="e">L’écart type et la cloche</h2>
      <EcartTypeNormale />
    </Slide>

    <Slide bandeau="La marge d’erreur" droite={D}>
      <h2 class="e">Deux écarts types</h2>
      <DeuxEcarts />
    </Slide>

    <Slide bandeau="La marge d’erreur" droite={D}>
      <h2 class="e">La marge d’erreur</h2>
      <MargeErreur />
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
      <h2 class="e">La conversation</h2>
      <DeuxHypotheses />
    </Slide>

    <Slide bandeau="Est-ce le hasard ?" droite={D}>
      <h2 class="e">Présumée vraie</h2>
      <Proces />
    </Slide>

    <Slide bandeau="Est-ce le hasard ?" droite={D}>
      <h2 class="e">Le monde de l’acheteur</h2>
      <TroisIngredients />
    </Slide>

    <Slide bandeau="Est-ce le hasard ?" droite={D}>
      <h2 class="e">Compter les paniers</h2>
      <PaniersH0 panier={105} />
    </Slide>

    <Slide bandeau="Est-ce le hasard ?" droite={D}>
      <h2 class="e">Pourquoi le monde à 100 g ?</h2>
      <PourquoiH0 />
    </Slide>

    <Slide bandeau="Est-ce le hasard ?" droite={D}>
      <h2 class="e">Et si son panier avait pesé 102 g ?</h2>
      <PaniersH0 panier={102} />
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

    <Slide bandeau="En direct · ggplot2" droite={D}>
      <h2 class="e">Les données : la CES 2025</h2>
      <Console lignes={c_donnees} />
    </Slide>

    <Slide bandeau="En direct · ggplot2" droite={D}>
      <h2 class="e">1 000 répondant.e.s, au hasard</h2>
      <Console lignes={c_mille} />
    </Slide>

    <Slide bandeau="ggplot2 · couche par couche" droite={D}>
      <h2 class="e">Les données, puis les axes</h2>
      <Couches source={GG} etapes={['vide', 'axes']} />
    </Slide>

    <Slide bandeau="ggplot2 · couche par couche" droite={D}>
      <h2 class="e">Les points, puis la transparence</h2>
      <Couches source={GG} etapes={['points', 'alpha']} depart="axes" />
    </Slide>

    <Slide bandeau="ggplot2 · couche par couche" droite={D}>
      <h2 class="e">Une tendance</h2>
      <Couches source={GG} etapes={['tendance']} depart="alpha" />
    </Slide>

    <Slide bandeau="ggplot2 · couche par couche" droite={D}>
      <h2 class="e">Une troisième variable, puis nos couleurs</h2>
      <Couches source={GG} etapes={['couleur', 'partis']} depart="tendance" />
    </Slide>

    <Slide bandeau="ggplot2 · couche par couche" droite={D}>
      <h2 class="e">L’habillage</h2>
      <Couches source={GG} etapes={['labs', 'theme']} depart="partis" />
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
