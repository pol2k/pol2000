<script>
  /**
   * La moyenne, pas à pas. Les quatre commandes de CONSOLES_PLUS.moyenne
   * (outils/seance4_plus.R), une par temps, et leur effet dessiné sous le
   * code : l'échelle gauche-droite de 0 à 10 (GAUCHE_DROITE), le bloc -99 à
   * part au bout de l'axe coupé, un repère pour la moyenne et le résultat en
   * grand.
   *
   * Code des couleurs, tenu d'un bout à l'autre :
   *   rouge          ce qui est faux (le -99, la moyenne de -11,44);
   *   gris pointillé NA, une valeur inconnue;
   *   encre          les barres comptées par le calcul en cours, et la
   *                  bonne réponse.
   *
   *   0  Les barres, le curseur de R attend.
   *   1  mean() : le -99 rougit, la moyenne tombe à -11,44, hors de l'échelle.
   *   2  na_if(-99) : le bloc -99 devient NA (creux, pointillé). Rien n'est
   *      effacé : les 3 184 personnes sont toujours dans les données.
   *   3  mean() : R répond NA; le bloc NA clignote en rouge, c'est la cause.
   *   4  na.rm = TRUE : le bloc NA est laissé de côté, la moyenne glisse à
   *      4,97, dans l'échelle.
   */
  import { brancherTemps } from '../temps.js';
  import { surlignerR } from '../surligner.js';
  import { Tween } from 'svelte/motion';
  import { cubicOut } from 'svelte/easing';
  import Copier from '../Copier.svelte';
  import { GAUCHE_DROITE as G } from '$lib/data/seance4.js';
  import { CONSOLES_PLUS } from '$lib/data/seance4_plus.js';

  const L = CONSOLES_PLUS.moyenne;
  const TOTAL = L.length; // 4 temps

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Le bout de code qui fait le travail, souligné. On coupe la chaîne de R
  // sur des frontières de jetons, pour que la coloration reste juste.
  const CLES = [null, 'na_if(cps25_lr_scale_bef_1, -99)', null, 'na.rm = TRUE'];
  const html = L.map((l, i) => {
    const cle = CLES[i];
    const k = cle ? l.in.indexOf(cle) : -1;
    if (k < 0) return surlignerR(l.in);
    return (
      surlignerR(l.in.slice(0, k)) +
      '<mark>' + surlignerR(cle) + '</mark>' +
      surlignerR(l.in.slice(k + cle.length))
    );
  });
  const commandes = L.map((l) => l.in).join('\n');

  const virgule = (x) => x.toFixed(2).replace('.', ',').replace('-', '−');
  const milliers = (n) => n.toLocaleString('fr-CA').replace(/\s/g, ' ');

  const n99 = G.effectifs[G.valeurs.indexOf(-99)];
  const nValides = G.n - n99;

  // Le résultat en grand : le nombre défile jusqu'à sa valeur, comme un calcul.
  const nombre = new Tween(0, { duration: 900, easing: cubicOut });
  $effect(() => {
    if (e === 1) nombre.set(G.moyenneBrute);
    else if (e === 4) nombre.set(G.moyennePropre);
    else nombre.set(0, { duration: 0 });
  });

  // L'axe : le bloc -99 seul à gauche (X99), une coupure, puis 0 à 10.
  const X99 = 90, XC = 160, X0 = 210, X1 = 640, Y0 = 280, Y1 = 70;
  const pas = (X1 - X0) / 11;
  const cx = (v) => X0 + (v + 0.5) * pas;
  // -11,44 n'a pas de place entre 0 et 10 : le repère se pose dans la
  // coupure, entre -99 et 0. Un repère, pas une abscisse.
  const xBrute = XC;
  const xPropre = cx(G.moyennePropre);
  const MAX = Math.ceil(Math.max(...G.effectifs) / 1000) * 1000;
  const y = (n) => Y0 - (n / MAX) * (Y0 - Y1);
  const graduations = Array.from({ length: MAX / 1000 + 1 }, (_, k) => k * 1000);
  const reste = G.valeurs.map((v, k) => ({ v, n: G.effectifs[k] })).filter((b) => b.v !== -99);

  // Les barres de 0 à 10 passent à l'encre quand un mean() les compte.
  const comptees = $derived(e === 1 || e === 3 || e === 4);
</script>

<div class="visuel moyenne" bind:this={hote}>
  <div class="code">
    <Copier texte={commandes} />
    <div class="ligne">
      {#if e === 0}
        <pre class="in"><span class="prompt">&gt;</span> <b class="curseur">▍</b></pre>
        <pre class="out">&nbsp;</pre>
      {:else}
        {#key e}
          <pre class="in entre"><span class="prompt">&gt;</span> {@html html[e - 1]}</pre>
          <pre class="out entre" class:vide={!L[e - 1].out}>{L[e - 1].out || ' '}</pre>
        {/key}
      {/if}
    </div>
    <ol class="etapes" aria-label="Étape {e} sur {TOTAL}">
      {#each L as _, i}<li class:fait={i < e} class:ici={i === e - 1}>{i + 1}</li>{/each}
    </ol>
  </div>

  <div class="bas">
    <svg viewBox="0 0 680 340" role="img" aria-label="L'échelle gauche-droite de 0 à 10, avec {milliers(n99)} réponses codées -99. mean() donne {virgule(G.moyenneBrute)}, hors de l'échelle. Après na_if(), les -99 deviennent NA et mean() donne NA. Avec na.rm = TRUE, mean() laisse les NA de côté et donne {virgule(G.moyennePropre)}.">
      {#each graduations as g}
        <line x1={X99 - 42} y1={y(g)} x2={X99 - 34} y2={y(g)} class="axe" />
        <text x={X99 - 48} y={y(g) + 5} class="tick d">{milliers(g)}</text>
      {/each}
      <line x1={X99 - 34} y1={Y0} x2={X99 - 34} y2={Y1 - 10} class="axe" />
      <!-- l'axe coupé -->
      <line x1={X99 - 34} y1={Y0} x2={XC - 12} y2={Y0} class="axe" />
      <text x={XC} y={Y0 + 7} class="coupure">//</text>
      <line x1={XC + 12} y1={Y0} x2={X1} y2={Y0} class="axe" />

      <!-- le bloc -99, puis NA : il change d'habit, il ne part pas -->
      <g class="b99" class:rouge={e === 1} class:na={e >= 2} class:cause={e === 3} class:ecarte={e === 4}>
        <g class="pousse"><rect x={X99 - pas / 2 + 3} y={y(n99)} width={pas - 6} height={Y0 - y(n99)} class="bloc" /></g>
        <text x={X99} y={y(n99) - 12} class="val">{milliers(n99)}</text>
        <text x={X99} y={Y0 + 28} class="tick t99">{e >= 2 ? 'NA' : '−99'}</text>
      </g>

      {#each reste as b, k}
        <rect x={X0 + k * pas + 4} y={y(b.n)} width={pas - 8} height={Y0 - y(b.n)} class="barre" class:comptee={comptees} style="animation-delay: {k * 40}ms" />
        <text x={cx(b.v)} y={Y0 + 28} class="tick">{b.v}</text>
      {/each}
      <text x={(X0 + X1) / 2} y={Y0 + 56} class="lab">0 = gauche · 10 = droite</text>

      <!-- le repère de la moyenne : il tombe à -11,44, puis se pose à 4,97 -->
      {#if e === 1}
        <g class="moy faux" style="transform: translateX({xBrute}px)">
          <line x1="0" y1={Y0} x2="0" y2={Y1 - 22} class="trait" />
          <text x="0" y={Y1 - 32} class="etiq">{virgule(G.moyenneBrute)}</text>
        </g>
      {:else if e === 4}
        <g class="moy juste" style="transform: translateX({xPropre}px)">
          <line x1="0" y1={Y0} x2="0" y2={Y1 - 22} class="halo" />
          <line x1="0" y1={Y0} x2="0" y2={Y1 - 22} class="trait" />
          <text x="0" y={Y1 - 32} class="etiq">{virgule(G.moyennePropre)}</text>
        </g>
      {/if}
    </svg>

    <div class="resultat" class:vide={e === 0} class:faux={e === 1} class:inconnu={e === 2 || e === 3} class:juste={e === 4}>
      {#if e === 1 || e === 4}
        <p class="v">{virgule(nombre.current)}</p>
        <p class="l">{e === 1 ? 'hors de l’échelle de 0 à 10' : `moyenne des ${milliers(nValides)} réponses`}</p>
      {:else if e === 2}
        <p class="v petit-v"><s>−99</s> → NA</p>
        <p class="l">{milliers(n99)} personnes</p>
      {:else if e === 3}
        <p class="v"><span class="boite-na">NA</span></p>
        <p class="l">{milliers(n99)} valeurs inconnues<br />→ moyenne inconnue</p>
      {/if}
    </div>
  </div>
  <p class="source">Étude électorale canadienne 2025 · cps25_lr_scale_bef_1</p>
</div>

<style>
  .moyenne { display: flex; flex-direction: column; gap: 0.6em; }

  /* Le code : un bloc du deck, une commande à la fois, en grand. */
  .code { position: relative; background: var(--dk-fond-2); border: 2px solid var(--dk-encre); border-left-width: 0.34em; border-left-color: var(--dk-accent); padding: 0.6em 0.9em 0.6em; }
  .code :global(.copier) { position: absolute; top: 0.5em; right: 0.5em; }
  .code:hover :global(.copier) { opacity: 1; }
  .ligne { min-height: 3em; }
  pre { margin: 0; font-family: var(--dk-mono); font-size: 1em; line-height: 1.5; white-space: pre; }
  .prompt { color: var(--dk-accent); font-weight: 600; }
  .out { color: var(--dk-gris); padding-left: 1.1em; }
  .entre { animation: tape 0.35s both; }
  .out.entre { animation-delay: 0.25s; }
  .curseur { color: var(--dk-accent); animation: clignote 1s steps(1) infinite; font-weight: 400; }
  .in :global(mark) { background: none; color: inherit; box-shadow: inset 0 -0.16em 0 var(--dk-accent); padding: 0 0.05em; }
  .etapes { position: absolute; right: 0.6em; bottom: 0.55em; margin: 0; padding: 0; list-style: none; display: flex; gap: 0.25em; }
  .etapes li { width: 1.35em; height: 1.35em; display: grid; place-items: center; line-height: 1; font-size: 0.55em; font-weight: 600; border: 2px solid var(--dk-filet); color: var(--dk-gris-2); transition: all 0.3s; }
  .etapes li.fait { border-color: var(--dk-encre); color: var(--dk-encre); }
  .etapes li.ici { background: var(--dk-accent); border-color: var(--dk-accent); color: var(--dk-fond); }

  /* Le dessin et le résultat, côte à côte. */
  .bas { display: grid; grid-template-columns: minmax(0, 1.9fr) minmax(0, 1fr); gap: 1.2em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 50vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .coupure { font-size: 22px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tick { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.d { text-anchor: end; font-size: 14px; }
  .lab { font-size: 16px; text-anchor: middle; fill: var(--dk-encre); }

  .barre { fill: var(--dk-gris-2); transition: fill 0.5s; animation: monte 0.55s cubic-bezier(0.34, 1.4, 0.64, 1) both; transform-origin: bottom; transform-box: fill-box; }
  .barre.comptee { fill: var(--dk-encre); }

  .b99 .bloc { fill: var(--dk-gris-2); stroke: var(--dk-gris-2); stroke-width: 2.5; stroke-dasharray: 0; transition: fill 0.5s, stroke 0.5s; }
  .pousse { animation: monte 0.55s cubic-bezier(0.34, 1.4, 0.64, 1) both; transform-origin: bottom; transform-box: fill-box; }
  .b99 .val { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-gris); transition: fill 0.5s; }
  .b99 .t99 { font-weight: 600; fill: var(--dk-encre); }
  .b99.rouge .bloc { fill: var(--dk-accent); stroke: var(--dk-accent); }
  .b99.rouge .val, .b99.rouge .t99 { fill: var(--dk-accent); }
  .b99.na .bloc { fill: var(--dk-fond); stroke: var(--dk-gris); stroke-dasharray: 8 6; }
  .b99.na .t99 { fill: var(--dk-gris); }
  .b99.cause .bloc { stroke: var(--dk-accent); animation: pouls 0.9s ease-in-out 3; }
  .b99.cause .val, .b99.cause .t99 { fill: var(--dk-accent); }
  .b99.ecarte { opacity: 0.4; transition: opacity 0.5s; }

  .moy { animation: tombe 0.7s cubic-bezier(0.34, 1.3, 0.64, 1) both; }
  .moy .trait { stroke-width: 4; stroke-dasharray: 10 8; }
  .moy .halo { stroke: var(--dk-fond); stroke-width: 12; }
  .moy .etiq { font-size: 20px; font-weight: 600; text-anchor: middle; }
  .moy.faux .trait { stroke: var(--dk-accent); }
  .moy.faux .etiq { fill: var(--dk-accent); }
  .moy.juste .trait { stroke: var(--dk-encre); stroke-dasharray: none; }
  .moy.juste .etiq { fill: var(--dk-encre); }

  /* Le résultat en grand. */
  .resultat.vide { border-left-color: transparent; }
  .resultat { min-height: 5em; display: flex; flex-direction: column; gap: 0.3em; border-left: 2px solid var(--dk-filet); padding-left: 1em; }
  .resultat p { margin: 0; }
  .v { font-size: 3.2em; font-weight: 600; line-height: 1; font-variant-numeric: tabular-nums; animation: tape 0.35s both; }
  .v.petit-v { font-size: 2.2em; }
  .v s { color: var(--dk-accent); text-decoration-thickness: 0.08em; }
  .l { font-size: 0.8em; line-height: 1.35; color: var(--dk-gris); animation: tape 0.35s 0.3s both; }
  .faux .v, .faux .l { color: var(--dk-accent); }
  .inconnu .v { color: var(--dk-gris); }
  .boite-na { display: inline-block; border: 3px dashed var(--dk-gris); padding: 0.05em 0.25em; }
  .juste .v { color: var(--dk-encre); }
  .juste .l { color: var(--dk-encre); }

  .source { margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }

  @keyframes monte { from { transform: scaleY(0); } to { transform: scaleY(1); } }
  @keyframes tombe { from { opacity: 0; translate: 0 -40px; } to { opacity: 1; translate: 0 0; } }
  @keyframes tape { from { opacity: 0; transform: translateY(0.2em); } to { opacity: 1; transform: none; } }
  @keyframes clignote { 50% { opacity: 0; } }
  @keyframes pouls { 50% { stroke-width: 6; } }
  @media (prefers-reduced-motion: reduce) {
    .barre, .pousse, .moy, .entre, .v, .l, .b99.cause .bloc { animation: none; }
  }
</style>
