<script>
  /**
   * Étape 1 du travail : une question claire, précise, mesurable. On part
   * d'une question floue, on arrive à celle des consignes (« le fait d'avoir
   * des enfants influence-t-il l'orientation gauche-droite des parents ? »),
   * et chaque morceau de la question trouve sa variable dans le codebook de
   * la CES 2025. Suite de l'entonnoir de la séance 1 (Entonnoir.svelte),
   * cette fois avec le vrai codebook. Cinq temps :
   *
   *   0  la question floue : on peut en parler, pas y répondre;
   *   1  la question précise des consignes, X et Y soulignés;
   *   2  X et Y descendent dans le codebook : la vraie question posée,
   *      mot pour mot, et le nom de la variable;
   *   3  les trois critères s'allument : claire, précise, mesurable;
   *   4  où chercher des idées : le codebook, dans Positron.
   *
   * Le libellé des questions est copié du codebook officiel
   * (ces::download_pdf_codebook("2025"), CES_2025_web_codebook.pdf, 477 p.) :
   * cps25_children, p. 199; cps25_lr_scale_bef_1, p. 77. Version française.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  const CRITERES = [
    { k: 'CLAIRE', t: 'une relation, X → Y' },
    { k: 'PRÉCISE', t: 'deux concepts, une population' },
    { k: 'MESURABLE', t: 'les deux sont dans la CES' }
  ];
</script>

<div class="visuel tm-q" bind:this={hote}>
  <div class="tm-q-floue" class:tm-recule={e >= 1}>
    <span class="tm-q-et">FLOUE</span>
    <p>La famille change-t-elle nos idées politiques&#8239;?</p>
  </div>

  <div class="tm-q-fl" class:tm-on={e >= 1}>↓</div>

  <div class="tm-q-precise" class:tm-on={e >= 1}>
    <span class="tm-q-et tm-rouge">PRÉCISE</span>
    <p>Le fait <u class="tm-x">d’avoir des enfants</u> influence-t-il <u class="tm-y">l’orientation gauche-droite</u> des parents&#8239;?</p>
  </div>

  <div class="tm-q-vars" class:tm-on={e >= 2}>
    <div class="tm-q-var tm-x">
      <span class="tm-q-xy">X</span>
      <code>cps25_children</code>
      <p>«&#8239;Combien d’enfants avez-vous&#8239;?&#8239;»</p>
      <small>codebook CES 2025, p. 199</small>
    </div>
    <div class="tm-q-var tm-y">
      <span class="tm-q-xy">Y</span>
      <code>cps25_lr_scale_bef_1</code>
      <p>«&#8239;… où 0 indique la gauche et 10 la droite&#8239;»</p>
      <small>codebook CES 2025, p. 77</small>
    </div>
  </div>

  <div class="tm-q-crit" class:tm-on={e >= 3}>
    {#each CRITERES as c, i}
      <div style="--i: {i}"><span class="tm-q-k"><i class="tm-coche"></i>{c.k}</span><span>{c.t}</span></div>
    {/each}
  </div>

  <p class="tm-q-code" class:tm-on={e >= 4}>
    <span>Des idées&#8239;? Feuilletez le codebook&#8239;:</span>
    <code>ces::download_pdf_codebook("2025")</code>
  </p>
</div>

<style>
  .tm-q { display: flex; flex-direction: column; align-items: center; gap: 0.45em; max-width: 56em; margin: 0 auto; }
  .tm-q-et { font-size: 0.6em; font-weight: 600; letter-spacing: 0.16em; color: var(--dk-gris); white-space: nowrap; }
  .tm-q-et.tm-rouge { color: var(--dk-accent); }
  .tm-q-floue, .tm-q-precise { display: grid; grid-template-columns: 6.5em 1fr; align-items: baseline; gap: 1em; width: 100%; box-sizing: border-box; padding: 0.6em 1.1em; }
  .tm-q-floue { border: 3px dashed var(--dk-gris-2); transition: opacity 0.5s, transform 0.5s; animation: tm-q-f 0.5s backwards; }
  .tm-q-floue p { margin: 0; font-size: 1.15em; }
  .tm-q-floue.tm-recule { opacity: 0.4; transform: scale(0.94); }
  .tm-q-fl { font-size: 1.3em; line-height: 1; font-weight: 600; color: var(--dk-accent); opacity: 0; transition: opacity 0.4s; }
  .tm-q-precise { border: 4px solid var(--dk-accent); opacity: 0; transform: translateY(0.5em); transition: opacity 0.5s, transform 0.5s; }
  .tm-q-precise p { margin: 0; font-size: 1.2em; line-height: 1.45; }
  .tm-q-precise u { text-decoration: none; padding-bottom: 0.05em; border-bottom: 0.22em solid; font-weight: 600; }
  u.tm-x { border-color: var(--dk-encre); }
  u.tm-y { border-color: var(--dk-accent); color: var(--dk-accent); }

  .tm-q-vars { display: grid; grid-template-columns: 1fr 1fr; gap: 1.1em; width: 100%; margin-top: 0.3em; opacity: 0; transform: translateY(-0.6em); transition: opacity 0.5s, transform 0.5s; }
  .tm-q-var { position: relative; display: flex; flex-direction: column; gap: 0.25em; background: var(--dk-fond-2); border-top: 6px solid var(--dk-encre); padding: 0.6em 0.9em 0.6em 3.4em; }
  .tm-q-var.tm-y { border-top-color: var(--dk-accent); }
  .tm-q-xy { position: absolute; left: 0.45em; top: 0.3em; font-size: 2em; font-weight: 600; line-height: 1; }
  .tm-y .tm-q-xy { color: var(--dk-accent); }
  .tm-q-var code { font-size: 0.85em; font-weight: 600; }
  .tm-q-var p { margin: 0; font-size: 0.95em; line-height: 1.35; }
  .tm-q-var small { font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }

  .tm-q-crit { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.1em; width: 100%; margin-top: 0.3em; }
  .tm-q-crit > div { display: flex; flex-direction: column; gap: 0.15em; border-top: 4px solid var(--dk-accent); padding-top: 0.35em; opacity: 0; transform: translateY(0.4em); transition: opacity 0.4s, transform 0.4s; transition-delay: calc(var(--i) * 160ms); }
  .tm-q-crit.tm-on > div { opacity: 1; transform: none; }
  .tm-coche { display: inline-block; width: 0.32em; height: 0.66em; margin: 0 0.55em 0.12em 0.1em; border: solid currentColor; border-width: 0 0.16em 0.16em 0; transform: rotate(45deg); }
  .tm-q-k { font-size: 0.95em; font-weight: 600; letter-spacing: 0.08em; color: var(--dk-accent); }
  .tm-q-crit span:not(.tm-q-k) { font-size: 0.8em; color: var(--dk-gris); }

  .tm-q-code { margin: 0.3em 0 0; width: 100%; display: flex; align-items: baseline; gap: 0.9em; flex-wrap: wrap; font-size: 0.95em; opacity: 0; transition: opacity 0.5s; }
  .tm-q-code code { font-size: 1em; font-weight: 600; background: var(--dk-fond-2); border-left: 0.3em solid var(--dk-accent); padding: 0.15em 0.6em; }

  .tm-on { opacity: 1 !important; transform: none !important; }
  @keyframes tm-q-f { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-q-floue { animation: none; }
    .tm-q-floue, .tm-q-fl, .tm-q-precise, .tm-q-vars, .tm-q-crit > div, .tm-q-code { transition: none; }
  }
</style>
