<script>
  /**
   * Une variable qui change beaucoup la pente : savoir le nom de la
   * gouverneure générale du Canada (CES 2025, pendant la campagne :
   * « What is the name of the Governor-General of Canada? », Mary Simon).
   * Même dessin que l'âge (M8Pente) : les mêmes points, les mêmes axes.
   * Puis le piège : la scolarité mène à le savoir, c'est un descendant de
   * X. Règle 1 d'Arel-Bundock (M8DeuxRegles) : on ne la contrôle pas.
   * Aucune variable de la CES d'avant la scolarité ne change autant la
   * pente (outils/seance8_bruit.R).
   *
   *   0  la droite de la scolarité seule, et la question;
   *   1  « sait » entre dans le modèle : la droite glisse (celle de qui ne
   *      sait pas), la pente baisse beaucoup;
   *   2  la droite de qui sait : parallèle, la même pente;
   *   3  le piège : scolarité → sait son nom. Un descendant.
   *
   * Tout vient de SAVOIR et POINTS (src/lib/data/seance8_bruit.js).
   */
  import { Tween } from 'svelte/motion';
  import { cubicInOut } from 'svelte/easing';
  import { brancherTemps } from '../temps.js';
  import { PARALLELES as P } from '$lib/data/seance8.js';
  import { SAVOIR as A, POINTS } from '$lib/data/seance8_bruit.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const lent = () => typeof window !== 'undefined' && !window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const L0 = A.lignes[0];
  const ligne = new Tween([A.seule.b0, A.seule.b1], { duration: 1000, easing: cubicInOut });
  $effect(() => {
    const d = e >= 1 ? L0 : A.seule;
    ligne.set([d.b0, d.b1], { duration: e === 0 || !lent() ? 0 : 1000 });
  });

  const f = (v, d = 2) => Math.abs(v).toLocaleString('fr-CA', { minimumFractionDigits: d, maximumFractionDigits: d });
  const sg = (v) => (v < 0 ? '−' : '+') + f(v);
  // Les mêmes axes que M8Paralleles.
  const X0 = 200, LX = 580, Y0 = 452, LY = 400;
  const px = (x) => X0 + x * LX;
  const py = (y) => Y0 - y * LY;
  const AX = X0 - 50;
  // Les deux ordonnées à l'origine sont proches ici : pas de flèche, les
  // deux valeurs s'écartent l'une de l'autre.
  const SERRE = Math.abs(A.seule.b0 - A.avec.b0) * 400 < 60;
  const PAN = 990; // la colonne de droite
  const NIV = ['Secondaire non terminé', 'Secondaire', 'Collégial', 'Université, 1er cycle', 'Maîtrise, doctorat'];
  const PTS = P.points.filter((p, i) => POINTS[i].m === 1);
  const b0 = $derived(ligne.current[0]);
  const b1 = $derived(ligne.current[1]);
  // La pente écrite sur chaque droite d'âge, le long du trait.
  const XP = 0.6;
  const angle = (-Math.atan2(A.avec.b1 * LY, LX) * 180) / Math.PI;
</script>

<div class="visuel m8a" bind:this={hote}>
  <svg viewBox="0 0 1200 560" role="img" aria-label="Notre sondage : la droite de la scolarité seule a une pente de {sg(A.seule.b1)}. La question : quel est le nom de la gouverneure générale du Canada ? Avec « sait son nom » dans le modèle, la pente tombe à {sg(A.avec.b1)}. Deux droites parallèles, sait et ne sait pas. Mais la scolarité mène à le savoir : c'est un descendant, on ne le contrôle pas.">
    <!-- Axes -->
    <line x1={AX} y1={Y0 + 10} x2={X0 + LX + 40} y2={Y0 + 10} class="axe" />
    <line x1={AX} y1={Y0 + 10} x2={AX} y2={py(1) - 6} class="axe" />
    {#each [0, 1] as v}
      <text x={AX - 12} y={py(v) + 7} class="tick fin">{f(v, 0)}</text>
    {/each}
    <text x={AX} y={py(1) - 22} class="titre-axe">intérêt pour la politique</text>
    {#each NIV as n, i}
      <text x={px(i / 4)} y={Y0 + 38} class="niv">{#each n.split(/, | (?=non)/) as l, k}<tspan x={px(i / 4)} dy={k ? 20 : 0}>{l}</tspan>{/each}</text>
    {/each}

    <!-- Les personnes -->
    {#each PTS as p}
      <circle cx={px(p.jx)} cy={py(p.jy)} r="3.2" class="pt" />
    {/each}

    <!-- 2 : une droite par âge -->
    {#each A.lignes.slice(1) as l, i}
      <line x1={px(0)} y1={py(l.b0)} x2={px(1)} y2={py(l.b0 + l.b1)} pathLength="1" class="dr-age trace" class:vu={e >= 2} style="transition-delay: {e >= 2 ? i * 0.25 : 0}s" />
      <text x={px(1) + 22} y={py(l.b0 + l.b1) + 8} class="lab rouge etape" class:vu={e >= 2}>{l.nom}</text>
    {/each}

    <!-- 2 : la pente, sur chaque droite : la même -->
    {#each A.lignes as l, i}
      {@const x = px(XP)}
      {@const yy = py(l.b0 + l.b1 * XP) - 12}
      <text x={x} y={yy} transform="rotate({angle} {x} {yy})" class="pente-l etape" class:vu={e >= 2} style="transition-delay: {e >= 2 ? 0.6 + i * 0.25 : 0}s">pente {sg(l.b1)}</text>
    {/each}

    <!-- 1 : l'ancienne droite, en pointillé -->
    <g class="etape" class:vu={e >= 1}>
      <line x1={px(0)} y1={py(A.seule.b0)} x2={px(1)} y2={py(A.seule.b0 + A.seule.b1)} class="fantome" />
      <circle cx={AX} cy={py(A.seule.b0)} r="7" class="ord-f" />
    </g>

    <!-- La droite : seule, puis avec l'âge -->
    <line x1={AX} y1={py(b0)} x2={px(0)} y2={py(b0)} class="repere" class:rouge-s={e >= 1} />
    <line x1={px(0)} y1={py(b0)} x2={px(1)} y2={py(b0 + b1)} class="dr" class:dr-r={e >= 1} />
    <circle cx={AX} cy={py(b0)} r="9" class="ord" class:ord-r={e >= 1} />

    <!-- L'ordonnée à l'origine, sur l'axe -->
    <text x={AX - 16} y={py(A.seule.b0) - 58} class="cap fin">ordonnée</text>
    <text x={AX - 16} y={py(A.seule.b0) - 34} class="cap fin">à l’origine</text>
    <text x={AX - 16} y={py(A.seule.b0) + 8 - (SERRE && e >= 1 ? 14 : 0)} class="val fin" class:pale={e >= 1}>{f(A.seule.b0)}</text>
    <g class="etape" class:vu={e >= 1}>
      {#if !SERRE}<line x1={AX - 40} y1={py(A.seule.b0) + 18} x2={AX - 40} y2={py(A.avec.b0) - 30} class="fl" />
      <polygon points="{AX - 40},{py(A.avec.b0) - 18} {AX - 48},{py(A.avec.b0) - 32} {AX - 32},{py(A.avec.b0) - 32}" class="tete" />{/if}
      <text x={AX - 16} y={py(A.avec.b0) + 8 + (SERRE ? 14 : 0)} class="val fin rouge">{f(A.avec.b0)}</text>
    </g>

    <!-- Au bout des droites -->
    <text x={px(1) + 22} y={py(A.seule.b0 + A.seule.b1) + 8} class="lab" class:pale={e >= 1} class:cache={e >= 2}>{e === 0 ? 'scolarité seule' : 'seule'}</text>
    <g class="etape" class:vu={e >= 1}>
      <text x={px(1) + 22} y={py(L0.b0 + L0.b1) + 8} class="lab rouge">{L0.nom}</text>
    </g>

    <!-- À droite : la question -->
    <g>
      <text x={PAN} y="40" class="q-eti">LA QUESTION</text>
      <text x={PAN} y="70" class="q-t">Quel est le nom</text>
      <text x={PAN} y="94" class="q-t">de la gouverneure</text>
      <text x={PAN} y="118" class="q-t">générale du Canada ?</text>
      <text x={PAN} y="150" class="q-r">{Math.round(A.part * 100)} % disent Mary Simon</text>
    </g>

    <!-- À droite : la pente -->
    <g class="pan">
      <text x={PAN} y="220" class="pan-nom">pente</text>
      <text x={PAN} y="262" class="pan-val" class:barre={e >= 1}>{sg(A.seule.b1)}</text>
      <g class="etape" class:vu={e >= 1}>
        <text x={PAN} y="310" class="pan-val rouge">{sg(A.avec.b1)}</text>
        <text x={PAN} y="342" class="pan-nom">avec « sait »</text>
      </g>
    </g>

    <!-- 3 : le piège -->
    <g class="etape" class:vu={e >= 3}>
      <rect x={PAN - 14} y="380" width="222" height="160" class="piege-fond" />
      <text x={PAN} y="412" class="piege-t">scolarité</text>
      <text x={PAN + 6} y="442" class="piege-f">↓</text>
      <text x={PAN} y="472" class="piege-t rouge">sait son nom</text>
      <text x={PAN} y="504" class="piege-r">un descendant de X</text>
      <text x={PAN} y="527" class="piege-r">on ne le contrôle pas</text>
    </g>

    <text x="0" y="552" class="source">Notre sondage de la séance 7 · droites : les {A.n} qui ont répondu à la question</text>
  </svg>
</div>

<style>
  .m8a { display: flex; justify-content: center; }
  svg { width: 100%; height: auto; max-height: 68vh; display: block; }
  text { font-family: var(--dk-mono); }
  .axe { stroke: var(--dk-encre); stroke-width: 2; }
  .tick { font-size: 20px; fill: var(--dk-gris); }
  .fin { text-anchor: end; }
  .titre-axe { font-size: 20px; fill: var(--dk-gris); }
  .niv { font-size: 17px; fill: var(--dk-gris); text-anchor: middle; }
  .pt { fill: var(--dk-gris-2); opacity: 0.32; }

  .dr { stroke: var(--dk-encre); stroke-width: 6; transition: stroke 0.4s; }
  .dr.dr-r { stroke: var(--dk-accent); }
  .fantome { stroke: var(--dk-gris); stroke-width: 3; stroke-dasharray: 10 8; }
  .dr-age { stroke: var(--dk-accent); stroke-width: 3.5; opacity: 0.85; }
  .repere { stroke: var(--dk-encre); stroke-width: 2; stroke-dasharray: 3 5; transition: stroke 0.4s; }
  .repere.rouge-s { stroke: var(--dk-accent); }
  .ord { fill: var(--dk-encre); stroke: var(--dk-fond); stroke-width: 3; transition: fill 0.4s; }
  .ord.ord-r { fill: var(--dk-accent); }
  .ord-f { fill: var(--dk-fond); stroke: var(--dk-gris); stroke-width: 2.5; }
  .fl { stroke: var(--dk-accent); stroke-width: 3; }
  .tete { fill: var(--dk-accent); }

  .val { font-size: 24px; font-weight: 700; fill: var(--dk-encre); transition: fill 0.4s; }
  .val.pale { fill: var(--dk-gris-2); }
  .lab { font-size: 22px; font-weight: 700; fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 7px; stroke-linejoin: round; transition: opacity 0.3s; }
  .lab.pale { fill: var(--dk-gris); font-weight: 600; }
  .lab.cache { opacity: 0; }
  .rouge, tspan.rouge { fill: var(--dk-accent); }

  .cap { font-size: 18px; fill: var(--dk-gris); }
  .pan-nom { font-size: 21px; fill: var(--dk-gris); }
  .pan-val { font-size: 34px; font-weight: 700; fill: var(--dk-encre); transition: fill 0.4s; }
  .pan-val.rouge { fill: var(--dk-accent); }
  .pan-val.barre { fill: var(--dk-gris-2); text-decoration: line-through; }

  .source { font-size: 17px; fill: var(--dk-gris); }
  .piege-fond { fill: var(--dk-fond); stroke: var(--dk-accent); stroke-width: 3; }
  .piege-t { font-size: 21px; font-weight: 700; fill: var(--dk-encre); }
  .piege-f { font-size: 22px; font-weight: 700; fill: var(--dk-accent); }
  .q-eti { font-size: 15px; letter-spacing: 0.08em; font-weight: 600; fill: var(--dk-gris); }
  .q-t { font-size: 19px; font-weight: 700; fill: var(--dk-encre); }
  .q-r { font-size: 16px; fill: var(--dk-gris); }
  .piege-r { font-size: 16px; fill: var(--dk-accent); font-weight: 600; }
  .pente-l { font-size: 19px; font-weight: 700; fill: var(--dk-accent); text-anchor: middle; paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6px; stroke-linejoin: round; }

  .trace { stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.2s; }
  .trace.vu { stroke-dashoffset: 0; transition: stroke-dashoffset 0.7s ease-out; }
  .etape { opacity: 0; transition: opacity 0.4s; }
  .etape.vu { opacity: 1; }
  @media (prefers-reduced-motion: reduce) {
    .etape, .trace, .trace.vu, .dr, .val, .lab, .ord, .repere, .pan-val { transition: none; }
  }
</style>
