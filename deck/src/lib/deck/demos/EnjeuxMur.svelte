<script>
  import d from './enjeux-mur.json';

  /**
   * Le corpus, montré au lieu d'être décrit : la question ouverte de l'Étude
   * électorale canadienne 2025 (cps25_imp_iss), le nombre de réponses, et six
   * vraies réponses telles que tapées, fautes et majuscules comprises.
   *
   * En bas, le but de l'exercice : ranger chaque réponse dans une des douze
   * catégories. Les deux diapositives suivantes le font de deux façons.
   *
   * Tout vient de enjeux-mur.json, écrit par outils/seance9_enjeux.R. Aucun
   * texte n'est retouché : ce sont des données.
   */
  // Séparateur de milliers fixe (U+202F) : même rendu au serveur et au client.
  const milliers = (n) => String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
  const LANGUE = { EN: 'en', 'FR-CA': 'fr' };
</script>

<div class="mur-tete">
  <figure class="q">
    <span class="q-src">Étude électorale canadienne 2025 · <code>{d.variable}</code></span>
    <blockquote>« {d.question} »</blockquote>
    <span class="q-note">Question ouverte : chacun répond dans ses propres mots.</span>
  </figure>
  <div class="prov-col">
    <span class="gros">{milliers(d.total)}</span>
    <span class="lab">réponses en texte libre</span>
    <span class="lgs">
      <span>en {milliers(d.langues.en)}</span>
      <span>fr {milliers(d.langues.fr)}</span>
    </span>
  </div>
</div>

<div class="mur">
  {#each d.exemples as a}
    <figure class="av" class:vide={a.texte.length < 5}>
      <div class="av-t">
        <span class="li">ligne {a.ligne}</span>
        <span class="lg">{LANGUE[a.langue] ?? a.langue}</span>
      </div>
      <blockquote>{a.texte}</blockquote>
    </figure>
  {/each}
</div>

<div class="cats">
  <span class="cats-t">Le but : chaque réponse dans une de ces {d.categories.length} catégories</span>
  <ul>
    {#each d.categories as c}<li>{c}</li>{/each}
  </ul>
</div>

<style>
  .mur-tete {
    display: grid;
    grid-template-columns: 1.75fr 1fr;
    gap: 1em;
    align-items: stretch;
    margin-bottom: 0.6em;
  }
  /* La question, mot pour mot : c'est elle qui fabrique la donnée. */
  .q {
    margin: 0;
    border-left: 3px solid var(--dk-accent);
    background: var(--dk-fond-2);
    padding: 0.5em 0.8em 0.55em;
    display: flex;
    flex-direction: column;
    gap: 0.3em;
  }
  .q-src {
    font-size: 0.55em;
    letter-spacing: 0.08em;
    color: var(--dk-gris);
  }
  .q-src code {
    font-family: var(--dk-mono);
    color: var(--dk-accent);
  }
  .q blockquote {
    margin: 0;
    font-size: 0.78em;
    line-height: 1.35;
    font-weight: 600;
    color: var(--dk-encre);
  }
  .q-note {
    font-size: 0.55em;
    color: var(--dk-gris-2);
  }

  .prov-col {
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 0.1em;
  }
  .gros {
    font-size: 1.9em;
    font-weight: 600;
    line-height: 1;
    letter-spacing: -0.04em;
    color: var(--dk-accent);
    font-variant-numeric: tabular-nums;
  }
  .lab {
    font-size: 0.6em;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--dk-gris);
  }
  .lgs {
    display: flex;
    gap: 1em;
    margin-top: 0.3em;
    font-size: 0.58em;
    color: var(--dk-gris);
    font-variant-numeric: tabular-nums;
  }

  .mur {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 0.6em;
    width: 100%;
  }
  .av {
    margin: 0;
    border: 2px solid var(--dk-encre);
    padding: 0.45em 0.65em 0.55em;
    display: flex;
    flex-direction: column;
    gap: 0.3em;
    min-width: 0;
  }
  /* Une non-réponse fait partie du corpus : on la montre, en retrait. */
  .av.vide {
    border-color: var(--dk-filet);
    border-style: dashed;
  }
  .av-t {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    gap: 0.5em;
  }
  .li {
    font-size: 0.55em;
    color: var(--dk-gris-2);
    font-variant-numeric: tabular-nums;
  }
  .lg {
    font-size: 0.55em;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--dk-accent);
    font-weight: 600;
  }
  .av blockquote {
    margin: 0;
    font-size: 0.7em;
    line-height: 1.4;
    color: var(--dk-encre);
  }
  .av.vide blockquote {
    color: var(--dk-gris);
  }

  .cats {
    margin-top: 0.65em;
    border-top: 2px solid var(--dk-encre);
    padding-top: 0.35em;
    display: flex;
    flex-direction: column;
    gap: 0.3em;
  }
  .cats-t {
    font-size: 0.6em;
    font-weight: 600;
    color: var(--dk-accent);
  }
  .cats ul {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-wrap: wrap;
    gap: 0.25em 0.3em;
  }
  .cats li {
    font-size: 0.52em;
    border: 1px solid var(--dk-filet);
    padding: 0.12em 0.45em;
    color: var(--dk-encre);
    white-space: nowrap;
  }
</style>
