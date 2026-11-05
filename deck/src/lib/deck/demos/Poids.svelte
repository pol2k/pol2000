<script>
  import d from './poids-reels.json';

  /**
   * Un poids, c'est la force d'un lien entre deux neurones. Une grille de
   * couleurs cache ça; un réseau le montre.
   *
   * Le dessin fait 5 → 4 → 3 neurones, soit exactement 32 liens — et les 32
   * poids affichés sont les 32 premiers de q_proj, couche 0, lus dans le vrai
   * fichier model.safetensors par requête partielle. Chaque trait du dessin
   * est donc un vrai poids: son épaisseur suit sa valeur absolue, sa teinte
   * son signe.
   *
   * Rien à survoler: tout ce qui compte est écrit sur la diapositive.
   */
  const A = 5, B = 4, C = 3;
  const V = d.valeurs;
  const MAX = Math.max(...V.map(Math.abs));

  const W = 760, H = 300;
  const col = (i, n, x) =>
    Array.from({ length: n }, (_, k) => ({ x, y: (H / (n + 1)) * (k + 1) }));
  const c1 = col(0, A, 90), c2 = col(1, B, 380), c3 = col(2, C, 670);

  const liens = [];
  let k = 0;
  for (const a of c1) for (const b of c2) liens.push({ a, b, v: V[k++] });
  for (const a of c2) for (const b of c3) liens.push({ a, b, v: V[k++] });

  const ep = (v) => 0.6 + (Math.abs(v) / MAX) * 5.4;
  const espace = (n) => Math.round(n).toLocaleString('fr-CA').replace(/ |,/g, ' ');
  const nb = (v) => (v >= 0 ? '+' : '−') + Math.abs(v).toFixed(4).replace('.', ',');

  // Trois liens désignés, dont le plus fort et le plus faible du dessin.
  const fort = liens.reduce((m, l) => (Math.abs(l.v) > Math.abs(m.v) ? l : m));
  const faible = liens.reduce((m, l) => (Math.abs(l.v) < Math.abs(m.v) ? l : m));
  const negatif = liens.reduce((m, l) => (l.v < m.v ? l : m));
  const CITES = [fort, negatif, faible];
</script>

<div class="pds">
  <svg viewBox="0 0 {W} {H}" role="img" aria-label="Un petit réseau de 5, 4 puis 3 neurones. Chacun des 32 traits est un poids réel du modèle: son épaisseur suit sa valeur.">
    {#each liens as l}
      <line
        x1={l.a.x} y1={l.a.y} x2={l.b.x} y2={l.b.y}
        class:neg={l.v < 0}
        class:cite={CITES.includes(l)}
        style="--e: {ep(l.v)}"
      />
    {/each}
    {#each [...c1, ...c2, ...c3] as p}
      <circle cx={p.x} cy={p.y} r="11" />
    {/each}
    {#each CITES as l, i}
      <text class="val" x={(l.a.x + l.b.x) / 2} y={(l.a.y + l.b.y) / 2 - 8} text-anchor="middle"
        >{nb(l.v)}</text
      >
    {/each}
  </svg>

  <div class="dire">
    <p class="p1">
      Un poids, c'est la <strong>force d'un lien</strong> entre deux neurones. Épais s'il compte,
      mince sinon ; <span class="pos">bleu</span> s'il pousse, <span class="neg-t">gris</span> s'il
      retient.
    </p>
    <p class="p2">
      Les 32 traits de ce dessin sont 32 <strong>vrais</strong> poids, lus dans le fichier de
      Qwen2.5-0.5B. Le modèle en a <strong>{espace(d.params)}</strong>.
    </p>
  </div>
</div>

<style>
  .pds {
    width: 100%;
    display: flex;
    flex-direction: column;
    gap: 0.5em;
  }
  svg {
    width: 100%;
    height: auto;
    display: block;
  }

  :global(.pds line) {
    stroke: var(--dk-accent);
    stroke-width: var(--e);
    opacity: 0.55;
  }
  :global(.pds line.neg) {
    stroke: var(--dk-gris-2);
  }
  /* Les trois liens chiffrés ressortent, le reste fait la texture. */
  :global(.pds line.cite) {
    opacity: 1;
  }
  :global(.pds circle) {
    fill: var(--dk-fond);
    stroke: var(--dk-encre);
    stroke-width: 2.5;
  }
  :global(.pds .val) {
    font-family: var(--dk-mono);
    font-size: 19px;
    font-weight: 600;
    fill: var(--dk-encre);
    paint-order: stroke;
    stroke: var(--dk-fond);
    stroke-width: 5;
  }

  .dire {
    display: flex;
    flex-direction: column;
    gap: 0.15em;
  }
  .p1,
  .p2 {
    margin: 0;
    font-size: 0.7em;
    line-height: 1.45;
    color: var(--dk-encre);
  }
  .p2 strong {
    color: var(--dk-accent);
  }
  .pos {
    color: var(--dk-accent);
    font-weight: 600;
  }
  .neg-t {
    color: var(--dk-gris);
    font-weight: 600;
  }
</style>
