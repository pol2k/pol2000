<script>
  /**
   * Étape 2 du travail : la revue de la littérature, vue comme une partie
   * de Risk. On ne résume pas des articles un par un : on dresse la carte
   * des camps, de leurs forces, de leurs alliances et de leurs fronts.
   * Plateau schématique : votre question au centre, cinq territoires
   * autour. Cinq temps, la légende s'écrit à mesure :
   *
   *   0  le plateau vide, votre question au centre;
   *   1  les camps prennent leurs territoires (un territoire = une théorie);
   *   2  les armées : un pion = un article; on compte les forces;
   *   3  les alliances (des articles qui s'appuient) et le front (un débat);
   *   4  votre coup : vous choisissez un camp, et c'est de là que vient
   *      l'hypothèse (étape 3).
   *
   * Tout est fictif et le dit : trois camps nommés A, B, C, des pions sans
   * nom. Aucune vraie référence, aucun vrai compte de citations.
   * La question au centre est celle de la séance (scolarité → intérêt pour
   * la politique).
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 4, lire: () => e, ecrire: (v) => (e = v) });
  });

  // Les territoires (viewBox 640 × 440). camp : a, b, c.
  const TERR = [
    { camp: 'a', pts: '40,40 230,30 260,120 200,190 60,170' },
    { camp: 'a', pts: '60,170 200,190 220,280 150,400 30,360' },
    { camp: 'b', pts: '260,120 230,30 450,40 600,70 560,180 400,170' },
    { camp: 'b', pts: '400,170 560,180 610,300 470,330 380,260' },
    { camp: 'c', pts: '220,280 380,260 470,330 430,420 150,400' }
  ];
  const CENTRE = '200,190 260,120 400,170 380,260 220,280';

  // Les camps : lettre, position de l'étiquette, ce qu'ils répondent.
  const CAMPS = [
    { camp: 'a', x: 135, y: 82, dit: '« oui »' },
    { camp: 'b', x: 500, y: 92, dit: '« non »' },
    { camp: 'c', x: 290, y: 326, dit: '« ça dépend »' }
  ];

  // Les pions (un article chacun). Le camp A est le plus fort.
  const PIONS = [
    { camp: 'a', x: 95, y: 145 }, { camp: 'a', x: 130, y: 145 }, { camp: 'a', x: 165, y: 145 },
    { camp: 'a', x: 85, y: 255 }, { camp: 'a', x: 120, y: 255 }, { camp: 'a', x: 100, y: 295 },
    { camp: 'b', x: 450, y: 145 }, { camp: 'b', x: 485, y: 145 },
    { camp: 'b', x: 500, y: 240 },
    { camp: 'c', x: 360, y: 385 }, { camp: 'c', x: 395, y: 385 }
  ];

  const LEGENDE = [
    { k: 'terr', t: 'un territoire', s: 'une théorie' },
    { k: 'pion', t: 'un pion', s: 'un article' },
    { k: 'alli', t: 'une alliance', s: 'des articles qui s’appuient' },
    { k: 'front', t: 'un front', s: 'un débat' },
    { k: 'coup', t: 'votre coup', s: 'votre hypothèse' }
  ];
  // Le temps où chaque ligne de la légende arrive.
  const QUAND = [1, 2, 3, 3, 4];
</script>

<div class="visuel tm-risk" bind:this={hote}>
  <svg viewBox="0 0 640 440" role="img" aria-label="Plateau schématique : votre question au centre, entourée de trois camps théoriques fictifs (A, B, C) qui tiennent des territoires. Des pions représentent les articles, des lignes les alliances, une ligne pointillée le front d'un débat.">
    <defs>
      <pattern id="tm-hachures" width="10" height="10" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
        <rect width="10" height="10" class="tm-hach-fond" />
        <line x1="0" y1="0" x2="0" y2="10" class="tm-hach" />
      </pattern>
    </defs>

    {#each TERR as t, i}
      <polygon points={t.pts} class="tm-terr tm-{t.camp}" class:tm-pris={e >= 1} style="transition-delay: {i * 90}ms" />
    {/each}
    <polygon points={CENTRE} class="tm-centre" />
    <text x="318" y="190" class="tm-centre-t">scolarité →</text>
    <text x="318" y="212" class="tm-centre-t">intérêt&#8239;?</text>
    <text x="318" y="240" class="tm-centre-s">votre question</text>

    {#each CAMPS as c}
      <g class="tm-camp tm-{c.camp}" class:tm-on={e >= 1}>
        <text x={c.x} y={c.y} class="tm-lettre">{c.camp.toUpperCase()}</text>
        <text x={c.x} y={c.y + 24} class="tm-dit">{c.dit}</text>
      </g>
    {/each}

    <!-- Les alliances : A et C s'appuient. Le front : A contre B. -->
    <g class="tm-trait-g" class:tm-on={e >= 3}>
      <path d="M 112 300 C 150 380, 250 400, 346 388" class="tm-alliance tm-dessous" pathLength="1" />
      <path d="M 112 300 C 150 380, 250 400, 346 388" class="tm-alliance" pathLength="1" />
      <path d="M 238 34 L 252 56 L 240 76 L 256 98 L 246 116" class="tm-front" />
      <text x="262" y="30" class="tm-front-t">le débat</text>
    </g>

    {#each PIONS as p, i}
      <rect x={p.x - 11} y={p.y - 11} width="22" height="22" class="tm-pion tm-{p.camp}" class:tm-on={e >= 2} style="transition-delay: {e >= 2 ? i * 60 : 0}ms" />
    {/each}

    <!-- Votre coup : de la question vers le camp A. -->
    <g class="tm-coup" class:tm-on={e >= 4}>
      <path d="M 282 178 L 222 140" class="tm-fleche" pathLength="1" />
      <polygon points="210,133 232,136 222,152" class="tm-pointe" />
    </g>
  </svg>

  <div class="tm-leg">
    {#each LEGENDE as l, i}
      <div class="tm-leg-l tm-leg-{l.k}" class:tm-on={e >= QUAND[i]} class:tm-dernier={e === QUAND[i]}>
        <span class="tm-glyphe" aria-hidden="true"></span>
        <span class="tm-leg-t"><b>{l.t}</b><span>= {l.s}</span></span>
      </div>
    {/each}
    <p class="tm-leg-note">Schéma. Camps et articles fictifs.</p>
  </div>
</div>

<style>
  .tm-risk { display: grid; grid-template-columns: 1.65fr 1fr; gap: 1.8em; align-items: center; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }

  .tm-terr { fill: var(--dk-fond); stroke: var(--dk-gris-2); stroke-width: 2.5; stroke-linejoin: round; transition: fill 0.5s, stroke 0.5s; }
  .tm-terr.tm-pris { stroke: var(--dk-fond); stroke-width: 4; }
  .tm-terr.tm-a.tm-pris { fill: var(--dk-encre); }
  .tm-terr.tm-b.tm-pris { fill: var(--dk-accent); }
  .tm-terr.tm-c.tm-pris { fill: url(#tm-hachures); }
  .tm-hach-fond { fill: var(--dk-fond-2); }
  .tm-hach { stroke: var(--dk-gris-2); stroke-width: 4; }
  .tm-centre { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .tm-centre-t { font-size: 15px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .tm-centre-s { font-size: 13px; text-anchor: middle; fill: var(--dk-gris); letter-spacing: 0.08em; }

  .tm-camp { opacity: 0; transition: opacity 0.5s 0.3s; }
  .tm-camp.tm-on { opacity: 1; }
  .tm-lettre { font-size: 30px; font-weight: 600; text-anchor: middle; }
  .tm-dit { font-size: 15px; text-anchor: middle; }
  .tm-camp.tm-a text, .tm-camp.tm-b text { fill: var(--dk-fond); }
  .tm-camp.tm-c text { fill: var(--dk-encre); paint-order: stroke; stroke: var(--dk-fond-2); stroke-width: 5px; }

  .tm-pion { stroke-width: 3; opacity: 0; transform: translateY(-30px); transform-box: fill-box; transition: opacity 0.3s, transform 0.4s cubic-bezier(0.34, 1.6, 0.64, 1); }
  .tm-pion.tm-on { opacity: 1; transform: none; }
  .tm-pion.tm-a { fill: var(--dk-fond); stroke: var(--dk-fond); }
  .tm-pion.tm-b { fill: var(--dk-fond); stroke: var(--dk-fond); }
  .tm-pion.tm-c { fill: var(--dk-encre); stroke: var(--dk-fond-2); }

  .tm-trait-g { opacity: 0; transition: opacity 0.3s; }
  .tm-trait-g.tm-on { opacity: 1; }
  .tm-alliance { fill: none; stroke: var(--dk-fond); stroke-width: 4; stroke-linecap: square; stroke-dasharray: 1; stroke-dashoffset: 1; }
  .tm-alliance.tm-dessous { stroke: var(--dk-encre); stroke-width: 10; }
  .tm-trait-g.tm-on .tm-alliance { animation: tm-trace 0.9s 0.1s ease-out forwards; }
  .tm-front { fill: none; stroke: var(--dk-fond); stroke-width: 5; stroke-dasharray: 7 5; }
  .tm-front-t { font-size: 14px; font-weight: 600; fill: var(--dk-accent); }

  .tm-coup { opacity: 0; transition: opacity 0.2s; }
  .tm-coup.tm-on { opacity: 1; }
  .tm-fleche { fill: none; stroke: var(--dk-accent); stroke-width: 6; stroke-dasharray: 1; stroke-dashoffset: 1; }
  .tm-coup.tm-on .tm-fleche { animation: tm-trace 0.5s ease-out forwards; }
  .tm-pointe { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 2; }

  .tm-leg { display: flex; flex-direction: column; gap: 0.7em; }
  .tm-leg-l { display: grid; grid-template-columns: 2.2em 1fr; align-items: center; gap: 0.8em; opacity: 0.15; transition: opacity 0.4s; }
  .tm-leg-l.tm-on { opacity: 1; }
  .tm-leg-t { display: flex; flex-direction: column; line-height: 1.25; }
  .tm-leg-t b { font-size: 1.05em; font-weight: 600; }
  .tm-leg-t span { font-size: 0.9em; color: var(--dk-gris); }
  .tm-dernier .tm-leg-t span { color: var(--dk-accent); font-weight: 600; }
  .tm-glyphe { display: block; width: 2.2em; height: 1.5em; box-sizing: border-box; }
  .tm-leg-terr .tm-glyphe { background: var(--dk-encre); clip-path: polygon(0 20%, 70% 0, 100% 45%, 80% 100%, 10% 90%); }
  .tm-leg-pion .tm-glyphe { width: 1.1em; height: 1.1em; margin: 0 auto; background: var(--dk-fond); border: 3px solid var(--dk-encre); }
  .tm-leg-alli .tm-glyphe { height: 0.55em; background: var(--dk-fond); border: 3px solid var(--dk-encre); }
  .tm-leg-front .tm-glyphe { height: 0; border-top: 5px dashed var(--dk-encre); }
  .tm-leg-coup .tm-glyphe { height: 0; border-top: 6px solid var(--dk-accent); position: relative; }
  .tm-leg-coup .tm-glyphe::after { content: ''; position: absolute; right: -0.2em; top: calc(-0.4em - 3px); border-left: 0.6em solid var(--dk-accent); border-top: 0.4em solid transparent; border-bottom: 0.4em solid transparent; }
  .tm-leg-note { margin: 0.4em 0 0; font-size: 0.6em; letter-spacing: 0.05em; color: var(--dk-gris); }

  @keyframes tm-trace { to { stroke-dashoffset: 0; } }
  @media (prefers-reduced-motion: reduce) {
    .tm-terr, .tm-camp, .tm-pion, .tm-trait-g, .tm-coup, .tm-leg-l { transition: none; }
    .tm-trait-g.tm-on .tm-alliance, .tm-coup.tm-on .tm-fleche { animation: none; stroke-dashoffset: 0; }
  }
</style>
