<script>
  /**
   * Les coefficients de saturation des dix institutions, puis des neuf qu'on
   * garde : les vrais chiffres de sondr::topdown_fa() (SATURATIONS,
   * outils/seance9_data.R), redessinés dans la langue du deck.
   *
   *   0  les dix, rangées de la plus forte à la plus faible; le seuil 0,3 en
   *      pointillé; celle sous le seuil en rouge;
   *   1  elle s'efface, les neuf remontent; alpha et valeur propre suivent.
   */
  import { brancherTemps } from '../temps.js';
  import { SATURATIONS as S } from '$lib/data/seance9.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });

  const COURT = {
    fed: 'gouvernement fédéral', prov: 'gouv. provincial', medias: 'les médias', elections: 'Élections Canada',
    tribunaux: 'les tribunaux', religion: 'la religion organisée', armee: 'les forces armées',
    ecoles: 'les écoles publiques', fonction: 'la fonction publique', police: 'la police'
  };
  const SEUIL = 0.3;
  const run = (r) => r.items.map((n, i) => ({ n, l: r.loadings[i] }));
  const UN = run(S.un).sort((a, b) => b.l - a.l);
  const DEUX = run(S.deux);
  // Au temps 1, chaque énoncé gardé prend sa nouvelle valeur et son nouveau
  // rang; les deux autres s'effacent sur place.
  const ordre2 = DEUX.slice().sort((a, b) => b.l - a.l).map((d) => d.n);
  const barres = $derived(UN.map((u, i) => {
    const d = DEUX.find((x) => x.n === u.n);
    const garde = !!d;
    return { n: u.n, garde, l: e >= 1 && garde ? d.l : u.l, rang: e >= 1 && garde ? ordre2.indexOf(u.n) : i };
  }));

  const NB = S.un.items.length;
  const W = 1000, X0 = 330, LX = 540, PAS = 44, Y0 = 20, HB = 30, H = Y0 + NB * PAS + 50;
  const x = (v) => X0 + v * LX;
  const f = (v) => v.toFixed(2).replace('.', ',');
  const alpha = $derived(e >= 1 ? S.deux.alpha : S.un.alpha);
  const eigen = $derived(e >= 1 ? S.deux.eigen : S.un.eigen);
</script>

<div class="visuel m9s" bind:this={hote}>
  <svg viewBox="0 0 {W} {H}" role="img" aria-label="Les coefficients de saturation des dix institutions, en barres. Une seule est sous le seuil de 0,3 : la religion organisée. Quand on la retire, les neuf autres restent au-dessus.">
    <line x1={x(SEUIL)} y1={Y0 - 6} x2={x(SEUIL)} y2={Y0 + NB * PAS} class="m9s-seuil" />
    <text x={x(SEUIL)} y={Y0 + NB * PAS + 24} class="m9s-seuil-t">seuil 0,3</text>
    <line x1={x(0)} y1={Y0 - 6} x2={x(0)} y2={Y0 + NB * PAS} class="m9s-zero" />
    {#each barres as b (b.n)}
      <g class="m9s-barre" class:faible={b.l < SEUIL} class:parti={e >= 1 && !b.garde} style="transform: translateY({b.rang * PAS}px)">
        <text x={X0 - 44} y={Y0 + HB / 2 + 7} class="m9s-nom">conf_{b.n} · {COURT[b.n]}</text>
        <rect x={b.l >= 0 ? x(0) : x(b.l)} y={Y0} width={Math.abs(b.l) * LX} height={HB} class="m9s-rect" />
        <text x={b.l >= 0 ? x(b.l) + 12 : x(0) + 12} y={Y0 + HB / 2 + 7} class="m9s-val">{f(b.l)}</text>
      </g>
    {/each}
  </svg>
  <div class="m9s-pied">
    {#key e}
      <span class="m9s-chiffre"><b>alpha</b> {f(alpha)}</span>
      <span class="m9s-chiffre"><b>1re valeur propre</b> {f(eigen)}</span>
      <span class="m9s-dit">{e >= 1 ? 'Neuf institutions, toutes au-dessus du seuil.' : 'Une institution sous le seuil : elle ne parle pas de la même chose.'}</span>
    {/key}
  </div>
</div>

<style>
  .m9s { display: flex; flex-direction: column; gap: 0.5em; max-width: 62em; margin: 0.4em auto 0; }
  svg { width: 100%; height: auto; max-height: 60vh; display: block; }
  text { font-family: var(--dk-mono); fill: var(--dk-encre); }
  .m9s-barre { transition: transform 0.7s, opacity 0.5s; }
  .m9s-barre.parti { opacity: 0; }
  .m9s-rect { fill: var(--dk-encre); transition: width 0.7s, x 0.7s, fill 0.4s; }
  .m9s-barre.faible .m9s-rect { fill: var(--dk-accent); }
  .m9s-nom { font-size: 19px; text-anchor: end; font-weight: 600; }
  .m9s-barre.faible .m9s-nom, .m9s-barre.faible .m9s-val { fill: var(--dk-accent); }
  .m9s-val { font-size: 21px; font-weight: 700; }
  .m9s-seuil { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 10 8; }
  .m9s-seuil-t { font-size: 17px; fill: var(--dk-accent); text-anchor: middle; font-weight: 600; }
  .m9s-zero { stroke: var(--dk-encre); stroke-width: 2; }
  .m9s-pied { display: flex; gap: 2em; align-items: baseline; font-size: 0.95em; border-top: 2px solid var(--dk-encre); padding-top: 0.5em; }
  .m9s-chiffre b { color: var(--dk-gris); font-weight: 600; font-size: 0.75em; letter-spacing: 0.08em; text-transform: uppercase; margin-right: 0.4em; }
  .m9s-chiffre { font-weight: 700; font-size: 1.2em; }
  .m9s-dit { margin-left: auto; font-weight: 600; }
  @media (prefers-reduced-motion: reduce) { .m9s-barre, .m9s-rect { transition: none; } }
</style>
