<script>
  /**
   * Un site du CLESSN, dans un cadre de navigateur. Au repos: la capture
   * d'écran (elle marche sans réseau). Un clic: la version en direct, dans
   * un iframe — c'est la personne qui présente qui décide d'y aller. Un
   * second clic revient à la capture. L'iframe n'est monté qu'au premier
   * passage en direct, pour ne pas charger trois sites à l'ouverture.
   *
   * Sites protégés par authentification HTTP (prof-datagotchi.com): Chrome
   * bloque l'invite d'identification dans un iframe d'une autre origine, mais
   * réutilise les identifiants déjà saisis au premier plan. S'identifier dans
   * un onglet avant la séance; l'identifiant n'est jamais inscrit ici.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  let { url, titre, sous, capture, note = '', plein = false } = $props();
  let e = $state(0);
  let monte = $state(false);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    if (plein) { e = 1; monte = true; return; }   // en direct tout de suite, sans temps
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => { e = v; if (v === 1) monte = true; } });
  });
  const domaine = url.replace(/^https?:\/\//, '').replace(/\/$/, '');
</script>

<div class="visuel site" class:plein bind:this={hote}>
  <div class="entete" class:cache={plein}>
    <div><strong>{titre}</strong><span>{sous}</span></div>
    <span class="etat" class:direct={e === 1}>{e === 1 ? '● EN DIRECT' : 'CAPTURE · cliquez pour le direct'}</span>
  </div>
  <div class="nav">
    <div class="barre"><i></i><i></i><i></i></div>
    <div class="url"><span class="cadenas">🔒</span>{domaine}</div>
    {#if plein}<span class="titre-plein">{titre}<em>{sous}</em></span>{/if}
  </div>
  <div class="cadre">
    <img src="{base}/img/{capture}" alt="Capture d'écran de {titre}" class:cache={e === 1} />
    {#if monte}
      <iframe src={url} title={titre} class:vu={e === 1} loading="lazy" referrerpolicy="no-referrer" allow="fullscreen"></iframe>
    {/if}
  </div>
  {#if note}<p class="note">{note}</p>{/if}
</div>

<style>
  .site { display: flex; flex-direction: column; gap: 0.35em; }
  .entete { display: grid; grid-template-columns: 1fr auto; align-items: baseline; gap: 1em; }
  .entete strong { font-size: 1.2em; margin-right: 0.6em; }
  .entete span { font-size: 0.74em; color: var(--dk-gris); }
  .etat { font-family: var(--dk-mono); font-size: 0.62em; letter-spacing: 0.14em; font-weight: 600; color: var(--dk-gris) !important; }
  .etat.direct { color: var(--dk-accent) !important; }
  .nav { display: flex; align-items: center; gap: 0.7em; background: var(--dk-encre); padding: 0.35em 0.7em; }
  .barre { display: flex; gap: 0.3em; }
  .barre i { width: 0.6em; height: 0.6em; border-radius: 50%; background: var(--dk-fond); opacity: 0.85; }
  .url { flex: 1; background: var(--dk-fond-2); color: var(--dk-encre); font-family: var(--dk-mono); font-size: 0.7em; padding: 0.25em 0.7em; display: flex; gap: 0.5em; align-items: center; }
  .cadenas { font-size: 0.8em; }
  .cadre { position: relative; border: 3px solid var(--dk-encre); border-top: 0; aspect-ratio: 16 / 9; max-height: 56vh; overflow: hidden; background: #fff; }
  .cadre img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; object-position: top; transition: opacity 0.4s; }
  .cadre img.cache { opacity: 0; }
  .cadre iframe { position: absolute; inset: 0; width: 100%; height: 100%; border: 0; opacity: 0; transition: opacity 0.4s; }
  .cadre iframe.vu { opacity: 1; }
  .note { margin: 0; font-size: 0.72em; color: var(--dk-gris); }
  /* plein: pas d'entête, la barre d'adresse porte le titre, le cadre prend toute la hauteur */
  .site.plein { height: 100%; gap: 0; }
  .entete.cache { display: none; }
  .site.plein .cadre { flex: 1; aspect-ratio: auto; max-height: none; height: calc(100vh - 8.2em); }
  .titre-plein { font-family: var(--dk-mono); font-size: 0.68em; color: var(--dk-fond); white-space: nowrap; }
  .titre-plein em { font-style: normal; color: var(--dk-gris-2); margin-left: 0.8em; }
</style>
