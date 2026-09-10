<script>
  /**
   * Les deux outils du semestre, sans prose : le logo de R et celui de
   * Positron, un rôle chacun, et l'image qui les relie, la calculatrice
   * posée sur le bureau. Trois temps automatiques : R tombe, le +, puis
   * Positron ; au bout, la petite calculatrice R vient se poser sur le
   * bureau de Positron. Aucun clic : la diapo se joue seule à l'arrivée.
   */
  import { base } from '$app/paths';
</script>

<div class="visuel rpos">
  <div class="carte r">
    <img src="{base}/img/Rlogo.png" alt="R" class="logo" />
    <strong>R</strong>
    <span class="role">LE LANGAGE</span>
    <em>la calculatrice</em>
  </div>
  <div class="plus">+</div>
  <div class="carte p">
    <img src="{base}/img/positron-logo.png" alt="Positron" class="logo" />
    <strong>Positron</strong>
    <span class="role">L’ÉDITEUR</span>
    <em>le bureau de travail</em>
    <img src="{base}/img/Rlogo.png" alt="" class="mini" aria-hidden="true" />
  </div>
</div>

<style>
  .rpos { display: grid; grid-template-columns: 1fr auto 1fr; gap: 1.6em; align-items: stretch; }
  .carte { position: relative; border: 3px solid var(--dk-encre); background: #fff; padding: 1.6em 1.2em 1.4em; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.35em; animation: tombe 0.6s cubic-bezier(0.2, 1.3, 0.4, 1) both; }
  .carte.p { animation-delay: 0.9s; }
  .logo { height: 7.5em; width: auto; max-width: 80%; object-fit: contain; margin-bottom: 0.5em; }
  .carte.p .logo { height: 5.5em; margin: 1em 0 1.5em; }
  .carte strong { font-size: 2.2em; line-height: 1; letter-spacing: -0.03em; }
  .role { font-size: 0.66em; letter-spacing: 0.2em; font-weight: 600; color: var(--dk-accent); margin-top: 0.2em; }
  .carte em { font-style: normal; font-size: 1.05em; font-weight: 600; color: var(--dk-gris); margin-top: 0.6em; }
  .plus { align-self: center; font-family: var(--dk-mono); font-size: 4em; font-weight: 600; color: var(--dk-accent); animation: pop 0.4s 0.6s cubic-bezier(0.2, 1.4, 0.4, 1) both; }
  /* La calculatrice se pose sur le bureau: le petit R glisse dans le coin de Positron. */
  .mini { position: absolute; right: 0.8em; top: 0.8em; height: 3em; width: auto; transform: rotate(-12deg); animation: pose 0.8s 1.8s cubic-bezier(0.2, 1.2, 0.4, 1) both; filter: drop-shadow(0 0.15em 0 rgba(12, 14, 15, 0.25)); }
  @keyframes tombe { from { opacity: 0; transform: translateY(-1.5em) rotate(-2deg); } to { opacity: 1; transform: none; } }
  @keyframes pop { from { opacity: 0; transform: scale(0.3); } to { opacity: 1; transform: scale(1); } }
  @keyframes pose { from { opacity: 0; transform: translate(-16em, 4em) rotate(-40deg) scale(1.8); } to { opacity: 1; transform: rotate(-12deg); } }
</style>
