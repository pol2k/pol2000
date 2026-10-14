<script>
  /**
   * « Jouer avec la droite » : le vrai nuage de notre sondage (les 564
   * personnes qui ont répondu aux deux questions, NOTRE.points de
   * src/lib/data/seance7.js), une droite, et son équation dont les nombres
   * suivent la droite. Les deux variables n'ont que 5 et 4 valeurs (VARS) :
   * chaque personne est dessinée à (jx, jy), un léger étalement autour de sa
   * case, pour le dessin seulement. Le calcul utilise les vraies valeurs.
   * On règle β0 (l'ordonnée à l'origine) et β1 (la pente) de trois façons :
   * au clic (télécommande), avec les deux curseurs, ou en tirant les deux
   * poignées posées sur la droite (le point rouge à 0 = β0, le cercle au
   * bout = β1, qui fait pivoter la droite autour de β0).
   *
   * « Total des carrés » (le mot de RegMoindres) : la somme des carrés des
   * écarts verticaux entre chaque point et la droite. Calculé ici à partir
   * de six sommes faites une fois, sur les vraies valeurs (x, y). Il est au
   * plus bas sur la droite de R (NOTRE.coefs : 0,83 et −0,37) : la barre
   * touche alors le trait « minimum ». La barre part de zéro (pas d'axe
   * menteur) : l'écart entre une droite plate et la meilleure est réel, mais
   * modeste (R² = 0,11, soit 1 − 45,8 / 51,5).
   *
   * Temps (clic, flèche, télécommande) :
   *   0  une droite plate à la moyenne de la satisfaction (0,60) : β1 = 0
   *      (sans animation : c'est l'état d'arrivée);
   *   1  on change β0 seulement : la droite monte et descend sans tourner,
   *      et s'arrête trop haut (0,90);
   *   2  on change β1 seulement : la droite pivote autour de β0 et
   *      s'arrête trop raide (−0,75);
   *   3  la droite de R : le total des carrés touche son minimum.
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
  import { NOTRE, VARS } from '$lib/data/seance7.js';
  import EquationDroite from './EquationDroite.svelte';

  const PTS = NOTRE.points;
  const R0 = NOTRE.coefs[0].b;
  const R1 = NOTRE.coefs[1].b;

  // Les six sommes qui donnent le total des carrés de n'importe quelle droite.
  const somme = (g) => PTS.reduce((s, p) => s + g(p), 0);
  const n = PTS.length;
  const sx = somme((p) => p.x), sy = somme((p) => p.y);
  const sxx = somme((p) => p.x * p.x), sxy = somme((p) => p.x * p.y), syy = somme((p) => p.y * p.y);
  const MOY = sy / n;
  const distance = (a, b) => syy - 2 * a * sy - 2 * b * sxy + n * a * a + 2 * a * b * sx + b * b * sxx;
  const MIN = distance(R0, R1);

  // Le scénario des temps : les positions (β0, β1) par lesquelles passe la droite.
  const TOTAL = 3;
  const HAUT = 0.9, RAIDE = -0.75;
  const SCENARIO = [
    { cibles: [[MOY, 0]], duree: 0 },
    { cibles: [[0.97, 0], [0.15, 0], [HAUT, 0]], duree: 800 },
    { cibles: [[HAUT, -0.95], [HAUT, 0.3], [HAUT, RAIDE]], duree: 800 },
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
  const pas = (v) => Math.round(v * 100) / 100;
  function regler(k, v) {
    arreter();
    touche = k;
    if (k === 'b0') b0 = borner(v, 0, 1);
    else b1 = borner(v, -1, 1);
  }
  function auClavier(ev) {
    if (ev.key === 'Escape') { ev.currentTarget.blur(); touche = null; }
  }
  function versR(ev) {
    ev.stopPropagation();
    ev.currentTarget.blur();
    aller(TOTAL);
  }

  // ---- Le dessin. Les deux axes vont de 0 à 1; le cadre déborde un peu
  // (de −0,1 à 1,1 et de −0,13 à 1,13) pour les grappes étalées.
  const DX = [-0.1, 1.1], DY = [-0.13, 1.13];
  const X0 = 124, X1 = 632, YB = 352, YT = 14;
  const x = (v) => X0 + ((v - DX[0]) / (DX[1] - DX[0])) * (X1 - X0);
  const y = (v) => YB - ((v - DY[0]) / (DY[1] - DY[0])) * (YB - YT);
  const xInv = (px) => DX[0] + ((px - X0) / (X1 - X0)) * (DX[1] - DX[0]);
  const yInv = (py) => DY[0] + ((YB - py) / (YB - YT)) * (DY[1] - DY[0]);

  // Les repères des axes : la valeur, puis le libellé du codebook (VARS).
  const nb2 = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 2 });
  // Un libellé sur deux lignes : au premier espace si le reste tient, sinon au milieu.
  const deuxLignes = (t) => {
    const i = t.indexOf(' ');
    if (i > 0 && t.length - i - 1 <= 15) return [t.slice(0, i), t.slice(i + 1)];
    const m = t.lastIndexOf(' ', Math.ceil(t.length / 2));
    return [t.slice(0, m), t.slice(m + 1)];
  };
  const REP_X = VARS.x.valeurs.map((v, i) => ({ v, lignes: deuxLignes(VARS.x.niveaux[i]) }));
  // En y, « satisfait » est dans le titre de l'axe : on garde le début du libellé.
  const REP_Y = VARS.y.valeurs.map((v, i) => ({ v, court: VARS.y.niveaux[i].replace(/ satisfait$/, '') }));

  // Le bout de la droite visible à droite : à 1, ou là où elle sort de 0 à 1.
  const xFin = $derived.by(() => {
    const y1 = b0 + b1;
    if (y1 >= 0 && y1 <= 1) return 1;
    return borner(((y1 < 0 ? 0 : 1) - b0) / b1, 0, 1);
  });
  const xPoignee = $derived(prise?.k === 'b1' ? prise.xh : Math.max(xFin, 0.06));
  // Aux extrêmes (β0 = 1 et β1 > 0, par exemple), la poignée reste dans le cadre.
  const yPoignee = $derived(borner(b0 + b1 * xPoignee, -0.1, 1.1));

  // ---- Les poignées, tirées à la souris ou au doigt.
  function versDonnee(ev) {
    const pt = svg.createSVGPoint();
    pt.x = ev.clientX; pt.y = ev.clientY;
    const q = pt.matrixTransform(svg.getScreenCTM().inverse());
    return { x: xInv(q.x), y: borner(yInv(q.y), 0, 1) };
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
      prise = { k, xh: k === 'b1' ? Math.max(xFin, 0.06) : 0 };
      touche = k;
      el.setPointerCapture(ev.pointerId);
    };
    const bouger = (ev) => {
      if (!prise) return;
      const d = versDonnee(ev);
      if (prise.k === 'b0') b0 = pas(d.y);
      else b1 = borner(pas((d.y - b0) / prise.xh), -1, 1);
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
  const aPlat = $derived(Math.abs(b1) < 0.005 && Math.abs(b0 - MOY) < 0.005);
  // La barre part de zéro; le bord droit vaut 2,5 fois le minimum.
  const ECHELLE = 2.5 * MIN;
  const largeur = $derived(Math.min(d / ECHELLE, 1) * 100);
  const deborde = $derived(d > ECHELLE);
  const actif = $derived(touche ?? (e === 1 ? 'b0' : e === 2 ? 'b1' : null));

  const nb = (v, k = 0) => v.toLocaleString('fr-CA', { minimumFractionDigits: k, maximumFractionDigits: k }).replace(/\s/g, ' ');
  const pct = (v) => (v < 9.95 ? nb(v, 1) : nb(v, 0));
  const T_MOY = `la moyenne : ${nb(MOY, 2)}`;
  const T_R = 'la droite de R';
</script>

<div class="visuel reglable" bind:this={hote} data-temps={e}>
  <EquationDroite {b0} {b1} {actif} />

  <div class="corps">
    <svg bind:this={svg} viewBox="0 0 640 448" role="img" aria-label="Nuage de points de notre sondage, {nb(n)} personnes&#8239;: la satisfaction envers la démocratie, de 0 à 1, selon le populisme, de 0 à 1. Une droite qu’on règle avec son ordonnée à l’origine et sa pente. La droite de R, {nb(R0, 2)} moins {nb(-R1, 2)} fois populisme, est celle dont le total des carrés est le plus petit.">
      <defs>
        <clipPath id="dr-cadre"><rect x={X0} y={YT} width={X1 - X0} height={YB - YT} /></clipPath>
      </defs>

      <!-- Les axes, avec les libellés du codebook. -->
      <line x1={X0} y1={YB} x2={X1} y2={YB} class="axe" />
      <line x1={X0} y1={YB} x2={X0} y2={YT} class="axe" />
      {#each REP_X as r}
        <line x1={x(r.v)} y1={YB} x2={x(r.v)} y2={YB + 7} class="axe" />
        <text x={x(r.v)} y={YB + 25} class="tick">{nb2(r.v)}</text>
        <text x={x(r.v)} y={YB + 43} class="niveau">{r.lignes[0]}</text>
        <text x={x(r.v)} y={YB + 57} class="niveau">{r.lignes[1]}</text>
      {/each}
      {#each REP_Y as r}
        <line x1={X0 - 7} y1={y(r.v)} x2={X0} y2={y(r.v)} class="axe" />
        <text x={X0 - 12} y={y(r.v) + 1} class="tick fin">{nb2(r.v)}</text>
        <text x={X0 - 12} y={y(r.v) + 17} class="niveau fin">{r.court}</text>
      {/each}
      <text x={(X1 + X0) / 2} y={YB + 86} class="titre-axe">{VARS.x.nom}</text>
      <text transform="translate(18 {(YB + YT) / 2}) rotate(-90)" class="titre-axe">{VARS.y.nom}</text>

      <!-- Les 564 personnes : dessinées une fois, elles ne dépendent pas de la droite. -->
      <g class="nuage">
        {#each PTS as p}<circle cx={x(p.jx)} cy={y(p.jy)} r="3.3" />{/each}
      </g>

      <!-- La droite, de 0 à 1, coupée au cadre. -->
      <g clip-path="url(#dr-cadre)">
        <line x1={x(0)} y1={y(b0)} x2={x(1)} y2={y(b0 + b1)} class="droite" class:min={auMinimum} />
      </g>

      <!-- Les étiquettes, posées dans les couloirs vides entre les rangées de grappes. -->
      {#if aPlat}
        <text x={x(1.08)} y={y(0.47)} class="ecrit fin">{T_MOY}</text>
      {/if}
      {#if auMinimum}
        <text x={x(0.12)} y={y(0.8)} class="ecrit rouge">{T_R}</text>
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
      <text x={x(0) + 18} y={y(b0) + (b0 > 0.9 ? 28 : -14)} class="nom-b" class:on={actif === 'b0'}>β0</text>
    </svg>

    <div class="cmd" bind:this={ctrl}>
      <div class="curseur" class:on={actif === 'b0'}>
        <span class="lib"><b>β0</b> ordonnée à l’origine</span>
        <input type="range" min="0" max="1" step="0.01" value={b0} aria-label="β0, l’ordonnée à l’origine"
          oninput={(ev) => regler('b0', +ev.currentTarget.value)}
          onkeydown={auClavier} />
        <span class="bornes"><span>0</span><span>1</span></span>
      </div>
      <div class="curseur" class:on={actif === 'b1'}>
        <span class="lib"><b>β1</b> pente</span>
        <input type="range" min="-1" max="1" step="0.01" value={b1} aria-label="β1, la pente"
          oninput={(ev) => regler('b1', +ev.currentTarget.value)}
          onkeydown={auClavier} />
        <span class="bornes"><span>−1</span><span>0</span><span>+1</span></span>
      </div>

      <div class="dist" class:min={auMinimum}>
        <span class="lib">total des carrés</span>
        <span class="valeur">{nb(d, 1)}</span>
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
  .niveau { font-family: var(--dk-mono); font-size: 12.5px; text-anchor: middle; fill: var(--dk-gris); }
  .niveau.fin { text-anchor: end; }

  .nuage circle { fill: var(--dk-accent); opacity: 0.22; }

  .droite { stroke: var(--dk-encre); stroke-width: 5; transition: stroke 0.3s; }
  .droite.min { stroke: var(--dk-accent); }

  .ecrit { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 5px; }
  .ecrit.fin { text-anchor: end; }
  .ecrit.rouge { fill: var(--dk-accent); font-size: 18px; }

  .poignee { cursor: grab; touch-action: none; }
  .poignee .prise { fill: transparent; }
  .p0 { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }
  .p1 { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3.5; }
  .poignee.on .p1 { stroke: var(--dk-accent); }
  .poignee.on .p0 { stroke: var(--dk-encre); }
  .nom-b { font-family: var(--dk-mono); font-size: 18px; font-weight: 600; fill: var(--dk-gris); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 5px; }
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
