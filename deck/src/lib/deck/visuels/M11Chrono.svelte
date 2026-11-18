<script>
  /**
   * La manchette avant l'article. Une ligne du temps, de janvier 2025 à
   * novembre 2026, où tombent les objets dans l'ordre où ils sont vraiment
   * arrivés :
   *
   *   0  la ligne vide, et l'automne 2024 : la collecte (23 septembre au
   *      18 octobre 2024, Richard et Régimbal 2026, p. 74);
   *   1  18 février 2025 : les journaux tombent (La Presse, « Près d'un
   *      élève sur deux touché »; le même jour, l'opposition officielle
   *      demande une commission parlementaire);
   *   2  19 août 2025 : l'article arrive, six mois plus tard (date de
   *      publication en ligne, cjhe-rces.ca); l'écart est mesuré;
   *   3  8 octobre 2025 : Radio-Canada, « entre 40 % et 60 % ».
   *
   * Les dates viennent des pages elles-mêmes (URL datées, page de la revue).
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // l'axe : de septembre 2024 (mois 0) à décembre 2025 (mois 15)
  const X0 = 60, X1 = 1140, M = 15;
  const x = (mois) => X0 + (mois / M) * (X1 - X0);
  const AXE = 380;
  const MOIS = ['sept.', 'oct.', 'nov.', 'déc.', 'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin', 'juil.', 'août', 'sept.', 'oct.', 'nov.'];
  // positions (en mois depuis le 1er septembre 2024)
  const COLLECTE = [0.73, 1.58];
  const PRESSE = 5.57; // 18 février 2025
  const ARTICLE = 11.6; // 19 août 2025
  const RC = 13.25; // 8 octobre 2025
</script>

<div class="visuel m11c" bind:this={hote}>
  <svg viewBox="0 0 1200 500" role="img" aria-label="Une ligne du temps. Automne 2024 : la collecte. 18 février 2025 : les manchettes et la demande d’une commission parlementaire. 19 août 2025 : l’article paraît, six mois plus tard. 8 octobre 2025 : Radio-Canada écrit « entre 40 % et 60 % ».">
    <!-- l'axe -->
    <line x1={X0} y1={AXE} x2={X1} y2={AXE} class="m11c-axe" />
    {#each MOIS as m, i (i)}
      <line x1={x(i)} y1={AXE - 8} x2={x(i)} y2={AXE + 8} class="m11c-tic" />
      <text x={x(i) + (X1 - X0) / M / 2} y={AXE + 36} class="m11c-mois">{m}</text>
    {/each}
    <text x={x(2)} y={AXE + 76} class="m11c-annee">2024</text>
    <text x={x(9.5)} y={AXE + 76} class="m11c-annee">2025</text>
    <line x1={x(4)} y1={AXE + 50} x2={x(4)} y2={AXE + 84} class="m11c-tic" />

    <!-- la collecte -->
    <rect x={x(COLLECTE[0])} y={AXE - 14} width={x(COLLECTE[1]) - x(COLLECTE[0])} height="28" class="m11c-collecte" />
    <text x={x(1.15)} y={AXE - 30} class="m11c-etiq">la collecte</text>

    <!-- les journaux -->
    <g class="m11c-tombe" class:m11c-vu={e >= 1}>
      {#each [0, 1, 2] as k (k)}
        <g transform="translate({x(PRESSE) - 70 + k * 10}, {AXE - 150 - k * 14}) rotate({-4 + k * 4})">
          <rect width="140" height="100" class="m11c-journal" />
          <line x1="12" y1="22" x2="128" y2="22" class="m11c-titre-j" />
          <line x1="12" y1="44" x2="96" y2="44" class="m11c-ligne-j" />
          <line x1="12" y1="60" x2="118" y2="60" class="m11c-ligne-j" />
          <line x1="12" y1="76" x2="88" y2="76" class="m11c-ligne-j" />
        </g>
      {/each}
      <line x1={x(PRESSE)} y1={AXE - 40} x2={x(PRESSE)} y2={AXE} class="m11c-pique" />
      <text x={x(PRESSE)} y={AXE - 222} class="m11c-date m11c-rouge">18 février 2025</text>
      <text x={x(PRESSE)} y={AXE - 194} class="m11c-etiq">« Près d’un élève sur deux »</text>
      <text x={x(PRESSE)} y="40" class="m11c-etiq m11c-petit">le même jour : on demande</text>
      <text x={x(PRESSE)} y="66" class="m11c-etiq m11c-petit">une commission parlementaire</text>
    </g>

    <!-- l'article -->
    <g class="m11c-tombe" class:m11c-vu={e >= 2}>
      <g transform="translate({x(ARTICLE) - 55}, {AXE - 190})">
        <rect width="110" height="146" class="m11c-feuille" />
        {#each [24, 42, 60, 78, 96, 114] as yy (yy)}<line x1="14" y1={yy} x2="96" y2={yy} class="m11c-ligne-j" />{/each}
      </g>
      <line x1={x(ARTICLE)} y1={AXE - 44} x2={x(ARTICLE)} y2={AXE} class="m11c-pique m11c-encre" />
      <text x={x(ARTICLE)} y={AXE - 222} class="m11c-date">19 août 2025</text>
      <text x={x(ARTICLE)} y={AXE - 252} class="m11c-etiq">l’article paraît</text>
      <!-- l'écart -->
      <path d="M {x(PRESSE)} {AXE + 110} L {x(ARTICLE)} {AXE + 110}" class="m11c-ecart" />
      <text x={(x(PRESSE) + x(ARTICLE)) / 2} y={AXE + 102} class="m11c-date m11c-rouge">six mois plus tard</text>
    </g>

    <!-- Radio-Canada -->
    <g class="m11c-tombe" class:m11c-vu={e >= 3}>
      <g transform="translate({x(RC) - 50}, {AXE - 120}) rotate(5)">
        <rect width="100" height="74" class="m11c-journal" />
        <line x1="10" y1="18" x2="90" y2="18" class="m11c-titre-j" />
        <line x1="10" y1="38" x2="70" y2="38" class="m11c-ligne-j" />
        <line x1="10" y1="54" x2="84" y2="54" class="m11c-ligne-j" />
      </g>
      <line x1={x(RC)} y1={AXE - 40} x2={x(RC)} y2={AXE} class="m11c-pique" />
      <text x={x(RC)} y="40" class="m11c-date m11c-rouge">8 octobre 2025</text>
      <text x={x(RC)} y="66" class="m11c-etiq m11c-petit">« entre 40 % et 60 % »</text>
    </g>
  </svg>
  <p class="m11c-cap">La Presse, 18 février 2025 · Radio-Canada, 8 octobre 2025 · Richard et Régimbal (2026), publié en ligne le 19 août 2025</p>
</div>

<style>
  .m11c { width: 100%; display: flex; flex-direction: column; align-items: center; gap: 0.3em; }
  svg { width: 100%; max-width: 56em; height: auto; max-height: 58vh; overflow: visible; }
  text { font-family: var(--dk-mono); text-anchor: middle; fill: var(--dk-encre); }
  .m11c-axe { stroke: var(--dk-encre); stroke-width: 4; }
  .m11c-tic { stroke: var(--dk-encre); stroke-width: 2; }
  .m11c-mois { font-size: 18px; fill: var(--dk-gris); }
  .m11c-annee { font-size: 22px; font-weight: 700; }
  .m11c-collecte { fill: var(--dk-gris-2); }
  .m11c-etiq { font-size: 24px; font-weight: 700; }
  .m11c-etiq.m11c-petit { font-size: 21px; font-weight: 400; }
  .m11c-date { font-size: 24px; font-weight: 700; }
  .m11c-rouge { fill: var(--dk-accent); }
  .m11c-journal { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 3; }
  .m11c-feuille { fill: white; stroke: var(--dk-encre); stroke-width: 3; }
  .m11c-titre-j { stroke: var(--dk-accent); stroke-width: 8; }
  .m11c-ligne-j { stroke: var(--dk-gris-2); stroke-width: 5; }
  .m11c-pique { stroke: var(--dk-accent); stroke-width: 3; }
  .m11c-pique.m11c-encre { stroke: var(--dk-encre); }
  .m11c-ecart { stroke: var(--dk-accent); stroke-width: 3; stroke-dasharray: 8 6; fill: none; }
  .m11c-tombe { opacity: 0; transform: translateY(-40px); transition: opacity 0.4s, transform 0.6s cubic-bezier(0.3, 1.4, 0.5, 1); }
  .m11c-tombe.m11c-vu { opacity: 1; transform: none; }
  .m11c-cap { margin: 0; font-size: 0.62em; color: var(--dk-gris); }
  @media (prefers-reduced-motion: reduce) { .m11c-tombe { transition: none; transform: none; } }
</style>
