<script>
  /**
   * L'équipe, en quatre cartes: qui, quel rôle, pour quoi on lui écrit. Slack
   * en bandeau au-dessus: un seul canal pour tout le monde. Les noms viennent
   * de l'enseignant. Photos: eiom.ca (Foisy, Dupuis), chaire-epi.ulaval.ca
   * (Piral), fournie par l'enseignant (Ménard). Les initiales restent le
   * repli si une photo manque.
   */
  import { base } from '$app/paths';
  const GENS = [
    { ini: 'LOF', photo: 'photo-foisy.jpg', nom: 'Laurence-Olivier M. Foisy', role: 'Enseignant', pour: 'le cours, le plan, les notes, les cas particuliers', grand: true },
    { ini: 'JP', photo: 'photo-piral.jpg', nom: 'Jules Piral', role: 'Auxiliaire', pour: 'R, les exercices, les travaux' },
    { ini: 'MAD', photo: 'photo-dupuis.jpg', nom: 'Marc-Antoine Dupuis', role: 'Auxiliaire', pour: 'R, les exercices, les travaux' },
    { ini: 'AM', photo: 'photo-menard.jpg', nom: 'Adam Ménard', role: 'Tuteur', pour: 'quand ça décroche : on reprend depuis le début' }
  ];
</script>

<div class="visuel equipe">
  <div class="canal"><span class="hash">#</span><strong>Slack</strong><span>un seul endroit, pour toute l'équipe, en tout temps</span></div>
  <div class="cartes">
    {#each GENS as g}
      <div class="carte" class:grand={g.grand}>
        <div class="avatar" class:acc={g.grand}>{#if g.photo}<img src="{base}/img/{g.photo}" alt="" />{:else}{g.ini}{/if}</div>
        <span class="role">{g.role}</span>
        <strong>{g.nom}</strong>
        <span class="pour">{g.pour}</span>
      </div>
    {/each}
  </div>
  <div class="bas">
    <span><strong>8 octobre</strong> et <strong>26 novembre</strong> · rencontres individuelles, toute l'équipe</span>
    <span><strong>pol2000.com</strong> · rendez-vous dans les plages publiées</span>
  </div>
</div>

<style>
  .equipe { display: flex; flex-direction: column; gap: 0.9em; }
  .canal { display: flex; align-items: baseline; gap: 0.6em; background: var(--dk-encre); color: var(--dk-fond); padding: 0.5em 1em; }
  .canal .hash { font-family: var(--dk-mono); font-size: 1.6em; color: var(--dk-accent-clair); font-weight: 600; }
  .canal strong { font-size: 1.2em; }
  .canal span:last-child { font-size: 0.8em; opacity: 0.85; }
  .cartes { display: grid; grid-template-columns: 1.3fr 1fr 1fr 1fr; gap: 0.8em; }
  .carte { border: 2px solid var(--dk-encre); padding: 1em 0.9em; display: flex; flex-direction: column; align-items: center; text-align: center; gap: 0.25em; }
  .carte.grand { border-width: 3px; border-color: var(--dk-accent); }
  .avatar { width: 3.4em; height: 3.4em; border-radius: 50%; border: 3px solid var(--dk-encre); display: flex; align-items: center; justify-content: center; font-family: var(--dk-mono); font-weight: 600; font-size: 0.85em; margin-bottom: 0.4em; }
  .avatar.acc { border-color: var(--dk-accent); color: var(--dk-accent); }
  .avatar img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; }
  .avatar { overflow: hidden; width: 5em; height: 5em; }
  .role { font-size: 0.6em; letter-spacing: 0.16em; text-transform: uppercase; color: var(--dk-gris); font-weight: 600; }
  .carte strong { font-size: 0.95em; line-height: 1.2; }
  .pour { font-size: 0.72em; color: var(--dk-gris); line-height: 1.35; margin-top: 0.2em; }
  .bas { display: flex; justify-content: space-between; gap: 1em; font-size: 0.78em; color: var(--dk-gris); }
  .bas strong { color: var(--dk-accent); }
</style>
