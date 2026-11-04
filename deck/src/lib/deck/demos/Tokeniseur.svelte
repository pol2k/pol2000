<script>
  import d from './jetons.json';

  /**
   * La phrase que le modèle vient de produire, découpée en jetons — les mêmes
   * fragments qu'on a vus sortir un par un à la diapositive précédente.
   *
   * L'encodage n'est pas supposé: cl100k_base reproduit exactement la suite de
   * jetons émise par gpt-3.5-turbo-instruct, ce qui a été vérifié avant
   * d'écrire ce fichier.
   *
   * L'équivalent anglais est là pour le coût: même contenu, moins de jetons.
   *
   * Chaque jeton bascule vers son identifiant puis revient au texte, en vague
   * de gauche à droite. Ce nombre est le vrai identifiant cl100k_base: c'est
   * lui, et rien d'autre, qui entre dans le modèle. Le modèle va ensuite
   * chercher un vecteur à cette adresse — on montre l'adresse, pas le
   * vecteur, qu'on n'a pas mesuré.
   */
</script>

<div class="tok">
  <div class="tok-tete">
    <span class="src">encodage {d.encodage} · comptes réels</span>
  </div>

  <div class="tok-lg">
    <div class="lg-t">
      <span class="lang">Français</span>
      <span class="n fort">{d.fr.n} jetons</span>
    </div>
    <div class="jetons">
      {#each d.fr.jetons as j, i}<span class="j" style="--i: {i}"
          ><span class="mot">{j.replace(' ', '␣')}</span><span class="id">{d.fr.ids[i]}</span></span
        >{/each}
    </div>
  </div>

  <div class="tok-lg">
    <div class="lg-t">
      <span class="lang">Anglais</span>
      <span class="n">{d.en.n} jetons</span>
    </div>
    <div class="jetons">
      {#each d.en.jetons as j, i}<span class="j en" style="--i: {i}"
          ><span class="mot">{j.replace(' ', '␣')}</span><span class="id">{d.en.ids[i]}</span></span
        >{/each}
    </div>
  </div>

  <p class="verdict">
    Même contenu, <strong>+{d.surcout} %</strong> de jetons en français.
  </p>
</div>

<style>
  .tok {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.55em;
  }
  .tok-tete {
    display: flex;
    justify-content: flex-end;
    border-bottom: 2px solid var(--dk-encre);
    padding-bottom: 0.25em;
  }
  .src {
    font-size: 0.62em;
    color: var(--dk-gris);
  }

  .tok-lg {
    display: flex;
    flex-direction: column;
    gap: 0.3em;
  }
  .lg-t {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
  }
  .lang {
    font-size: 0.6em;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--dk-gris);
  }
  .n {
    font-size: 0.68em;
    color: var(--dk-gris);
    font-variant-numeric: tabular-nums;
  }
  .n.fort {
    color: var(--dk-accent);
    font-weight: 600;
  }

  .jetons {
    display: flex;
    flex-wrap: wrap;
    gap: 0.2em;
  }
  /* Chaque jeton est une boîte: la frontière est le sujet de la diapositive.
     L'espace initial est rendu visible — il fait partie du jeton. */
  .j {
    position: relative;
    display: inline-grid;
    font-size: 0.68em;
    padding: 0.12em 0.35em;
    border: 1px solid var(--dk-accent);
    color: var(--dk-accent);
    white-space: pre;
  }
  /* Les deux faces occupent la même case: la boîte ne change pas de taille
     quand le texte devient un nombre, sinon toute la ligne se réagence. */
  .j .mot,
  .j .id {
    grid-area: 1 / 1;
    animation: bascule 4s infinite;
    animation-delay: calc(var(--i) * 0.07s);
  }
  .j .id {
    animation-name: bascule-id;
    font-variant-numeric: tabular-nums;
    justify-self: center;
  }

  @keyframes bascule {
    0%, 26% { opacity: 1; }
    32%, 62% { opacity: 0; }
    68%, 100% { opacity: 1; }
  }
  @keyframes bascule-id {
    0%, 26% { opacity: 0; }
    32%, 62% { opacity: 1; }
    68%, 100% { opacity: 0; }
  }

  @media (prefers-reduced-motion: reduce) {
    .j .mot { animation: none; opacity: 1; }
    .j .id { animation: none; opacity: 0; }
  }
  .j.en {
    border-color: var(--dk-gris-2);
    color: var(--dk-gris);
  }

  .verdict {
    margin: 0;
    font-size: 0.72em;
    color: var(--dk-encre);
  }
</style>
