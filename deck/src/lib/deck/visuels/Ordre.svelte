<script>
  /**
   * L'ordre d'installation, avec les vrais objets: le logo de R, puis une
   * fenêtre Positron qui trouve R. Deux temps: le bon ordre; puis le mauvais
   * — Positron d'abord, qui s'ouvre sur rien. Le logo R est récupéré à la
   * source, jamais redessiné.
   */
  import { base } from '$app/paths';
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel ordre" bind:this={hote}>
  <div class="rang bon">
    <div class="etape">
      <span class="n">1</span>
      <img src="{base}/img/Rlogo.png" alt="R" class="rlogo" />
      <strong>R</strong><small>cran.r-project.org · le moteur</small>
    </div>
    <div class="fl">→</div>
    <div class="etape">
      <span class="n">2</span>
      <div class="pos">
        <div class="pbar"><i></i><i></i><i></i><span>Positron</span></div>
        <div class="pconsole"><span class="ok">R 4.x trouvé ✓</span><br />&gt; <b class="curseur">▍</b></div>
      </div>
      <strong>Positron</strong><small>positron.posit.co · l'éditeur</small>
    </div>
    <div class="verdict ok">✓ <span>Positron trouve R tout seul.</span></div>
  </div>

  <div class="rang mauvais" class:vu={e === 1}>
    <div class="etape">
      <span class="n">1</span>
      <div class="pos vide">
        <div class="pbar"><i></i><i></i><i></i><span>Positron</span></div>
        <div class="pconsole"><span class="err">Aucun interpréteur R</span><br />&gt; <b class="curseur">▍</b></div>
      </div>
      <strong>Positron</strong>
    </div>
    <div class="fl">→</div>
    <div class="etape">
      <span class="n">2</span>
      <img src="{base}/img/Rlogo.png" alt="R" class="rlogo pale" />
      <strong>R</strong>
    </div>
    <div class="verdict non">✗ <span>Positron s'ouvre, ne trouve rien, et tout semble cassé. Refaites l'ordre.</span></div>
  </div>
</div>

<style>
  .ordre { display: flex; flex-direction: column; gap: 1.2em; }
  .rang { display: grid; grid-template-columns: 1fr auto 1fr 1.3fr; gap: 1em; align-items: center; }
  .etape { position: relative; border: 3px solid var(--dk-encre); padding: 1em 0.9em 0.8em; display: flex; flex-direction: column; align-items: center; gap: 0.3em; text-align: center; }
  .n { position: absolute; top: -0.7em; left: 0.7em; background: var(--dk-accent); color: var(--dk-fond); font-family: var(--dk-mono); font-weight: 600; padding: 0.1em 0.55em; }
  .rlogo { height: 4.6em; width: auto; }
  .rlogo.pale { opacity: 0.3; filter: grayscale(1); }
  .etape strong { font-size: 1.25em; }
  .etape small { font-size: 0.68em; color: var(--dk-gris); }
  .pos { width: 100%; border: 2px solid var(--dk-encre); text-align: left; }
  .pbar { display: flex; align-items: center; gap: 0.3em; background: var(--dk-encre); color: var(--dk-fond); padding: 0.25em 0.5em; font-size: 0.6em; }
  .pbar i { width: 0.6em; height: 0.6em; border-radius: 50%; background: var(--dk-fond); opacity: 0.85; }
  .pbar span { margin-left: 0.5em; letter-spacing: 0.1em; }
  .pconsole { background: #0c0e0f; color: var(--dk-fond); font-family: var(--dk-mono); font-size: 0.68em; padding: 0.5em 0.7em; line-height: 1.6; }
  .ok { color: var(--dk-accent-clair); }
  .err { color: var(--dk-accent); }
  .curseur { animation: clignote 1s steps(1) infinite; font-weight: 400; }
  @keyframes clignote { 50% { opacity: 0; } }
  .fl { font-size: 2.4em; color: var(--dk-accent); }
  .mauvais { opacity: 0.12; transition: opacity 0.5s; }
  .mauvais.vu { opacity: 1; }
  .mauvais .etape { border-style: dashed; border-color: var(--dk-gris); }
  .mauvais .fl { color: var(--dk-gris); }
  .verdict { font-family: var(--dk-mono); font-weight: 600; font-size: 1.5em; display: flex; align-items: center; gap: 0.5em; }
  .verdict span { font-family: inherit; font-size: 0.55em; font-weight: 400; line-height: 1.3; color: var(--dk-encre); }
  .verdict.ok { color: var(--dk-encre); }
  .verdict.non { color: var(--dk-accent); }
</style>
