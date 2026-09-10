<script>
  /**
   * Les deux choses à faire avant jeudi prochain : le cours Datacamp
   * « Introduction to R » et rejoindre le Slack du cours. Deux grandes
   * tuiles, un logo chacune, une ligne chacune. Les liens viennent de
   * cours.js, comme sur le site.
   */
  import { base } from '$app/paths';
  import { LIENS } from '$lib/data/cours.js';
</script>

<div class="visuel deux-choses">
  <a class="tuile" href={LIENS.datacamp} target="_blank" rel="noopener">
    <img src="{base}/img/datacamp.png" alt="Datacamp" />
    <strong>Datacamp</strong>
    <span>Le cours « Introduction to R », à votre rythme.</span>
    <em>obligatoire · 10 % de la note</em>
  </a>
  <a class="tuile" href={LIENS.slack} target="_blank" rel="noopener">
    <img src="{base}/img/slack.png" alt="Slack" />
    <strong>Rejoindre Slack</strong>
    <span>L’invitation est dans votre courriel.</span>
    <em>le seul canal du cours</em>
  </a>
</div>

<style>
  .deux-choses { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.4em; max-width: 42em; margin: 0 auto; }
  .tuile { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.45em; border: 3px solid var(--dk-encre); padding: 1.6em 1.2em 1.4em; color: inherit; text-decoration: none; transition: transform 0.2s, border-color 0.2s; animation: fondu 0.5s both; }
  .tuile:nth-child(2) { animation-delay: 0.15s; }
  .tuile:hover { transform: translateY(-0.2em); border-color: var(--dk-accent); }
  .tuile img { width: 6.4em; height: 6.4em; object-fit: contain; border: 2px solid var(--dk-encre); margin-bottom: 0.5em; background: #fff; }
  .tuile strong { font-size: 1.5em; }
  .tuile span { font-size: 0.85em; color: var(--dk-gris); line-height: 1.4; }
  .tuile em { margin-top: 0.4em; font-size: 0.72em; font-style: normal; font-weight: 600; color: var(--dk-accent); letter-spacing: 0.06em; }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
</style>
