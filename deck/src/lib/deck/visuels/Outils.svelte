<script>
  /**
   * Trois diapos-objets, chacune avec son image ou son mouvement, sans copier
   * une interface:
   *   positron  — le logo officiel, puis une ligne de R qui se tape toute
   *               seule et rend son résultat (le vrai, de ces_fit2.R).
   *   ordi      — un ThinkPad Z13, photo CC0 (Wikimedia Commons), qui flotte.
   *   slack     — une fenêtre Slack fidèle et calme: canaux, message de
   *               bienvenue, indicateur de saisie. Pas de conversation jouée.
   *   rvs       — R et Positron: ce que chacun est, sans ordre d'installation.
   */
  import { base } from '$app/paths';
  import { REG } from '$lib/data/ces.js';
  let { quoi } = $props();

  // Positron: la ligne qui se tape
  const LIGNE = 'lm(vote_conservateur ~ cps25_income, data = ces)';
  let tape = $state('');
  let fini = $state(false);
  $effect(() => {
    if (quoi !== 'positron') return;
    let i = 0;
    const id = setInterval(() => {
      i += 1;
      if (i <= LIGNE.length) { tape = LIGNE.slice(0, i); fini = false; }
      else if (i === LIGNE.length + 6) fini = true;
      else if (i > LIGNE.length + 40) { i = 0; tape = ''; fini = false; }
    }, 70);
    return () => clearInterval(id);
  });
  const coef = REG.coefs[1].estimate;
</script>

{#if quoi === 'positron'}
  <div class="visuel outil positron">
    <img src="{base}/img/positron-logo.png" alt="Positron" class="plogo" />
    <p class="ligne-haut">L'éditeur, par Posit. Gratuit. Là où vous écrirez, verrez et corrigerez votre code, chaque semaine.</p>
    <div class="editeur">
      <div class="gouttiere"><span>1</span><span>2</span></div>
      <div class="code">
        <div class="l1"><span class="com"># une ligne, un résultat</span></div>
        <div class="l2">{tape}<b class="curseur">▍</b></div>
      </div>
    </div>
    <div class="sortie" class:vu={fini}>
      <span class="prompt">&gt;</span> Coefficients: <span class="k">(Intercept)</span> {REG.coefs[0].estimate.toLocaleString('fr-CA', { minimumFractionDigits: 3 })} &nbsp; <span class="k">cps25_income</span> {coef.toLocaleString('fr-CA', { minimumFractionDigits: 3 })}
    </div>
    <div class="trois">
      <span>Éditeur</span><span>Console</span><span>Graphiques</span><span>Données</span>
    </div>
  </div>

{:else if quoi === 'ordi'}
  <div class="visuel outil ordi">
    <div class="scene">
      <img src="{base}/img/thinkpad-z13.png" alt="Un ordinateur portable ThinkPad ouvert" class="laptop" />
      <div class="ombre"></div>
    </div>
    <div class="os"><span>Windows</span><span>macOS</span><span>Linux</span><em>n'importe lequel</em></div>
    <p class="appel">Pas d'ordinateur ? <strong>Venez me voir.</strong></p>
  </div>

{:else if quoi === 'slack'}
  <div class="visuel outil slackui">
    <aside>
      <div class="ws"><strong>POL-2000 · A26</strong><span>▾</span></div>
      <div class="sec">Canaux</div>
      <div class="ch on"># général</div>
      <div class="ch"># r-et-positron</div>
      <div class="ch"># travaux</div>
      <div class="ch"># examens</div>
      <div class="ch"># datacamp</div>
      <div class="sec">Messages directs</div>
      <div class="ch dm"><i class="pt"></i>Laurence-Olivier M. Foisy</div>
      <div class="ch dm"><i class="pt"></i>Jules Piral</div>
      <div class="ch dm"><i class="pt"></i>Marc-Antoine Dupuis</div>
      <div class="ch dm"><i class="pt"></i>Adam Ménard</div>
    </aside>
    <main>
      <div class="tete"><strong># général</strong><span>Tout le monde · le seul canal du cours</span></div>
      <div class="msgs">
        <div class="msg m1"><img src="{base}/img/photo-foisy.jpg" alt="" /><div><b>Laurence-Olivier M. Foisy</b><small>aujourd'hui, 15h30</small><p>Bienvenue dans POL-2000. À partir de la semaine 3, c'est ici qu'on se parle : questions, blocages, rendez-vous. Je ne réponds plus aux courriels.</p></div></div>
        <div class="msg m2"><span class="sys">Jules Piral, Marc-Antoine Dupuis et Adam Ménard ont rejoint le canal.</span></div>
        <div class="msg m3"><img src="{base}/img/photo-dupuis.jpg" alt="" /><div><b>Marc-Antoine Dupuis</b><small>15h34</small><p>Le canal <b>#r-et-positron</b> est pour tout ce qui ne marche pas sur votre machine. On y répond vite.</p></div></div>
        <div class="tape"><i></i><i></i><i></i><span>Jules Piral est en train d'écrire…</span></div>
      </div>
      <div class="saisie"><span>Message #général</span><b>⏎</b></div>
    </main>
  </div>

{:else}
  <div class="visuel outil rvs">
    <div class="colonne">
      <img src="{base}/img/Rlogo.png" alt="R" class="rlogo" />
      <strong>R</strong>
      <span class="role">LE LANGAGE</span>
      <p>C'est lui qui calcule. Il lit vos données, fait la régression, dessine le graphique. Sans lui, rien ne se passe.</p>
      <em>le moteur</em>
    </div>
    <div class="et">+</div>
    <div class="colonne">
      <img src="{base}/img/positron-logo.png" alt="Positron" class="plogo2" />
      <strong>Positron</strong>
      <span class="role">L'ÉDITEUR</span>
      <p>C'est là que vous écrivez, que vous voyez vos données et vos graphiques, que vous corrigez. Il parle à R pour vous.</p>
      <em>le tableau de bord</em>
    </div>
    <p class="note">Positron vous propose d'installer R s'il ne le trouve pas. Deux outils, gratuits, sur Windows, macOS et Linux.</p>
  </div>
{/if}

<style>
  .outil { display: flex; flex-direction: column; gap: 0.8em; }
  /* ---- Positron ---- */
  .plogo { width: 22em; max-width: 60%; height: auto; align-self: center; }
  .ligne-haut { margin: 0; text-align: center; font-size: 0.95em; color: var(--dk-gris); }
  .editeur { display: grid; grid-template-columns: 2.4em 1fr; border: 3px solid var(--dk-encre); background: var(--dk-fond); font-family: var(--dk-mono); font-size: 1.05em; }
  .gouttiere { display: flex; flex-direction: column; gap: 0.3em; padding: 0.7em 0.5em; background: var(--dk-fond-2); color: var(--dk-gris-2); text-align: right; font-size: 0.8em; border-right: 2px solid var(--dk-filet); }
  .code { padding: 0.6em 0.9em; display: flex; flex-direction: column; gap: 0.3em; min-height: 3.6em; }
  .com { color: var(--dk-gris); }
  .curseur { animation: clignote 1s steps(1) infinite; color: var(--dk-accent); font-weight: 400; }
  @keyframes clignote { 50% { opacity: 0; } }
  .sortie { background: var(--dk-encre); color: var(--dk-fond); font-family: var(--dk-mono); font-size: 0.85em; padding: 0.6em 0.9em; opacity: 0; transition: opacity 0.4s; }
  .sortie.vu { opacity: 1; }
  .prompt { color: var(--dk-accent-clair); } .k { color: var(--dk-accent-clair); }
  .trois { display: flex; gap: 0.6em; justify-content: center; }
  .trois span { border: 2px solid var(--dk-encre); padding: 0.3em 0.9em; font-size: 0.8em; font-weight: 600; }
  /* ---- Ordinateur ---- */
  .scene { position: relative; display: flex; justify-content: center; }
  .laptop { width: 62%; max-height: 58vh; object-fit: contain; animation: flotte 5s ease-in-out infinite; }
  @keyframes flotte { 0%, 100% { transform: translateY(0) rotate(0); } 50% { transform: translateY(-1.1em) rotate(-0.6deg); } }
  .ombre { position: absolute; bottom: -0.2em; left: 50%; width: 46%; height: 1.4em; transform: translateX(-50%); background: radial-gradient(ellipse, rgba(12,14,15,0.35), transparent 70%); animation: souffle 5s ease-in-out infinite; }
  @keyframes souffle { 0%, 100% { transform: translateX(-50%) scaleX(1); opacity: 0.9; } 50% { transform: translateX(-50%) scaleX(0.82); opacity: 0.5; } }
  .os { display: flex; gap: 0.6em; align-items: center; justify-content: center; }
  .os span { border: 2px solid var(--dk-encre); padding: 0.3em 0.9em; font-weight: 600; font-size: 0.9em; }
  .os em { margin-left: 0.6em; color: var(--dk-gris); font-style: normal; font-size: 0.85em; }
  .appel { margin: 0; text-align: center; font-size: 1.1em; }
  /* ---- Slack ---- */
  .slackui { display: grid; grid-template-columns: 15em 1fr; border: 3px solid #3f0e40; height: 66vh; font-family: 'Libre Franklin', system-ui, sans-serif; gap: 0; }
  .slackui aside { background: #3f0e40; color: #cfc3cf; padding: 0.6em 0; display: flex; flex-direction: column; font-size: 0.78em; }
  .ws { display: flex; justify-content: space-between; align-items: center; padding: 0.4em 1em 0.7em; color: #fff; border-bottom: 1px solid #522653; margin-bottom: 0.5em; }
  .ws strong { font-size: 1.05em; }
  .sec { padding: 0.5em 1em 0.2em; font-size: 0.85em; color: #a99ca9; }
  .ch { padding: 0.25em 1em; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .ch.on { background: #1164a3; color: #fff; }
  .ch.dm { display: flex; align-items: center; gap: 0.5em; }
  .pt { width: 0.55em; height: 0.55em; border-radius: 50%; background: #2bac76; flex: none; }
  .slackui main { display: flex; flex-direction: column; background: #fff; color: #1d1c1d; }
  .tete { padding: 0.6em 1em; border-bottom: 1px solid #e0e0e0; display: flex; gap: 0.8em; align-items: baseline; }
  .tete strong { font-size: 0.95em; } .tete span { font-size: 0.72em; color: #616061; }
  .msgs { flex: 1; padding: 0.6em 1em; display: flex; flex-direction: column; gap: 0.7em; overflow: hidden; }
  .msg { display: grid; grid-template-columns: 2.4em 1fr; gap: 0.7em; opacity: 0; animation: monte 0.5s both; }
  .msg.m1 { animation-delay: 0.4s; } .msg.m2 { animation-delay: 1.4s; grid-template-columns: 1fr; } .msg.m3 { animation-delay: 2.4s; }
  @keyframes monte { from { opacity: 0; transform: translateY(0.4em); } to { opacity: 1; transform: none; } }
  .msg img { width: 2.4em; height: 2.4em; border-radius: 4px; object-fit: cover; }
  .msg b { font-size: 0.82em; } .msg small { font-size: 0.65em; color: #616061; margin-left: 0.5em; }
  .msg p { margin: 0.15em 0 0; font-size: 0.8em; line-height: 1.45; }
  .sys { font-size: 0.72em; color: #616061; font-style: italic; }
  .tape { display: flex; align-items: center; gap: 0.25em; margin-top: auto; font-size: 0.7em; color: #616061; opacity: 0; animation: monte 0.5s 3.4s both; }
  .tape i { width: 0.4em; height: 0.4em; border-radius: 50%; background: #616061; animation: pulse 1.2s infinite; }
  .tape i:nth-child(2) { animation-delay: 0.2s; } .tape i:nth-child(3) { animation-delay: 0.4s; }
  .tape span { margin-left: 0.4em; }
  @keyframes pulse { 0%, 80%, 100% { opacity: 0.25; } 40% { opacity: 1; } }
  .saisie { margin: 0.6em 1em 0.8em; border: 1.5px solid #8d8d8d; border-radius: 6px; padding: 0.5em 0.8em; display: flex; justify-content: space-between; font-size: 0.78em; color: #616061; }
  .saisie b { color: #007a5a; }
  /* ---- R vs Positron ---- */
  .rvs { display: grid; grid-template-columns: 1fr auto 1fr; gap: 1.4em; align-items: stretch; }
  .colonne { border: 3px solid var(--dk-encre); padding: 1.2em 1.2em 1em; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.3em; }
  .rlogo { height: 5.5em; width: auto; }
  .plogo2 { width: 14em; height: auto; margin: 1.2em 0; }
  .colonne strong { font-size: 1.6em; }
  .role { font-size: 0.62em; letter-spacing: 0.18em; font-weight: 600; color: var(--dk-accent); }
  .colonne p { margin: 0.4em 0 0; font-size: 0.9em; line-height: 1.45; }
  .colonne em { margin-top: 0.5em; font-style: normal; font-weight: 600; color: var(--dk-gris); }
  .et { align-self: center; font-family: var(--dk-mono); font-size: 3em; color: var(--dk-accent); }
  .rvs .note { grid-column: 1 / -1; margin: 0; text-align: center; font-size: 0.85em; color: var(--dk-gris); }
</style>
