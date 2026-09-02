<script>
  /**
   * POL-2000 — Séance 1 · Introduction et les éléments fondamentaux de la recherche
   * Jeudi 3 septembre 2026, 15h30–18h20, DKN-3159.
   *
   * Doctrine: moins de texte, plus de figure. Une idée par diapo, une phrase
   * parlée au plus; le reste se dessine. Rien n'est inventé pour une figure —
   * les visuels sont schématiques et dits tels; les dates et pondérations
   * viennent du plan de cours A26. Le tableau de régression de l'ouverture
   * est vide, volontairement.
   */
  import Deck from '$lib/deck/Deck.svelte';
  import Slide from '$lib/deck/Slide.svelte';
  import Carte from '$lib/deck/Carte.svelte';
  import Deux from '$lib/deck/Deux.svelte';
  import Etiquette from '$lib/deck/Etiquette.svelte';
  import Grand from '$lib/deck/Grand.svelte';
  import Citation from '$lib/deck/Citation.svelte';
  import Code from '$lib/deck/Code.svelte';
  import Picto from '$lib/deck/Picto.svelte';
  import Axe from '$lib/deck/visuels/Axe.svelte';
  import Silhouette from '$lib/deck/visuels/Silhouette.svelte';
  import Parcours from '$lib/deck/visuels/Parcours.svelte';
  import Frise from '$lib/deck/visuels/Frise.svelte';
  import Ponderation from '$lib/deck/visuels/Ponderation.svelte';
  import Retard from '$lib/deck/visuels/Retard.svelte';
  import Equipe from '$lib/deck/visuels/Equipe.svelte';
  import Entonnoir from '$lib/deck/visuels/Entonnoir.svelte';
  import Points from '$lib/deck/visuels/Points.svelte';
  import Niveaux from '$lib/deck/visuels/Niveaux.svelte';
  import Hypotheses from '$lib/deck/visuels/Hypotheses.svelte';
  import Varie from '$lib/deck/visuels/Varie.svelte';
  import Ordre from '$lib/deck/visuels/Ordre.svelte';

  const TOTAL = 43;
  const D = 'POL-2000 · séance 1 · jeu 3 sept';

  const c_verif = `R.version.string
# [1] "R version 4.x.x (2026-..-..)"

install.packages("tidyverse")
# ... beaucoup de texte, puis :
# * DONE (tidyverse)`;
</script>

<svelte:head>
  <title>POL-2000 · Séance 1 — Introduction et les éléments fondamentaux de la recherche</title>
</svelte:head>

<Deck total={TOTAL}>
  {#snippet children()}

    <!-- ================= OUVERTURE ================= -->
    <Slide fond="encre" droite={D}>
      <p class="surtitre e">POL-2000 · Méthodologie quantitative · Automne 2026</p>
      <h1 class="e">Introduction et les éléments fondamentaux de la recherche</h1>
      <hr class="filet" />
      <p class="lead e">Séance 1 · jeudi 3 septembre 2026</p>
      <p class="lead e">Laurence-Olivier M. Foisy · Université Laval</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Qui suis-je</h2>
      <div class="frise-moi e">
        <div><span class="an">2025 · 2026</span><strong>Université de Montréal</strong><span>FAS1001 · mégadonnées, deux fois</span></div>
        <div class="fl">→</div>
        <div><span class="an">août 2026</span><strong>EIOM · Laval</strong><span>l'IA et la recherche</span></div>
        <div class="fl">→</div>
        <div class="ici"><span class="an">aujourd'hui</span><strong>POL-2000</strong><span>avec vous</span></div>
      </div>
      <p class="e"><code>mail@mfoisy.com</code> — deux semaines. Ensuite, Slack.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">À main levée</h2>
      <ol class="mains e">
        <li><span>Un cours de statistiques au cégep ?</span></li>
        <li><span>Une ligne de code, n'importe laquelle ?</span></li>
        <li><span>ChatGPT, Claude ou Gemini chaque semaine ?</span></li>
        <li><span>Ce cours vous fait peur ?</span></li>
      </ol>
    </Slide>


    <!-- ================= 1 · UNE QUESTION ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Une question, pour commencer</h1>
      <hr class="filet" />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">L'éducation rend-elle plus à gauche ?</h2>
      <Axe />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Ce qu'il faudrait pour répondre</h2>
      <Silhouette />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Ce tableau, vous le produirez en novembre</h2>
      <table class="e tableau-vide">
        <thead><tr><th>Placement gauche-droite (0–10)</th><th>Coefficient</th><th>Erreur-type</th><th>p</th></tr></thead>
        <tbody>
          <tr><td>Scolarité</td><td>?</td><td>?</td><td>?</td></tr>
          <tr><td>Âge</td><td>?</td><td>?</td><td>?</td></tr>
          <tr><td>Revenu</td><td>?</td><td>?</td><td>?</td></tr>
          <tr><td>Constante</td><td>?</td><td>?</td><td>?</td></tr>
        </tbody>
      </table>
      <p class="lead e">Le lire. Le produire. Dire pourquoi il <strong>ne prouve pas</strong> ce qu'on croit.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Le parcours, en trois temps</h2>
      <Parcours />
    </Slide>


    <!-- ================= 2 · LA MAUVAISE RÉPUTATION ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Ce cours a mauvaise réputation</h1>
      <hr class="filet" />
      <p class="lead e">Parlons-en.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Trois peurs, trois réponses</h2>
      <div class="peurs e">
        <div class="peur">
          <div class="glyphe barre">∑ β̂ σ²</div>
          <span class="fix">Aucune formule à dériver.</span>
          <small>Préalable : le secondaire.</small>
        </div>
        <div class="peur">
          <div class="glyphe"><s>sem. 4</s> <strong>sem. 2</strong></div>
          <span class="fix">R dès jeudi prochain.</span>
          <small>Et à presque toutes les séances.</small>
        </div>
        <div class="peur">
          <div class="glyphe"><s>0,032</s> <strong>?</strong></div>
          <span class="fix">La question d'abord.</span>
          <small>Le chiffre ensuite.</small>
        </div>
      </div>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">En échange</h2>
      <div class="quatre e">
        <div><Picto nom="terminal" taille="2.6em" /><strong>L'ordinateur</strong><span>à chaque séance</span></div>
        <div><Picto nom="horloge" taille="2.6em" /><strong>Les Datacamp</strong><span>chaque semaine</span></div>
        <div><Picto nom="humain" taille="2.6em" /><strong>Les questions « bêtes »</strong><span>cent personnes ont la même</span></div>
        <div><Picto nom="oeil" taille="2.6em" /><strong>Me dire quand ça décroche</strong><span>tôt</span></div>
      </div>
    </Slide>


    <!-- ================= 3 · LE PLAN DE COURS ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Le plan de cours</h1>
      <hr class="filet" />
      <p class="lead e">Contestable aujourd'hui. Ensuite, c'est le contrat.</p>
      <p class="lead e"><code>pol2000.com/syllabus</code></p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Identification</h2>
      <div class="etiqs e">
        <Etiquette ton="accent">POL-2000</Etiquette>
        <Etiquette>NRC 87892</Etiquette>
        <Etiquette>3 crédits · 3-0-6</Etiquette>
        <Etiquette>Jeudi 15h30–18h20</Etiquette>
        <Etiquette>DKN-3159</Etiquette>
        <Etiquette ton="ambre">En présentiel</Etiquette>
        <Etiquette>14 séances</Etiquette>
        <Etiquette>Préalable mathématique : aucun</Etiquette>
      </div>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">En décembre, vous saurez</h2>
      <ol class="qs-num e">
        <li><span>Maîtriser les concepts de l'analyse statistique</span></li>
        <li><span>Utiliser R et Positron</span></li>
        <li><span>Critiquer un article quantitatif</span></li>
        <li><span>Raisonner en termes de causes — et de limites</span></li>
        <li><span>Mener votre propre projet</span></li>
      </ol>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">La session</h2>
      <Frise />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">… et ce qui s'y évalue</h2>
      <Frise evaluations />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Cent points</h2>
      <Ponderation />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Trois examens</h2>
      <div class="trois e">
        <Carte titre="1 · chez vous">Sur R. Ouvre le 24 sept., se remet le 4 oct.</Carte>
        <Carte ton="accent" titre="2 · en classe">22 oct. Une heure. Papier, crayon.</Carte>
        <Carte ton="accent" titre="3 · en classe">10 déc. Une heure. Papier, crayon.</Carte>
      </div>
      <p class="e">Pas de centre d'examen : c'est ici, à l'heure du cours.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Un seul projet, en deux temps</h2>
      <div class="croissance e">
        <div class="doc petit-doc">
          <span class="et">MI-SESSION · 20 % · 25 OCT.</span>
          <ul><li>la question</li><li>X et Y</li><li>les hypothèses</li><li>les données</li></ul>
        </div>
        <div class="fl">→</div>
        <div class="doc grand-doc">
          <span class="et acc">FINAL · 25 % · 18 DÉC.</span>
          <ul><li>la question</li><li>X et Y</li><li>les hypothèses</li><li>les données</li><li class="plus">+ le graphe orienté acyclique</li><li class="plus">+ les descriptives</li><li class="plus">+ la régression et son tableau</li><li class="plus">+ l'interprétation, les biais, les limites</li></ul>
        </div>
      </div>
      <p class="e">Le mi-session revient corrigé <strong>avant</strong> que vous écriviez la suite.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Datacamp</h2>
      <Deux ratio="1fr 1.6fr">
        <Grand valeur="10 %" legende="5 + 5" />
        <div class="dc e">
          <div class="semaines">
            {#each Array.from({ length: 14 }) as _, i}
              <i class:jalon={i === 7 || i === 13}></i>
            {/each}
          </div>
          <div class="jalons"><span>dim. 25 oct.</span><span>ven. 18 déc.</span></div>
          <p>Un devoir par semaine, chez vous. C'est là que R devient un réflexe.</p>
        </div>
      </Deux>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Un retard</h2>
      <Retard />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">L'intelligence artificielle</h2>
      <div class="feux e">
        <div class="feu ok"><span class="signe">✓</span><strong>Le code R</strong><small>permis, si déclaré</small></div>
        <div class="feu non"><span class="signe">✗</span><strong>L'interprétation. La rédaction.</strong><small>jamais</small></div>
        <div class="feu selon"><span class="signe">≈</span><strong>Chaque évaluation</strong><small>ses propres consignes</small></div>
      </div>
      <Citation source="La question, chaque fois">L'aurais-je accepté d'un assistant humain sans vérifier son travail ?</Citation>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Matériel</h2>
      <div class="materiel e">
        <div class="item"><span class="grosR">R</span><strong>gratuit</strong></div>
        <div class="item"><span class="grosP">Positron</span><strong>gratuit</strong></div>
        <div class="item"><Picto nom="terminal" taille="2.8em" /><strong>votre portable</strong></div>
        <div class="item livre"><span class="couv">Arel-Bundock<br />2021</span><strong>référence, gratuit en PDF</strong><small>rien d'obligatoire à lire</small></div>
      </div>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">L'équipe</h2>
      <Equipe />
      <p class="e">Rencontres individuelles le <strong>8 octobre</strong>. Rendez-vous : <code>pol2000.com</code>.</p>
    </Slide>

    <Slide fond="encre" droite={D}>
      <div class="deuxgrands e">
        <div><span class="signe non">✗</span><strong>Enregistrement</strong><small>ce cours se donne ici</small></div>
        <div><span class="signe">↻</span><strong>Hiver</strong><small>la version en ligne, asynchrone</small></div>
      </div>
    </Slide>

    <Slide fond="encre" droite={D}>
      <h1 class="e">Des objections ?</h1>
      <hr class="filet" />
      <p class="lead e">C'est maintenant.</p>
    </Slide>


    <!-- ================= PAUSE ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Pause</h1>
      <hr class="filet" />
      <p class="lead e">Quinze minutes.</p>
    </Slide>


    <!-- ================= 4 · LES ÉLÉMENTS FONDAMENTAUX ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Les éléments fondamentaux</h1>
      <hr class="filet" />
      <p class="lead e">Le vocabulaire d'ici décembre.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">De la curiosité à la question</h2>
      <Entonnoir />
    </Slide>

    <Slide droite={D}>
      <div class="xy e">
        <div class="x"><span class="lettre">X</span><strong>indépendante</strong><small>ce qui explique</small><em>l'âge</em></div>
        <div class="fl">→</div>
        <div class="y"><span class="lettre">Y</span><strong>dépendante</strong><small>ce qu'on explique</small><em>voter</em></div>
      </div>
      <p class="lead e centre">Une question de recherche, c'est au minimum un X et un Y.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Une variable varie</h2>
      <Varie />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Population, échantillon</h2>
      <Points />
      <p class="e">Ce que je vois ici, puis-je le dire de tout ça ? <span class="pale">Séance 5.</span></p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Une ligne, c'est quoi ?</h2>
      <div class="unites e">
        <div><Picto nom="humain" taille="2.4em" /><strong>une personne</strong><span>a voté, ou non</span></div>
        <div><span class="glyphe-u">◯</span><strong>un pays, une année</strong><span>indice de démocratie</span></div>
        <div><span class="glyphe-u">▣</span><strong>un parti, une élection</strong><span>part des voix</span></div>
        <div><span class="glyphe-u">❝</span><strong>un discours, un tweet</strong><span>ton positif ou négatif</span></div>
      </div>
      <p class="e">L'unité d'analyse. On ne les mélange pas — et aucun logiciel ne vous le dira.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Ce que les chiffres permettent</h2>
      <Niveaux />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">L'hypothèse, et sa nulle</h2>
      <Hypotheses />
      <p class="e">On ne prouve jamais H₁. On demande aux données de <strong>rejeter H₀</strong>.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Opérationnaliser</h2>
      <div class="chaine e">
        <div><span class="et">CONCEPT</span><strong>« Être à gauche »</strong></div>
        <div class="fl">→</div>
        <div><span class="et">DÉFINITION</span><strong>Se situer soi-même sur un axe</strong></div>
        <div class="fl">→</div>
        <div><span class="et">MESURE</span><strong>0 ······ 5 ······ 10</strong></div>
      </div>
      <p class="lead e">Chaque flèche perd quelque chose.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">La fiche</h2>
      <Deux>
        <div class="fiche vide">
          <dl>
            <dt>Question</dt><dd>—</dd>
            <dt>Y</dt><dd>—</dd>
            <dt>X</dt><dd>—</dd>
            <dt>Population</dt><dd>—</dd>
            <dt>Unité</dt><dd>—</dd>
            <dt>Mesure</dt><dd>—</dd>
            <dt>H₁ · H₀</dt><dd>—</dd>
          </dl>
        </div>
        <div class="fiche pleine">
          <dl>
            <dt>Question</dt><dd>L'éducation rend-elle plus à gauche ?</dd>
            <dt>Y</dt><dd>placement gauche-droite</dd>
            <dt>X</dt><dd>scolarité</dd>
            <dt>Population</dt><dd>électeur.rice.s, Canada, 2025</dd>
            <dt>Unité</dt><dd>la personne sondée</dd>
            <dt>Mesure</dt><dd>Y : 0–10 · X : ordinal</dd>
            <dt>H₁ · H₀</dt><dd>plus scolarisé, plus à gauche · aucune relation</dd>
          </dl>
        </div>
      </Deux>
      <p class="lead e">Votre mi-session, c'est la fiche de droite.</p>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">À vous</h2>
      <p class="lead e">Une question de recherche. On remplit la fiche ensemble.</p>
      <div class="fiche pleine e grande">
        <dl>
          <dt>Question</dt><dd>&nbsp;</dd>
          <dt>Y</dt><dd>&nbsp;</dd>
          <dt>X</dt><dd>&nbsp;</dd>
          <dt>Population · unité</dt><dd>&nbsp;</dd>
          <dt>Mesure</dt><dd>&nbsp;</dd>
          <dt>H₁ · H₀</dt><dd>&nbsp;</dd>
        </dl>
      </div>
    </Slide>


    <!-- ================= 5 · AVANT JEUDI PROCHAIN ================= -->
    <Slide fond="encre" droite={D}>
      <h1 class="e">Avant jeudi prochain</h1>
      <hr class="filet" />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Dans cet ordre</h2>
      <Ordre />
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Preuve que ça marche</h2>
      <Deux ratio="1.5fr 1fr">
        <Code src={c_verif} brut />
        <div class="bonus">
          <Grand valeur="+2" legende="points, sur la note finale" />
          <p>Une capture d'écran de ces deux résultats, avant le <strong>jeudi 17 septembre, 23h59</strong>.</p>
        </div>
      </Deux>
    </Slide>

    <Slide droite={D}>
      <h2 class="e">Trois liens</h2>
      <div class="liens e">
        <div><strong>Slack</strong><span>l'invitation arrive par courriel</span></div>
        <div><strong>Datacamp</strong><span>idem · premier devoir en semaine 2</span></div>
        <div><strong>pol2000.com</strong><span>plan, calendrier, diapositives</span></div>
      </div>
      <p class="lead e">Un blocage ? Écrivez <strong>avant</strong> jeudi.</p>
    </Slide>

    <Slide fond="encre" droite={D}>
      <h1 class="e">Jeudi prochain</h1>
      <hr class="filet" />
      <p class="lead e">R et Positron, à partir de zéro.</p>
      <p class="lead e">Apportez l'ordinateur. <strong>Installé.</strong></p>
    </Slide>

  {/snippet}
</Deck>

<style>
  .trois { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.9em; align-items: stretch; }
  .etiqs { display: flex; flex-wrap: wrap; gap: 0.6em; font-size: 1.15em; }
  .pale { color: var(--dk-gris); }
  .centre { text-align: center; max-width: none; }
  :global(.carte-d.accent) { border-color: var(--dk-accent); }
  :global(.carte-d.accent h4) { color: var(--dk-accent); }
  :global(.qs-num li) { font-size: 1.5em; }

  /* Qui suis-je: trois étapes. */
  .frise-moi { display: grid; grid-template-columns: 1fr auto 1fr auto 1fr; gap: 0.8em; align-items: stretch; margin-bottom: 1em; }
  .frise-moi > div:not(.fl) { border: 2px solid var(--dk-filet); padding: 0.7em 0.9em; display: flex; flex-direction: column; gap: 0.2em; }
  .frise-moi .ici { border: 3px solid var(--dk-accent); }
  .frise-moi .an { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .frise-moi strong { font-size: 1.15em; }
  .frise-moi span:last-child { font-size: 0.75em; color: var(--dk-gris); }
  .fl { align-self: center; font-size: 2em; color: var(--dk-accent); }

  /* À main levée: quatre questions, très grandes. */
  .mains { list-style: none; padding: 0; margin: 0; counter-reset: m; display: flex; flex-direction: column; gap: 0.5em; }
  .mains li { counter-increment: m; display: grid; grid-template-columns: 1.4em 1fr; gap: 0.6em; align-items: baseline; font-size: 1.7em; line-height: 1.25; }
  .mains li::before { content: counter(m); color: var(--dk-accent); font-weight: 600; }

  /* Tableau vide. */
  .tableau-vide td:not(:first-child) { text-align: center; color: var(--dk-gris-2); font-weight: 600; font-size: 1.3em; }

  /* Peurs. */
  .peurs { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; }
  .peur { display: flex; flex-direction: column; gap: 0.3em; border: 2px solid var(--dk-encre); padding: 0.7em 0.8em; }
  .glyphe { font-family: var(--dk-mono); font-size: 2.2em; line-height: 1; color: var(--dk-gris-2); margin-bottom: 0.3em; }
  .glyphe.barre { text-decoration: line-through; text-decoration-color: var(--dk-accent); text-decoration-thickness: 4px; }
  .glyphe s { text-decoration-color: var(--dk-accent); text-decoration-thickness: 4px; }
  .glyphe strong { color: var(--dk-accent); }
  .fix { font-size: 1.1em; font-weight: 600; }
  .peur small { font-size: 0.72em; color: var(--dk-gris); }

  /* Quatre pictos. */
  .quatre, .unites { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1em; }
  .quatre > div, .unites > div { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.35em; border: 2px solid var(--dk-encre); padding: 1em 0.6em; }
  .quatre strong, .unites strong { font-size: 1em; }
  .quatre span, .unites span:not(.glyphe-u) { font-size: 0.72em; color: var(--dk-gris); }
  .glyphe-u { font-size: 2.4em; line-height: 1; color: var(--dk-encre); }

  /* Un projet en deux temps. */
  .croissance { display: grid; grid-template-columns: 1fr auto 1.4fr; gap: 1em; align-items: end; }
  .doc { border: 2px solid var(--dk-encre); padding: 0.7em 0.9em; }
  .grand-doc { border: 3px solid var(--dk-accent); }
  .doc .et { display: block; font-size: 0.58em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); margin-bottom: 0.4em; }
  .doc .et.acc { color: var(--dk-accent); }
  .doc ul { margin: 0; padding: 0; list-style: none; }
  .doc li { font-size: 0.85em; line-height: 1.5; }
  .doc li.plus { color: var(--dk-accent); font-weight: 600; }

  /* Datacamp: quatorze semaines. */
  .dc .semaines { display: flex; gap: 0.35em; }
  .dc .semaines i { flex: 1; height: 1.4em; background: var(--dk-gris-2); }
  .dc .semaines i.jalon { background: var(--dk-accent); }
  .dc .jalons { display: flex; justify-content: space-between; font-size: 0.65em; color: var(--dk-accent); font-weight: 600; margin: 0.25em 0 0.6em; padding-left: 47%; }
  .dc p { font-size: 0.95em; }

  /* IA: trois feux. */
  .feux { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; margin-bottom: 0.8em; }
  .feu { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.2em; padding: 0.9em 0.6em; border: 2px solid var(--dk-encre); }
  .feu .signe { font-family: var(--dk-mono); font-size: 3em; line-height: 1; font-weight: 600; }
  .feu.ok .signe { color: var(--dk-encre); }
  .feu.non { border-color: var(--dk-accent); border-width: 3px; }
  .feu.non .signe { color: var(--dk-accent); }
  .feu.selon .signe { color: var(--dk-gris); }
  .feu small { font-size: 0.72em; color: var(--dk-gris); }

  /* Matériel. */
  .materiel { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1em; }
  .item { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.4em; border: 2px solid var(--dk-encre); padding: 1em 0.6em; justify-content: flex-end; }
  .grosR { font-family: var(--dk-mono); font-size: 3.4em; line-height: 1; font-weight: 600; color: var(--dk-accent); }
  .grosP { font-family: var(--dk-mono); font-size: 1.4em; line-height: 1; font-weight: 600; padding: 0.5em 0.4em; border: 3px solid var(--dk-encre); }
  .couv { display: flex; align-items: center; justify-content: center; text-align: center; width: 4.2em; height: 5.4em; border: 3px solid var(--dk-encre); font-size: 0.62em; font-weight: 600; line-height: 1.3; }
  .item small { font-size: 0.68em; color: var(--dk-gris); }
  .item strong { font-size: 0.9em; }

  /* Deux grands, sur encre. */
  .deuxgrands { display: grid; grid-template-columns: 1fr 1fr; gap: 2em; }
  .deuxgrands > div { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.3em; }
  .deuxgrands .signe { font-family: var(--dk-mono); font-size: 5em; line-height: 1; font-weight: 600; color: var(--dk-accent-clair); }
  .deuxgrands .signe.non { color: var(--dk-accent); }
  .deuxgrands strong { font-size: 1.8em; }
  .deuxgrands small { font-size: 0.85em; opacity: 0.8; }

  /* X → Y. */
  .xy { display: grid; grid-template-columns: 1fr auto 1fr; gap: 1.2em; align-items: center; margin: 0.6em 0 1em; }
  .xy > div:not(.fl) { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.15em; border: 3px solid var(--dk-encre); padding: 1em; }
  .xy .y { border-color: var(--dk-accent); }
  .xy .lettre { font-family: var(--dk-mono); font-size: 5em; line-height: 1; font-weight: 600; }
  .xy .y .lettre { color: var(--dk-accent); }
  .xy strong { font-size: 1.2em; }
  .xy small { font-size: 0.75em; color: var(--dk-gris); }
  .xy em { font-size: 0.85em; color: var(--dk-accent); font-style: normal; font-weight: 600; margin-top: 0.3em; }
  .xy .fl { font-size: 4em; }

  /* Chaîne concept → mesure. */
  .chaine { display: grid; grid-template-columns: 1fr auto 1fr auto 1fr; gap: 0.6em; align-items: stretch; margin: 0.6em 0 0.9em; }
  .chaine > div:not(.fl) { border: 2px solid var(--dk-filet); padding: 0.7em 0.9em; display: flex; flex-direction: column; gap: 0.35em; }
  .chaine > div:last-child { border-color: var(--dk-accent); border-width: 3px; }
  .chaine .et { font-size: 0.58em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .chaine strong { font-size: 1.05em; }
  .chaine .fl { font-size: 1.8em; }

  /* La fiche. */
  .fiche { border: 2px solid var(--dk-filet); padding: 0.8em 1em; }
  .fiche.pleine { border: 3px solid var(--dk-accent); }
  .fiche dl { display: grid; grid-template-columns: auto 1fr; gap: 0.35em 1em; margin: 0; font-size: 0.85em; }
  .fiche dt { color: var(--dk-gris); font-weight: 600; white-space: nowrap; }
  .fiche dd { margin: 0; }
  .fiche.vide dd { color: var(--dk-gris-2); }
  .fiche.grande dl { font-size: 1.05em; gap: 0.7em 1.2em; }
  .fiche.grande dd { border-bottom: 2px dotted var(--dk-filet); min-height: 1.4em; }

  /* Bonus. */
  .bonus { display: flex; flex-direction: column; gap: 0.6em; justify-content: center; }
  .bonus p { font-size: 0.9em; margin: 0; }

  /* Trois liens. */
  .liens { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; margin-bottom: 1em; }
  .liens > div { border: 2px solid var(--dk-encre); padding: 1em 0.9em; display: flex; flex-direction: column; gap: 0.25em; }
  .liens strong { font-size: 1.3em; }
  .liens span { font-size: 0.75em; color: var(--dk-gris); }
</style>
