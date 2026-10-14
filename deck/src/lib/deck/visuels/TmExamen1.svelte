<script>
  /**
   * Retour sur l'examen 1 : où en est la correction. Le prof en parle, la
   * diapo ne montre que le cadre : le poids et la date de remise (cours.js,
   * EVALUATIONS, id 'examen1'), puis les auxiliaires qui corrigent
   * (cours.js, EQUIPE, rôle « Auxiliaire »), avec leur photo. Aucune note,
   * aucune moyenne : le dépôt est public.
   *
   * Pas de clic : la diapo est là pendant qu'on parle.
   */
  import { base } from '$app/paths';
  import { EQUIPE, EVALUATIONS } from '$lib/data/cours.js';
  const ex = EVALUATIONS.find((v) => v.id === 'examen1');
  const aux = EQUIPE.filter((p) => p.role === 'Auxiliaire');
  const jour = (iso) => new Date(iso + 'T12:00:00').toLocaleDateString('fr-CA', { day: 'numeric', month: 'long' });
</script>

<div class="visuel tm-ex1">
  <div class="tm-ex1-bande">
    <span class="tm-ex1-poids">{ex.poids}&#8239;%</span>
    <span class="tm-ex1-nom">{ex.court} · remis le {jour(ex.date)}</span>
    <span class="tm-ex1-corr">la correction</span>
  </div>
  <div class="tm-ex1-aux">
    {#each aux as p, i}
      <figure style="animation-delay: {0.2 + i * 0.15}s">
        <img src="{base}/img/{p.photo}" alt={p.nom} />
        <figcaption><strong>{p.nom}</strong><span>{p.role.toLowerCase()} · corrige</span></figcaption>
      </figure>
    {/each}
  </div>
</div>

<style>
  .tm-ex1 { display: flex; flex-direction: column; gap: 2em; max-width: 52em; margin: 0 auto; width: 100%; }
  .tm-ex1-bande { display: flex; align-items: baseline; gap: 1.2em; border-bottom: 3px solid var(--dk-encre); padding-bottom: 0.45em; animation: tm-ex1-f 0.5s both; }
  .tm-ex1-poids { font-size: 2.4em; font-weight: 600; line-height: 1; color: var(--dk-accent); }
  .tm-ex1-nom { font-size: 1.05em; font-weight: 600; }
  .tm-ex1-corr { margin-left: auto; font-size: 0.85em; font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase; color: var(--dk-fond); background: var(--dk-encre); padding: 0.2em 0.6em; }
  .tm-ex1-aux { display: flex; justify-content: center; gap: 4em; }
  figure { margin: 0; display: flex; flex-direction: column; align-items: center; gap: 0.8em; animation: tm-ex1-f 0.5s both; }
  img { width: 9em; height: 9em; object-fit: cover; border: 3px solid var(--dk-encre); filter: grayscale(1); }
  figcaption { display: flex; flex-direction: column; align-items: center; gap: 0.2em; }
  figcaption strong { font-size: 1.05em; }
  figcaption span { font-size: 0.8em; color: var(--dk-gris); letter-spacing: 0.06em; }
  @keyframes tm-ex1-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-ex1-bande, figure { animation: none; }
  }
</style>
