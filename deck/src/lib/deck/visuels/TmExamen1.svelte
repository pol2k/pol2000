<script>
  /**
   * Retour sur l'examen 1 : où en est la correction. Le prof en parle, la
   * diapo ne montre que le cadre : le poids et la date de remise (cours.js,
   * EVALUATIONS, id 'examen1'), puis les auxiliaires qui corrigent
   * (cours.js, EQUIPE, rôle « Auxiliaire »), avec leur photo. Aucune note,
   * aucune moyenne : le dépôt est public.
   *
   * L'état de chaque correction est donné par le prof (15 octobre) :
   * Marc-Antoine a fini (un crochet vert), Jules est encore dessus. Pour
   * Jules, une barre de chargement qui file jusqu'à 99 % et s'y bloque,
   * comme toutes les barres de chargement du monde.
   *
   * Pas de clic : la diapo est là pendant qu'on parle.
   */
  import { base } from '$app/paths';
  import { EQUIPE, EVALUATIONS } from '$lib/data/cours.js';
  const ex = EVALUATIONS.find((v) => v.id === 'examen1');
  const aux = EQUIPE.filter((p) => p.role === 'Auxiliaire');
  const jour = (iso) => new Date(iso + 'T12:00:00').toLocaleDateString('fr-CA', { day: 'numeric', month: 'long' });
  // Qui a fini. Les autres sont « en cours ».
  const FINI = ['Marc-Antoine Dupuis'];
</script>

<div class="visuel tm-ex1">
  <div class="tm-ex1-bande">
    <span class="tm-ex1-poids">{ex.poids}&#8239;%</span>
    <span class="tm-ex1-nom">{ex.court} · remis le {jour(ex.date)}</span>
    <span class="tm-ex1-corr">la correction</span>
  </div>
  <div class="tm-ex1-aux">
    {#each aux as p, i}
      {@const fini = FINI.includes(p.nom)}
      <figure style="animation-delay: {0.2 + i * 0.15}s">
        <div class="tm-ex1-photo">
          <img src="{base}/img/{p.photo}" alt={p.nom} />
          {#if fini}
            <svg class="tm-ex1-ok" viewBox="0 0 40 40" aria-label="correction terminée">
              <circle cx="20" cy="20" r="19" />
              <path d="M11 20.5 L17.5 27 L29.5 14" />
            </svg>
          {/if}
        </div>
        <figcaption>
          <strong>{p.nom}</strong>
          {#if fini}
            <span class="tm-ex1-fini">c'est corrigé</span>
          {:else}
            <span class="tm-ex1-barre" aria-label="correction en cours, 99 %"><span></span></span>
            <span class="tm-ex1-attente">chargement… <b>99&#8239;%</b><em>(depuis un moment)</em></span>
          {/if}
        </figcaption>
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
  .tm-ex1-photo { position: relative; }
  img { width: 9em; height: 9em; object-fit: cover; border: 3px solid var(--dk-encre); filter: grayscale(1); display: block; }
  .tm-ex1-ok { position: absolute; right: -0.9em; bottom: -0.9em; width: 3.2em; height: 3.2em; animation: tm-ex1-pop 0.45s 0.9s both; }
  .tm-ex1-ok circle { fill: #1f8a4c; stroke: var(--dk-fond); stroke-width: 2; }
  .tm-ex1-ok path { fill: none; stroke: #fff; stroke-width: 4; stroke-linecap: square; stroke-dasharray: 30; stroke-dashoffset: 30; animation: tm-ex1-trait 0.4s 1.25s forwards; }
  figcaption { display: flex; flex-direction: column; align-items: center; gap: 0.35em; min-width: 14em; }
  figcaption strong { font-size: 1.05em; }
  .tm-ex1-fini { font-size: 0.85em; font-weight: 600; color: #1f8a4c; letter-spacing: 0.06em; }
  .tm-ex1-barre { display: block; width: 12em; height: 0.7em; border: 2px solid var(--dk-encre); margin-top: 0.15em; }
  .tm-ex1-barre span { display: block; height: 100%; width: 0; background: var(--dk-accent); animation: tm-ex1-charge 2.6s 0.8s cubic-bezier(0.2, 0.9, 0.3, 1) forwards; }
  .tm-ex1-attente { font-size: 0.8em; color: var(--dk-gris); display: flex; flex-direction: column; align-items: center; gap: 0.1em; }
  .tm-ex1-attente b { color: var(--dk-accent); animation: tm-ex1-clignote 1.2s 3.4s infinite; }
  .tm-ex1-attente em { font-style: normal; font-size: 0.85em; }
  @keyframes tm-ex1-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @keyframes tm-ex1-pop { from { opacity: 0; transform: scale(0.3); } 70% { transform: scale(1.15); } to { opacity: 1; transform: scale(1); } }
  @keyframes tm-ex1-trait { to { stroke-dashoffset: 0; } }
  @keyframes tm-ex1-charge { 0% { width: 0; } 60% { width: 90%; } 100% { width: 99%; } }
  @keyframes tm-ex1-clignote { 50% { opacity: 0.25; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-ex1-bande, figure, .tm-ex1-ok, .tm-ex1-attente b { animation: none; }
    .tm-ex1-ok path { animation: none; stroke-dashoffset: 0; }
    .tm-ex1-barre span { animation: none; width: 99%; }
  }
</style>
