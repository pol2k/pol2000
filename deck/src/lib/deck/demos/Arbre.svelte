<script>
  /**
   * Arbre des familles d'IA. Schéma original, inspiré de l'arbre évolutif des
   * LLM de Yang et al. 2023 (arXiv:2304.13712), cité sur la diapositive.
   *
   * Les deux branches en accent sont celles qui comptent pour la semaine:
   * l'encodeur donne les classifieurs (séance 2), le décodeur donne
   * les modèles génératifs (séance 1).
   */
  const N = [
    { id: 'ia',    x: 44,  y: 214, t: 'IA',                        r: 'racine' },
    { id: 'regl',  x: 236, y: 74,  t: 'Systèmes à règles',         s: 'jusqu’aux années 1990', ton: 'eteint' },
    { id: 'appr',  x: 236, y: 286, t: 'Apprentissage automatique' },
    { id: 'stat',  x: 486, y: 372, t: 'Modèles statistiques',      s: 'régression, SVM, forêts', ton: 'gris' },
    { id: 'prof',  x: 486, y: 240, t: 'Réseaux profonds',          s: 'depuis 2012' },
    { id: 'trans', x: 700, y: 240, t: 'Transformers',              s: '2017' },
    { id: 'enc',   x: 872, y: 128, t: 'Encodeur',                  s: 'BERT · RoBERTa', b: 'classifieurs', ton: 'accent' },
    { id: 'encdec',x: 872, y: 240, t: 'Encodeur-décodeur',         s: 'T5 · BART', ton: 'gris' },
    { id: 'dec',   x: 872, y: 350, t: 'Décodeur',                  s: 'GPT · Claude · Llama', b: 'génératifs', ton: 'accent' }
  ];
  const idx = Object.fromEntries(N.map((n) => [n.id, n]));

  const L = [
    ['ia', 'regl'], ['ia', 'appr'],
    ['appr', 'stat'], ['appr', 'prof'],
    ['prof', 'trans'],
    ['trans', 'enc'], ['trans', 'encdec'], ['trans', 'dec']
  ];

  /** Branche en courbe douce, du bord droit d'un nœud vers le suivant. */
  function branche([a, b]) {
    const p = idx[a], q = idx[b];
    const x1 = p.x + 8, y1 = p.y, x2 = q.x - 8, y2 = q.y;
    const m = x1 + (x2 - x1) * 0.55;
    return `M${x1} ${y1} C${m} ${y1}, ${m} ${y2}, ${x2} ${y2}`;
  }
  const ton = (n) => idx[n[1]].ton ?? '';

  // En monospace la largeur d'un texte se calcule: 0,6 em par caractère. On
  // pose donc un fond opaque derrière chaque étiquette, ce qui masque la
  // branche qui passe dessous. Déterministe, contrairement à un
  // repositionnement à l'oeil.
  const larg = (txt, taille) => txt.length * taille * 0.6 + 10;
</script>

<div class="arbre">
  <svg viewBox="0 0 1000 420" role="img"
       aria-label="Arbre des familles d'IA, des systèmes à règles jusqu'aux modèles génératifs">
    {#each L as l}
      <path class="br {ton(l)}" d={branche(l)} />
    {/each}

    {#each N as n}
      <g class="nd {n.ton ?? ''}">
        <rect class="fond" x={n.x + 13} y={n.y - 18} width={larg(n.t, 19)} height="23" />
        {#if n.s}
          <rect class="fond" x={n.x + 13} y={n.y + 5} width={larg(n.s, 15)} height="20" />
        {/if}
        {#if n.b}
          <rect class="fond" x={n.x + 13} y={n.y + 25} width={larg(n.b, 14) + n.b.length * 1.7} height="19" />
        {/if}
        <rect class="pt" x={n.x - 7} y={n.y - 7} width="14" height="14" />
        <text x={n.x + 18} y={n.y - 2} class="nd-t">{n.t}</text>
        {#if n.s}<text x={n.x + 18} y={n.y + 20} class="nd-s">{n.s}</text>{/if}
        {#if n.b}<text x={n.x + 18} y={n.y + 40} class="nd-b">{n.b}</text>{/if}
      </g>
    {/each}
  </svg>
</div>

<style>
  .arbre { width: 100%; }
  svg { width: 100%; height: auto; display: block; overflow: visible; }

  :global(.br) { fill: none; stroke: var(--dk-encre); stroke-width: 2.5; }
  :global(.br.gris) { stroke: var(--dk-gris-2); }
  :global(.br.eteint) { stroke: var(--dk-gris-2); stroke-dasharray: 6 5; }
  :global(.br.accent) { stroke: var(--dk-accent); stroke-width: 3.5; }

  :global(.nd .fond) { fill: var(--dk-fond); }
  :global(.nd .pt) { fill: var(--dk-encre); }
  :global(.nd.gris .pt), :global(.nd.eteint .pt) { fill: var(--dk-gris-2); }
  :global(.nd.accent .pt) { fill: var(--dk-accent); }

  :global(.nd-t) {
    font-family: var(--dk-mono); font-size: 19px; font-weight: 500;
    fill: var(--dk-encre);
  }
  :global(.nd.gris .nd-t), :global(.nd.eteint .nd-t) { fill: var(--dk-gris); }
  :global(.nd.accent .nd-t) { fill: var(--dk-accent); font-weight: 600; }

  :global(.nd-s) { font-family: var(--dk-mono); font-size: 15px; fill: var(--dk-gris); }
  :global(.nd-b) {
    font-family: var(--dk-mono); font-size: 14px;
    letter-spacing: 0.12em; text-transform: uppercase; fill: var(--dk-accent);
  }
</style>
