<script>
  /**
   * Le travail de mi-session, tel que le plan de cours le décrit, et rien de
   * plus : les consignes détaillées ne sont pas encore écrites. En haut, le
   * poids, la date et le mode (EVALUATIONS, id 'misession', dans cours.js,
   * comme sur le site). En dessous, les sept éléments de la liste du plan de
   * cours, en étiquettes courtes. Le troisième (l'hypothèse et son
   * hypothèse nulle) est ce qu'on a vu aujourd'hui : cadre rouge.
   * Pas de temps.
   */
  import { EVALUATIONS } from '$lib/data/cours.js';
  const ms = EVALUATIONS.find((v) => v.id === 'misession');
  const jour = (iso) => new Date(iso + 'T12:00:00').toLocaleDateString('fr-CA', { weekday: 'long', day: 'numeric', month: 'long' });
  const ELEMENTS = [
    'Une question de recherche : VD et VI',
    'Une courte revue de la littérature',
    'Une hypothèse et son hypothèse nulle',
    'La base de données et les variables',
    'La pertinence et l’originalité',
    'La contribution à la littérature',
    'Une justification personnelle'
  ];
  const AUJOURDHUI = 2;
</script>

<div class="visuel mi-session">
  <div class="ms-bande">
    <span class="ms-poids">{ms.poids}&#8239;%</span>
    <span class="ms-date">à remettre {jour(ms.date)}, {ms.heure}</span>
    <span class="ms-mode">individuel · PDF</span>
  </div>
  <ol class="ms-tuiles">
    {#each ELEMENTS as el, i}
      <li class="ms-tuile" class:ms-ici={i === AUJOURDHUI} style="animation-delay: {0.1 + i * 0.07}s">
        <span class="ms-num">{i + 1}</span>
        <span class="ms-lab">{el}</span>
        {#if i === AUJOURDHUI}<span class="ms-tag">aujourd’hui</span>{/if}
      </li>
    {/each}
  </ol>
  <p class="ms-note">Une version courte du travail final, comme un devis de recherche.</p>
</div>

<style>
  .mi-session { max-width: 58em; margin: 0 auto; display: flex; flex-direction: column; gap: 1em; }
  .ms-bande { display: flex; align-items: baseline; gap: 1.4em; border-bottom: 3px solid var(--dk-encre); padding-bottom: 0.5em; animation: ms-fondu 0.5s both; }
  .ms-poids { font-size: 2.4em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  .ms-date { font-size: 1em; font-weight: 600; }
  .ms-mode { margin-left: auto; font-size: 0.8em; color: var(--dk-gris); letter-spacing: 0.06em; }

  .ms-tuiles { list-style: none; margin: 0; padding: 0; display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.8em; }
  .ms-tuile { position: relative; display: flex; flex-direction: column; gap: 0.35em; border: 2px solid var(--dk-encre); padding: 0.7em 0.8em 0.8em; animation: ms-fondu 0.5s both; }
  .ms-ici { border: 4px solid var(--dk-accent); padding: 0.6em 0.7em 0.7em; }
  .ms-num { font-size: 1.5em; font-weight: 600; line-height: 1; color: var(--dk-gris); }
  .ms-ici .ms-num { color: var(--dk-accent); }
  .ms-lab { font-size: 0.8em; line-height: 1.35; }
  .ms-tag { position: absolute; top: -0.8em; right: 0.6em; background: var(--dk-accent); color: var(--dk-fond); font-size: 0.62em; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; padding: 0.15em 0.5em; }
  .ms-note { margin: 0; font-size: 0.8em; color: var(--dk-gris); animation: ms-fondu 0.5s 0.7s both; }

  @keyframes ms-fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .ms-bande, .ms-tuile, .ms-note { animation: none; }
  }
</style>
