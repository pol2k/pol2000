<script>
  /**
   * « Jouer avec la droite » : le vrai nuage de notre sondage (les 783
   * personnes qui ont répondu aux deux questions, NOTRE.points de
   * src/lib/data/seance7.js; `jx` étale chaque cran de ± 0,3 pour le dessin
   * seulement), une droite, et son équation dont les nombres suivent la
   * droite. On règle β0 (l'ordonnée à l'origine) et β1 (la pente) de trois
   * façons : au clic (télécommande), avec les deux curseurs, ou en tirant
   * les deux poignées posées sur la droite (le point rouge à 0 = β0, le
   * cercle au bout = β1, qui fait pivoter la droite autour de β0).
   *
   * « Distance totale » : la somme des carrés des écarts verticaux entre
   * chaque point et la droite, la même idée qu'à « La droite qui passe le
   * plus près ». Calculée ici sur les vrais crans (x, pas jx), à partir de
   * six sommes faites une fois. Elle est au plus bas sur la droite de R
   * (NOTRE.coefs : 79,8 et −5,05) : la barre touche alors le trait
   * « minimum ». La barre part de zéro (pas d'axe menteur) : l'écart entre
   * une droite plate et la meilleure est réel, mais modeste (R² = 0,14).
   *
   * Temps (clic, flèche, télécommande) :
   *   0  une droite plate à la moyenne de la note (55,1) : β1 = 0
   *      (sans animation : c'est l'état d'arrivée);
   *   1  on change β0 seulement : la droite monte et descend sans tourner,
   *      et s'arrête trop haut (90);
   *   2  on change β1 seulement : la droite pivote autour de β0 et
   *      s'arrête trop raide (−9);
   *   3  la droite de R : la distance totale touche son minimum.
   *
   * Curseurs et temps. Les curseurs et les poignées règlent la droite
   * librement, sans changer de temps. Le clic suivant (ou la flèche)
   * reprend le scénario au temps suivant, en partant de là où la droite
   * se trouve. Le bouton « La droite de R » saute au temps 3. Arriver sur
   * la diapo ou la quitter remet le temps 0 (droite plate).
   *
   * Pièges réglés ici, sans toucher au moteur :
   *   - brancherTemps écoute les clics sur toute la diapo : les commandes
   *     arrêtent la propagation, et le clic qui suit un glissement (relâché
   *     ailleurs, sur le nuage par exemple) est avalé en phase de capture;
   *   - un curseur qui garde le focus capte les flèches et la télécommande
   *     (dansUnChamp) : on lui retire le focus quand on relâche la souris
   *     ou le doigt. Au clavier (Tab), les flèches règlent le curseur
   *     jusqu'à Échap, qui rend la main au deck;
   *   - les `onclick` de Svelte 5 sont délégués à la racine : le bouton
   *     écoute donc directement (addEventListener), sinon l'arrêt de la
   *     propagation l'empêcherait de recevoir son propre clic.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE } from '$lib/data/seance7.js';
  import EquationDroite from './EquationDroite.svelte';

  const PTS = NOTRE.points;
  const R0 = NOTRE.coefs[0].b;
  const R1 = NOTRE.coefs[1].b;

  // Les six sommes qui donnent la distance totale de n'importe quelle droite.
  const somme = (g) => PTS.reduce((s, p) => s + g(p), 0);
  const n = PTS.length;
  const sx = somme((p) => p.x), sy = somme((p) => p.y);
  const sxx = somme((p) => p.x * p.x), sxy = somme((p) => p.x * p.y), syy = somme((p) => p.y * p.y);
  const MOY = sy / n;
  const distance = (a, b) => syy - 2 * a * sy - 2 * b * sxy + n * a * a + 2 * a * b * sx + b * b * sxx;
  const MIN = distance(R0, R1);

  // Le scénario des temps : les positions (β0, β1) par lesquelles passe la droite.
  const TOTAL = 3;
  const HAUT = 90, RAIDE = -9;
  const SCENARIO = [
    { cibles: [[MOY, 0]], duree: 0 },
    { cibles: [[96, 0], [18, 0], [HAUT, 0]], duree: 800 },
    { cibles: [[HAUT, -14], [HAUT, 3], [HAUT, RAIDE]], duree: 800 },
    { cibles: [[R0, R1]], duree: 1200 }
  ];

  let e = $state(0);
  let b0 = $state(MOY);
  let b1 = $state(0);
  let touche = $state(null); // 'b0' ou 'b1' pendant qu'on règle à la main
  let prise = $state(null); // la poignée tenue : { k, xh }
  let hote = $state(null);
  let svg = $state(null);
  let ctrl = $state(null);
  let bouton = $state(null);
  let glisse = false; // un glissement est en cours : le clic qui suit ne compte pas

  // ---- L'animation (requestAnimationFrame, déterministe).
  let raf = 0;
  const lisse = (t) => (t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2);
  function arreter() { cancelAnimationFrame(raf); raf = 0; }
  function jouer({ cibles, duree }) {
    arreter();
    const calme = typeof matchMedia !== 'undefined' && matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (!duree || calme) { [b0, b1] = cibles.at(-1); return; }
    let i = 0, depart = [b0, b1], t0 = performance.now();
    const pas = (t) => {
      const u = Math.min(1, Math.max(0, (t - t0) / duree));
      const k = lisse(u), [a, b] = cibles[i];
      b0 = depart[0] + (a - depart[0]) * k;
      b1 = depart[1] + (b - depart[1]) * k;
      if (u < 1) raf = requestAnimationFrame(pas);
      else if (++i < cibles.length) { depart = [a, b]; t0 = t; raf = requestAnimationFrame(pas); }
      else raf = 0;
    };
    raf = requestAnimationFrame(pas);
  }
  function aller(v) { e = v; touche = null; jouer(SCENARIO[v]); }

  $effect(() => {
    if (!hote) return;
    const debrancher = brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: aller });
    return () => { debrancher(); arreter(); };
  });

  // ---- Les commandes ne font pas avancer la diapo.
  function relacher() {
    const a = document.activeElement;
    if (a && ctrl?.contains(a)) a.blur();
    setTimeout(() => (glisse = false), 0); // après le clic qui suit le relâchement
  }
  function avaler(ev) {
    if (!glisse) return;
    ev.stopPropagation();
    glisse = false;
  }
  // Les gestionnaires `onclick` de Svelte 5 sont délégués à la racine : un
  // clic arrêté ici ne les atteindrait jamais. Le bouton écoute donc
  // directement, avant que le clic soit arrêté.
  $effect(() => {
    if (!ctrl || !bouton) return;
    const stop = (ev) => ev.stopPropagation();
    const saisir = (ev) => {
      ev.stopPropagation();
      // Un curseur qu'on tire : le clic qui suivra ne compte pas.
      if (ev.target.tagName === 'INPUT') glisse = true;
      window.addEventListener('pointerup', relacher, { once: true });
    };
    bouton.addEventListener('click', versR);
    ctrl.addEventListener('click', stop);
    ctrl.addEventListener('pointerdown', saisir);
    window.addEventListener('click', avaler, true);
    return () => {
      bouton.removeEventListener('click', versR);
      ctrl.removeEventListener('click', stop);
      ctrl.removeEventListener('pointerdown', saisir);
      window.removeEventListener('click', avaler, true);
      window.removeEventListener('pointerup', relacher);
    };
  });

  const borner = (v, a, b) => Math.min(b, Math.max(a, v));
  const pas0 = (v) => Math.round(v * 10) / 10;
  const pas1 = (v) => Math.round(v * 20) / 20;
  function regler(k, v) {
    arreter();
    touche = k;
    if (k === 'b0') b0 = borner(v, 0, 100);
    else b1 = borner(v, -15, 15);
  }
  function auClavier(ev) {
    if (ev.key === 'Escape') { ev.currentTarget.blur(); touche = null; }
  }
  function versR(ev) {
    ev.stopPropagation();
    ev.currentTarget.blur();
    aller(TOTAL);
  }

  // ---- Le dessin. Note de 0 à 100, gauche_droite de 0 à 10.
  const X0 = 66, X1 = 616, YB = 372, YT = 22;
  const x = (v) => X0 + (v / 10) * (X1 - X0);
  const y = (v) => YB - (v / 100) * (YB - YT);
  const xInv = (px) => ((px - X0) / (X1 - X0)) * 10;
  const yInv = (py) => ((YB - py) / (YB - YT)) * 100;

  // Le bout de la droite visible à droite : à 10, ou là où elle sort du cadre.
  const xFin = $derived.by(() => {
    const y10 = b0 + 10 * b1;
    if (y10 >= 0 && y10 <= 100) return 10;
    return borner(((y10 < 0 ? 0 : 100) - b0) / b1, 0, 10);
  });
  const xPoignee = $derived(prise?.k === 'b1' ? prise.xh : Math.max(xFin, 0.6));
  // Aux extrêmes (β0 = 100 et β1 > 0, par exemple), la poignée reste dans le cadre.
  const yPoignee = $derived(borner(b0 + b1 * xPoignee, -4, 104));

  // ---- Les poignées, tirées à la souris ou au doigt.
  function versDonnee(ev) {
    const pt = svg.createSVGPoint();
    pt.x = ev.clientX; pt.y = ev.clientY;
    const q = pt.matrixTransform(svg.getScreenCTM().inverse());
    return { x: xInv(q.x), y: borner(yInv(q.y), 0, 100) };
  }
  $effect(() => {
    if (!svg) return;
    const saisir = (ev) => {
      const el = ev.target.closest('[data-poignee]');
      if (!el) return;
      ev.stopPropagation();
      ev.preventDefault();
      arreter();
      glisse = true;
      const k = el.dataset.poignee;
      prise = { k, xh: k === 'b1' ? Math.max(xFin, 0.6) : 0 };
      touche = k;
      el.setPointerCapture(ev.pointerId);
    };
    const bouger = (ev) => {
      if (!prise) return;
      const d = versDonnee(ev);
      if (prise.k === 'b0') b0 = pas0(d.y);
      else b1 = borner(pas1((d.y - b0) / prise.xh), -15, 15);
    };
    const lacher = () => {
      if (!prise) return;
      prise = null;
      touche = null;
      setTimeout(() => (glisse = false), 0);
    };
    svg.addEventListener('pointerdown', saisir);
    svg.addEventListener('pointermove', bouger);
    svg.addEventListener('pointerup', lacher);
    svg.addEventListener('pointercancel', lacher);
    return () => {
      svg.removeEventListener('pointerdown', saisir);
      svg.removeEventListener('pointermove', bouger);
      svg.removeEventListener('pointerup', lacher);
      svg.removeEventListener('pointercancel', lacher);
    };
  });

  // ---- Ce qu'on affiche.
  const d = $derived(distance(b0, b1));
  const enTrop = $derived((d / MIN - 1) * 100);
  const auMinimum = $derived(enTrop < 0.05);
  const aPlat = $derived(Math.abs(b1) < 0.005 && Math.abs(b0 - MOY) < 0.05);
  // La barre part de zéro; le bord droit vaut 2,5 fois le minimum.
  const ECHELLE = 2.5 * MIN;
  const largeur = $derived(Math.min(d / ECHELLE, 1) * 100);
  const deborde = $derived(d > ECHELLE);
  const actif = $derived(touche ?? (e === 1 ? 'b0' : e === 2 ? 'b1' : null));

  const nb = (v, k = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: k, maximumFractionDigits: k }).replace(/\s/g, ' ');
  const pct = (v) => (v < 9.95 ? nb(v, 1) : nb(v, 0));
  const larg = (t, taille) => t.length * 0.6 * taille + 14;
  const T_MOY = `la moyenne : ${nb(MOY, 1)}`;
  const T_R = 'la droite de R';
</script>

<div class="visuel reglable" bind:this={hote} data-temps={e}>
  <EquationDroite {b0} {b1} {actif} />

  <div class="corps">
    <svg bind:this={svg} viewBox="0 0 640 432" role="img" aria-label="Nuage de points de notre sondage, {nb(n)} personnes&#8239;: la note donnée à Mark Carney, de 0 à 100, selon la position gauche-droite, de 0 à 10. Une droite qu’on règle avec son ordonnée à l’origine et sa pente. La droite de R, {nb(R0, 1)} moins {nb(-R1, 2)} fois gauche_droite, est celle dont la distance totale aux points est la plus petite.">
      <defs>
        <clipPath id="dr-cadre"><rect x={X0} y={YT - 8} width={X1 - X0 + 10} height={YB - YT + 8} /></clipPath>
      </defs>

      <!-- Les axes. -->
      <line x1={X0} y1={YB} x2={X1} y2={YB} class="axe" />
      <line x1={X0} y1={YB} x2={X0} y2={YT - 8} class="axe" />
      {#each [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] as v}
        <line x1={x(v)} y1={YB} x2={x(v)} y2={YB + 7} class="axe" />
        <text x={x(v)} y={YB + 27} class="tick">{v}</text>
      {/each}
      {#each [0, 25, 50, 75, 100] as v}
        <line x1={X0 - 7} y1={y(v)} x2={X0} y2={y(v)} class="axe" />
        <text x={X0 - 13} y={y(v) + 5} class="tick fin">{v}</text>
      {/each}
      <text x={(X0 + X1) / 2} y="424" class="titre-axe">gauche_droite</text>
      <text x={X0 + 8} y={YB + 46} class="pole">gauche</text>
      <text x={X1} y={YB + 46} class="pole fin">droite</text>
      <text transform="translate(16 {(YB + YT) / 2}) rotate(-90)" class="titre-axe">note_carney</text>

      <!-- Les 783 personnes : dessinées une fois, elles ne dépendent pas de la droite. -->
      <g class="nuage">
        {#each PTS as p}<circle cx={x(p.jx)} cy={y(p.y)} r="3.6" />{/each}
      </g>

      <!-- La droite, coupée au cadre. -->
      <g clip-path="url(#dr-cadre)">
        <line x1={x(0)} y1={y(b0)} x2={x(10)} y2={y(b0 + 10 * b1)} class="droite" class:min={auMinimum} />
      </g>

      <!-- Les étiquettes de la droite plate (la moyenne) et de la droite de R. -->
      {#if aPlat}
        <rect x={x(10) - larg(T_MOY, 17)} y={y(MOY) - 34} width={larg(T_MOY, 17)} height="24" class="fond" />
        <text x={x(10) - 7} y={y(MOY) - 16} class="ecrit fin">{T_MOY}</text>
      {/if}
      {#if auMinimum}
        <rect x={x(7.3) - 10} y={y(R0 + R1 * 7.3) - 42} width={larg(T_R, 18)} height="25" class="fond" />
        <text x={x(7.3)} y={y(R0 + R1 * 7.3) - 23} class="ecrit rouge">{T_R}</text>
      {/if}

      <!-- Les poignées : β0 à gauche (monte et descend), β1 au bout (fait pivoter). -->
      <g class="poignee" class:on={actif === 'b1'} data-poignee="b1">
        <circle cx={x(xPoignee)} cy={y(yPoignee)} r="22" class="prise" />
        <circle cx={x(xPoignee)} cy={y(yPoignee)} r="10" class="p1" />
      </g>
      <g class="poignee" class:on={actif === 'b0'} data-poignee="b0">
        <circle cx={x(0)} cy={y(b0)} r="22" class="prise" />
        <circle cx={x(0)} cy={y(b0)} r="11" class="p0" />
      </g>
      <text x={x(0) + 18} y={y(b0) + (b0 > 88 ? 26 : -14)} class="nom-b" class:on={actif === 'b0'}>β0</text>
    </svg>

    <div class="cmd" bind:this={ctrl}>
      <div class="curseur" class:on={actif === 'b0'}>
        <span class="lib"><b>β0</b> ordonnée à l’origine</span>
        <input type="range" min="0" max="100" step="0.1" value={b0} aria-label="β0, l’ordonnée à l’origine"
          oninput={(ev) => regler('b0', +ev.currentTarget.value)}
          onkeydown={auClavier} />
        <span class="bornes"><span>0</span><span>100</span></span>
      </div>
      <div class="curseur" class:on={actif === 'b1'}>
        <span class="lib"><b>β1</b> pente</span>
        <input type="range" min="-15" max="15" step="0.05" value={b1} aria-label="β1, la pente"
          oninput={(ev) => regler('b1', +ev.currentTarget.value)}
          onkeydown={auClavier} />
        <span class="bornes"><span>−15</span><span>0</span><span>+15</span></span>
      </div>

      <div class="dist" class:min={auMinimum}>
        <span class="lib">distance totale</span>
        <span class="valeur">{nb(d)}</span>
        <span class="barre" aria-hidden="true">
          <span class="plein" class:deborde style="width: {largeur}%"></span>
          <span class="repere" style="left: {(MIN / ECHELLE) * 100}%"></span>
        </span>
        <span class="trop">{auMinimum ? 'le minimum' : `+${pct(enTrop)} % de plus que le minimum`}</span>
      </div>

      <button type="button" class="vers-r" class:on={e === TOTAL && auMinimum} bind:this={bouton}>La droite de R</button>
    </div>
  </div>
</div>

<style>
  .reglable { display: flex; flex-direction: column; gap: 0.5em; }
  .corps { display: grid; grid-template-columns: 1.45fr 1fr; gap: 1.4em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 58vh; display: block; }

  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-family: var(--dk-mono); font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.fin { text-anchor: end; }
  .titre-axe { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .pole { font-family: var(--dk-mono); font-size: 13px; letter-spacing: 0.14em; text-transform: uppercase; fill: var(--dk-gris); }
  .pole.fin { text-anchor: end; }

  .nuage circle { fill: var(--dk-accent); opacity: 0.22; }

  .droite { stroke: var(--dk-encre); stroke-width: 5; transition: stroke 0.3s; }
  .droite.min { stroke: var(--dk-accent); }

  .fond { fill: var(--dk-fond); }
  .ecrit { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; fill: var(--dk-encre); }
  .ecrit.fin { text-anchor: end; }
  .ecrit.rouge { fill: var(--dk-accent); font-size: 18px; }

  .poignee { cursor: grab; touch-action: none; }
  .poignee .prise { fill: transparent; }
  .p0 { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }
  .p1 { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3.5; }
  .poignee.on .p1 { stroke: var(--dk-accent); }
  .poignee.on .p0 { stroke: var(--dk-encre); }
  .nom-b { font-family: var(--dk-mono); font-size: 18px; font-weight: 600; fill: var(--dk-gris); }
  .nom-b.on { fill: var(--dk-accent); }

  /* Les commandes : grandes, lisibles du fond de la salle. */
  .cmd { display: flex; flex-direction: column; gap: 1em; }
  .curseur { display: flex; flex-direction: column; gap: 0.25em; }
  .lib { font-size: 0.72em; letter-spacing: 0.06em; color: var(--dk-gris); }
  .lib b { font-size: 1.25em; color: var(--dk-encre); margin-right: 0.3em; }
  .curseur.on .lib b { color: var(--dk-accent); }
  .bornes { display: flex; justify-content: space-between; font-size: 0.6em; color: var(--dk-gris); font-variant-numeric: tabular-nums; }

  input[type='range'] { -webkit-appearance: none; appearance: none; width: 100%; height: 1.5em; margin: 0; background: transparent; cursor: pointer; }
  input[type='range']:focus { outline: none; }
  input[type='range']::-webkit-slider-runnable-track { height: 0.3em; background: var(--dk-encre); border: 0; border-radius: 0; }
  input[type='range']::-moz-range-track { height: 0.3em; background: var(--dk-encre); border: 0; border-radius: 0; }
  input[type='range']::-webkit-slider-thumb { -webkit-appearance: none; appearance: none; width: 1.1em; height: 1.4em; margin-top: -0.55em; background: var(--dk-fond); border: 3px solid var(--dk-encre); border-radius: 0; box-sizing: border-box; }
  input[type='range']::-moz-range-thumb { width: 1.1em; height: 1.4em; background: var(--dk-fond); border: 3px solid var(--dk-encre); border-radius: 0; box-sizing: border-box; }
  .curseur.on input[type='range']::-webkit-slider-thumb { background: var(--dk-accent); border-color: var(--dk-accent); }
  .curseur.on input[type='range']::-moz-range-thumb { background: var(--dk-accent); border-color: var(--dk-accent); }
  input[type='range']:focus-visible::-webkit-slider-thumb { outline: 3px solid var(--dk-accent); outline-offset: 2px; }

  .dist { display: flex; flex-direction: column; gap: 0.2em; border-top: 2px solid var(--dk-encre); padding-top: 0.6em; }
  .dist .valeur { font-size: 1.35em; font-weight: 600; font-variant-numeric: tabular-nums; }
  .dist.min .valeur, .dist.min .trop { color: var(--dk-accent); }
  .barre { position: relative; display: block; height: 0.7em; background: var(--dk-fond-2); }
  .plein { position: absolute; left: 0; top: 0; bottom: 0; background: var(--dk-encre); }
  .dist.min .plein { background: var(--dk-accent); }
  .plein.deborde { background: var(--dk-gris); }
  .repere { position: absolute; top: -0.25em; bottom: -0.25em; width: 3px; margin-left: -1.5px; background: var(--dk-accent); }
  .trop { font-size: 0.66em; color: var(--dk-gris); font-variant-numeric: tabular-nums; }

  .vers-r {
    align-self: flex-start;
    font-family: var(--dk-mono); font-size: 0.8em; font-weight: 600;
    padding: 0.45em 0.9em;
    background: var(--dk-fond); color: var(--dk-encre);
    border: 2px solid var(--dk-encre); border-radius: 0; cursor: pointer;
  }
  .vers-r:hover, .vers-r.on { background: var(--dk-accent); border-color: var(--dk-accent); color: var(--dk-fond); }
</style>
