<script>
  import { base } from '$app/paths';
  import { COURS } from '$lib/data/cours.js';
</script>

<footer class="pied">
  <div class="g">
    <img src="{base}/img/ulaval-logo.png" alt="Université Laval" class="logo" />
    <span>{COURS.sigle} · {COURS.titre}<br />Département de science politique · Faculté des sciences sociales · {COURS.session}</span>
  </div>
  <nav>
    <a href="{base}/syllabus/">Plan de cours</a>
    <a href="{base}/slides/">Diapositives</a>
    <a href={COURS.depot} rel="noopener">Code source</a>
    <a href="mailto:{COURS.enseignant.courriel}">{COURS.enseignant.courriel}</a>
  </nav>
</footer>

<style>
  .pied {
    margin-top: clamp(64px, 10vh, 120px);
    border-top: var(--trait);
    padding: 1.6rem var(--marge) 3rem;
    display: flex; justify-content: space-between; align-items: flex-start; gap: 2rem; flex-wrap: wrap;
    font-size: 0.7rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--gris); line-height: 1.7;
  }
  .g { display: flex; gap: 1rem; align-items: center; }
  .logo { height: 2.2rem; width: auto; background: #fff; padding: 0.2rem 0.35rem; border: 1.5px solid var(--encre); }
  nav { display: flex; gap: 1.6em; flex-wrap: wrap; }
  nav a { color: var(--encre); text-decoration: none; border-bottom: 2px solid transparent; }
  nav a:hover { border-bottom-color: var(--accent); }
</style>
