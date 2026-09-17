<script>
  /**
   * L'écart type, ça sert à quoi ? Même note, deux groupes. Quatre temps.
   *
   *   0  Deux groupes fictifs de quinze notes, même moyenne (70, vérifiée
   *      ci-dessous). Le groupe A est serré, le groupe B étalé. Votre note,
   *      80, est marquée en rouge dans les deux.
   *   1  Dans chaque groupe, une accolade rouge de 70 à 80 dit combien
   *      d'écarts types vous séparent de la moyenne : environ 2 dans A,
   *      environ 0,5 dans B. Calculé comme sd() dans R (n − 1).
   *   2  À gauche de chaque rangée, le calcul de la cote Z avec les nombres
   *      de la figure : l'écart type du groupe, puis (80 − 70) ÷ écart type.
   *   3  La cote R : sa forme en mots (la réponse, sous la scène), puis, à
   *      droite, l'illustration sans correction de groupe, (Z + 5) × 5 :
   *      35,0 contre 27,5. « même note, meilleure cote » bat à côté de A.
   *
   * Faits vérifiés dans BCI, « La cote de rendement au collégial : ce qu'elle
   * est, ce qu'elle fait » (21 janvier 2025), annexe A :
   *   « CRC = ((Zcol x IDGZ) + IFGZ + C) x D », avec « C et D, des constantes
   *   de valeur 5 » ; IFGZ est l'indicateur de la force du groupe, IDGZ celui
   *   de sa dispersion, tous deux tirés des cotes Z au secondaire. Quand
   *   « l'IFGZ prend la valeur 0, l'IDGZ prend la valeur 1 […] aucune
   *   correction n'est apportée » : c'est le cas illustré ici.
   * Deux écarts assumés : le BCI divise par le nombre de notes, sd() par
   * n − 1 (on garde sd(), comme à la diapositive précédente) ; la cote R est
   * calculée à partir du Z arrondi affiché, pour que le calcul à l'écran
   * tombe juste.
   */
  import { brancherTemps } from '../temps.js';
  import Pis from './Pis.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  const NOTE = 80;
  const GROUPES = [
    { nom: 'Groupe A', notes: [61, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 79] },
    { nom: 'Groupe B', notes: [42, 43, 45, 48, 52, 58, 65, 70, 75, 82, 88, 92, 95, 97, 98] }
  ];
  const moyenne = (v) => v.reduce((s, x) => s + x, 0) / v.length;
  const ecartType = (v) => {
    const m = moyenne(v);
    return Math.sqrt(v.reduce((s, x) => s + (x - m) ** 2, 0) / (v.length - 1));
  };
  const MOY = moyenne(GROUPES[0].notes);
  if (GROUPES.some((g) => moyenne(g.notes) !== MOY)) {
    throw new Error('PourquoiEcartType : les deux groupes doivent avoir la même moyenne.');
  }
  const f1 = (v) => v.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 });
  // Les constantes C et D de la formule du BCI, toutes deux de valeur 5.
  const C = 5, D = 5;
  const calculs = GROUPES.map((g) => {
    const et = ecartType(g.notes);
    const z = Math.round(((NOTE - MOY) / et) * 10) / 10;
    return { et: f1(et), z: f1(z), crc: f1((z + C) * D) };
  });
  const ecarts = calculs.map((c, r) => {
    const z = (NOTE - MOY) / ecartType(GROUPES[r].notes);
    return `+${c.z} ${Math.round(z * 10) / 10 >= 2 ? 'écarts types' : 'écart type'}`;
  });

  const X0 = 170, X1 = 950;
  const x = (v) => X0 + ((v - 40) / 60) * (X1 - X0);
  const RANGS = [110, 236];
</script>

<Pis stat="l'écart type" reponse="Cote R = (Z, corrigé selon la force et la dispersion du groupe, + 5) × 5" vu={e >= 3} source="BCI, « La cote de rendement au collégial : ce qu’elle est, ce qu’elle fait », 21 janvier 2025 ; groupes : exemple fictif">
  {#snippet children()}
    <svg bind:this={hote} class="notes" viewBox="0 0 1000 390" role="img" aria-label="Deux groupes fictifs de quinze notes avec la même moyenne de 70. Une note de 80 est à environ deux écarts types de la moyenne dans le groupe serré, et à environ un demi écart type dans le groupe étalé. Exemple fictif.">
      <!-- La moyenne commune. -->
      <line x1={x(MOY)} y1="54" x2={x(MOY)} y2="300" class="moy" />
      <text x={x(MOY)} y="40" class="moy-t">moyenne · {MOY}</text>

      {#each GROUPES as g, r}
        {@const y = RANGS[r]}
        <text x="20" y={y + 6} class="nom">{g.nom}</text>
        {#each g.notes as n, i}
          <circle cx={x(n)} cy={y + (i % 2 ? 8 : -8)} r="9" class="pt" style="--d: {r * 180 + i * 35}ms" />
        {/each}

        <!-- Vous : 80. -->
        <g class="vous">
          <path d="M {x(NOTE)} {y + 16} L {x(NOTE) - 9} {y - 2} L {x(NOTE)} {y - 20} L {x(NOTE) + 9} {y - 2} Z" class="losange" />
          <text x={x(NOTE)} y={y - 30} class="vous-t">vous · {NOTE}</text>
        </g>

        <!-- L'accolade : combien d'écarts types. -->
        <g class="acc" class:vu={e >= 1} style="--r: {r}">
          <path d="M {x(MOY)} {y + 24} L {x(MOY)} {y + 34} L {x(NOTE)} {y + 34} L {x(NOTE)} {y + 24}" pathLength="1" class="acc-l" />
          <text x={(x(MOY) + x(NOTE)) / 2} y={y + 58} class="acc-t">{ecarts[r]}</text>
        </g>

        <!-- La cote Z, avec les nombres de la figure. -->
        <g class="calc" class:vu={e >= 2} style="--r: {r}">
          <text x="20" y={y + 36} class="calc-t">écart type du groupe&#8239;: {calculs[r].et}</text>
          <text x="20" y={y + 58} class="calc-t calc-z">cote Z = ({NOTE} − {MOY}) ÷ {calculs[r].et} ≈ {calculs[r].z}</text>
        </g>

        <!-- La cote R, sans correction de groupe : (Z + 5) × 5. -->
        <text x="730" y={y + 58} class="crc" class:vu={e >= 3}>({calculs[r].z} + {C}) × {D} = <tspan class="crc-n">{calculs[r].crc}</tspan></text>
      {/each}

      <text x="730" y={RANGS[0] + 6} class="cote" class:vu={e >= 3}>même note, meilleure cote</text>
      <text x="730" y={RANGS[0] + 36} class="sans" class:vu={e >= 3}>sans correction de groupe&#8239;:</text>

      <line x1={X0} y1="320" x2={X1} y2="320" class="axe" />
      {#each [40, 50, 60, 70, 80, 90, 100] as t}
        <line x1={x(t)} y1="320" x2={x(t)} y2="328" class="axe" />
        <text x={x(t)} y="348" class="tick">{t}</text>
      {/each}
      <text x={X1} y="382" class="fictif">groupes : exemple fictif</text>
    </svg>
  {/snippet}
</Pis>

<style>
  .notes { width: 100%; height: 100%; max-height: 44vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .moy { stroke: var(--dk-encre); stroke-width: 3; stroke-dasharray: 9 7; animation: fondu 0.5s both; }
  .moy-t { font-size: 20px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .nom { font-size: 20px; font-weight: 600; fill: var(--dk-encre); }
  .pt { fill: var(--dk-gris-2); stroke: var(--dk-fond); stroke-width: 2.5; transform-box: fill-box; transform-origin: center; animation: pop 0.45s cubic-bezier(0.34, 1.7, 0.64, 1) both; animation-delay: var(--d); }
  .losange { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 2; }
  .vous { animation: tombe 0.5s cubic-bezier(0.34, 1.6, 0.64, 1) 0.7s both; }
  .vous-t { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .acc-l { fill: none; stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.6s ease-out; transition-delay: calc(var(--r) * 250ms); }
  .acc.vu .acc-l { stroke-dashoffset: 0; }
  /* Halo couleur papier : la ligne de la moyenne passe derrière le texte, pas à travers. */
  .acc-t { font-size: 18px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 8px; stroke-linejoin: round; opacity: 0; transform: translateY(6px); transition: opacity 0.4s, transform 0.4s cubic-bezier(0.34, 1.6, 0.64, 1); transition-delay: calc(var(--r) * 250ms + 400ms); }
  .acc.vu .acc-t { opacity: 1; transform: none; }

  .cote { font-size: 18px; font-weight: 600; fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s; transform-box: fill-box; transform-origin: 0 50%; }
  .cote.vu { opacity: 1; animation: bat 0.7s ease-in-out 0.4s 3; }

  .calc { opacity: 0; transition: opacity 0.4s; transition-delay: calc(var(--r) * 250ms); }
  .calc.vu { opacity: 1; }
  .calc-t { font-size: 18px; fill: var(--dk-gris); }
  .calc-z { font-weight: 600; fill: var(--dk-encre); }
  .sans { font-size: 18px; fill: var(--dk-gris); opacity: 0; transition: opacity 0.4s; }
  .sans.vu { opacity: 1; }
  .crc { font-size: 18px; font-weight: 600; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s 0.3s; }
  .crc.vu { opacity: 1; }
  .crc-n { fill: var(--dk-accent); }

  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 18px; text-anchor: middle; fill: var(--dk-gris); }
  .fictif { font-size: 18px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }

  @keyframes pop { from { opacity: 0; transform: scale(0); } to { opacity: 1; transform: scale(1); } }
  @keyframes tombe { from { opacity: 0; transform: translateY(-30px); } to { opacity: 1; transform: none; } }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  @keyframes bat { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.08); } }

  @media (prefers-reduced-motion: reduce) {
    .moy, .pt, .vous, .cote.vu { animation: none; }
    .acc-l, .acc-t, .cote, .calc, .sans, .crc { transition: none; }
  }
</style>
