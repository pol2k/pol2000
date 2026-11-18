<script>
  /**
   * Condition 1 : ne pas contrôler un descendant de X (Arel-Bundock 2021,
   * p. 124-125), avec son exemple : le sexe agit sur le salaire
   * directement, et par l'occupation (les promotions). Un immeuble de
   * bureaux : un étage par occupation, et plus on monte, plus le salaire
   * est élevé.
   *
   *   0  une femme et un homme au rez-de-chaussée;
   *   1  ils montent : lui jusqu'au 3e, elle au 2e (moins de promotions).
   *      À droite, leurs salaires : l'écart total;
   *   2  « à occupation égale » : on ne compare plus qu'au même étage. Un
   *      homme du 2e étage (pointillé) à côté d'elle : un petit écart;
   *   3  l'écart des promotions a disparu de la comparaison : contrôler
   *      l'occupation, un descendant du sexe, efface une partie de l'effet.
   *
   * Schéma, aucune donnée : les longueurs des barres sont illustratives.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const ETAGES = ['commis', 'technique', 'gestion', 'direction'];
  const BAS = 520, HE = 110; // le rez-de-chaussée, la hauteur d'un étage
  const yEtage = (k) => BAS - k * HE;
  // Les salaires (barres, en pixels) : par étage, et l'écart direct à l'étage.
  const SAL = { f: 250, h: 380, h2: 290 };
  const LEG = [
    'Une femme, un homme. L’effet du sexe sur le salaire ?',
    'Elle monte moins haut. Écart total : promotions et paie.',
    '« À occupation égale » : on ne compare qu’au même étage.',
    'L’écart des promotions a disparu : un biais post-traitement.'
  ];
</script>

{#snippet personne(x, y, classe, lettre)}
  <g class="pers {classe}" style="transform: translate({x}px, {y}px)">
    <circle cx="0" cy="-74" r="15" />
    <path d="M0 -59 L0 -26 M0 -52 L-16 -36 M0 -52 L16 -36 M0 -26 L-12 0 M0 -26 L12 0" />
    <text x="0" y="-98">{lettre}</text>
  </g>
{/snippet}

<div class="visuel m11e" bind:this={hote}>
  <svg viewBox="0 0 1200 580" role="img" aria-label="Un immeuble de bureaux : plus on monte, plus le salaire est élevé. L’homme monte au troisième, la femme au deuxième. À occupation égale, au même étage, l’écart est petit : on a effacé l’écart des promotions.">
    <!-- l'immeuble -->
    {#each ETAGES as nom, k (nom)}
      <rect x="120" y={yEtage(k + 1)} width="460" height={HE} class="etage" class:egal={e >= 2 && k === 2} />
      <text x="140" y={yEtage(k + 1) + 34} class="n-etage">{nom}</text>
    {/each}
    <line x1="60" y1={BAS} x2="640" y2={BAS} class="sol" />

    <!-- l'échelle -->
    <line x1="604" y1={BAS} x2="604" y2={yEtage(4)} class="montant" />
    <line x1="634" y1={BAS} x2="634" y2={yEtage(4)} class="montant" />
    {#each Array(16) as _, i (i)}<line x1="604" y1={BAS - 14 - i * 27} x2="634" y2={BAS - 14 - i * 27} class="barreau" />{/each}

    <!-- les personnes -->
    {@render personne(330, e >= 1 ? yEtage(2) : BAS, 'f', 'F')}
    {@render personne(450, e >= 1 ? yEtage(3) : BAS, 'h', 'H')}
    {#if e >= 2}{@render personne(450, yEtage(2), 'h fantome', 'H')}{/if}

    <!-- les salaires -->
    <text x="700" y="80" class="t-sal">salaire</text>
    <g class="sal" class:vu={e >= 1}>
      <text x="700" y="150" class="lettre">H</text>
      <rect x="740" y="122" width={SAL.h} height="40" class="b-h" class:pale={e >= 2} />
      <text x="700" y="230" class="lettre f">F</text>
      <rect x="740" y="202" width={SAL.f} height="40" class="b-f" />
      <path d="M {740 + SAL.f} 182 L {740 + SAL.h} 182" class="ecart" class:pale={e >= 2} />
      <text x={740 + (SAL.f + SAL.h) / 2} y="112" class="t-ecart" class:pale={e >= 2}>écart total</text>
    </g>
    <g class="sal" class:vu={e >= 2}>
      <text x="700" y="330" class="lettre">H</text>
      <rect x="740" y="302" width={SAL.h2} height="40" class="b-h pointille" />
      <text x="700" y="410" class="lettre f">F</text>
      <rect x="740" y="382" width={SAL.f} height="40" class="b-f" />
      <path d="M {740 + SAL.f} 362 L {740 + SAL.h2} 362" class="ecart" />
      <text x="740" y="460" class="t-egal">au même étage</text>
    </g>
    <g class="sal" class:vu={e >= 3}>
      <rect x={740 + SAL.h2} y="122" width={SAL.h - SAL.h2} height="40" class="perdu" />
      <text x={740 + SAL.h + 12} y="150" class="t-perdu">perdu</text>
    </g>
  </svg>
  <p class="legende"><b>{e + 1}</b>{LEG[e]}</p>
  <p class="cap">D’après Arel-Bundock (2021), p. 125 · schéma, aucune donnée</p>
</div>

<style>
  .m11e { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.25em; }
  svg { width: 100%; max-width: 50em; height: auto; max-height: 56vh; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .etage { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; transition: fill 0.4s; }
  .etage.egal { fill: #f4d6db; }
  .n-etage { font-size: 22px; fill: var(--dk-gris); }
  .sol { stroke: var(--dk-encre); stroke-width: 5; }
  .montant { stroke: var(--dk-encre); stroke-width: 5; }
  .barreau { stroke: var(--dk-encre); stroke-width: 3; }

  .pers { transition: transform 1.4s ease-in-out; }
  .pers circle { fill: var(--dk-encre); }
  .pers path { stroke: var(--dk-encre); stroke-width: 8; stroke-linecap: round; fill: none; }
  .pers text { font-size: 26px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); }
  .pers.f circle { fill: var(--dk-accent); }
  .pers.f path { stroke: var(--dk-accent); }
  .pers.f text { fill: var(--dk-accent); }
  .pers.fantome circle { fill: none; stroke: var(--dk-gris-2); stroke-width: 4; stroke-dasharray: 6 5; }
  .pers.fantome path { stroke: var(--dk-gris-2); stroke-width: 4; stroke-dasharray: 8 6; }
  .pers.fantome text { fill: var(--dk-gris-2); }

  .t-sal { font-size: 28px; font-weight: 700; fill: var(--dk-encre); }
  .sal { opacity: 0; transition: opacity 0.5s; }
  .sal.vu { opacity: 1; transition-delay: 0.6s; }
  .lettre { font-size: 28px; font-weight: 700; fill: var(--dk-encre); }
  .lettre.f { fill: var(--dk-accent); }
  .b-h { fill: var(--dk-encre); transition: opacity 0.4s; }
  .b-h.pointille { fill: none; stroke: var(--dk-encre); stroke-width: 4; stroke-dasharray: 10 8; }
  .b-f { fill: var(--dk-accent); }
  .ecart { stroke: var(--dk-encre); stroke-width: 4; marker-start: none; transition: opacity 0.4s; }
  .t-ecart { font-size: 22px; font-weight: 700; text-anchor: middle; fill: var(--dk-encre); transition: opacity 0.4s; }
  .t-egal { font-size: 22px; font-weight: 700; fill: var(--dk-accent); }
  .pale { opacity: 0.35; }
  .perdu { fill: none; stroke: var(--dk-accent); stroke-width: 5; stroke-dasharray: 8 6; }
  .t-perdu { font-size: 24px; font-weight: 700; fill: var(--dk-accent); }
  .legende { margin: 0; display: flex; align-items: baseline; gap: 0.5em; font-size: 0.95em; font-weight: 600; }
  .legende b { display: inline-grid; place-items: center; width: 1.5em; height: 1.5em; color: white; background: var(--dk-accent); font-size: 0.75em; flex: none; }
  .cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .pers, .sal, .etage { transition: none; } }
</style>
