<script>
  /**
   * L'article du début de la séance 11, lu comme on a lu Blais et Gélineau
   * à la séance 8 : la vraie page, le passage surligné là où il est
   * imprimé, une carte par-dessus (M8Article, réutilisé avec d'autres
   * pages). Cette fois, on cherche les signes d'une étude qui ne tient pas.
   *
   *   partie 'a'     Richard et Régimbal (2026), p. 71-77 : le chiffre, qui
   *                  a choisi les cégeps, qui a choisi les étudiants, à quoi
   *                  ressemble l'échantillon, l'écart entre cégeps,
   *                  l'instrument et le tableau 2;
   *          'usda'  le mode d'emploi de l'instrument (USDA ERS 2024,
   *                  Six-Item Short Form, p. 2-4) : la question des repas
   *                  équilibrés, puis la règle de classement;
   *          'b'     Richard et Régimbal, p. 77-83 : la comparaison avec
   *                  le Québec, « influence », aucun contrôle, vingt tests,
   *                  et « pas significatif » lu comme « pas de différence ».
   *
   * Chaque passage est le texte exact du document (article.js le retrouve;
   * un passage absent fait échouer la page). Pages et mots :
   * outils/seance11_article.py. L'article est sous licence CC BY-NC-ND 4.0;
   * les pages sont montrées telles quelles, avec leur référence.
   */
  import M8Article from './M8Article.svelte';
  import { PAGES as PA, MOTS as MA } from '$lib/data/seance11_article.js';
  import { PAGES as PU, MOTS as MU } from '$lib/data/seance11_usda.js';

  let { partie = 'a' } = $props();

  const A = [
    { vue: 'page', passages: [{ phrase: 'L’insécurité alimentaire chez les cégépiens', ton: 'encre' }, { phrase: 'les analyses montrent que 43,9 % des participants vivent une forme d’insécurité alimentaire' }] },
    { passages: [{ phrase: 'les analyses montrent que 43,9 % des participants vivent une forme d’insécurité alimentaire' }] },
    { passages: [{ phrase: 'Le choix des collèges s’est fait en fonction de leur situation géographique (milieux urbains et semi-urbains et régions éloignées des centres urbains) et de l’intérêt des directions de collège à participer à la recherche.', tag: '1' }] },
    { passages: [
      { phrase: 'Tous les étudiants inscrits dans l’un des collèges participants ont été invités par le biais de la plateforme pédagogique de leur établissement à répondre au questionnaire sur la plateforme Survey Monkey.', ton: 'encre' },
      { phrase: 'Il s’agit d’un échantillon de volontaires.', tag: '2' }
    ], focus: 1 },
    { passages: [{ phrase: 'Féminin 69,0', tag: '3' }] },
    { passages: [{ phrase: 'Les taux d’insécurité alimentaire varient entre 34,0 % et 57,9 % dans les six établissements à l’étude.', tag: '4' }] },
    { passages: [{ phrase: 'Nous avons eu recours à la version abrégée de six items', tag: '5' }] },
    { passages: [{ phrase: '1 Insécurité alimentaire marginale 16,2 %', tag: '5' }] }
  ];

  const U = [
    { passages: [{ phrase: '“(I/we) couldn’t afford to eat balanced meals.”' }] },
    { passages: [
      { phrase: 'Raw score 0-1—High or marginal food security' },
      { phrase: 'the food security status of households with raw score 0-1 is described as food secure', ton: 'encre' }
    ] }
  ];

  const B = [
    { passages: [{ phrase: 'Une part importante des populations étudiantes cégépiennes québécoises, nettement plus grande que celle de la population générale québécoise (15,7 %), apparaît donc comme vulnérable sur le plan alimentaire', tag: '6' }] },
    { passages: [{ phrase: 'Enfin, les résultats sur le sentiment d’auto-efficacité et sur la satisfaction dans les études montrent que l’insécurité alimentaire influence ces deux variables', tag: '7' }] },
    { passages: [
      { phrase: 'Les tests utilisés sont le test du khi-carré lorsque les variables sont catégorisées, et le t de Student et l’analyse de variance univariée (ANOVA) lorsqu’il s’agit de variables continues.', ton: 'encre' },
      { phrase: 'Ainsi, nous avons analysé les interactions séparément pour chacune des caractéristiques démographiques et la variable de l’insécurité alimentaire.', tag: '7' }
    ], focus: 1 },
    { passages: [
      { phrase: 'Deux interactions sont significatives.', tag: '8' },
      { phrase: 'il apparaît évident que l’Aide financière aux études gagnerait à prendre en compte les indicateurs d’insécurité alimentaire' }
    ] },
    { passages: [{ phrase: 'nos résultats suggèrent également que la réponse et les interventions liées à l’insécurité alimentaire dans les établissements d’enseignement supérieur peuvent être destinées à tous les étudiants et n’ont pas à cibler spécifiquement certains groupes', tag: '9' }] }
  ];

  const usda = partie === 'usda';
  const etats = partie === 'a' ? A : usda ? U : B;
</script>

{#snippet source(p)}
  {#if usda}USDA ERS (2024), <em lang="en">U.S. Household Food Security Survey Module: Six-Item Short Form</em>, p. {p}{:else}Richard et Régimbal (2026), <em>Revue canadienne d’enseignement supérieur</em>, 56(1), p. {p} · CC BY-NC-ND 4.0{/if}
{/snippet}

<M8Article {etats} pages={usda ? PU : PA} mots={usda ? MU : MA} premiere={usda ? 2 : 71} nom={usda ? 'USDA ERS (2024)' : 'Richard et Régimbal (2026)'} {source}>
  {#snippet note(e)}
    {#if partie === 'a'}
      {#if e === 0}
        <span class="m11a-eti">L’article</span>
        <p class="m11a-ref">Richard, É., et Régimbal, F. (2026). L’insécurité alimentaire chez les cégépiens. <em>Revue canadienne d’enseignement supérieur</em>, <em>56</em>(1), 71-92.</p>
        <p class="m11a-gris">Revue avec comité de lecture.</p>
      {:else if e === 1}
        <span class="m11a-eti">Le chiffre repris par les médias</span>
        <p class="m11a-grand">43,9&#8239;%</p>
      {:else if e === 2}
        <span class="m11a-eti">Signe 1 · Le choix des cégeps</span>
        <p class="m11a-grand">Six cégeps sur 48, choisis selon l’intérêt de leur direction</p>
      {:else if e === 3}
        <span class="m11a-eti">Signe 2 · Le choix des étudiants</span>
        <p class="m11a-grand">Des volontaires</p>
        <p class="m11a-gris">Aucun taux de réponse n’est rapporté.</p>
      {:else if e === 4}
        <span class="m11a-eti">Signe 3 · La composition de l’échantillon</span>
        <p class="m11a-grand">69&#8239;% de femmes</p>
        <p class="m11a-gris">Aucune comparaison avec la population des cégeps, aucune pondération.</p>
      {:else if e === 5}
        <span class="m11a-eti">Signe 4 · Les écarts entre cégeps</span>
        <p class="m11a-grand">De 34&#8239;% à 58&#8239;% selon le cégep</p>
        <p class="m11a-gris">Le total dépend des cégeps retenus.</p>
      {:else if e === 6}
        <span class="m11a-eti">Signe 5 · L’instrument</span>
        <p class="m11a-grand">La version abrégée en six questions du USDA</p>
      {:else}
        <span class="m11a-eti">Signe 5 · L’instrument</span>
        <p class="m11a-grand">Un score de 1 classé «&#8239;insécurité marginale&#8239;»</p>
        <p class="m11a-gris">16,2&#8239;% des répondants, inclus dans le 43,9&#8239;%.</p>
      {/if}
    {:else if usda}
      {#if e === 0}
        <span class="m11a-eti">Le mode d’emploi · une des six questions</span>
        <p class="m11a-grand">«&#8239;Je n’avais pas les moyens de manger des repas équilibrés.&#8239;»</p>
        <p class="m11a-gris">Répondre «&#8239;parfois&#8239;» donne un score de 1.</p>
      {:else}
        <span class="m11a-eti">Le mode d’emploi · la règle de classement</span>
        <p class="m11a-grand">Score 0 ou 1&#8239;: sécurité alimentaire</p>
        <p class="m11a-gris">L’insécurité commence à 2.</p>
      {/if}
    {:else}
      {#if e === 0}
        <span class="m11a-eti">Signe 6 · La comparaison</span>
        <p class="m11a-ligne"><strong>15,7&#8239;%</strong><span>Statistique Canada&#8239;: 18 questions, des ménages, un échantillon représentatif</span></p>
        <p class="m11a-ligne"><strong class="m11a-r">43,9&#8239;%</strong><span>6 questions, un classement maison, des volontaires</span></p>
      {:else if e === 1}
        <span class="m11a-eti">Signe 7 · Le vocabulaire causal</span>
        <p class="m11a-grand">«&#8239;influence&#8239;»</p>
        <p class="m11a-gris">Un sondage à un seul moment montre un lien, pas un effet.</p>
      {:else if e === 2}
        <span class="m11a-eti">Signe 7 · Le vocabulaire causal</span>
        <p class="m11a-grand">Aucune variable de contrôle</p>
        <p class="m11a-gris">Chaque variable est testée seule. Une régression multiple, comme à la séance 8, les aurait incluses ensemble.</p>
      {:else if e === 3}
        <span class="m11a-eti">Signe 8 · Les tests multiples</span>
        <p class="m11a-grand">20 tests, 2 sous 0,05</p>
        <p class="m11a-gris">Au seuil de 5&#8239;%, on en attend environ 1 par hasard. La recommandation sur l’aide financière repose sur l’un d’eux (p = 0,022).</p>
      {:else}
        <span class="m11a-eti">Signe 9 · L’absence de résultat</span>
        <p class="m11a-grand">Non significatif ≠ aucune différence</p>
      {/if}
    {/if}
  {/snippet}
</M8Article>

<style>
  .m11a-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m11a-ref { margin: 0; font-size: 0.9em; line-height: 1.45; }
  .m11a-grand { margin: 0; font-size: 1.35em; font-weight: 700; line-height: 1.3; }
  .m11a-gris { margin: 0; font-size: 0.9em; color: var(--dk-gris); line-height: 1.4; }
  .m11a-ligne { margin: 0; display: grid; grid-template-columns: 4.2em 1fr; gap: 0.6em; align-items: baseline; font-size: 0.9em; }
  .m11a-ligne strong { font-size: 1.4em; }
  .m11a-r { color: var(--dk-accent); }
</style>
