<script>
  /**
   * Le matériel, un objet par diapo: R et Positron, l'ordinateur (un ThinkPad
   * dessiné — la bille rouge suffit à le reconnaître), Slack, le livre. Les
   * logos sont récupérés à la source et jamais redessinés.
   */
  import { base } from '$app/paths';
  let { quoi } = $props(); // 'r' | 'ordi' | 'slack' | 'livre'
</script>

<div class="visuel mat {quoi}">
  {#if quoi === 'r'}
    <div class="deux">
      <div class="bloc">
        <img src="{base}/img/Rlogo.png" alt="R" class="rlogo" />
        <strong>R</strong>
        <span>le langage. Gratuit, libre, partout.</span>
        <code>cran.r-project.org</code>
      </div>
      <div class="bloc">
        <div class="positron">
          <div class="pbar"><i></i><i></i><i></i><span>Positron</span></div>
          <div class="pcorps">
            <div class="pfichiers"><b>script.R</b><b>donnees.csv</b><b>figure.png</b></div>
            <div class="pediteur"><span class="k">ces</span> &lt;- read_dta(<span class="s">"ces2025.dta"</span>)<br /><span class="k">lm</span>(lr ~ income, data = ces)</div>
            <div class="pconsole">&gt; <span class="curseur">▍</span></div>
          </div>
        </div>
        <strong>Positron</strong>
        <span>l'éditeur, par Posit. Gratuit aussi.</span>
        <code>positron.posit.co</code>
      </div>
    </div>
  {:else if quoi === 'ordi'}
    <svg viewBox="0 0 900 420" role="img" aria-label="Un ordinateur portable ThinkPad, ouvert, avec sa bille rouge.">
      <!-- écran -->
      <rect x="240" y="30" width="420" height="270" rx="10" class="coque" />
      <rect x="262" y="52" width="376" height="226" class="ecran" />
      <text x="450" y="150" class="ecran-t">POL-2000</text>
      <text x="450" y="190" class="ecran-s">&gt; R et Positron installés ✓</text>
      <!-- charnière + base -->
      <rect x="220" y="300" width="460" height="14" class="coque" />
      <path d="M 200 314 L 700 314 L 730 380 L 170 380 Z" class="coque" />
      <!-- clavier -->
      {#each [0, 1, 2, 3] as r}{#each Array.from({ length: 14 }) as _, c}
        <rect x={262 + c * 27 + r * 4} y={322 + r * 13} width="22" height="9" rx="2" class="touche" />
      {/each}{/each}
      <!-- la bille rouge -->
      <circle cx="450" cy="346" r="7" class="bille" />
      <!-- pavé -->
      <rect x="405" y="362" width="90" height="12" rx="3" class="pave" />
      <!-- badge -->
      <text x="640" y="292" class="badge">ThinkPad</text>
    </svg>
    <div class="os">
      <span>Windows</span><span>macOS</span><span>Linux</span>
      <em>N'importe lequel.</em>
    </div>
    <p class="appel">Pas d'ordinateur ? <strong>Venez me voir.</strong> Des solutions existent.</p>
  {:else if quoi === 'slack'}
    <div class="deux">
      <div class="bloc">
        <img src="{base}/img/slack.png" alt="Slack" class="logo" />
        <strong>Slack</strong>
        <span>Le seul canal du cours. Pas de courriel après deux semaines.</span>
        <code>lien d'invitation par courriel</code>
      </div>
      <div class="canal">
        <div class="cbar"># pol2000 · général</div>
        <div class="msg"><i class="av">É</i><div><b>Étudiant.e</b> <small>15h42</small><p>Mon fichier .dta ne s'ouvre pas dans Positron, erreur « cannot open file ». Quelqu'un ?</p></div></div>
        <div class="msg"><i class="av a">JP</i><div><b>Jules Piral</b> <small>15h47</small><p>Vérifie le dossier de travail : Session &gt; Set Working Directory. Le fichier est ailleurs.</p></div></div>
        <div class="msg"><i class="av">É</i><div><b>Étudiant.e</b> <small>15h49</small><p>Ça marche, merci !</p></div></div>
        <div class="saisie">Message #pol2000 · général</div>
      </div>
    </div>
  {:else}
    <div class="deux livre">
      <img src="{base}/img/acmq_couverture.png" alt="Couverture du livre Analyse causale et méthodes quantitatives, de Vincent Arel-Bundock" class="couv" />
      <div class="bloc gauche">
        <span class="sur">OUVRAGE DE RÉFÉRENCE</span>
        <strong>Analyse causale et méthodes quantitatives</strong>
        <span>Vincent Arel-Bundock · Presses de l'Université de Montréal · 2021</span>
        <p>Toute la matière du cours, dans le même ordre.</p>
        <code>gratuit en PDF · pum.umontreal.ca</code>
      </div>
    </div>
  {/if}
</div>

<style>
  .mat { display: flex; flex-direction: column; gap: 0.8em; }
  .deux { display: grid; grid-template-columns: 1fr 1fr; gap: 2em; align-items: center; }
  .bloc { display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.3em; }
  .bloc.gauche { align-items: flex-start; text-align: left; }
  .bloc strong { font-size: 1.6em; }
  .bloc span { font-size: 0.85em; color: var(--dk-gris); }
  .bloc code { font-size: 0.8em; color: var(--dk-accent); }
  .rlogo { width: 9em; height: auto; }
  .logo { width: 6em; height: 6em; border: 2px solid var(--dk-encre); }
  /* Positron: une fenêtre dessinée */
  .positron { width: 100%; border: 3px solid var(--dk-encre); background: var(--dk-fond); margin-bottom: 0.4em; text-align: left; }
  .pbar { display: flex; align-items: center; gap: 0.35em; background: var(--dk-encre); color: var(--dk-fond); padding: 0.3em 0.6em; font-size: 0.65em; }
  .pbar i { width: 0.65em; height: 0.65em; border-radius: 50%; background: var(--dk-fond); opacity: 0.85; }
  .pbar span { margin-left: 0.6em; letter-spacing: 0.1em; }
  .pcorps { display: grid; grid-template-columns: 6em 1fr; grid-template-rows: auto auto; }
  .pfichiers { grid-row: 1 / 3; border-right: 2px solid var(--dk-filet); padding: 0.5em; display: flex; flex-direction: column; gap: 0.3em; font-size: 0.6em; color: var(--dk-gris); }
  .pfichiers b:first-child { color: var(--dk-accent); }
  .pediteur { padding: 0.6em 0.8em; font-family: var(--dk-mono); font-size: 0.68em; line-height: 1.6; }
  .k { color: var(--dk-accent); font-weight: 600; } .s { color: var(--dk-gris); }
  .pconsole { background: var(--dk-encre); color: var(--dk-fond); font-family: var(--dk-mono); font-size: 0.68em; padding: 0.4em 0.8em; }
  .curseur { animation: clignote 1s steps(1) infinite; }
  @keyframes clignote { 50% { opacity: 0; } }
  /* ThinkPad */
  svg { width: 100%; height: auto; max-height: 52vh; }
  .coque { fill: var(--dk-encre); }
  .ecran { fill: #0c0e0f; stroke: #2a2e31; stroke-width: 2; }
  .ecran-t { font-family: var(--dk-mono); font-size: 34px; font-weight: 600; text-anchor: middle; fill: var(--dk-fond); }
  .ecran-s { font-family: var(--dk-mono); font-size: 18px; text-anchor: middle; fill: var(--dk-accent-clair); }
  .touche { fill: #2a2e31; }
  .bille { fill: var(--dk-accent); }
  .pave { fill: #2a2e31; }
  .badge { font-family: var(--dk-mono); font-size: 13px; font-weight: 600; fill: var(--dk-accent); text-anchor: end; }
  .os { display: flex; gap: 0.6em; align-items: center; justify-content: center; }
  .os span { border: 2px solid var(--dk-encre); padding: 0.3em 0.9em; font-weight: 600; font-size: 0.9em; }
  .os em { margin-left: 0.6em; color: var(--dk-gris); font-style: normal; font-size: 0.85em; }
  .appel { margin: 0; text-align: center; font-size: 1.05em; }
  /* Slack */
  .canal { border: 3px solid var(--dk-encre); background: var(--dk-fond); display: flex; flex-direction: column; text-align: left; }
  .cbar { background: var(--dk-encre); color: var(--dk-fond); padding: 0.35em 0.8em; font-size: 0.75em; font-weight: 600; }
  .msg { display: grid; grid-template-columns: auto 1fr; gap: 0.6em; padding: 0.55em 0.8em; border-bottom: 1px solid var(--dk-filet); }
  .av { display: flex; align-items: center; justify-content: center; width: 2.2em; height: 2.2em; background: var(--dk-gris); color: var(--dk-fond); font-style: normal; font-weight: 600; font-size: 0.75em; }
  .av.a { background: var(--dk-accent); }
  .msg b { font-size: 0.78em; } .msg small { font-size: 0.6em; color: var(--dk-gris); }
  .msg p { margin: 0.1em 0 0; font-size: 0.74em; line-height: 1.4; }
  .saisie { margin: 0.5em 0.8em 0.7em; border: 2px solid var(--dk-filet); padding: 0.35em 0.6em; font-size: 0.68em; color: var(--dk-gris-2); }
  /* Livre */
  .livre { grid-template-columns: auto 1fr; }
  .couv { height: 60vh; width: auto; border: 3px solid var(--dk-encre); }
  .sur { font-size: 0.62em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-accent); }
  .bloc.gauche strong { font-size: 1.5em; line-height: 1.2; }
  .bloc.gauche p { margin: 0.5em 0 0.3em; font-size: 0.92em; line-height: 1.45; }
</style>
