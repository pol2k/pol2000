<script>
  /**
   * Les trois liens à rejoindre avant jeudi: Slack, Datacamp, le site. Trois
   * grandes tuiles, un logo chacune, ce qui arrive et quand. Les marques sont
   * récupérées à la source.
   */
  import { base } from '$app/paths';
</script>

<div class="visuel liens">
  <a class="tuile" href="https://slack.com" target="_blank" rel="noopener">
    <img src="{base}/img/slack.png" alt="Slack" />
    <strong>Slack</strong>
    <span>L'invitation arrive par courriel cette semaine.</span>
    <em>le seul canal du cours</em>
  </a>
  <a class="tuile" href="https://www.datacamp.com" target="_blank" rel="noopener">
    <img src="{base}/img/datacamp.png" alt="Datacamp" />
    <strong>Datacamp</strong>
    <span>L'invitation aussi. Premier devoir en semaine 2.</span>
    <em>gratuit · 10 % de la note</em>
  </a>
  <a class="tuile site" href="https://pol2000.com" target="_blank" rel="noopener">
    <img src="{base}/img/pol2000_logo.svg" alt="pol2000.com" />
    <strong>pol2000.com</strong>
    <span>Le plan, le calendrier à jour, les diapositives de chaque séance.</span>
    <em>tout est là</em>
  </a>
</div>

<style>
  .liens { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.2em; }
  .tuile { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.4em; border: 3px solid var(--dk-encre); padding: 1.4em 1em 1.2em; color: inherit; text-decoration: none; transition: transform 0.2s, border-color 0.2s; }
  .tuile:hover { transform: translateY(-0.2em); border-color: var(--dk-accent); }
  .tuile img { width: 5.2em; height: 5.2em; object-fit: contain; border: 2px solid var(--dk-encre); margin-bottom: 0.5em; background: #fff; }
  .tuile.site img { border-color: var(--dk-accent); padding: 0.6em; }
  .tuile strong { font-size: 1.4em; }
  .tuile span { font-size: 0.82em; color: var(--dk-gris); line-height: 1.4; }
  .tuile em { margin-top: 0.4em; font-size: 0.72em; font-style: normal; font-weight: 600; color: var(--dk-accent); letter-spacing: 0.06em; }
</style>
