<script>
  /**
   * POL-2000 — Séance 11 · Les graphes orientés acycliques (GOA)
   * Jeudi 19 novembre 2026, 15h30–18h20.
   *
   * Doctrine : moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine et bouge.
   *
   * Le fil. On ouvre sur une étude qui a fait toutes les manchettes
   * (Richard et Régimbal 2026, l'insécurité alimentaire au cégep), lue
   * comme Blais et Gélineau à la séance 8, mais pour en repérer les signes :
   * échantillon volontaire, instrument lu sans son mode d'emploi, un lien
   * présenté comme un effet, sans contrôle. La grève du 12 novembre a
   * reporté la séance 10 : on enchaîne donc sur le problème fondamental de
   * l'inférence causale (deux mondes). Puis le GOA, ramené à l'essentiel
   * (demande du professeur) : le dessiner, puis deux règles pour choisir
   * les contrôles, dites simplement : ne jamais contrôler une variable sur
   * laquelle X a un effet, contrôler les variables qui ont un effet sur X et
   * sur Y; l'article y revient. Retour honnête sur la séance 8 (le revenu,
   * un descendant de la scolarité). Pause. Deux exercices, puis les
   * simulations du livre dans R : on voit les contrôles déplacer l'estimé.
   *
   * Sources. Le cours 11 « Les graphes orientés acycliques (GOA) » de
   * L.-O. M. Foisy et Adrien Cloutier (hiver 2024), qui donne l'ordre et
   * plusieurs exemples (la ceinture, la crème glacée, le sucre, les
   * exercices). Arel-Bundock, V. (2021), Analyse causale et méthodes
   * quantitatives, chapitre 6, p. 115 à 136 (vocabulaire, définitions,
   * simulations), et chapitre 7 pour le pont.
   *
   * Tous les graphes sont dans src/lib/data/seance11-goa.js; ouvert ou fermé
   * est calculé par src/lib/deck/goa.js (testé : goa.test.js), jamais écrit
   * à la main. Les sorties de R viennent de src/lib/data/seance11.js
   * (outils/seance11_data.R).
   */
  import { base } from '$app/paths';
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Session from '$lib/deck/visuels/Session.svelte';
  import M11Carrefour from '$lib/deck/visuels/M11Carrefour.svelte';
  import M11Liste from '$lib/deck/visuels/M11Liste.svelte';
  import Goa from '$lib/deck/visuels/Goa.svelte';
  import M11Arbitre from '$lib/deck/visuels/M11Arbitre.svelte';
  import M11Exercice from '$lib/deck/visuels/M11Exercice.svelte';
  import M11Tranches from '$lib/deck/visuels/M11Tranches.svelte';
  import M11Cible from '$lib/deck/visuels/M11Cible.svelte';
  import M11Melange from '$lib/deck/visuels/M11Melange.svelte';
  import M11Regle from '$lib/deck/visuels/M11Regle.svelte';
  import M11Education from '$lib/deck/visuels/M11Education.svelte';
  import M11Cycle from '$lib/deck/visuels/M11Cycle.svelte';
  import M11Consignes from '$lib/deck/visuels/M11Consignes.svelte';
  import M11Article from '$lib/deck/visuels/M11Article.svelte';
  import M11Experience from '$lib/deck/visuels/M11Experience.svelte';
  import M11Debit from '$lib/deck/visuels/M11Debit.svelte';
  import M11Recompte from '$lib/deck/visuels/M11Recompte.svelte';
  import M11Presse from '$lib/deck/visuels/M11Presse.svelte';
  import M11Rumeur from '$lib/deck/visuels/M11Rumeur.svelte';
  import Console from '$lib/deck/visuels/Console.svelte';
  import { SIMS } from '$lib/data/seance11.js';
  import { DEVOIRS, EVALUATIONS } from '$lib/data/cours.js';
  import { GOA } from '$lib/data/seance11-goa.js';

  const TOTAL = 46;
  const QUESTIONS = [
    { t: 'Sur quelles variables X a-t-il un effet ?', g: 'On ne les contrôle jamais.' },
    { t: 'Quelles variables ont un effet sur X et sur Y ?', g: 'On les contrôle.' },
    { t: 'Peut-on estimer l’effet de X sur Y ?' }
  ];
  // Les consoles viennent de R telles quelles (seance11.js); seules les notes sont d'ici.
  const avec = (cle, notes = [], de = 0, a = undefined) => SIMS[cle].map((l, i) => ({ ...l, note: notes[i] || '' })).slice(de, a);
  const dc = DEVOIRS.find((d) => d.seance === 11);
  const ex2 = EVALUATIONS.find((v) => v.id === 'examen2');
  const jour = (iso) => new Date(iso + 'T12:00:00').toLocaleDateString('fr-CA', { weekday: 'long', day: 'numeric', month: 'long' });
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

    <Slide bandeau="Travail final" droite={D}>
      <M11Consignes doc="tpfinal" />
    </Slide>

    <!-- ================= 0. UNE MANCHETTE ================= -->

    <Slide fond="encre" bandeau="Une manchette" droite={D}>
      <h1 class="e">Près d’un cégépien sur deux</h1>
      <hr class="filet" />
      <p class="lead e">Richard et Régimbal (2026), <em>Revue canadienne d’enseignement supérieur</em></p>
    </Slide>

    <Slide bandeau="Les manchettes" droite={D}>
      <M11Presse qui="lapresse" />
    </Slide>

    <Slide bandeau="Les manchettes" droite={D}>
      <M11Presse qui="lettre" />
    </Slide>

    <Slide bandeau="Les manchettes" droite={D}>
      <M11Presse qui="radcan" />
    </Slide>

    <Slide bandeau="Les manchettes" droite={D}>
      <M11Presse qui="devoir" />
    </Slide>

    <Slide bandeau="Les manchettes" droite={D}>
      <h2 class="e">De l’article aux médias</h2>
      <M11Rumeur />
    </Slide>

    <Slide bandeau="L’article" droite={D}>
      <M11Article partie="a" />
    </Slide>

    <Slide bandeau="Le mode d’emploi" droite={D}>
      <M11Article partie="usda" />
    </Slide>

    <Slide bandeau="Le recompte" droite={D}>
      <h2 class="e">Le même tableau, lu avec le mode d’emploi</h2>
      <M11Recompte />
    </Slide>

    <Slide bandeau="L’article" droite={D}>
      <M11Article partie="b" />
    </Slide>

    <Slide bandeau="Les signes" droite={D}>
      <h2 class="e">Les signes à repérer</h2>
      <div class="serre"><M11Liste items={[
        { t: 'Un échantillon de volontaires', g: 'Six cégeps choisis selon l’intérêt de leur direction, aucun taux de réponse.' },
        { t: 'Un instrument mal appliqué', g: 'Avec la règle de l’instrument, 43,9 % devient 27,7 %.' },
        { t: 'Des données manquantes et aucun code', g: 'On ne sait pas combien de questionnaires sont incomplets, et personne ne peut refaire l’analyse.' },
        { t: 'Un lien présenté comme un effet', g: 'Un sondage à un seul moment.' }
      ]} /></div>
    </Slide>

    <!-- ================= 1. DEUX MONDES ================= -->

    <Slide fond="encre" bandeau="Deux mondes" droite={D}>
      <h1 class="e">Deux mondes</h1>
      <hr class="filet" />
      <p class="lead e">Le problème fondamental de l’inférence causale.</p>
    </Slide>

    <Slide bandeau="Deux mondes" droite={D}>
      <h2 class="e">L’université rend-elle Marie plus intéressée par la politique ?</h2>
      <M11Carrefour />
    </Slide>

    <Slide fond="encre" bandeau="Deux mondes" droite={D}>
      <p class="slogan-e e">On n’observe jamais les deux mondes pour la même personne.</p>
      <hr class="filet" />
      <p class="lead e">Un GOA rend explicites nos hypothèses causales.</p>
    </Slide>

    <Slide bandeau="Une expérience" droite={D}>
      <h2 class="e">Une expérience : le hasard choisit la route</h2>
      <M11Experience />
    </Slide>

    <!-- ================= 2. DESSINER UN GOA ================= -->

    <Slide fond="encre" bandeau="Dessiner un GOA" droite={D}>
      <h1 class="e">Dessiner un GOA</h1>
      <hr class="filet" />
      <p class="lead e">Des variables, reliées par des flèches causales.</p>
    </Slide>

    <Slide bandeau="Pourquoi un GOA" droite={D}>
      <h2 class="e">Un GOA sert à trois choses</h2>
      <M11Liste items={[
        { t: 'Rendre nos hypothèses visibles', g: 'Toute analyse causale repose sur des postulats. On les montre.' },
        { t: 'Savoir si l’effet de la VI sur la VD est identifiable', g: 'Est-ce possible, avec ces données ?' },
        { t: 'Choisir les variables de contrôle', g: 'Celles à inclure, et celles à laisser dehors.' }
      ]} />
    </Slide>

    <Slide bandeau="Dessiner un GOA" droite={D}>
      <h2 class="e">L’éducation rend-elle plus à droite ?</h2>
      <M11Education />
    </Slide>

    <!-- ================= 3. LA GRAMMAIRE ================= -->

    <Slide bandeau="Acyclique" droite={D}>
      <h2 class="e">Acyclique : l’effet ne revient jamais sur ses pas</h2>
      <M11Cycle />
    </Slide>

    <!-- ================= 4. LES CONTRÔLES ================= -->

    <Slide fond="encre" bandeau="Les contrôles" droite={D}>
      <h1 class="e">Quoi contrôler ?</h1>
      <hr class="filet" />
      <p class="lead e">Les deux règles de la séance 8, avec les mots du GOA.</p>
    </Slide>

    <Slide bandeau="Les contrôles" droite={D}>
      <h2 class="e">Deux règles pour estimer l’effet de X sur Y</h2>
      <M11Liste items={[
        { t: 'Ne jamais contrôler une variable sur laquelle X a un effet' },
        { t: 'Contrôler les variables qui ont un effet sur X et sur Y' }
      ]} />
    </Slide>

    <Slide bandeau="Règle 1" droite={D}>
      <h2 class="e">Ne jamais contrôler une variable sur laquelle X a un effet</h2>
      <M11Debit />
    </Slide>

    <Slide bandeau="Règle 1 · dans R" droite={D}>
      <h2 class="e">Dans R : contrôler une variable sur laquelle X a un effet</h2>
      <M11Regle regle={1} />
    </Slide>

    <Slide bandeau="Règle 2" droite={D}>
      <h2 class="e">Contrôler les variables qui ont un effet sur X et sur Y</h2>
      <M11Melange />
    </Slide>

    <Slide bandeau="Règle 2 · dans R" droite={D}>
      <h2 class="e">Dans R : contrôler une variable qui agit sur X et sur Y</h2>
      <M11Regle regle={2} />
    </Slide>

<Slide bandeau="Dessiner un GOA" droite={D}>
      <h2 class="e">Dessiner un GOA</h2>
      <Goa graphe={GOA.dessin} taille={1.2} legende={SCHEMA} temps={[
        { aretes: [], verdict: false, note: 'Une boîte par variable' },
        { verdict: false, note: 'Une flèche par effet, dans le sens de l’effet' },
        { controles: ['revenu_parents'], verdict: false, note: 'Encadrer une variable, c’est la contrôler' }
      ]} />
    </Slide>

    <Slide fond="encre" bandeau="Pause" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <p class="lead e">Ensuite : deux exercices, puis R.</p>
    </Slide>

    <!-- ================= 5. PRATIQUE ================= -->

    <Slide bandeau="Contrôler ou pas" droite={D}>
      <h2 class="e">Contrôler ou pas : trois questions</h2>
      <M11Liste tout items={QUESTIONS} />
    </Slide>

    <Slide bandeau="Exercice 1 de 2" droite={D}>
      <M11Exercice graphe={GOA.exercice2}
        reponses={['Z1, Z2 et Z3 : on ne les contrôle pas', 'Z4 : on la contrôle', 'Oui, en contrôlant Z4']}
        etats={[
          {},
          {},
          { accent: ['Z4'] },
          { controles: ['Z4'] }
        ]} />
    </Slide>

    <Slide bandeau="Exercice 2 de 2" droite={D}>
      <M11Exercice graphe={GOA.exercice3}
        reponses={['Le cholestérol (Z1) : on ne le contrôle pas', 'La vie malsaine (Z3) : on la contrôle', 'Oui, en contrôlant Z3']}
        etats={[
          {},
          {},
          { accent: ['vie'] },
          { controles: ['vie'] }
        ]} />
    </Slide>

    <!-- ================= 6. SIMULER DANS R ================= -->

    <Slide fond="encre" bandeau="Simuler dans R" droite={D}>
      <h1 class="e">Simuler dans R</h1>
      <hr class="filet" />
      <p class="lead e">On crée les données nous-mêmes : le vrai effet est connu, et on vérifie quel modèle le retrouve.</p>
    </Slide>

    <Slide bandeau="Simuler · une flèche" droite={D}>
      <h2 class="e">Le vrai effet de X sur Y : 1,7</h2>
      <div class="visuel sim">
        <Goa graphe={GOA.sim1} taille={1.1} temps={[{ coefs: true }]} legende="Données simulées" />
        <Console lignes={avec('simple', ['on écrit le vrai effet : 1,7', 'R retrouve 1,7'])} />
      </div>
    </Slide>

    <Slide bandeau="Simuler · une chaîne" droite={D}>
      <h2 class="e">Une chaîne : 3 × 0,5 = 1,5</h2>
      <div class="visuel sim">
        <Goa graphe={GOA.sim2} taille={0.9} temps={[{ coefs: true }]} legende="Données simulées" />
        <Console lignes={avec('chaine', ['', 'R retrouve 1,5, sans contrôle'])} />
      </div>
    </Slide>

    <Slide bandeau="Simuler · une collision" droite={D}>
      <h2 class="e">Contrôler Z, sur lequel X a un effet</h2>
      <div class="visuel sim">
        <Goa graphe={GOA.sim3} taille={0.9} temps={[{ coefs: true }]} legende="Données simulées" />
        <Console lignes={avec('collision', ['', 'sans contrôle : 1,7, juste', 'avec Z : 0,45, faux'])} />
      </div>
    </Slide>

<Slide bandeau="Simuler · une fourchette" droite={D}>
      <h2 class="e">Contrôler Z2, qui a un effet sur X et sur Y</h2>
      <div class="visuel sim">
        <Goa graphe={GOA.sim4} taille={0.9} temps={[{ coefs: true }]} legende="Données simulées" />
        <Console lignes={avec('fourchette', ['vrai effet : 2 × 0,25 = 0,5', 'contrôler Z2 : 0,5, juste'], 0, 2)} />
      </div>
    </Slide>

    <Slide bandeau="Simuler · une fourchette" droite={D}>
      <h2 class="e">Et sans contrôler Z2 ?</h2>
      <div class="visuel sim">
        <Goa graphe={GOA.sim4} taille={0.9} temps={[{ coefs: true, chemin: ['X', 'Z2', 'Y'], court: true }]} legende="Données simulées" />
        <Console lignes={avec('fourchette', ['', '', 'sans contrôle : 1,0, faux. Z2 n’est pas contrôlé'], 2)} />
      </div>
    </Slide>

    <Slide bandeau="Simuler · le modèle complet" droite={D}>
      <M11Exercice graphe={GOA.sim5}
        reponses={['Z2 et Z3 : on ne les contrôle pas', 'Z1 : on la contrôle', 'Oui, avec Z1, sans Z2 ni Z3']}
        etats={[
          { coefs: true },
          { coefs: true },
          { coefs: true, accent: ['Z1'] },
          { coefs: true, controles: ['Z1'] }
        ]} />
    </Slide>

    <Slide bandeau="Simuler · la preuve" droite={D}>
      <h2 class="e">Le vrai effet : 2 × 0,5 = 1</h2>
      <div class="visuel sim">
        <Goa graphe={GOA.sim5} taille={0.75} temps={[{ coefs: true, controles: ['Z1'] }]} legende="Données simulées" />
        <Console lignes={avec('complexe', ['', 'contrôler Z1 : 1,0, juste'], 0, 2)} />
      </div>
    </Slide>

    <Slide bandeau="Simuler · la preuve" droite={D}>
      <h2 class="e">Et sans contrôler Z1 ?</h2>
      <div class="visuel sim">
        <Goa graphe={GOA.sim5} taille={0.75} temps={[{ coefs: true, chemin: ['X', 'Z1', 'Y'], court: true }]} legende="Données simulées" />
        <Console lignes={avec('complexe', ['', '', 'sans contrôle : 1,5, faux'], 2)} />
      </div>
    </Slide>

<Slide fond="encre" bandeau="Simuler dans R" droite={D}>
      <p class="slogan-e e">Ajouter des contrôles n’améliore pas toujours l’estimation.</p>
      <hr class="filet" />
      <p class="lead e">On choisit les contrôles à partir du GOA.</p>
    </Slide>

    <!-- ================= CLÔTURE ================= -->

    <Slide bandeau="Examen 2" droite={D}>
      <M11Consignes doc="examen2" />
    </Slide>

<Slide bandeau="Avant la prochaine séance" droite={D}>
      <h2 class="e">Avant la prochaine séance</h2>
      <div class="visuel avant">
        <div class="tuile rouge-b">
          <span class="poids">{ex2.poids} %</span>
          <strong>{ex2.court}</strong>
          <span>À remettre {jour(ex2.date)}, {ex2.heure}</span>
          <span>{ex2.mode}</span>
        </div>
        <a class="tuile" href={dc.url} target="_blank" rel="noopener">
          <img src="{base}/img/datacamp.png" alt="Datacamp" />
          <strong>Datacamp</strong>
          <span>{dc.cours} · {dc.chapitre}</span>
        </a>
        <div class="tuile">
          <strong>Votre GOA</strong>
          <span>Dessinez-le pour votre travail final, et apportez-le aux rencontres individuelles.</span>
        </div>
      </div>
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

.cote-a-cote { width: 100%; display: grid; grid-template-columns: 1fr 1fr; gap: 2.4em; margin-top: 1.4em; align-items: end; }
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
.trois { width: 100%; display: grid; grid-template-columns: repeat(3, 1fr); gap: 2em; margin-top: 1.6em; }
.nom-ch { font-size: 1.3em; font-weight: 700; margin: 0; border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.2em; align-self: stretch; text-align: center; }
.pile { width: 100%; display: flex; flex-direction: column; gap: 1.4em; align-items: center; margin-top: 1em; }
.escalier { width: 100%; display: grid; grid-template-columns: auto 1fr; gap: 2.4em; align-items: center; margin-top: 1em; }
.merci h1 { font-size: 3.4em; }
.sim { width: 100%; display: grid; grid-template-columns: minmax(0, 0.8fr) minmax(0, 1.2fr); gap: 2em; align-items: center; margin-top: 0.4em; }
.tf { width: 100%; display: grid; grid-template-columns: minmax(0, 1.1fr) minmax(0, 0.9fr); gap: 2em; align-items: center; }
.tf :global(.m11l) { margin-top: 0; }
.avant { width: 100%; display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.4em; max-width: 62em; margin: 1.2em auto 0; }
.tuile .poids { font-size: 2.2em; font-weight: 700; line-height: 1; color: var(--dk-accent); }
.tuile { border: 3px solid var(--dk-encre); padding: 1.2em 1.3em; display: flex; flex-direction: column; gap: 0.5em; color: inherit; text-decoration: none; }
.tuile.rouge-b { border-color: var(--dk-accent); }
.tuile img { height: 2.4em; width: auto; align-self: flex-start; }
.tuile strong { font-size: 1.3em; }
.tuile span { font-size: 0.9em; color: var(--dk-gris); }
.trois-g { width: 100%; display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.6em; margin-top: 0.6em; }
.nom-g { font-size: 1.2em; font-weight: 700; margin: 0; text-align: center; border-bottom: 2px solid var(--dk-encre); padding-bottom: 0.2em; }
.sous-g { margin-top: 0.8em; text-align: center; font-weight: 600; }
.pile-g { width: 100%; display: flex; flex-direction: column; gap: 0.2em; align-items: center; }
  .serre { font-size: 0.82em; width: 100%; }
</style>
