<script>
  /**
   * Les sept évaluations: la barre des cent points d'abord (encre pour les
   * examens, rouge pour les travaux, gris pour Datacamp — comme sur la
   * diapositive 16), puis la liste datée, avec l'état d'après la date.
   */
  import { EVALUATIONS, LIENS } from '$lib/data/cours.js';
  import { aujourdhui, moyenne, statut } from './dates.js';

  let ref = $state(aujourdhui());
  $effect(() => { ref = aujourdhui(); });
  const ETATS = { passe: 'Passé', encours: 'En cours', avenir: 'À venir' };
  const GROUPES = { ex: 'Examens', tr: 'Travaux', dc: 'Datacamp' };
</script>

<div class="evals">
  <div class="barre" role="img" aria-label="Pondération : trois examens de 15 %, un travail de mi-session de 20 %, un travail final de 25 %, deux volets Datacamp de 5 %.">
    {#each EVALUATIONS as e}
      <div class="part {e.groupe}" style="flex: {e.poids}"><span>{e.court}</span><strong>{e.poids} %</strong></div>
    {/each}
  </div>
  <div class="legende">
    <span><i class="ex"></i>{GROUPES.ex} · 45 %</span>
    <span><i class="tr"></i>{GROUPES.tr} · 45 %</span>
    <span><i class="dc"></i>{GROUPES.dc} · 10 %</span>
  </div>

  <ol class="liste">
    {#each EVALUATIONS as e}
      {@const s = statut(e, ref)}
      <li id="eval-{e.id}" class="{s} {e.groupe}">
        <div class="quand">
          <span class="date">{moyenne(e.date)}</span>
          <span class="heure">{e.heure}</span>
        </div>
        <div class="corps">
          <h3>{e.nom}</h3>
          <p class="mode">{e.mode}{#if e.ouvre}{' · ouvre le '}{moyenne(e.ouvre)}{/if}</p>
        </div>
        <div class="droite">
          <span class="poids">{e.poids} %</span>
          <span class="etiq" class:gris={s !== 'encours'} class:encre={s === 'passe'}>{ETATS[s]}</span>
        </div>
      </li>
    {/each}
  </ol>

  <div class="regles">
    <div class="cadre">
      <span class="etiq">Un retard</span>
      <p><strong>10 % par jour</strong> de la note obtenue. Après trois jours, 0.</p>
    </div>
    <div class="cadre">
      <span class="etiq">Les examens 2 et 3</span>
      <p>Sur papier, en classe, à livre ouvert : vos notes, oui. Un appareil, non.</p>
    </div>
    <div class="cadre">
      <span class="etiq">Consignes</span>
      <p>Les consignes des travaux sont déposées sur le site de cours après la séance 4.{#if !LIENS.monportail} <span class="gris">Lien monPortail à venir.</span>{:else} <a href={LIENS.monportail}>monPortail →</a>{/if}</p>
    </div>
  </div>
</div>

<style>
  .evals { display: flex; flex-direction: column; gap: 0.7rem; }
  .barre { display: flex; gap: 3px; }
  .part { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.1rem; padding: 0.7rem 0.2rem; min-width: 0; color: var(--fond); }
  .part span { font-size: 0.58rem; letter-spacing: 0.12em; text-transform: uppercase; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 100%; }
  .part strong { font-size: 1.05rem; }
  .part.ex { background: var(--encre); }
  .part.tr { background: var(--accent); }
  .part.dc { background: var(--gris); }
  .part.dc span { display: none; }
  .legende { display: flex; gap: 1.6rem; font-size: 0.66rem; letter-spacing: 0.08em; color: var(--gris); flex-wrap: wrap; }
  .legende i { display: inline-block; width: 1.6em; height: 0.45em; vertical-align: middle; margin-right: 0.4em; }
  .legende .ex { background: var(--encre); } .legende .tr { background: var(--accent); } .legende .dc { background: var(--gris); }

  .liste { list-style: none; margin: 1.2rem 0 0; padding: 0; border-top: var(--trait); }
  .liste li { display: grid; grid-template-columns: 8.5rem minmax(0, 1fr) auto; gap: 1.2rem; align-items: center; padding: 1rem 0.4rem; border-bottom: var(--trait-fin); scroll-margin-top: 4.5rem; }
  .liste li:hover { background: var(--fond-2); }
  .quand { display: flex; flex-direction: column; line-height: 1.3; }
  .date { font-weight: 600; font-size: 0.95rem; }
  .heure { font-size: 0.7rem; color: var(--gris); }
  li.passe .date { color: var(--gris-2); text-decoration: line-through; text-decoration-color: var(--accent); }
  li.encours .date { color: var(--accent); }
  h3 { font-size: 1rem; line-height: 1.25; font-weight: 600; }
  li.passe h3 { color: var(--gris); }
  .mode { font-size: 0.78rem; color: var(--gris); margin-top: 0.15rem; }
  .droite { display: flex; align-items: center; gap: 1.2rem; }
  .poids { font-size: 1.3rem; font-weight: 600; letter-spacing: -0.03em; min-width: 3.2rem; text-align: right; }
  li.ex .poids { color: var(--encre); } li.tr .poids { color: var(--accent); } li.dc .poids { color: var(--gris); }
  .regles { display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.8rem; margin-top: 1.4rem; }
  .regles .cadre { display: flex; flex-direction: column; gap: 0.5rem; }
  .regles p { font-size: 0.86rem; line-height: 1.45; }
  @media (max-width: 46rem) {
    .liste li { grid-template-columns: minmax(0, 1fr) auto; gap: 0.6rem 1rem; }
    .quand { grid-column: 1 / -1; flex-direction: row; gap: 0.6rem; align-items: baseline; }
    .droite { flex-direction: column; align-items: flex-end; gap: 0.3rem; }
    .poids { min-width: 0; }
    .regles { grid-template-columns: 1fr; }
  }
</style>
