<script>
  /**
   * « Lire la pente » : ce que veut dire β1 = −0,37, sur la droite de R
   * (notre sondage, NOTRE.coefs de src/lib/data/seance7.js : 0,83 et
   * −0,37). Pas de nuage ici : la droite seule, sur les axes de 0 à 1, avec
   * les libellés du codebook (VARS).
   *
   * Toutes les variables du cours vont de 0 à 1 : la pente se lit donc « de
   * 0 à 1 », d'un bout à l'autre de l'échelle. On compare deux positions sur
   * la droite (fortement en désaccord et fortement en accord), pas une
   * personne qui « change d'idée » : la régression compare des gens.
   *
   * Temps :
   *   0  la droite de R et son équation;
   *   1  la grande marche, de 0 à 1 : la droite descend de 0,37 (au-dessus
   *      de la droite);
   *   2  la phrase : « De fortement en désaccord à fortement en accord, la
   *      satisfaction baisse de 0,37 sur une échelle de 0 à 1. »;
   *   3  un échelon de l'échelle (0,25) : quatre petites marches sous la
   *      droite, chacune d'environ −0,09 (0,25 × −0,37 = −0,093);
   *   4  la constante : à 0 (fortement en désaccord), la droite prédit
   *      0,83, une satisfaction possible sur l'échelle de 0 à 1;
   *   5  la recette générale, sur fond d'encre : « x passe de 0 à 1 → y
   *      change de β1 », la flèche se lit « est associé à » (pas « cause »),
   *      et « toutes choses égales par ailleurs » annoncé pour la séance 8.
   */
  import { brancherTemps } from '../temps.js';
  import { NOTRE, VARS } from '$lib/data/seance7.js';
  import EquationDroite from './EquationDroite.svelte';

  const R0 = NOTRE.coefs[0].b;
  const R1 = NOTRE.coefs[1].b;
  const TOTAL = 5;

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: TOTAL, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Format québécois, vrai signe moins (U+2212).
  const f = (v, d = 2) => (v < 0 ? '−' : '') + Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const nb2 = (v) => v.toLocaleString('fr-CA', { maximumFractionDigits: 2 });
  const B0 = f(R0);
  const B1 = f(R1);
  const BAISSE = f(-R1); // « baisse de 0,37 »
  const ECHELON = 0.25;
  const B_ECHELON = f(R1 * ECHELON); // −0,09
  const BAS = VARS.x.niveaux[0].toLowerCase();
  const HAUT = VARS.x.niveaux.at(-1).toLowerCase();

  // Le dessin : les deux axes de 0 à 1 (un peu de marge en x).
  const DX = [-0.05, 1.05];
  const X0 = 124, X1 = 628, YB = 340, YT = 22;
  const x = (v) => X0 + ((v - DX[0]) / (DX[1] - DX[0])) * (X1 - X0);
  const y = (v) => YB - v * (YB - YT);
  const pred = (v) => R0 + R1 * v;

  // Les repères : la valeur, puis le libellé (sur deux lignes en x).
  const deuxLignes = (t) => {
    const i = t.indexOf(' ');
    if (i > 0 && t.length - i - 1 <= 15) return [t.slice(0, i), t.slice(i + 1)];
    const m = t.lastIndexOf(' ', Math.ceil(t.length / 2));
    return [t.slice(0, m), t.slice(m + 1)];
  };
  const REP_X = VARS.x.valeurs.map((v, i) => ({ v, lignes: deuxLignes(VARS.x.niveaux[i]) }));
  const REP_Y = VARS.y.valeurs.map((v, i) => ({ v, court: VARS.y.niveaux[i].replace(/ satisfait$/, '') }));

  // La grande marche (au-dessus de la droite) et les petites (en dessous).
  const GRANDE = `M ${x(0)} ${y(pred(0))} H ${x(1)} V ${y(pred(1))}`;
  const PETITES = [0, 0.25, 0.5, 0.75];
  const petite = (a) => `M ${x(a)} ${y(pred(a))} V ${y(pred(a + ECHELON))} H ${x(a + ECHELON)}`;
  const LUE = 0.5; // la petite marche qu'on lit : de 0,5 à 0,75

  // Le rôle de chaque case de l'équation, selon le temps.
  const actif = $derived(e >= 1 && e <= 3 ? 'b1' : e === 4 ? 'b0' : null);
</script>

<div class="visuel lire-pente" bind:this={hote} data-temps={e}>
  <EquationDroite b0={R0} b1={R1} {actif} />

  <div class="corps">
    <svg viewBox="0 0 640 432" role="img" aria-label="La droite de R&#8239;: satisfaction égale {B0} moins {BAISSE} fois populisme. De {BAS} à {HAUT}, de 0 à 1, la droite descend de {BAISSE}. Un échelon de 0,25 vaut environ {B_ECHELON}. À 0, {BAS}, la droite prédit {B0}.">
      <!-- Les axes, avec les libellés du codebook. -->
      <line x1={X0} y1={YB} x2={X1} y2={YB} class="axe" />
      <line x1={X0} y1={YB} x2={X0} y2={YT - 8} class="axe" />
      {#each REP_X as r}
        <line x1={x(r.v)} y1={YB} x2={x(r.v)} y2={YB + 7} class="axe" />
        <text x={x(r.v)} y={YB + 25} class="tick" class:fort={(e === 1 || e === 2) && (r.v === 0 || r.v === 1)}>{nb2(r.v)}</text>
        <text x={x(r.v)} y={YB + 43} class="niveau">{r.lignes[0]}</text>
        <text x={x(r.v)} y={YB + 57} class="niveau">{r.lignes[1]}</text>
      {/each}
      {#each REP_Y as r}
        <line x1={X0 - 7} y1={y(r.v)} x2={X0} y2={y(r.v)} class="axe" />
        <text x={X0 - 12} y={y(r.v) + 1} class="tick fin">{nb2(r.v)}</text>
        <text x={X0 - 12} y={y(r.v) + 17} class="niveau fin">{r.court}</text>
      {/each}
      <text x={(X0 + X1) / 2} y={YB + 86} class="titre-axe">{VARS.x.nom}</text>
      <text transform="translate(18 {(YB + YT) / 2}) rotate(-90)" class="titre-axe">satisfaction prédite</text>

      <!-- La droite de R, de 0 à 1. -->
      <line x1={x(0)} y1={y(pred(0))} x2={x(1)} y2={y(pred(1))} class="droite" />

      <!-- 1 : la grande marche, de 0 à 1. Elle pâlit quand viennent les petites. -->
      <g class="grande" class:pale={e >= 3}>
        <path d={GRANDE} pathLength="1" class="trace" class:vu={e >= 1} style="transition-delay: {e >= 1 ? 300 : 0}ms" />
        <g class="apparait" class:vu={e >= 1} style="transition-delay: {e >= 1 ? 1100 : 0}ms">
          <text x={x(0.5)} y={y(pred(0)) - 14} class="note-m">de 0 à 1</text>
          <text x={x(1) - 14} y={y((pred(0) + pred(1)) / 2) + 8} class="note-m rouge fin">{B1}</text>
        </g>
      </g>
      <circle cx={x(1)} cy={y(pred(1))} r="9" class="pt apparait" class:vu={e >= 1 && e < 3} />

      <!-- 3 : un échelon (0,25), quatre fois, sous la droite. -->
      {#each PETITES as a, i}
        <path d={petite(a)} pathLength="1" class="trace fine" class:lue={a === LUE} class:vu={e >= 3} style="transition-delay: {e >= 3 ? 150 + i * 200 : 0}ms" />
      {/each}
      <g class="apparait" class:vu={e >= 3} style="transition-delay: {e >= 3 ? 1000 : 0}ms">
        <text x={x(LUE) - 10} y={y((pred(LUE) + pred(LUE + ECHELON)) / 2) + 7} class="note-m rouge fin petit">{B_ECHELON}</text>
        <text x={x(LUE + ECHELON / 2)} y={y(pred(LUE + ECHELON)) + 24} class="note-m petit">+0,25</text>
      </g>

      <!-- 4 : la constante, à 0. -->
      <circle cx={x(0)} cy={y(R0)} r="9" class="pt apparait" class:vu={(e >= 1 && e < 3) || e >= 4} />
      <g class="apparait" class:vu={e >= 4}>
        <circle cx={x(0)} cy={y(R0)} r="12" class="pt0" />
        <text x={x(0) + 18} y={y(R0) - 16} class="note-m debut encre">{B0}</text>
      </g>
    </svg>

    <div class="panneau">
      <p class="gros apparait" class:vu={e >= 1} style="transition-delay: {e === 1 ? 1100 : 0}ms">0 → 1&#8239;: <span class="rouge">{B1}</span></p>
      <p class="phrase apparait" class:vu={e >= 2}>De {BAS} à {HAUT}, la satisfaction baisse de {BAISSE} sur une échelle de 0 à 1.</p>
      <p class="phrase apparait" class:vu={e >= 3}>Un échelon (0,25)&#8239;: environ <b>{B_ECHELON}</b>.</p>
      <p class="phrase apparait" class:vu={e >= 4}>{VARS.x.niveaux[0]} ({VARS.x.nom} = 0)&#8239;: la droite prédit <b>{B0}</b>.</p>
      <div class="recette apparait" class:vu={e >= 5}>
        <p class="r1">x passe de 0 à 1 → y change de β1</p>
        <p class="r2">«&#8239;→&#8239;» se lit «&#8239;est associé à&#8239;», pas «&#8239;cause&#8239;»</p>
        <p class="r3">toutes choses égales par ailleurs&#8239;: séance 8</p>
      </div>
    </div>
  </div>
</div>

<style>
  .lire-pente { display: flex; flex-direction: column; gap: 0.5em; }
  .corps { display: grid; grid-template-columns: minmax(0, 1.12fr) 1fr; gap: 1.6em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 61vh; display: block; }

  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-family: var(--dk-mono); font-size: 16px; text-anchor: middle; fill: var(--dk-gris); transition: fill 0.3s; }
  .tick.fin { text-anchor: end; }
  .tick.fort { fill: var(--dk-accent); font-weight: 600; }
  .niveau { font-family: var(--dk-mono); font-size: 12.5px; text-anchor: middle; fill: var(--dk-gris); }
  .niveau.fin { text-anchor: end; }
  .titre-axe { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }

  .droite { stroke: var(--dk-encre); stroke-width: 4; }

  .trace { fill: none; stroke: var(--dk-accent); stroke-width: 4.5; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out; }
  .trace.fine { stroke-width: 2.5; opacity: 0.75; transition-duration: 0.4s; }
  .trace.fine.lue { stroke-width: 4.5; opacity: 1; }
  .trace.vu { stroke-dashoffset: 0; }
  .grande { transition: opacity 0.4s; }
  .grande.pale { opacity: 0.3; }

  .pt { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }
  .pt0 { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 3; }
  .note-m { font-family: var(--dk-mono); font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; stroke-linejoin: round; }
  .note-m.debut { text-anchor: start; }
  .note-m.fin { text-anchor: end; }
  .note-m.rouge { fill: var(--dk-accent); font-size: 24px; }
  .note-m.rouge.petit { font-size: 19px; }
  .note-m.petit { font-size: 15px; }
  .note-m.encre { font-size: 21px; }

  .apparait { opacity: 0; transition: opacity 0.45s; }
  .apparait.vu { opacity: 1; }

  .panneau { display: flex; flex-direction: column; gap: 0.7em; }
  .panneau p { margin: 0; }
  .gros { font-size: 1.3em !important; font-weight: 600; line-height: 1.2 !important; font-variant-numeric: tabular-nums; }
  .rouge { color: var(--dk-accent); }
  .phrase { font-size: 0.86em !important; line-height: 1.4 !important; }
  .phrase b { color: var(--dk-accent); }
  .recette { background: var(--dk-encre); color: var(--dk-fond); padding: 0.7em 0.9em; display: flex; flex-direction: column; gap: 0.35em; }
  .r1 { color: var(--dk-accent-clair); font-weight: 600; font-size: 1em !important; }
  .r2 { font-size: 0.8em !important; line-height: 1.4 !important; }
  .r3 { font-size: 0.76em !important; line-height: 1.4 !important; color: var(--dk-gris-2); }
</style>
