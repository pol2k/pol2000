<script>
  /**
   * « 80 % du temps d'analyse passe à préparer les données. » Un adage, pas
   * une mesure : Wickham (2014) le rapporte d'après Dasu et Johnson (2003).
   * La barre est donc schématique, bornée par des guillemets et étiquetée
   * « ce qu'on dit souvent »; aucun axe, aucune graduation. Un temps : la
   * part « préparer » se remplit, puis la phrase qui la ramène à sa place.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel quatre-vingts" bind:this={hote}>
  <span class="et">CE QU’ON DIT SOUVENT</span>
  <div class="barre" aria-label="Schéma : environ 80 % du temps à préparer les données, 20 % à les analyser. Un adage, pas une mesure.">
    <span class="guil">«</span>
    <div class="part prep">
      <strong>≈ 80 %</strong>
      <span>préparer</span>
    </div>
    <div class="part ana">
      <strong>20 %</strong>
      <span>analyser</span>
    </div>
    <span class="guil">»</span>
  </div>
  <p class="chute" class:vu={e >= 1}>Un ordre de grandeur, pas une mesure. Mais tout le monde le vit.</p>
  <p class="source">Wickham (2014), d’après Dasu et Johnson (2003)</p>
</div>

<style>
  .quatre-vingts { display: flex; flex-direction: column; gap: 0.9em; }
  .et { font-size: 0.65em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .barre { display: flex; align-items: stretch; gap: 0.3em; }
  .guil { font-size: 4em; line-height: 1; color: var(--dk-gris-2); align-self: center; }
  .part { display: flex; flex-direction: column; justify-content: center; gap: 0.15em; padding: 0.9em 1em; border: 3px solid var(--dk-encre); min-height: 6.5em; box-sizing: border-box; }
  .prep { flex: 80 1 0; background: var(--dk-accent); border-color: var(--dk-accent); color: var(--dk-fond); transform-origin: left; animation: remplit 0.9s cubic-bezier(0.3, 0.9, 0.3, 1) both; }
  .ana { flex: 20 1 0; background: var(--dk-fond); animation: fondu 0.4s 0.8s both; }
  .part strong { font-size: 2.4em; line-height: 1; letter-spacing: -0.02em; }
  .part span { font-size: 0.95em; font-weight: 600; }
  .ana strong { font-size: 1.6em; }
  .chute { margin: 0.3em 0 0; font-size: 1.25em; line-height: 1.35; opacity: 0; transition: opacity 0.4s; }
  .chute.vu { opacity: 1; }
  .source { margin: 0; font-size: 0.6em; letter-spacing: 0.06em; color: var(--dk-gris); text-align: right; }
  @keyframes remplit { from { transform: scaleX(0); } to { transform: scaleX(1); } }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  @media (prefers-reduced-motion: reduce) { .prep, .ana { animation: none; } }
</style>
