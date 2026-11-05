<script>
  /**
   * On ne lance pas 551 appels sur un prompt qu'on n'a pas vérifié.
   *
   * Le dessin oppose deux volumes: cinq lignes qu'on relit à l'œil, puis le
   * corpus entier. C'est le rapport de taille qui fait l'argument, pas la
   * consigne écrite en dessous.
   */
  const N_ECH = 5;
  const N_TOT = 551;
</script>

<div class="ech">
  <div class="etape">
    <span class="num">1</span>
    <div class="corps">
      <h3>SUR UN ÉCHANTILLON</h3>
      <div class="grille petite">
        {#each Array(N_ECH) as _, i}<span class="case pleine"></span>{/each}
      </div>
      <p class="n">{N_ECH} lignes</p>
      <p class="quoi">On lit les cinq sorties à l'œil. On corrige le prompt.</p>
    </div>
  </div>

  <div class="fleche">↓</div>

  <div class="etape">
    <span class="num">2</span>
    <div class="corps">
      <h3>SUR TOUT LE CORPUS</h3>
      <div class="grille">
        {#each Array(60) as _, i}<span class="case" class:pleine={i < 5}></span>{/each}
      </div>
      <p class="n fort">{N_TOT} lignes</p>
      <p class="quoi">Une fois seulement, et sans surveillance.</p>
    </div>
  </div>
</div>

<style>
  .ech {
    display: flex;
    flex-direction: column;
    gap: 0.35em;
    width: 100%;
  }
  .etape {
    display: grid;
    grid-template-columns: 1.6em 1fr;
    gap: 0.7em;
    align-items: start;
  }
  .num {
    font-size: 1.05em;
    font-weight: 600;
    color: var(--dk-accent);
    line-height: 1.1;
  }
  .corps {
    display: flex;
    flex-direction: column;
    gap: 0.22em;
  }
  h3 {
    margin: 0;
    font-size: 0.58em;
    letter-spacing: 0.15em;
    font-weight: 600;
    color: var(--dk-gris);
  }

  .grille {
    display: flex;
    flex-wrap: wrap;
    gap: 0.14em;
    max-width: 26em;
  }
  .case {
    width: 0.62em;
    height: 0.62em;
    border: 1px solid var(--dk-gris-2);
  }
  /* Les cinq mêmes lignes, d'abord seules puis noyées dans le reste: c'est
     le même échantillon, pas un autre. */
  .case.pleine {
    background: var(--dk-accent);
    border-color: var(--dk-accent);
  }
  .grille.petite .case {
    width: 0.9em;
    height: 0.9em;
  }

  .n {
    margin: 0.15em 0 0;
    font-size: 0.72em;
    font-weight: 600;
    color: var(--dk-gris);
    font-variant-numeric: tabular-nums;
  }
  .n.fort {
    color: var(--dk-accent);
  }
  .quoi {
    margin: 0;
    font-size: 0.6em;
    color: var(--dk-gris);
  }
  .fleche {
    margin-left: 0.5em;
    color: var(--dk-gris-2);
    font-size: 0.85em;
    line-height: 1;
  }
</style>
