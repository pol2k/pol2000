<script>
  /**
   * « Sur les épaules d'un géant » : d'où vient le slogan de Google
   * Scholar. Trois dates, une par clic. Bernard de Chartres (mort vers
   * 1124), rapporté par Jean de Salisbury (Metalogicon, 1159); Isaac
   * Newton, lettre à Robert Hooke (5 février 1675); Google Scholar.
   * Les citations sont traduites en français.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });
  const DATES = [
    { quand: 'vers 1120', qui: 'Bernard de Chartres', dit: '« Nous sommes des nains assis sur des épaules de géants. »', note: 'rapporté par Jean de Salisbury, 1159' },
    { quand: '1675', qui: 'Isaac Newton', dit: '« Si j’ai vu plus loin, c’est en me tenant sur les épaules de géants. »', note: 'lettre à Robert Hooke' },
    { quand: 'aujourd’hui', qui: 'Google Scholar', dit: '« Sur les épaules d’un géant »', note: 'sa page d’accueil, en français' }
  ];
</script>

<div class="visuel m8g" bind:this={hote}>
  <div class="ligne-temps"></div>
  {#each DATES as d, i}
    <div class="date" class:vu={e >= i} class:der={i === 2}>
      <span class="point"></span>
      <span class="quand">{d.quand}</span>
      <strong>{d.qui}</strong>
      <span class="dit">{d.dit}</span>
      <span class="note">{d.note}</span>
    </div>
  {/each}
</div>

<style>
  .m8g { position: relative; display: grid; grid-template-columns: repeat(3, 1fr); gap: 2em; max-width: 64em; margin: 2.2em auto 0; }
  .ligne-temps { position: absolute; left: 0; right: 0; top: 0.55em; border-top: 3px solid var(--dk-encre); }
  .date { position: relative; display: flex; flex-direction: column; gap: 0.45em; padding-top: 1.8em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; }
  .date.vu { opacity: 1; transform: none; }
  .point { position: absolute; top: 0; left: 0; width: 1.1em; height: 1.1em; background: var(--dk-encre); }
  .der .point { background: var(--dk-accent); }
  .quand { font-size: 0.9em; letter-spacing: 0.1em; text-transform: uppercase; color: var(--dk-accent); font-weight: 600; }
  strong { font-size: 1.35em; }
  .dit { font-size: 1.15em; line-height: 1.4; }
  .note { color: var(--dk-gris); font-size: 0.85em; }
  @media (prefers-reduced-motion: reduce) { .date { transition: none; transform: none; } }
</style>
