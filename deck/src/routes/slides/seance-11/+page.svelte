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
   * les contrôles, ne pas contrôler un descendant de X et fermer les portes
   * arrière; l'article y revient. Retour honnête sur la séance 8 (le revenu,
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
  import Aujourdhui11 from '$lib/deck/visuels/Aujourdhui11.svelte';
  import M11Carrefour from '$lib/deck/visuels/M11Carrefour.svelte';
  import M11Dominos from '$lib/deck/visuels/M11Dominos.svelte';
  import M11Thermometre from '$lib/deck/visuels/M11Thermometre.svelte';
  import M11Liste from '$lib/deck/visuels/M11Liste.svelte';
  import Goa from '$lib/deck/visuels/Goa.svelte';
  import M11Arbitre from '$lib/deck/visuels/M11Arbitre.svelte';
  import M11Escalier from '$lib/deck/visuels/M11Escalier.svelte';
  import M11Exercice from '$lib/deck/visuels/M11Exercice.svelte';
  import M11Tranches from '$lib/deck/visuels/M11Tranches.svelte';
  import M11Cible from '$lib/deck/visuels/M11Cible.svelte';
  import M11Echelle from '$lib/deck/visuels/M11Echelle.svelte';
  import M11Maison from '$lib/deck/visuels/M11Maison.svelte';
  import M11Hypotheses from '$lib/deck/visuels/M11Hypotheses.svelte';
  import M11Article from '$lib/deck/visuels/M11Article.svelte';
  import M11Recompte from '$lib/deck/visuels/M11Recompte.svelte';
  import M11Chrono from '$lib/deck/visuels/M11Chrono.svelte';
  import Console from '$lib/deck/visuels/Console.svelte';
  import { SIMS } from '$lib/data/seance11.js';
  import { DEVOIRS, EVALUATIONS } from '$lib/data/cours.js';
  import { GOA } from '$lib/data/seance11-goa.js';

  const TOTAL = 46;
  const QUESTIONS = [
    { t: 'Y a-t-il des descendants de X ?' },
    { t: 'Y a-t-il des chemins par la porte arrière ?' },
    { t: 'Sont-ils ouverts ?' },
    { t: 'Peut-on les bloquer ?' },
    { t: 'L’effet de X sur Y est-il identifiable ?' }
  ];
  // Les consoles viennent de R telles quelles (seance11.js); seules les notes sont d'ici.
  const avec = (cle, notes = [], de = 0, a = undefined) => SIMS[cle].map((l, i) => ({ ...l, note: notes[i] || '' })).slice(de, a);
  const dc = DEVOIRS.find((d) => d.seance === 11);
  const ex2 = EVALUATIONS.find((v) => v.id === 'examen2');
  const jour = (iso) => new Date(iso + 'T12:00:00').toLocaleDateString('fr-CA', { weekday: 'long', day: 'numeric', month: 'long' });
  const D = 'POL-2000 · séance 11 · jeu 19 nov';
  const SCHEMA = 'Schéma, aucune donnée';
  const FAIM = 'Liens tirés de l’article : tableau 3 (p. 78) et tests F (p. 79)';
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

    <!-- ================= 0. UNE MANCHETTE ================= -->

    <Slide fond="encre" bandeau="Une manchette" droite={D}>
      <h1 class="e">Près d’un cégépien sur deux</h1>
      <hr class="filet" />
      <p class="lead e">Une étude, toutes les manchettes. Regardons-la de près.</p>
    </Slide>

    <Slide bandeau="Une manchette" droite={D}>
      <h2 class="e">La manchette arrive avant l’article</h2>
      <M11Chrono />
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

    <Slide bandeau="L’article" droite={D}>
      <h2 class="e">« Influence » : et les autres chemins ?</h2>
      <Goa graphe={GOA.faim} taille={1.1} legende={FAIM} temps={[
        { voir: ['insecurite', 'satisfaction'], aretes: [0], accent: ['insecurite', 'satisfaction'], verdict: false, note: 'Ce que l’article affirme' },
        { voir: ['insecurite', 'satisfaction', 'age'], aretes: [0, 1, 2], accent: ['insecurite', 'satisfaction'], chemin: ['insecurite', 'age', 'satisfaction'], court: true, note: '24 ans et plus : 73 % en insécurité. 17 ans et moins : 32 %' },
        { accent: ['insecurite', 'satisfaction'], chemin: ['insecurite', 'enfants', 'satisfaction'], court: true, note: 'Leurs propres tableaux : chacune est liée aux deux bouts' }
      ]} />
    </Slide>

    <Slide bandeau="Les signes" droite={D}>
      <h2 class="e">Les signes à repérer</h2>
      <div class="serre"><M11Liste items={[
        { t: 'La manchette arrive avant l’article', g: 'Six mois avant, personne ne l’avait relue.' },
        { t: 'Un échantillon qui s’est choisi lui-même', g: 'Des cégeps et des étudiants volontaires.' },
        { t: 'Un instrument lu sans son mode d’emploi', g: '43,9 % devient 27,7 %.' },
        { t: 'Un lien présenté comme un effet', g: 'Aucun contrôle. C’est le sujet d’aujourd’hui.' },
        { t: 'Beaucoup de tests, peu de résultats', g: '20 tests, 2 sous 0,05.' }
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
        { t: 'Savoir si l’effet de la VI sur la VD est identifiable', g: 'Est-ce possible, avec ces données ?' },
        { t: 'Choisir les variables de contrôle', g: 'Celles à inclure, et celles à laisser dehors.' }
      ]} />
    </Slide>

    <Slide bandeau="Dessiner un GOA" droite={D}>
      <h2 class="e">L’éducation rend-elle plus à droite ? Une phrase, une flèche</h2>
      <M11Hypotheses />
      <p class="source e">D’après Arel-Bundock (2021), p. 116</p>
    </Slide>

    <!-- ================= 3. LA GRAMMAIRE ================= -->

    <Slide bandeau="Orienté" droite={D}>
      <h2 class="e">Orienté, acyclique : des dominos</h2>
      <M11Dominos />
    </Slide>

    <Slide bandeau="Effet ou information" droite={D}>
      <h2 class="e">Le mercure fait-il vendre de la crème glacée ?</h2>
      <M11Thermometre />
    </Slide>

    <!-- ================= 4. LES CONTRÔLES ================= -->

    <Slide fond="encre" bandeau="Les contrôles" droite={D}>
      <h1 class="e">Quoi contrôler ?</h1>
      <hr class="filet" />
      <p class="lead e">Les deux règles de la séance 8, avec les mots du GOA.</p>
    </Slide>

    <Slide bandeau="Les contrôles" droite={D}>
      <h2 class="e">Deux conditions pour estimer l’effet de X sur Y</h2>
      <M11Liste items={[
        { t: 'Ne pas contrôler un descendant de X', g: 'Elle dit quelles variables laisser dehors.' },
        { t: 'Fermer tous les chemins par la porte arrière', g: 'Les causes de la cause. Elle dit quelles variables inclure.' }
      ]} />
    </Slide>

    <Slide bandeau="Condition 1" droite={D}>
      <h2 class="e">Ne pas contrôler un descendant de X</h2>
      <M11Echelle />
    </Slide>

    <Slide bandeau="Condition 2" droite={D}>
      <h2 class="e">Fermer les chemins par la porte arrière</h2>
      <M11Maison />
    </Slide>

    <Slide bandeau="Retour à l’article" droite={D}>
      <h2 class="e">Ce qu’il aurait fallu contrôler</h2>
      <Goa graphe={GOA.faim} taille={1.1} legende={FAIM} temps={[
        { accent: ['insecurite', 'satisfaction'], chemin: ['insecurite', 'age', 'satisfaction'], court: true, note: 'Trois portes arrière, ouvertes' },
        { accent: ['insecurite', 'satisfaction'], chemin: ['insecurite', 'age', 'satisfaction'], controles: ['age', 'enfants', 'naissance'], court: true, note: 'Dans un même modèle, on les ferme' }
      ]} />
    </Slide>

    <Slide bandeau="À vous" droite={D}>
      <h2 class="e">L’effet de l’éducation sur l’idéologie : quoi contrôler ?</h2>
      <Goa graphe={GOA.education} legende={SCHEMA} temps={[{ accent: ['education', 'ideologie'] }]} />
    </Slide>

    <Slide bandeau="Réponse" droite={D}>
      <h2 class="e">L’effet de l’éducation sur l’idéologie : quoi contrôler ?</h2>
      <Goa graphe={GOA.education} legende={SCHEMA} temps={[
        { accent: ['education', 'ideologie'], barres: ['revenu_ind'], note: 'Le revenu individuel : un descendant. On ne le contrôle pas' },
        { accent: ['education', 'ideologie'], barres: ['revenu_ind'], chemin: ['education', 'revenu_parents', 'revenu_ind', 'ideologie'], note: 'Une porte arrière, par le revenu des parents' },
        { accent: ['education', 'ideologie'], barres: ['revenu_ind'], chemin: ['education', 'revenu_parents', 'revenu_ind', 'ideologie'], controles: ['revenu_parents'], note: 'On contrôle le revenu des parents. Seulement lui' }
      ]} />
    </Slide>

    <Slide bandeau="Retour sur la séance 8" droite={D}>
      <h2 class="e">Avait-on le droit de contrôler le revenu ?</h2>
      <div class="visuel escalier">
        <M11Escalier marque />
        <Goa graphe={GOA.escalier8} taille={0.9} legende={SCHEMA} temps={[
          { flux: true, controles: ['age', 'sexe'] },
          { flux: true, controles: ['age', 'sexe', 'revenu'], barres: ['revenu'], note: 'Non : le revenu est un descendant de la scolarité' }
        ]} />
      </div>
    </Slide>

    <Slide fond="encre" bandeau="Pause" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <p class="lead e">Ensuite : à vous de jouer, puis R.</p>
    </Slide>

    <!-- ================= 5. PRATIQUE ================= -->

    <Slide bandeau="Contrôler ou pas" droite={D}>
      <h2 class="e">Contrôler ou pas : cinq questions</h2>
      <M11Liste tout items={QUESTIONS} />
    </Slide>

    <Slide bandeau="Exercice 1 de 2" droite={D}>
      <M11Exercice graphe={GOA.exercice2}
        reponses={['Oui : Z1, Z2 et Z3', 'Oui : X ← Z4 → Z3 → Y', 'Oui, il est ouvert', 'Oui : contrôler Z4', 'Oui, si on contrôle Z4']}
        etats={[
          {},
          { barres: ['Z1', 'Z2', 'Z3'] },
          { barres: ['Z1', 'Z2', 'Z3'], accent: ['Z4'] },
          { barres: ['Z1', 'Z2', 'Z3'], chemin: ['X', 'Z4', 'Z3', 'Y'], court: true },
          { barres: ['Z1', 'Z2', 'Z3'], chemin: ['X', 'Z4', 'Z3', 'Y'], controles: ['Z4'], court: true },
          { barres: ['Z1', 'Z2', 'Z3'], controles: ['Z4'] }
        ]} />
    </Slide>

    <Slide bandeau="Exercice 2 de 2" droite={D}>
      <M11Exercice graphe={GOA.exercice3}
        reponses={['Oui : le cholestérol (Z1)', 'Oui : par la vie malsaine et le poids', 'Oui, il est ouvert', 'Oui : contrôler Z3, ou Z2', 'Oui, si on contrôle Z3 ou Z2']}
        etats={[
          {},
          { barres: ['cholesterol'] },
          { barres: ['cholesterol'], accent: ['vie', 'poids'] },
          { barres: ['cholesterol'], chemin: ['fumer', 'vie', 'poids', 'cholesterol', 'arret'], court: true },
          { barres: ['cholesterol'], chemin: ['fumer', 'vie', 'poids', 'cholesterol', 'arret'], controles: ['vie'], court: true },
          { barres: ['cholesterol'], chemin: ['fumer', 'vie', 'poids', 'cholesterol', 'arret'], controles: ['poids'], court: true, note: 'Le poids ferme aussi la porte' }
        ]} />
    </Slide>

    <!-- ================= 6. SIMULER DANS R ================= -->

    <Slide fond="encre" bandeau="Simuler dans R" droite={D}>
      <h1 class="e">Simuler dans R</h1>
      <hr class="filet" />
      <p class="lead e">On fabrique le monde nous-mêmes. On connaît donc le vrai effet. Le bon modèle doit le retrouver.</p>
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
      <h2 class="e">Contrôler Z, un descendant de X : le biais post-traitement</h2>
      <div class="visuel sim">
        <Goa graphe={GOA.sim3} taille={0.9} temps={[{ coefs: true }]} legende="Données simulées" />
        <Console lignes={avec('collision', ['', 'sans contrôle : 1,7, juste', 'avec Z : 0,45, faux'])} />
      </div>
    </Slide>

    <Slide bandeau="Simuler · une collision" droite={D}>
      <h2 class="e">Contrôler Z, c’est regarder une tranche à la fois</h2>
      <M11Tranches />
    </Slide>

    <Slide bandeau="Simuler · une fourchette" droite={D}>
      <h2 class="e">Fermer la porte arrière, pas plus</h2>
      <div class="visuel sim">
        <Goa graphe={GOA.sim4} taille={0.9} temps={[{ coefs: true }]} legende="Données simulées" />
        <Console lignes={avec('fourchette', ['vrai effet : 2 × 0,25 = 0,5', 'contrôler Z2 : 0,5, juste'], 0, 2)} />
      </div>
    </Slide>

    <Slide bandeau="Simuler · une fourchette" droite={D}>
      <h2 class="e">Et sans contrôler Z2 ?</h2>
      <div class="visuel sim">
        <Goa graphe={GOA.sim4} taille={0.9} temps={[{ coefs: true, chemin: ['X', 'Z2', 'Y'], court: true }]} legende="Données simulées" />
        <Console lignes={avec('fourchette', ['', '', 'sans contrôle : 1,0, faux. La porte arrière est ouverte'], 2)} />
      </div>
    </Slide>

    <Slide bandeau="Simuler · le modèle complet" droite={D}>
      <M11Exercice graphe={GOA.sim5}
        reponses={['Oui : Z2 et Z3', 'Oui : X ← Z1 → Y', 'Oui, il est ouvert', 'Oui : contrôler Z1', 'Oui, avec Z1, sans Z2 ni Z3']}
        etats={[
          { coefs: true },
          { coefs: true, barres: ['Z2', 'Z3'] },
          { coefs: true, barres: ['Z2', 'Z3'], accent: ['Z1'] },
          { coefs: true, barres: ['Z2', 'Z3'], chemin: ['X', 'Z1', 'Y'], court: true },
          { coefs: true, barres: ['Z2', 'Z3'], chemin: ['X', 'Z1', 'Y'], controles: ['Z1'], court: true },
          { coefs: true, barres: ['Z2', 'Z3'], controles: ['Z1'] }
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

    <Slide bandeau="Simuler · huit modèles" droite={D}>
      <h2 class="e">Huit modèles, un seul dans le mille</h2>
      <M11Cible />
    </Slide>

    <Slide fond="encre" bandeau="Simuler dans R" droite={D}>
      <p class="slogan-e e">Le bon modèle n’est pas celui qui a le plus de contrôles.</p>
      <hr class="filet" />
      <p class="lead e">C’est celui que le GOA dicte.</p>
    </Slide>

    <!-- ================= CLÔTURE ================= -->

    <Slide bandeau="Travail final" droite={D}>
      <h2 class="e">Votre travail final : un GOA</h2>
      <div class="visuel tf">
        <Goa graphe={GOA.travailFinal} taille={0.75} haut="40vh" temps={[{ controles: ['v1', 'v2'] }]} legende={SCHEMA} />
        <M11Liste tout items={[
          { t: 'X, Y et au moins trois autres variables' },
          { t: 'Pour chacune, son mécanisme', g: 'Comment elle agit sur X, et comment elle agit sur Y.' },
          { t: 'Contrôlez celles qui sont dans la CES', g: 'Les autres vont dans vos limites.' },
          { t: 'Jamais un descendant de X' }
        ]} />
      </div>
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
