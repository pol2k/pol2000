<script>
  /**
   * L'ordre d'installation, et le piège: Positron avant R s'ouvre sur du
   * vide. Le bon ordre en haut, le mauvais barré en dessous.
   */
</script>

<div class="visuel ordre" role="img" aria-label="Installer R, puis Positron. L'ordre inverse est barré.">
  <div class="rang bon">
    <div class="boite"><span class="n">1</span><strong>R</strong><small>cran.r-project.org</small><em>le moteur</em></div>
    <div class="fl">→</div>
    <div class="boite"><span class="n">2</span><strong>Positron</strong><small>positron.posit.co</small><em>l'éditeur</em></div>
    <div class="verdict ok">✓</div>
  </div>
  <div class="rang mauvais">
    <div class="boite"><span class="n">1</span><strong>Positron</strong></div>
    <div class="fl">→</div>
    <div class="boite"><span class="n">2</span><strong>R</strong></div>
    <div class="verdict non">✗ <span>Positron s'ouvre et ne trouve rien</span></div>
  </div>
</div>

<style>
  .ordre { display: flex; flex-direction: column; gap: 0.8em; }
  .rang { display: grid; grid-template-columns: 1fr auto 1fr 1.4fr; gap: 0.8em; align-items: center; }
  .boite { border: 3px solid var(--dk-encre); padding: 0.6em 0.9em; display: grid; grid-template-columns: auto 1fr; column-gap: 0.7em; align-items: baseline; }
  .boite .n { font-family: var(--dk-mono); font-weight: 600; color: var(--dk-accent); font-size: 1.3em; grid-row: 1 / 4; }
  .boite strong { font-size: 1.5em; }
  .boite small { font-size: 0.65em; color: var(--dk-gris); white-space: nowrap; }
  .boite em { font-size: 0.7em; color: var(--dk-accent); font-style: normal; font-weight: 600; }
  .fl { font-size: 2em; color: var(--dk-accent); }
  .mauvais { position: relative; opacity: 0.55; }
  .mauvais .boite { border-style: dashed; }
  .mauvais .fl { color: var(--dk-gris); }
  .mauvais::after { content: ''; position: absolute; left: 0; right: 36%; top: 50%; border-top: 4px solid var(--dk-accent); transform: rotate(-4deg); }
  .verdict { font-family: var(--dk-mono); font-weight: 600; font-size: 1.6em; }
  .verdict.ok { color: var(--dk-encre); }
  .verdict.non { color: var(--dk-accent); display: flex; align-items: center; gap: 0.5em; }
  .verdict.non span { font-size: 0.5em; font-weight: 400; color: var(--dk-encre); line-height: 1.2; }
</style>
