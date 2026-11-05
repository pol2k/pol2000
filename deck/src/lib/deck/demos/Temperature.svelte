<script>
  import d from './temperature.json';

  /**
   * La même distribution, à trois températures. On voit l'aplatissement au
   * lieu de le lire dans un tableau.
   *
   * La distribution de départ est mesurée — premier jeton de la génération de
   * la diapositive précédente. Les deux autres s'en déduisent par la formule
   * de la température, p^(1/T) renormalisé: ce ne sont pas des illustrations,
   * c'est le calcul que fait le serveur.
   */
  const lisible = (t) => (t === ' ' ? '␣' : t.replace(/^ /, '␣'));
</script>

<div class="temp">
  <p class="amorce">« {d.amorce} », le jeton suivant</p>

  <div class="cols">
    {#each d.temperatures as bloc}
      <section class="col" class:zero={bloc.t === 0}>
        <div class="tete">
          <span class="val">{bloc.t.toFixed(1).replace('.', ',')}</span>
          <span class="usage">{bloc.usage}</span>
        </div>
        <ul>
          {#each bloc.candidats as c, i}
            <li class:gagnant={i === 0}>
              <span class="jt">{lisible(c.t)}</span>
              <span class="piste"><span class="rempli" style="height: {c.p}%"></span></span>
              <span class="pc">{c.p.toFixed(0)}</span>
            </li>
          {/each}
        </ul>
      </section>
    {/each}
  </div>

  <p class="note">
    Zéro rend les sorties <strong>plus stables</strong>, jamais déterministes : le calcul en virgule
    flottante et le routage entre serveurs laissent une variation résiduelle.
  </p>
</div>

<style>
  .temp {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.5em;
  }
  .amorce {
    margin: 0;
    font-size: 0.66em;
    color: var(--dk-gris);
  }

  .cols {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1em;
  }
  .col {
    border: 2px solid var(--dk-filet);
    padding: 0.5em 0.6em 0.6em;
    display: flex;
    flex-direction: column;
    gap: 0.4em;
  }
  /* Zéro est le réglage de mesure: c'est celui qu'on veut qu'ils retiennent. */
  .col.zero {
    border-color: var(--dk-accent);
  }

  .tete {
    display: flex;
    flex-direction: column;
  }
  .val {
    font-size: 1.5em;
    font-weight: 600;
    line-height: 1;
    letter-spacing: -0.04em;
    color: var(--dk-gris);
    font-variant-numeric: tabular-nums;
  }
  .col.zero .val {
    color: var(--dk-accent);
  }
  .usage {
    font-size: 0.55em;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    color: var(--dk-gris-2);
  }

  /* Des barres verticales: l'aplatissement d'une colonne à l'autre se lit
     d'un coup d'œil, ce qu'un tableau de valeurs ne donne jamais. */
  ul {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    align-items: flex-end;
    gap: 0.3em;
    height: 6.2em;
  }
  li {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.15em;
    height: 100%;
    justify-content: flex-end;
  }
  .piste {
    width: 100%;
    flex: 1;
    display: flex;
    align-items: flex-end;
    background: var(--dk-fond-2);
  }
  .rempli {
    width: 100%;
    background: var(--dk-gris-2);
    min-height: 1px;
  }
  li.gagnant .rempli {
    background: var(--dk-accent);
  }
  .jt {
    font-size: 0.5em;
    color: var(--dk-gris);
    order: 3;
  }
  .pc {
    font-size: 0.5em;
    color: var(--dk-gris-2);
    font-variant-numeric: tabular-nums;
  }
  li.gagnant .pc {
    color: var(--dk-accent);
    font-weight: 600;
  }

  .note {
    margin: 0;
    font-size: 0.62em;
    color: var(--dk-gris);
  }
</style>
