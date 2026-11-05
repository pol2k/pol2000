<script>
  import d from './modeles.json';

  /**
   * Combien de modèles existe-t-il, et comment on tranche.
   *
   * Le nombre n'est pas une estimation: c'est le catalogue d'un seul
   * revendeur, relevé le jour même. La grille de points donne l'ordre de
   * grandeur d'un coup d'œil — chaque point est un modèle offert.
   *
   * À droite, les quatre questions qui décident vraiment. Aucune n'est
   * « lequel est le meilleur »: la question n'a pas de réponse générale, et
   * c'est ça qu'il faut faire comprendre.
   */
  const espace = (v) => Math.round(v).toLocaleString('fr-CA').replace(/ |,/g, ' ');
  const CRITERES = [
    { q: 'Combien ça coûte', r: `de ${String(d.prix_min).replace('.', ',')} $ à ${espace(d.prix_max)} $ le million de jetons, un facteur ${espace(d.prix_max / d.prix_min)}` },
    { q: 'Où passent les données', r: 'chez le fournisseur, ou sur votre machine si le modèle est ouvert' },
    { q: 'Le modèle est-il épinglable', r: 'un nom de version qui ne bougera pas, sinon la reproductibilité tombe' },
    { q: 'Fait-il la tâche', r: 'la seule réponse valable vient d’une comparaison sur VOTRE corpus' }
  ];
</script>

<div class="mod">
  <section class="gauche">
    <div class="chiffres">
      <div class="gros">
        <span class="v">{espace(d.total)}</span>
        <span class="l">modèles offerts</span>
      </div>
      <div class="gros petit">
        <span class="v">{d.fournisseurs}</span>
        <span class="l">fournisseurs</span>
      </div>
    </div>

    <div class="nuage" aria-hidden="true">
      {#each Array(d.total) as _, i}<span class="pt" style="--i: {i % 11}"></span>{/each}
    </div>

    <ul class="tops">
      {#each d.top.slice(0, 5) as t}
        <li><span class="n">{t.nom}</span><span class="c">{t.n}</span></li>
      {/each}
      <li class="reste"><span class="n">… {d.fournisseurs - 5} autres fournisseurs</span></li>
    </ul>
  </section>

  <section class="droite">
    <span class="tete">CE QUI DÉCIDE VRAIMENT</span>
    <ul class="crit">
      {#each CRITERES as c, i}
        <li><span class="q">{c.q}</span><span class="r">{c.r}</span></li>
      {/each}
    </ul>
  </section>
</div>

<style>
  .mod {
    display: grid;
    grid-template-columns: 1fr 1.15fr;
    gap: 1.4em;
    width: 100%;
    align-items: start;
  }

  .chiffres {
    display: flex;
    align-items: baseline;
    gap: 1.4em;
  }
  .gros {
    display: flex;
    flex-direction: column;
  }
  .gros .v {
    font-size: 2.4em;
    font-weight: 600;
    line-height: 1;
    letter-spacing: -0.05em;
    color: var(--dk-accent);
    font-variant-numeric: tabular-nums;
  }
  .gros.petit .v {
    font-size: 1.5em;
    color: var(--dk-encre);
  }
  .gros .l {
    font-size: 0.56em;
    letter-spacing: 0.13em;
    text-transform: uppercase;
    color: var(--dk-gris);
  }

  /* Un point par modèle: le nombre se voit avant d'être lu. */
  .nuage {
    display: flex;
    flex-wrap: wrap;
    gap: 2px;
    margin: 0.5em 0;
  }
  .pt {
    width: 5px;
    height: 5px;
    background: var(--dk-accent);
    opacity: calc(0.3 + var(--i) * 0.06);
  }

  .tops {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.08em;
  }
  .tops li {
    display: flex;
    justify-content: space-between;
    gap: 0.6em;
    font-size: 0.6em;
    border-bottom: 1px solid var(--dk-filet);
    padding: 0.1em 0;
  }
  .tops .n {
    color: var(--dk-encre);
  }
  .tops .c {
    color: var(--dk-accent);
    font-weight: 600;
    font-variant-numeric: tabular-nums;
  }
  .tops li.reste {
    border-bottom: none;
  }
  .tops li.reste .n {
    color: var(--dk-gris-2);
  }

  .tete {
    font-size: 0.58em;
    letter-spacing: 0.15em;
    font-weight: 600;
    color: var(--dk-accent);
  }
  .crit {
    list-style: none;
    margin: 0.4em 0 0;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.4em;
  }
  .crit li {
    display: flex;
    flex-direction: column;
    gap: 0.02em;
    border-left: 3px solid var(--dk-accent);
    padding-left: 0.7em;
  }
  .crit .q {
    font-size: 0.68em;
    font-weight: 600;
    color: var(--dk-encre);
  }
  .crit .r {
    font-size: 0.62em;
    color: var(--dk-gris);
    line-height: 1.35;
  }
</style>
