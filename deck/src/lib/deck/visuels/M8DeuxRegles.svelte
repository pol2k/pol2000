<script>
  /**
   * Les deux règles du contrôle, d'après Arel-Bundock (2021), Analyse
   * causale et méthodes quantitatives, chapitre 6 (« Graphes orientés
   * acycliques »), section « Identification causale », p. 124 à 127 :
   *
   *   Condition 1 : « Ne pas contrôler les descendants de X » (p. 124-125).
   *     Un descendant est une variable « en aval » de la cause. Son exemple :
   *     genre → occupation → salaire.
   *   Condition 2 : « Bloquer les chemins par la porte arrière » (p. 125-126).
   *     Intuitivement, « les causes de la cause ». Son exemple : la santé
   *     mentale, cause commune de l'éclatement familial et de l'itinérance.
   *
   * On garde sa numérotation et son vocabulaire (descendant, chemin par la
   * porte arrière, contrôler), sans la notation des graphes (séance 11). Les
   * variables contrôlées sont encadrées, comme dans sa figure 6.1 (p. 128).
   *
   * Les exemples suivent le fil du cours (X = scolarité, Y = intérêt pour la
   * politique). Le livre, p. 127, prend éducation → revenu individuel →
   * idéologie comme descendant; on ne reprend pas le revenu, parce que le
   * modèle de la séance (M8Escalier) le contrôle. Le descendant
   * dessiné ici est la lecture des nouvelles.
   *
   *   0  règle 1 et son schéma : scolarité → lecture des nouvelles → intérêt.
   *      Le flux (Flux.svelte) part de la scolarité par les deux chemins,
   *      direct et par la lecture : tout l'effet arrive à l'intérêt;
   *   1  on contrôle (à tort) la lecture des nouvelles : la boîte est
   *      encadrée, ses points s'arrêtent à la boîte, plus rien ne passe de
   *      la lecture à l'intérêt. Seul le flux direct arrive : une partie de
   *      l'effet de la scolarité est perdue. Verdict : ne pas la contrôler;
   *   2  règle 2 et son schéma : l'âge pousse la scolarité et l'intérêt
   *      (flux rouge), en plus du flux scolarité → intérêt;
   *   3  verdict : l'âge est encadré (contrôler), ses points s'arrêtent aux
   *      coupures, comme dans M8Intuition; le flux direct continue.
   *
   * Toutes les flèches vont de la cause vers l'effet : les points du flux
   * voyagent dans le bon sens.
   *
   * Schéma : aucune donnée.
   */
  import { brancherTemps } from '../temps.js';
  import Flux from './Flux.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  function fleche(ax, ay, bx, by, pointe = 20) {
    const dx = bx - ax, dy = by - ay, L = Math.hypot(dx, dy);
    const ux = dx / L, uy = dy / L;
    const px = bx - ux * pointe, py = by - uy * pointe;
    const nx = -uy * pointe * 0.5, ny = ux * pointe * 0.5;
    const mx = (ax + bx) / 2, my = (ay + by) / 2;
    return {
      d: `M ${ax} ${ay} L ${px} ${py}`,
      // Longueur du tracé (sans la pointe) et fraction du tracé où les
      // points s'arrêtent, juste avant la coupure dessinée au milieu.
      long: L - pointe,
      coupe: (L / 2 - 12) / (L - pointe),
      tete: `${bx},${by} ${px + nx},${py + ny} ${px - nx},${py - ny}`,
      mx, my,
      cx1: mx - uy * 20, cy1: my + ux * 20, cx2: mx + uy * 20, cy2: my - ux * 20
    };
  }

  // Les deux boîtes X et Y, mêmes dimensions dans les deux panneaux.
  const W = 220, H = 92;
  // Panneau 1 : X et Y en haut, le descendant en bas.
  const S1 = { cx: 120, cy: 70 }, I1 = { cx: 480, cy: 70 };
  const M = { cx: 300, cy: 268, w: 280, h: 104 };
  const SI1 = fleche(S1.cx + W / 2 + 6, S1.cy, I1.cx - W / 2 - 6, I1.cy);
  // Les flèches de la lecture s'arrêtent à 16 de la boîte : la place du
  // cadre « contrôlé » au temps 1.
  const SM = fleche(S1.cx + 20, S1.cy + H / 2 + 6, M.cx - 70, M.cy - M.h / 2 - 16);
  const MI = fleche(M.cx + 70, M.cy - M.h / 2 - 16, I1.cx - 20, I1.cy + H / 2 + 6);
  // Panneau 2 : la cause commune en haut, X et Y en bas.
  const A = { cx: 300, cy: 72, w: 170, h: 84 };
  const S2 = { cx: 120, cy: 268 }, I2 = { cx: 480, cy: 268 };
  const SI2 = fleche(S2.cx + W / 2 + 6, S2.cy, I2.cx - W / 2 - 6, I2.cy);
  const AS = fleche(A.cx - 50, A.cy + A.h / 2 + 6, S2.cx + 20, S2.cy - H / 2 - 6);
  const AI = fleche(A.cx + 50, A.cy + A.h / 2 + 6, I2.cx - 20, I2.cy - H / 2 - 6);

  // Même vitesse sur toutes les flèches : la durée suit la longueur.
  const VIT = 95;
  const duree = (f) => f.long / VIT;
</script>

{#snippet boite(b, nom, role)}
  <rect x={b.cx - W / 2} y={b.cy - H / 2} width={W} height={H} class="m8d-boite" />
  <text x={b.cx} y={b.cy + 2} class="m8d-nom">{nom}</text>
  <text x={b.cx} y={b.cy + 32} class="m8d-role">{role}</text>
{/snippet}

<div class="visuel m8d" bind:this={hote}>
  <div class="m8d-cols">
    <!-- Règle 1 -->
    <section class="m8d-col">
      <header class="m8d-tete">
        <span class="m8d-n">1</span>
        <div>
          <p class="m8d-regle">Ne pas contrôler un descendant de X</p>
          <p class="m8d-glose">une variable que X cause</p>
        </div>
      </header>
      <svg viewBox="0 0 600 340" role="img" aria-label="La scolarité pointe vers l’intérêt, et aussi vers la lecture des nouvelles, qui pointe vers l’intérêt. Contrôler la lecture des nouvelles arrête l’effet qui passe par elle : une partie de l’effet de la scolarité est perdue. On ne la contrôle pas.">
        <path d={SI1.d} class="m8d-fl" />
        <polygon points={SI1.tete} class="m8d-pointe" />
        <path d={SM.d} class="m8d-fl" />
        <polygon points={SM.tete} class="m8d-pointe" />
        <g class="m8d-arriere" class:m8d-coupe={e >= 1}>
          <path d={MI.d} class="m8d-fl" />
          <polygon points={MI.tete} class="m8d-pointe" />
        </g>
        <!-- Le flux : tout l'effet part de la scolarité, par les deux chemins.
             Au temps 1, la lecture contrôlée absorbe ses points. -->
        <Flux d={SI1.d} n={2} duree={duree(SI1)} r={7} />
        <Flux d={SM.d} arret={e >= 1 ? 0.96 : 1} n={2} duree={duree(SM)} r={7} />
        <Flux d={MI.d} actif={e < 1} n={2} duree={duree(MI)} r={7} />

        {@render boite(S1, 'scolarité', 'X')}
        {@render boite(I1, 'intérêt', 'Y')}
        <rect x={M.cx - M.w / 2} y={M.cy - M.h / 2} width={M.w} height={M.h} class="m8d-boite" />
        <text x={M.cx} y={M.cy - 6} class="m8d-nom m8d-petit">lecture des</text>
        <text x={M.cx} y={M.cy + 26} class="m8d-nom m8d-petit">nouvelles</text>

        <!-- 1 : la lecture contrôlée, une partie de l'effet perdue. -->
        <g class="m8d-etape" class:m8d-vu={e >= 1}>
          <rect x={M.cx - M.w / 2 - 11} y={M.cy - M.h / 2 - 11} width={M.w + 22} height={M.h + 22} class="m8d-cadre" />
          <text x={M.cx} y="142" class="m8d-perte">une partie de</text>
          <text x={M.cx} y="166" class="m8d-perte">l’effet perdue</text>
          <g transform="translate({M.cx + M.w / 2 + 11} {M.cy - M.h / 2 - 11})">
            <rect x="-22" y="-22" width="44" height="44" class="m8d-badge" />
            <path d="M -10 -10 L 10 10 M 10 -10 L -10 10" class="m8d-badge-x" />
          </g>
        </g>
      </svg>
      <p class="m8d-verdict m8d-etape" class:m8d-vu={e >= 1}><span class="m8d-non" aria-hidden="true"></span>ne pas la contrôler</p>
    </section>

    <!-- Règle 2 -->
    <section class="m8d-col m8d-etape" class:m8d-vu={e >= 2}>
      <header class="m8d-tete">
        <span class="m8d-n">2</span>
        <div>
          <p class="m8d-regle">Bloquer les chemins par la porte arrière</p>
          <p class="m8d-glose">les causes de la cause</p>
        </div>
      </header>
      <svg viewBox="0 0 600 340" role="img" aria-label="L’âge pointe vers la scolarité et vers l’intérêt : un chemin par la porte arrière. On contrôle l’âge : son effet s’arrête aux coupures, il reste l’effet de la scolarité.">
        <path d={SI2.d} class="m8d-fl" class:m8d-epais={e >= 3} />
        <polygon points={SI2.tete} class="m8d-pointe" />
        <g class="m8d-arriere" class:m8d-coupe={e >= 3}>
          <path d={AS.d} pathLength="1" class="m8d-fl m8d-rouge m8d-trace" class:m8d-vu={e >= 2} />
          <polygon points={AS.tete} class="m8d-pointe m8d-rouge-t m8d-etape m8d-tard" class:m8d-vu={e >= 2} />
          <path d={AI.d} pathLength="1" class="m8d-fl m8d-rouge m8d-trace" class:m8d-vu={e >= 2} />
          <polygon points={AI.tete} class="m8d-pointe m8d-rouge-t m8d-etape m8d-tard" class:m8d-vu={e >= 2} />
        </g>
        <Flux d={SI2.d} actif={e >= 2} n={2} duree={duree(SI2)} r={7} />
        <Flux d={AS.d} actif={e >= 2} arret={e >= 3 ? AS.coupe : 1} rouge n={2} duree={duree(AS)} r={7} />
        <Flux d={AI.d} actif={e >= 2} arret={e >= 3 ? AI.coupe : 1} rouge n={2} duree={duree(AI)} r={7} />
        {@render boite(S2, 'scolarité', 'X')}
        {@render boite(I2, 'intérêt', 'Y')}
        <rect x={A.cx - A.w / 2} y={A.cy - A.h / 2} width={A.w} height={A.h} class="m8d-boite m8d-age" />
        <text x={A.cx} y={A.cy + 10} class="m8d-nom m8d-rouge-t">âge</text>
        <g class="m8d-etape" class:m8d-vu={e >= 3}>
          <rect x={A.cx - A.w / 2 - 11} y={A.cy - A.h / 2 - 11} width={A.w + 22} height={A.h + 22} class="m8d-cadre" />
          <line x1={AS.cx1} y1={AS.cy1} x2={AS.cx2} y2={AS.cy2} class="m8d-cut" />
          <line x1={AI.cx1} y1={AI.cy1} x2={AI.cx2} y2={AI.cy2} class="m8d-cut" />
        </g>
      </svg>
      <p class="m8d-verdict m8d-etape" class:m8d-vu={e >= 3}><span class="m8d-oui" aria-hidden="true"></span>contrôler l’âge</p>
    </section>
  </div>
  <p class="m8d-cap">Arel-Bundock (2021), chapitre 6 · schéma, aucune donnée</p>
</div>

<style>
  .m8d { display: flex; flex-direction: column; gap: 0.4em; }
  .m8d-cols { display: grid; grid-template-columns: 1fr 1fr; gap: 2.6em; }
  .m8d-col { display: flex; flex-direction: column; gap: 0.5em; border-top: 2px solid var(--dk-encre); padding-top: 0.7em; }
  .m8d-tete { display: grid; grid-template-columns: auto 1fr; gap: 0.6em; align-items: start; min-height: 3em; }
  .m8d-n { font-size: 2.2em; font-weight: 700; line-height: 1; color: var(--dk-accent); }
  .m8d-regle { margin: 0; font-size: 1.05em; font-weight: 700; line-height: 1.25; }
  .m8d-glose { margin: 0.2em 0 0; font-size: 0.85em; color: var(--dk-gris); }
  .m8d-verdict { margin: 0; font-size: 1.05em; font-weight: 700; color: var(--dk-accent); text-align: center; }
  .m8d-non, .m8d-oui { display: inline-block; width: 0.8em; height: 0.8em; margin-right: 0.5em; vertical-align: -0.05em; box-sizing: border-box; }
  .m8d-non { background: var(--dk-accent); clip-path: polygon(15% 0, 50% 35%, 85% 0, 100% 15%, 65% 50%, 100% 85%, 85% 100%, 50% 65%, 15% 100%, 0 85%, 35% 50%, 0 15%); }
  .m8d-oui { border: 4px solid var(--dk-accent); outline: 2px solid var(--dk-accent); outline-offset: 3px; }
  .m8d-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }

  svg { width: 100%; height: auto; max-height: 46vh; display: block; }
  text { font-family: var(--dk-mono); }
  .m8d-boite { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: opacity 0.4s; }
  .m8d-boite.m8d-age { stroke: var(--dk-accent); }
  .m8d-badge { fill: var(--dk-accent); }
  .m8d-perte { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .m8d-badge-x { stroke: #fff; stroke-width: 5; }
  .m8d-nom { font-size: 28px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .m8d-nom.m8d-petit { font-size: 26px; }
  .m8d-role { font-size: 20px; text-anchor: middle; fill: var(--dk-gris); }

  .m8d-fl { fill: none; stroke: var(--dk-encre); stroke-width: 4; transition: stroke-width 0.4s; }
  .m8d-fl.m8d-epais { stroke-width: 7; }
  .m8d-pointe { fill: var(--dk-encre); }
  .m8d-rouge { stroke: var(--dk-accent); }
  .m8d-rouge-t { fill: var(--dk-accent); }
  .m8d-cadre { fill: none; stroke: var(--dk-accent); stroke-width: 5; }
  .m8d-cut { stroke: var(--dk-accent); stroke-width: 6; }
  .m8d-arriere { transition: opacity 0.5s; }
  .m8d-arriere.m8d-coupe { opacity: 0.35; }

  .m8d-trace { stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.8s ease-out 0.3s; }
  .m8d-trace.m8d-vu { stroke-dashoffset: 0; }
  .m8d-etape { opacity: 0; transition: opacity 0.3s; }
  .m8d-etape.m8d-vu { opacity: 1; transition: opacity 0.5s; }
  .m8d-etape.m8d-tard.m8d-vu { transition: opacity 0.3s 1s; }

  @media (prefers-reduced-motion: reduce) {
    .m8d-trace, .m8d-etape, .m8d-etape.m8d-vu, .m8d-etape.m8d-tard.m8d-vu, .m8d-arriere, .m8d-fl, .m8d-boite { transition: none; }
  }
</style>
