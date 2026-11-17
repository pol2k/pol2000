<script>
  /**
   * POL-2000 — Séance 11 · Les graphes orientés acycliques (GOA)
   * Jeudi 19 novembre 2026, 15h30–18h20.
   *
   * Doctrine : moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine et bouge.
   *
   * Le fil. La grève du 12 novembre a reporté la séance 10 : on ouvre donc
   * sur le problème fondamental de l'inférence causale (deux mondes, on n'en
   * voit qu'un), comme le faisait le cours 11 de 2024. Puis le GOA : pourquoi
   * et comment le dessiner, sa grammaire (orienté, acyclique, effet causal
   * contre information statistique), les trois types de chemins, les deux
   * conditions de l'identification (déjà vues à la séance 8, sans les mots
   * des graphes), et un retour honnête sur la séance 8 : on y avait contrôlé
   * le revenu, un descendant de la scolarité. Pause. Pratique : ouvert ou
   * fermé, trois exercices. Puis les simulations du livre dans R, qu'on
   * roule en direct : on fabrique le monde, on connaît le vrai effet.
   *
   * Sources. Le cours 11 « Les graphes orientés acycliques (GOA) » de
   * L.-O. M. Foisy et Adrien Cloutier (hiver 2024), qui donne l'ordre et
   * plusieurs exemples (la ceinture, la crème glacée, le sucre, les
   * exercices). Arel-Bundock, V. (2021), Analyse causale et méthodes
   * quantitatives, chapitre 6, p. 115 à 136 (vocabulaire, définitions,
   * simulations), et chapitre 7 pour le pont.
   *
   * Tous les graphes sont dans src/lib/data/seance11-goa.js; ouvert ou fermé
   * est calculé par src/lib/deck/goa.js (testé : goa.test.js), jamais écrit
   * à la main. Les sorties de R viennent de src/lib/data/seance11.js
   * (outils/seance11_data.R).
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import Aujourdhui11 from '$lib/deck/visuels/Aujourdhui11.svelte';
  import M11DeuxMondes from '$lib/deck/visuels/M11DeuxMondes.svelte';
  import M11Liste from '$lib/deck/visuels/M11Liste.svelte';
  import Goa from '$lib/deck/visuels/Goa.svelte';
  import { GOA } from '$lib/data/seance11-goa.js';

  const TOTAL = 17;
  const D = 'POL-2000 · séance 11 · jeu 19 nov';
  const SCHEMA = 'Schéma, aucune donnée';
</script>

<svelte:head>
  <title>POL-2000 · Séance 11 · Les graphes orientés acycliques</title>
</svelte:head>

<Deck total={TOTAL} logo="{base}/img/ulaval-logo.png">
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->

    <Slide fond="encre" bandeau="Laurence-Olivier M. Foisy" droite={D}>
      <div class="titre">
        <p class="surtitre e">POL-2000 · Méthodologie quantitative</p>
        <h1 class="e">Les graphes orientés acycliques</h1>
        <hr class="filet" />
        <p class="lead e">Séance 11 · jeudi 19 novembre 2026</p>
      </div>
      <div class="entete-ul e">
        <img src="{base}/img/ulaval-logo.png" alt="Université Laval" />
        <span class="sep"></span>
        <span class="dept">Département de science politique<br />Faculté des sciences sociales</span>
        <span class="session">Automne 2026</span>
      </div>
    </Slide>

    <Slide bandeau="Où on en est" droite={D}>
      <Session ici={11} />
    </Slide>

    <Slide bandeau="Aujourd’hui" droite={D}>
      <h2 class="e">Aujourd’hui</h2>
      <Aujourdhui11 />
    </Slide>

    <!-- ================= 1. DEUX MONDES ================= -->

    <Slide fond="encre" bandeau="Deux mondes" droite={D}>
      <h1 class="e">Deux mondes</h1>
      <hr class="filet" />
      <p class="lead e">Le problème fondamental de l’inférence causale.</p>
    </Slide>

    <Slide bandeau="Deux mondes" droite={D}>
      <h2 class="e">L’université rend-elle Marie plus intéressée par la politique ?</h2>
      <M11DeuxMondes />
    </Slide>

    <Slide bandeau="Deux mondes" droite={D}>
      <h2 class="e">On ne voit jamais les deux mondes à la fois</h2>
      <p class="grande-q e">Alors on compare des personnes <span class="rouge">différentes</span>.</p>
    </Slide>

    <Slide bandeau="Deux mondes" droite={D}>
      <h2 class="e">Comparer Marie et Julie</h2>
      <M11DeuxMondes mode="deux" />
    </Slide>

    <Slide fond="encre" bandeau="Deux mondes" droite={D}>
      <p class="slogan-e e">On ne peut pas tout voir.<br />Il faut dire ce qu’on croit.</p>
      <hr class="filet" />
      <p class="lead e">C’est le rôle du GOA.</p>
    </Slide>

    <!-- ================= 2. DESSINER UN GOA ================= -->

    <Slide fond="encre" bandeau="Dessiner un GOA" droite={D}>
      <h1 class="e">Dessiner un GOA</h1>
      <hr class="filet" />
      <p class="lead e">Des boîtes, des flèches, nos hypothèses.</p>
    </Slide>

    <Slide bandeau="Pourquoi un GOA" droite={D}>
      <h2 class="e">Un GOA sert à trois choses</h2>
      <M11Liste items={[
        { t: 'Rendre nos hypothèses visibles', g: 'Toute analyse causale repose sur des postulats. On les montre.' },
        { t: 'Savoir si l’effet de la VI sur la VD est identifiable', g: 'Est-ce possible, avec ces données ?' },
        { t: 'Choisir les variables de contrôle', g: 'Celles à inclure, et celles à laisser dehors.' }
      ]} />
    </Slide>

    <Slide bandeau="Dessiner un GOA" droite={D}>
      <h2 class="e">L’éducation rend-elle plus à droite ?</h2>
      <M11Liste items={[
        { t: 'L’éducation augmente le revenu individuel' },
        { t: 'Le revenu augmente l’appui aux partis qui promettent des baisses d’impôt' },
        { t: 'Le revenu des parents augmente l’éducation des enfants' },
        { t: 'Le revenu des parents augmente le revenu des enfants' }
      ]} />
      <p class="source e">D’après Arel-Bundock (2021), p. 116</p>
    </Slide>

    <Slide bandeau="Dessiner un GOA" droite={D}>
      <h2 class="e">Une flèche par hypothèse</h2>
      <Goa graphe={GOA.education} legende={SCHEMA} temps={[
        { voir: ['education', 'ideologie'], aretes: [4], note: 'L’effet qu’on veut connaître' },
        { voir: ['education', 'ideologie', 'revenu_ind'], aretes: [4, 0] },
        { voir: ['education', 'ideologie', 'revenu_ind'], aretes: [4, 0, 1] },
        { aretes: [4, 0, 1, 2] },
        {}
      ]} />
    </Slide>

    <!-- ================= 3. LA GRAMMAIRE ================= -->

    <Slide bandeau="Orienté" droite={D}>
      <h2 class="e">Orienté : la flèche va de la cause vers l’effet</h2>
      <Goa graphe={GOA.orienteCause} taille={1.7} legende={SCHEMA} temps={[
        { flux: true, note: 'A cause B, B cause C : un chemin' },
        { flux: true, accent: ['A', 'B'], note: 'A et B sont les ancêtres de C' },
        { flux: true, accent: ['B', 'C'], note: 'B et C sont les descendants de A' }
      ]} />
    </Slide>

    <Slide bandeau="Orienté" droite={D}>
      <h2 class="e">Ici, A ne cause pas C</h2>
      <Goa graphe={GOA.orientePasCause} taille={1.7} legende={SCHEMA} temps={[
        { flux: true, note: 'Aucune suite de flèches ne mène de A à C' }
      ]} />
    </Slide>

    <Slide bandeau="Acyclique" droite={D}>
      <h2 class="e">Acyclique : jamais de retour au point de départ</h2>
      <div class="cote-a-cote">
        <div class="cote">
          <Goa graphe={GOA.acycliqueBon} taille={1.2} />
          <p class="verdict-oui e">Un GOA</p>
        </div>
        <div class="cote">
          <Goa graphe={GOA.acycliqueMauvais} taille={1.2} temps={[{ rouges: [0, 2, 3], accent: ['A', 'B', 'C'] }]} />
          <p class="verdict-non e">Pas un GOA : un cycle</p>
        </div>
      </div>
    </Slide>

    <Slide bandeau="Effet ou information" droite={D}>
      <h2 class="e">Deux choses circulent dans un GOA</h2>
      <div class="deux-cartes">
        <div class="carte-ei e">
          <svg viewBox="0 0 300 60" aria-hidden="true"><line x1="20" y1="30" x2="250" y2="30" class="ei-l" /><polygon points="280,30 250,16 250,44" class="ei-p" /><circle cx="90" cy="30" r="9" class="ei-pt" /><circle cx="180" cy="30" r="9" class="ei-pt" /></svg>
          <strong>L’effet causal</strong>
          <span>Dans un seul sens : de la cause vers l’effet.</span>
        </div>
        <div class="carte-ei rouge-b e">
          <svg viewBox="0 0 300 60" aria-hidden="true"><line x1="50" y1="30" x2="250" y2="30" class="ei-l ei-r" /><polygon points="280,30 250,16 250,44" class="ei-p ei-rp" /><polygon points="20,30 50,16 50,44" class="ei-p ei-rp" /></svg>
          <strong>L’information statistique</strong>
          <span>Dans les deux sens : connaître l’un nous renseigne sur l’autre.</span>
        </div>
      </div>
    </Slide>

    <Slide bandeau="Effet ou information" droite={D}>
      <h2 class="e">Le mercure ne fait pas vendre de crème glacée</h2>
      <Goa graphe={GOA.glace} legende={SCHEMA} temps={[
        { flux: true, note: 'La température cause les deux' },
        { chemin: ['mercure', 'temperature', 'glace'], note: 'Mais le mercure annonce les ventes' }
      ]} />
    </Slide>

  {/snippet}
</Deck>

<style>
.titre { padding-bottom: 5.2em; }
.entete-ul { position: absolute; left: 0; right: 0; bottom: 0; display: flex; align-items: center; gap: 1.2em;
    background: #fff; color: var(--dk-encre); padding: 0.8em 2.6em 0.8em 2.6em; border-top: 6px solid var(--dk-accent); }
.entete-ul img { height: 2.6em; width: auto; display: block; }
.entete-ul .sep { width: 2px; align-self: stretch; background: var(--dk-encre); }
.entete-ul .dept { font-size: 0.62em; letter-spacing: 0.12em; text-transform: uppercase; line-height: 1.45; font-weight: 600; }
.entete-ul .session { margin-left: auto; font-size: 0.72em; letter-spacing: 0.16em; text-transform: uppercase; color: var(--dk-accent); font-weight: 600; }

.grande-q { font-size: 2em; line-height: 1.3; max-width: 22em; margin-top: 1.2em; }
.rouge { color: var(--dk-accent); }
.slogan-e { font-size: 2.6em; line-height: 1.25; font-weight: 600; margin: 0 0 0.4em; }
.source { margin-top: 1em; font-size: 0.62em; color: var(--dk-gris); }

.cote-a-cote { display: grid; grid-template-columns: 1fr 1fr; gap: 2.4em; margin-top: 1.4em; align-items: end; }
.cote { display: flex; flex-direction: column; align-items: center; gap: 0.6em; }
.verdict-oui, .verdict-non { font-size: 1.2em; font-weight: 700; margin: 0; }
.verdict-non { color: var(--dk-accent); }

.deux-cartes { display: grid; grid-template-columns: 1fr 1fr; gap: 2em; max-width: 54em; margin: 1.6em auto 0; }
.carte-ei { border: 3px solid var(--dk-encre); padding: 1.3em 1.4em; display: flex; flex-direction: column; gap: 0.6em; }
.carte-ei.rouge-b { border-color: var(--dk-accent); }
.carte-ei svg { width: 70%; height: auto; margin-bottom: 0.4em; }
.carte-ei strong { font-size: 1.4em; }
.carte-ei span { font-size: 0.95em; color: var(--dk-gris); }
.ei-l { stroke: var(--dk-encre); stroke-width: 6; }
.ei-p { fill: var(--dk-encre); }
.ei-pt { fill: var(--dk-encre); }
.ei-r { stroke: var(--dk-accent); stroke-width: 8; }
.ei-rp { fill: var(--dk-accent); }
</style>
