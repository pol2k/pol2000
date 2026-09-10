<script>
  /**
   * Un graphique ggplot2 qui se construit couche par couche, au clic, avec
   * les 47 vraies provinces de `swiss` (src/lib/data/swiss.js, généré par
   * outils/swiss_data.R). Quatre temps : les axes (aes), les points
   * (geom_point), les titres (labs), la droite (geom_smooth, la vraie pente
   * de lm). Le code qui grandit à gauche est exactement celui qu'on tape.
   */
  import { brancherTemps } from '../temps.js';
  import { SWISS, LM_EDUCATION } from '$lib/data/swiss.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });
  // Repères du dessin : Education 0 à 55, Fertility 30 à 95.
  const X0 = 90, X1 = 740, Y0 = 400, Y1 = 30;
  const x = (v) => X0 + (v / 55) * (X1 - X0);
  const y = (v) => Y0 - ((v - 30) / 65) * (Y0 - Y1);
  const droite = { x1: x(0), y1: y(LM_EDUCATION.constante), x2: x(55), y2: y(LM_EDUCATION.constante + 55 * LM_EDUCATION.pente) };
</script>

<div class="visuel nuage" bind:this={hote}>
  <pre class="code"><span class="l on">ggplot(df, aes(x = Education, y = Fertility))</span><span class="l" class:on={e >= 1}> +
  geom_point()</span><span class="l" class:on={e >= 2}> +
  labs(x = "Scolarité au-delà du primaire (%)",
       y = "Indice de fécondité",
       title = "47 provinces suisses, 1888")</span><span class="l" class:on={e >= 3}> +
  geom_smooth(method = "lm")</span></pre>
  <svg viewBox="0 0 780 470" role="img" aria-label="Nuage de points : fécondité selon la scolarité pour 47 provinces suisses en 1888. Les provinces plus scolarisées ont une fécondité plus basse.">
    <text x={(X0 + X1) / 2} y="16" class="titre" class:vu={e >= 2}>47 provinces suisses, 1888</text>
    <line x1={X0} y1={Y0} x2={X1} y2={Y0} class="axe" /><line x1={X0} y1={Y0} x2={X0} y2={Y1} class="axe" />
    {#each [0, 10, 20, 30, 40, 50] as v}
      <line x1={x(v)} y1={Y0} x2={x(v)} y2={Y0 + 8} class="axe" /><text x={x(v)} y={Y0 + 26} class="tick">{v}</text>
    {/each}
    {#each [30, 50, 70, 90] as v}
      <line x1={X0 - 8} y1={y(v)} x2={X0} y2={y(v)} class="axe" /><text x={X0 - 14} y={y(v) + 5} class="tick d">{v}</text>
    {/each}
    <text x={(X0 + X1) / 2} y="452" class="lab" class:vu={e >= 2}>Scolarité au-delà du primaire (%)</text>
    <text x={(X0 + X1) / 2} y="452" class="lab pale" class:vu={e < 2}>Education</text>
    <text transform="translate(22 {(Y0 + Y1) / 2}) rotate(-90)" class="lab" class:vu={e >= 2}>Indice de fécondité</text>
    <text transform="translate(22 {(Y0 + Y1) / 2}) rotate(-90)" class="lab pale" class:vu={e < 2}>Fertility</text>
    {#each SWISS as p, i}
      <circle cx={x(p.education)} cy={y(p.fertilite)} r="7" class="pt" class:vu={e >= 1} style="transition-delay: {e >= 1 ? i * 14 : 0}ms" />
    {/each}
    <line x1={droite.x1} y1={droite.y1} x2={droite.x2} y2={droite.y2} class="droite" class:vu={e >= 3} />
  </svg>
</div>

<style>
  .nuage { display: grid; grid-template-columns: 1fr 1.25fr; gap: 1.4em; align-items: center; }
  .code { margin: 0; font-family: var(--dk-mono); font-size: 0.8em; line-height: 1.6; border: 3px solid var(--dk-encre); padding: 0.7em 0.9em; white-space: pre; overflow-x: auto; }
  .l { color: var(--dk-gris-2); transition: color 0.3s; }
  .l.on { color: var(--dk-encre); }
  svg { width: 100%; height: auto; max-height: 62vh; display: block; }
  .axe { stroke: var(--dk-encre); stroke-width: 2.5; }
  .tick { font-family: var(--dk-mono); font-size: 15px; text-anchor: middle; fill: var(--dk-gris); }
  .tick.d { text-anchor: end; }
  .lab { font-family: var(--dk-mono); font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .lab.pale { fill: var(--dk-gris-2); font-weight: 400; }
  .lab.vu { opacity: 1; }
  .titre { font-family: var(--dk-mono); font-size: 17px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); opacity: 0; transition: opacity 0.4s; }
  .titre.vu { opacity: 1; }
  .pt { fill: var(--dk-accent); opacity: 0; transition: opacity 0.35s; }
  .pt.vu { opacity: 0.85; }
  .droite { stroke: var(--dk-encre); stroke-width: 4; opacity: 0; transition: opacity 0.5s; }
  .droite.vu { opacity: 1; }
</style>
