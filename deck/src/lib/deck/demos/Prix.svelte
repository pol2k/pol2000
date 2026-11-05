<script>
  import { base } from '$app/paths';
  import d from './prix.json';

  /**
   * « Par million de jetons » ne veut rien dire tant qu'on ne l'a pas traduit
   * en projet. La diapositive fait cette traduction sur LEUR corpus: les 551
   * avis de La Ligne Rouge, comptés avec un vrai tokeniseur, multipliés par
   * les prix affichés le matin même.
   *
   * Le fait contre-intuitif est en bas: la consigne, répétée à chaque appel,
   * pèse plus lourd que les avis eux-mêmes. C'est ce qu'il faut retenir pour
   * budgéter, et ça ne se devine pas.
   */
  const esp = (v) => Math.round(v).toLocaleString('fr-CA').replace(/ |,/g, ' ');
  const cents = (v) => (v * 100).toFixed(1).replace('.', ',');
  const MAX = Math.max(...d.modeles.map((m) => m.cout));
</script>

<div class="prx">
  <div class="haut">
    <figure class="cap">
      <img src="{base}/img/prix-anthropic.jpg" alt="Tarifs par million de jetons des modèles Claude" />
      <figcaption>anthropic.com/pricing · 24 août 2026</figcaption>
    </figure>

    <div class="col">
      <span class="et">CE QUE ÇA DONNE SUR VOTRE CORPUS</span>
      <p class="sous">Les {d.corpus.avis} avis de La Ligne Rouge, classés une fois</p>
      <ul class="cous">
        {#each d.modeles as m}
          <li>
            <span class="n">{m.nom}</span>
            <span class="piste"><span class="rmp" style="width: {(m.cout / MAX) * 100}%"></span></span>
            <span class="c">{cents(m.cout)} ¢</span>
          </li>
        {/each}
      </ul>
    </div>
  </div>

  <div class="col bas2">
    <span class="et">CE QUI COÛTE VRAIMENT</span>
    <ul class="rep">
      <li><span class="v">{esp(d.corpus.jetons_avis)}</span><span class="l">jetons : les avis</span></li>
      <li class="fort">
        <span class="v">{esp(d.corpus.jetons_consigne_total)}</span
        ><span class="l">jetons : la consigne, renvoyée {d.corpus.avis} fois</span>
      </li>
    </ul>
    <p class="note">
      La consigne coûte plus cher que les données. Elle repart entière à chaque appel.
    </p>
  </div>
</div>

<style>
  .prx {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.7em;
  }
  .cap {
    margin: 0;
  }
  .cap img {
    display: block;
    width: 100%;
    height: auto;
    border: 2px solid var(--dk-encre);
  }

  /* La capture à gauche des coûts: en bandeau pleine largeur elle prenait le
     tiers de la diapositive et écrasait ce qu'elle sert à expliquer. */
  .haut {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1.3em;
    align-items: start;
  }
  .bas2 {
    border-top: 2px solid var(--dk-filet);
    padding-top: 0.45em;
  }
  .cap figcaption {
    font-size: 0.52em;
    color: var(--dk-gris-2);
    margin-top: 0.2em;
  }
  .col {
    display: flex;
    flex-direction: column;
    gap: 0.15em;
    min-width: 0;
  }
  .et {
    font-size: 0.56em;
    letter-spacing: 0.15em;
    font-weight: 600;
    color: var(--dk-accent);
  }
  .sous {
    margin: 0 0 0.2em;
    font-size: 0.58em;
    color: var(--dk-gris);
  }

  .cous {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.18em;
  }
  .cous li {
    display: grid;
    grid-template-columns: 7em 1fr 4.8em;
    gap: 0.6em;
    align-items: center;
    font-size: 0.62em;
  }
  .n {
    color: var(--dk-encre);
  }
  .piste {
    height: 0.7em;
    background: var(--dk-fond-2);
  }
  .rmp {
    display: block;
    height: 100%;
    background: var(--dk-accent);
  }
  .c {
    text-align: right;
    white-space: nowrap;
    font-weight: 600;
    color: var(--dk-accent);
    font-variant-numeric: tabular-nums;
  }

  .rep {
    list-style: none;
    margin: 0.1em 0 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.15em;
  }
  .rep li {
    display: grid;
    grid-template-columns: 5.2em 1fr;
    gap: 0.6em;
    align-items: baseline;
    border-left: 3px solid var(--dk-filet);
    padding-left: 0.6em;
  }
  /* La consigne pèse plus que les données: c'est la ligne à retenir. */
  .rep li.fort {
    border-left-color: var(--dk-accent);
  }
  .rep .v {
    font-size: 0.9em;
    white-space: nowrap;
    font-weight: 600;
    color: var(--dk-encre);
    font-variant-numeric: tabular-nums;
    text-align: right;
  }
  .rep li.fort .v {
    color: var(--dk-accent);
  }
  .rep .l {
    font-size: 0.58em;
    color: var(--dk-gris);
    line-height: 1.3;
  }
  .note {
    margin: 0.35em 0 0;
    font-size: 0.62em;
    line-height: 1.4;
    color: var(--dk-encre);
  }
</style>
