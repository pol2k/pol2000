<script>
  /**
   * Un graphique ggplot2 qui se construit couche par couche, au clic, avec
   * les vraies parts de l'Étude électorale canadienne 2025
   * (src/lib/data/ces2025.js, généré par outils/ces_data.R) : la part de
   * chaque parti dans chaque groupe de scolarité. Quatre temps : les axes
   * (aes), les barres (geom_col), les titres (labs), le thème
   * (theme_minimal, qui efface le fond gris de ggplot2). Le code, en haut,
   * est exactement celui qu'on tape ; le tableau d se prépare avec les
   * verbes des diapos précédentes, et la recette est dans le script de la
   * séance. Le graphique prend toute la place qui reste : c'est lui qu'on
   * regarde changer.
   */
  import { brancherTemps } from '../temps.js';
  import { BARRES } from '$lib/data/ces2025.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  // Les groupes et les partis, dans l'ordre des facteurs de R.
  const groupes = [...new Set(BARRES.map((b) => b.scolarite))];
  const partis = [...new Set(BARRES.map((b) => b.parti))];
  // Les couleurs officielles des partis, à la place de la palette de ggplot2.
  const couleurs = ['#d71920', '#1a4782', '#f37021', '#33b2cc', '#3d9b35'];
  // Repères du dessin, large et bas comme l'espace sous le code : part de 0 à 0,58
  // (ggplot2 gradue 0,0, 0,2, 0,4), trois groupes, légende à droite.
  const W = 1000, H = 350;
  const X0 = 80, X1 = 740, Y0 = 300, Y1 = 46, MAX = 0.58;
  const largeur = (X1 - X0) / groupes.length;
  const barre = (largeur * 0.9) / partis.length;
  const x = (g, p) => X0 + g * largeur + largeur * 0.05 + p * barre;
  const y = (v) => Y0 - (v / MAX) * (Y0 - Y1);
  const graduations = [0, 0.2, 0.4];
  const part = (b) => BARRES.find((r) => r.scolarite === groupes[b.g] && r.parti === partis[b.p]);
  const XL = X1 + 40;
</script>

<div class="visuel barres-ces" bind:this={hote}>
  <div class="codes">
    <span class="prep">d, le tableau préparé avec filter(), mutate() et count() : la recette est dans le script de la séance.</span>
    <pre class="code"><span class="l on">ggplot(d, aes(x = scolarite, y = part, fill = parti))</span><span class="l" class:on={e >= 1}> +
  geom_col(position = "dodge")</span><span class="l" class:on={e >= 2}> +
  labs(x = "Scolarité", y = "Part des intentions de vote", fill = "Parti", title = "Étude électorale canadienne 2025")</span><span class="l" class:on={e >= 3}> +
  theme_minimal()</span></pre>
  </div>
  <svg viewBox="0 0 {W} {H}" preserveAspectRatio="xMidYMid meet" role="img" aria-label="Diagramme à barres : part de chaque parti selon la scolarité, Étude électorale canadienne 2025. Les libéraux dominent chez les universitaires, les conservateurs chez les personnes sans diplôme postsecondaire.">
    <text x={X0} y="26" class="titre" class:vu={e >= 2}>Étude électorale canadienne 2025</text>
    <!-- Le fond gris et la grille blanche de ggplot2, que theme_minimal() efface. -->
    <rect x={X0} y={Y1} width={X1 - X0} height={Y0 - Y1} class="panneau" class:efface={e >= 3} />
    {#each graduations as g}
      <line x1={X0} y1={y(g)} x2={X1} y2={y(g)} class="grille" class:mince={e >= 3} />
      <text x={X0 - 10} y={y(g) + 5} class="tick d">{g.toFixed(1)}</text>
    {/each}
    {#each groupes as nom, g}
      <text x={X0 + (g + 0.5) * largeur} y={Y0 + 24} class="tick">{nom}</text>
    {/each}
    <text x={(X0 + X1) / 2} y="342" class="lab" class:vu={e >= 2}>Scolarité</text>
    <text x={(X0 + X1) / 2} y="342" class="lab pale" class:vu={e < 2}>scolarite</text>
    <text transform="translate(22 {(Y0 + Y1) / 2}) rotate(-90)" class="lab" class:vu={e >= 2}>Part des intentions de vote</text>
    <text transform="translate(22 {(Y0 + Y1) / 2}) rotate(-90)" class="lab pale" class:vu={e < 2}>part</text>
    {#each groupes as _, g}
      {#each partis as _, p}
        {@const r = part({ g, p })}
        <rect x={x(g, p)} y={y(r.part)} width={barre} height={Y0 - y(r.part)} fill={couleurs[p]} class="barre" class:vu={e >= 1} style="transition-delay: {e >= 1 ? (g * partis.length + p) * 40 : 0}ms" />
      {/each}
    {/each}
    <g class="legende" class:vu={e >= 1}>
      <!-- Sans labs(fill = …), ggplot2 prend la question du sondage comme titre de légende. -->
      <text x={XL} y={Y1 + 6} class="lab-leg" class:vu={e >= 2}>Parti</text>
      <text x={XL} y={Y1 - 2} class="question" class:vu={e < 2}><tspan x={XL} dy="0">Which party do you think you</tspan><tspan x={XL} dy="14">will vote for? - Selected Choice</tspan></text>
      {#each partis as nom, p}
        <rect x={XL} y={Y1 + 34 + p * 34} width="22" height="22" fill={couleurs[p]} />
        <text x={XL + 32} y={Y1 + 51 + p * 34} class="tick g">{nom}</text>
      {/each}
    </g>
  </svg>
</div>

<style>
  .barres-ces { display: flex; flex-direction: column; gap: 0.5em; flex: 1 1 auto; min-height: 0; }
  .codes { flex: none; display: flex; flex-direction: column; gap: 0.3em; min-width: 0; }
  .prep { font-size: 0.6em; letter-spacing: 0.04em; color: var(--dk-gris); }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 0.72em; line-height: 1.5; border: 3px solid var(--dk-encre); padding: 0.55em 0.9em; white-space: pre; overflow-x: auto; }
  .l { color: var(--dk-gris-2); transition: color 0.3s; }
  .l.on { color: var(--dk-encre); }
  svg { flex: 1 1 0; min-height: 0; width: 100%; display: block; }
  .panneau { fill: var(--dk-fond-2); transition: opacity 0.4s; }
  .panneau.efface { opacity: 0; }
  .grille { stroke: var(--dk-fond); stroke-width: 3; transition: stroke 0.4s; }
  .grille.mince { stroke: var(--dk-filet); stroke-width: 2; }
  .tick { font-family: var(--dk-mono); font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.d { text-anchor: end; }
  .tick.g { text-anchor: start; fill: var(--dk-encre); }
  .lab { font-family: var(--dk-mono); font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .lab.pale { fill: var(--dk-gris-2); font-weight: 400; }
  .lab.vu { opacity: 1; }
  .lab-leg { font-family: var(--dk-mono); font-size: 16px; font-weight: 600; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .lab-leg.vu { opacity: 1; }
  .question { font-family: var(--dk-mono); font-size: 11px; fill: var(--dk-gris-2); opacity: 0; transition: opacity 0.4s; }
  .question.vu { opacity: 1; }
  .titre { font-family: var(--dk-mono); font-size: 19px; font-weight: 600; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .titre.vu { opacity: 1; }
  .barre { opacity: 0; transition: opacity 0.35s; }
  .barre.vu { opacity: 0.9; }
  .legende { opacity: 0; transition: opacity 0.4s; }
  .legende.vu { opacity: 1; }
</style>
