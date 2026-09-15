<script>
  /**
   * Pis, l'écart type, ça sert à quoi ? Même note, deux groupes. Trois temps.
   *
   *   0  Deux groupes fictifs de quinze notes, même moyenne (70, vérifiée
   *      ci-dessous). Le groupe A est serré, le groupe B étalé. Votre note,
   *      80, est marquée en rouge dans les deux.
   *   1  Dans chaque groupe, une accolade rouge de 70 à 80 dit combien
   *      d'écarts types vous séparent de la moyenne : environ 2 dans A,
   *      environ 0,5 dans B. Calculé comme sd() dans R (n − 1).
   *   2  La réponse apparaît; « même note, meilleure cote » bat à côté de A.
   *
   * Fait vérifié (BCI, la cote de rendement au collégial) : la cote R part
   * d'une cote Z, la position de l'élève par rapport à son groupe, avec la
   * moyenne et l'écart type du groupe, puis applique des corrections de
   * groupe. On n'en dit pas plus.
   */
  import { brancherTemps } from '../temps.js';
  import Pis from './Pis.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
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
  const ecarts = GROUPES.map((g) => {
    const z = Math.round(((NOTE - MOY) / ecartType(g.notes)) * 10) / 10;
    const n = z.toLocaleString('fr-CA', { minimumFractionDigits: 1, maximumFractionDigits: 1 });
    return `+${n} ${Math.abs(z) >= 2 ? 'écarts types' : 'écart type'}`;
  });

  const X0 = 170, X1 = 950;
  const x = (v) => X0 + ((v - 40) / 60) * (X1 - X0);
  const RANGS = [110, 236];
</script>

<Pis stat="l'écart type" reponse="Votre cote R part de là : votre écart à la moyenne du groupe, en écarts types." vu={e >= 2} source="BCI · la cote de rendement au collégial ; groupes : exemple fictif">
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
      {/each}

      <text x={x(NOTE) + 30} y={RANGS[0] + 6} class="cote" class:vu={e >= 2}>même note, meilleure cote</text>

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
  .moy-t { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .nom { font-size: 17px; font-weight: 600; fill: var(--dk-encre); }
  .pt { fill: var(--dk-gris-2); stroke: var(--dk-fond); stroke-width: 2.5; transform-box: fill-box; transform-origin: center; animation: pop 0.45s cubic-bezier(0.34, 1.7, 0.64, 1) both; animation-delay: var(--d); }
  .losange { fill: var(--dk-accent); stroke: var(--dk-fond); stroke-width: 2; }
  .vous { animation: tombe 0.5s cubic-bezier(0.34, 1.6, 0.64, 1) 0.7s both; }
  .vous-t { font-size: 15px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .acc-l { fill: none; stroke: var(--dk-accent); stroke-width: 4; stroke-dasharray: 1; stroke-dashoffset: 1; transition: stroke-dashoffset 0.6s ease-out; transition-delay: calc(var(--r) * 250ms); }
  .acc.vu .acc-l { stroke-dashoffset: 0; }
  /* Halo couleur papier : la ligne de la moyenne passe derrière le texte, pas à travers. */
  .acc-t { font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 8px; stroke-linejoin: round; opacity: 0; transform: translateY(6px); transition: opacity 0.4s, transform 0.4s cubic-bezier(0.34, 1.6, 0.64, 1); transition-delay: calc(var(--r) * 250ms + 400ms); }
  .acc.vu .acc-t { opacity: 1; transform: none; }

  .cote { font-size: 17px; font-weight: 600; fill: var(--dk-accent); opacity: 0; transition: opacity 0.4s; transform-box: fill-box; transform-origin: 0 50%; }
  .cote.vu { opacity: 1; animation: bat 0.7s ease-in-out 0.4s 3; }

  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .fictif { font-size: 14px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }

  @keyframes pop { from { opacity: 0; transform: scale(0); } to { opacity: 1; transform: scale(1); } }
  @keyframes tombe { from { opacity: 0; transform: translateY(-30px); } to { opacity: 1; transform: none; } }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  @keyframes bat { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.08); } }

  @media (prefers-reduced-motion: reduce) {
    .moy, .pt, .vous, .cote.vu { animation: none; }
    .acc-l, .acc-t, .cote { transition: none; }
  }
</style>
