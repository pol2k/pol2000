<script>
  /**
   * Trois façons d'apprendre R, une tuile chacune, avec la marque telle
   * quelle : Datacamp (le cours du plan de cours), swirl (apprendre R dans
   * R) et R for Data Science (le livre, gratuit en ligne).
   */
  import { base } from '$app/paths';
</script>

<div class="visuel ressources">
  <a class="tuile" href="https://www.datacamp.com" target="_blank" rel="noopener">
    <span class="logo"><img src="{base}/img/datacamp.png" alt="Datacamp" /></span>
    <strong>Datacamp</strong>
    <span>Des exercices interactifs, un chapitre par séance. C’est dans le plan de cours.</span>
    <em>obligatoire · 10 % de la note</em>
  </a>
  <a class="tuile" href="https://swirlstats.com" target="_blank" rel="noopener">
    <span class="logo"><img src="{base}/img/hex-swirl.png" alt="swirl" /></span>
    <strong>swirl</strong>
    <span>Apprendre R dans R : un package qui vous pose des questions dans la console.</span>
    <em>gratuit · install.packages("swirl")</em>
  </a>
  <a class="tuile" href="https://r4ds.hadley.nz" target="_blank" rel="noopener">
    <span class="logo livre"><img src="{base}/img/r4ds-cover.jpg" alt="R for Data Science" /></span>
    <strong>R for Data Science</strong>
    <span>Le livre de référence, écrit par les auteurs du tidyverse. Gratuit, en ligne, en anglais.</span>
    <em>r4ds.hadley.nz</em>
  </a>
</div>

<style>
  .ressources { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.2em; }
  .tuile { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.4em; border: 3px solid var(--dk-encre); padding: 1.3em 1em 1.1em; color: inherit; text-decoration: none; transition: transform 0.2s, border-color 0.2s; animation: fondu 0.5s both; }
  .tuile:nth-child(2) { animation-delay: 0.15s; } .tuile:nth-child(3) { animation-delay: 0.3s; }
  .tuile:hover { transform: translateY(-0.25em); border-color: var(--dk-accent); }
  .logo { height: 6.5em; display: flex; align-items: center; justify-content: center; margin-bottom: 0.4em; }
  .logo img { max-height: 6.5em; max-width: 11em; object-fit: contain; }
  .logo.livre img { border: 2px solid var(--dk-encre); }
  .tuile strong { font-size: 1.3em; }
  .tuile span:not(.logo) { font-size: 0.8em; color: var(--dk-gris); line-height: 1.4; }
  .tuile em { margin-top: 0.4em; font-size: 0.7em; font-style: normal; font-weight: 600; color: var(--dk-accent); letter-spacing: 0.06em; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
</style>
