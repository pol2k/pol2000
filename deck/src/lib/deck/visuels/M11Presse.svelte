<script>
  /**
   * Les manchettes, avant l'article (séance 11). Les vraies pages, telles
   * que le professeur les a imprimées ou capturées le 18 novembre 2026, dans
   * la même visionneuse que l'article (M8Article) : d'abord la manchette,
   * puis on descend et on zoome sur le chiffre, puis sur ce qui est dit de
   * l'étude. Pas de chronologie : le professeur ne veut pas d'argument
   * sur les dates de parution.
   *
   *   qui  'lapresse'  La Presse, 18 février 2025;
   *        'lettre'    Le Devoir, lettre d'une lectrice, 18 juin 2025;
   *        'radcan'    Radio-Canada (L'épicerie), 8 octobre 2025 : deux
   *                    captures en mode sombre, mots repérés par OCR;
   *        'devoir'    Le Devoir, éditorial, 14 octobre 2025.
   *
   * Pages et mots : outils/seance11_article.py. Chaque passage est le texte
   * exact de la page (article.js le retrouve, sinon la page échoue).
   */
  import M8Article from './M8Article.svelte';
  import * as LP from '$lib/data/seance11_lapresse.js';
  import * as LE from '$lib/data/seance11_lettre.js';
  import * as RC from '$lib/data/seance11_radcan.js';
  import * as DE from '$lib/data/seance11_devoir.js';

  let { qui = 'lapresse' } = $props();

  const DOCS = {
    lapresse: {
      d: LP, nom: 'La Presse', source: 'La Presse, 18 février 2025, « Insécurité alimentaire au cégep : près d’un élève sur deux touché »',
      etats: [
        { vue: 'page', passages: [{ phrase: 'Près d’un élève sur deux touché' }] },
        { passages: [
          { phrase: 'Au cégep, plus de 4 élèves sur 10 vivent une forme d’insécurité alimentaire' }
        ] },
        { passages: [{ phrase: 'près de 44 % des élèves des cégeps vivraient une forme d’insécurité alimentaire, qu’elle soit grave, modérée ou légère.' }] },
        { passages: [{ phrase: 'Les chercheurs ont utilisé le même instrument de mesure que celui dont se sert Statistique Canada pour mesurer l’insécurité alimentaire des ménages.' }] },
        { passages: [
          { phrase: 'Près de 13 % ont signalé une insécurité alimentaire grave' },
          { phrase: 'Parmi les répondants, 8 % ont répondu vivre une insécurité alimentaire modérée' },
          { phrase: 'Enfin, 23 % ont rapporté avoir craint de manquer de nourriture' }
        ], focus: 1 },
        { passages: [{ phrase: 'D’où l’importance, arguent les chercheurs, d’avoir des solutions adaptées aux besoins particuliers de chaque groupe.' }] }
      ]
    },
    lettre: {
      d: LE, nom: 'Le Devoir', source: 'Le Devoir, 18 juin 2025, lettre « Faim et compressions : le mépris de la CAQ envers les étudiants »',
      etats: [
        { vue: 'page', passages: [{ phrase: 'Faim et compressions: le mépris de la CAQ', ton: 'encre' }, { phrase: 'Retirer 150 millions de dollars des budgets des cégeps du Québec.', ton: 'encre' }] },
        { passages: [
          { phrase: 'près d’un cégépien sur deux (44 % des étudiants interrogés) vit une forme d’insécurité alimentaire.', ton: 'encre' },
          { phrase: 'Cela signifie qu’un étudiant sur deux doute de pouvoir manger à sa faim chaque jour' }
        ], focus: 1 }
      ]
    },
    radcan: {
      d: RC, nom: 'Radio-Canada', sombre: true, source: 'Radio-Canada (L’épicerie), 8 octobre 2025, « De plus en plus d’étudiants ont le ventre vide »',
      etats: [
        { vue: 'page', passages: [{ phrase: 'De plus en plus d’étudiants ont le ventre vide' }] },
        { passages: [{ phrase: 'Une vaste étude menée par François Régimbal', ton: 'encre' }, { phrase: 'révèle que l\'insécurité alimentaire touche entre 40 % et 60 % des cégépiens du Québec.' }], focus: 1 },
        { passages: [{ phrase: 'Ce sont des personnes qui ont faim' }] }
      ]
    },
    devoir: {
      d: DE, nom: 'Le Devoir', source: 'Le Devoir, 14 octobre 2025, éditorial « Les ventres vides au cégep »',
      etats: [
        { vue: 'page', passages: [{ phrase: 'Les ventres vides au cégep' }] },
        { passages: [{ phrase: 'près d’un jeune Québécois sur deux vogue au cégep le ventre vide' }] }
      ]
    }
  };
  const doc = DOCS[qui];
</script>

{#snippet source()}{doc.source}{/snippet}

<M8Article etats={doc.etats} pages={doc.d.PAGES} mots={doc.d.MOTS} premiere={1} nom={doc.nom} sombre={doc.sombre} rail={false} {source}>
  {#snippet note(e)}
    {#if qui === 'lapresse'}
      {#if e === 0}
        <span class="m11p-eti">La Presse</span>
        <p class="m11p-grand">«&#8239;Près d’un élève sur deux touché&#8239;»</p>
      {:else if e === 1}
        <span class="m11p-eti">Le titre et le texte</span>
        <p class="m11p-ligne"><strong>«&#8239;près d’un sur deux&#8239;»</strong><span>dans le titre</span></p>
        <p class="m11p-ligne"><strong>«&#8239;plus de 4 sur 10&#8239;»</strong><span>dans le texte</span></p>
      {:else if e === 2}
        <span class="m11p-eti">Le chiffre</span>
        <p class="m11p-grand">44&#8239;%, catégorie «&#8239;légère&#8239;» incluse</p>
      {:else if e === 3}
        <span class="m11p-eti">L’instrument</span>
        <p class="m11p-grand">Statistique Canada pose 18 questions. L’étude en a posé 6.</p>
      {:else if e === 4}
        <span class="m11p-eti">Les catégories</span>
        <p class="m11p-ligne"><strong>13 + 8 + 23</strong><span>dans La Presse</span></p>
        <p class="m11p-ligne"><strong>12,5 + 15,2 + 16,2</strong><span>dans l’article</span></p>
        <p class="m11p-gris">Même total, catégories différentes.</p>
      {:else}
        <span class="m11p-eti">La recommandation</span>
        <p class="m11p-grand">Des solutions adaptées à chaque groupe</p>
        <p class="m11p-gris">Dans l’article&#8239;: les interventions «&#8239;n’ont pas à cibler spécifiquement certains groupes&#8239;».</p>
      {/if}
    {:else if qui === 'lettre'}
      {#if e === 0}
        <span class="m11p-eti">Le Devoir · lettre</span>
        <p class="m11p-grand">Le chiffre sert à argumenter contre des compressions de 150 M$.</p>
      {:else}
        <span class="m11p-eti">La reformulation</span>
        <p class="m11p-ligne"><strong>«&#8239;une forme d’insécurité alimentaire&#8239;»</strong><span>devient</span></p>
        <p class="m11p-ligne"><strong>«&#8239;doute de pouvoir manger à sa faim chaque jour&#8239;»</strong></p>
      {/if}
    {:else if qui === 'radcan'}
      {#if e === 0}
        <span class="m11p-eti">Radio-Canada</span>
        <p class="m11p-grand">«&#8239;De plus en plus d’étudiants ont le ventre vide&#8239;»</p>
      {:else if e === 1}
        <span class="m11p-eti">Le chiffre</span>
        <p class="m11p-grand">«&#8239;Entre 40&#8239;% et 60&#8239;%&#8239;»</p>
        <p class="m11p-gris">Dans l’article&#8239;: 43,9&#8239;% en tout, de 34&#8239;% à 58&#8239;% selon le cégep.</p>
      {:else}
        <span class="m11p-eti">Le chercheur, cité</span>
        <p class="m11p-grand">«&#8239;Des personnes qui ont faim&#8239;»</p>
        <p class="m11p-gris">Le 43,9&#8239;% inclut un seul «&#8239;parfois&#8239;» à la question sur les repas équilibrés.</p>
      {/if}
    {:else}
      {#if e === 0}
        <span class="m11p-eti">Le Devoir · éditorial</span>
        <p class="m11p-grand">«&#8239;Les ventres vides au cégep&#8239;»</p>
      {:else}
        <span class="m11p-eti">La reformulation</span>
        <p class="m11p-grand">«&#8239;Près d’un jeune Québécois sur deux vogue au cégep le ventre vide.&#8239;»</p>
      {/if}
    {/if}
  {/snippet}
</M8Article>

<style>
  .m11p-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m11p-grand { margin: 0; font-size: 1.3em; font-weight: 700; line-height: 1.3; }
  .m11p-gris { margin: 0; font-size: 0.9em; color: var(--dk-gris); line-height: 1.4; }
  .m11p-ligne { margin: 0; display: flex; flex-direction: column; font-size: 0.95em; }
  .m11p-ligne strong { font-size: 1.3em; }
  .m11p-ligne span { color: var(--dk-gris); font-size: 0.85em; }
</style>
