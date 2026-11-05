<script>
  /**
   * Le modèle brisé qui a l'air excellent.
   *
   * Cent personnes, une seule malade. Un modèle qui répond « non » à tout le
   * monde se trompe une fois sur cent — et ne sert à rien. Le dessin met les
   * deux faits côte à côte: la grille presque toute juste, et le seul cas qui
   * comptait, raté.
   *
   * Cent points plutôt que mille: à 1 % de prévalence, cent suffit pour que
   * le point unique se voie, et le compte reste lisible.
   */
  const N = 100;
  const MALADE = 46; // au milieu, pour qu'on le cherche un instant
</script>

<div class="mes">
  <p class="premisse">
    Une maladie qui touche <strong>1 %</strong> des gens. Un modèle brisé répond
    <strong>« non »</strong> à tout le monde.
  </p>

  <div class="grille" role="img" aria-label="Cent personnes, une seule malade. Le modèle répond non à tout le monde: il a raison 99 fois et rate la seule personne malade.">
    {#each Array(N) as _, i}
      <span class="p" class:malade={i === MALADE}></span>
    {/each}
  </div>

  <div class="bilan">
    <div class="col">
      <span class="v">99 %</span>
      <span class="l">de précision</span>
      <span class="d">99 personnes sur 100 correctement classées</span>
    </div>
    <div class="col rate">
      <span class="v">0</span>
      <span class="l">malade détecté</span>
      <span class="d">le seul cas qui comptait est passé au travers</span>
    </div>
  </div>

  <p class="note">
    D'autres mesures existent pour ce genre de situation. La précision seule ne suffit pas.
  </p>
</div>

<style>
  .mes {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.6em;
  }
  .premisse {
    margin: 0;
    font-size: 0.78em;
    line-height: 1.45;
    color: var(--dk-encre);
  }

  /* Cent points, un seul en accent: on le cherche, et c'est le propos. */
  .grille {
    display: grid;
    grid-template-columns: repeat(25, 1fr);
    gap: 0.28em;
    max-width: 30em;
  }
  .p {
    aspect-ratio: 1;
    border: 1.5px solid var(--dk-gris-2);
  }
  .p.malade {
    background: var(--dk-accent);
    border-color: var(--dk-accent);
  }

  .bilan {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.6em;
    margin-top: 0.3em;
  }
  .col {
    display: flex;
    flex-direction: column;
    gap: 0.02em;
    border-left: 3px solid var(--dk-gris-2);
    padding-left: 0.8em;
  }
  .col.rate {
    border-left-color: var(--dk-accent);
  }
  .v {
    font-size: 2.1em;
    font-weight: 600;
    line-height: 1;
    letter-spacing: -0.04em;
    color: var(--dk-encre);
    font-variant-numeric: tabular-nums;
  }
  .col.rate .v {
    color: var(--dk-accent);
  }
  .l {
    font-size: 0.6em;
    letter-spacing: 0.13em;
    text-transform: uppercase;
    color: var(--dk-gris);
  }
  .d {
    font-size: 0.6em;
    color: var(--dk-gris);
    margin-top: 0.15em;
  }

  .note {
    margin: 0;
    font-size: 0.72em;
    color: var(--dk-encre);
  }
  .note strong {
    color: var(--dk-accent);
  }
</style>
