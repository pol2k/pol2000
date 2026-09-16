<script>
  /**
   * Une bonne théorie interdit des choses. Plus elle en interdit, plus elle
   * risque, plus elle vaut. Deux tableaux, même grille. Quatre temps.
   *
   *   0  Un seul tableau, centré : toutes les cases de « tout ce qui
   *      pourrait arriver », aucune n’est barrée.
   *   1  Théorie A : presque toutes les cases se barrent une à une, il n’en
   *      reste qu’une petite zone permise, en rouge. Elle risque.
   *   2  Théorie B arrive à côté : la grille entière reste permise. Elle ne
   *      barre rien, donc elle ne risque rien.
   *   3  La citation de Popper, puis le rappel : la classe a déjà rencontré
   *      l’idée à la séance 1, sous le nom de H₀.
   *
   * Citation : Karl Popper, Conjectures et réfutations (1963), chapitre 1,
   * dans la traduction française publiée. On cite le chapitre seulement,
   * pas de page. Schéma : aucune donnée, la zone permise est fixe.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // La grille des possibles : 12 × 8 cases, coordonnées fixes.
  const COLS = 12, LIGNES = 8, PAS = 20, COTE = 18;
  const permise = (c, r) => c >= 7 && c <= 9 && r >= 3 && r <= 4;
  const CASES = [];
  for (let r = 0; r < LIGNES; r++) {
    for (let c = 0; c < COLS; c++) {
      CASES.push({ x: c * PAS + 1, y: r * PAS + 1, ok: permise(c, r) });
    }
  }
</script>

<div class="visuel pp-fig" class:pp-serre={e >= 3} bind:this={hote}>
  <p class="pp-titre">tout ce qui pourrait arriver</p>

  <div class="pp-rangee">
    <div class="pp-tab">
      <span class="pp-tag pp-tag-a" class:pp-vu={e >= 1}>{#if e >= 1}risquée{/if}</span>
      <svg
        class="pp-grille"
        viewBox="0 0 240 160"
        role="img"
        aria-label={e >= 1
          ? 'La grille des événements possibles, presque entièrement barrée : la théorie A n’en laisse qu’une petite zone permise.'
          : 'Une grille de petites cases, aucune barrée : tout ce qui pourrait arriver.'}
      >
        {#each CASES as k, i}
          <rect x={k.x} y={k.y} width={COTE} height={COTE} class="pp-case" class:pp-ok={e >= 1 && k.ok} style="--k: {i}" />
          {#if e >= 1 && !k.ok}
            <line x1={k.x} y1={k.y} x2={k.x + COTE} y2={k.y + COTE} pathLength="1" class="pp-barre" style="--k: {i}" />
          {/if}
        {/each}
      </svg>
      <span class="pp-nom" class:pp-vu={e >= 1}>{#if e >= 1}théorie A · interdit presque tout{/if}</span>
      <span class="pp-sous" class:pp-vu={e >= 1}>{#if e >= 1}Si on observe autre chose, elle est morte.{/if}</span>
    </div>

    {#if e >= 2}
      <div class="pp-tab pp-tab-b">
        <span class="pp-tag pp-tag-b pp-vu">irréfutable</span>
        <svg
          class="pp-grille"
          viewBox="0 0 240 160"
          role="img"
          aria-label="La même grille, aucune case barrée : la théorie B permet tout ce qui peut arriver."
        >
          {#each CASES as k, i}
            <rect x={k.x} y={k.y} width={COTE} height={COTE} class="pp-case" style="--k: {i}" />
          {/each}
        </svg>
        <span class="pp-nom pp-vu">théorie B · compatible avec tout ce qui peut arriver</span>
        <span class="pp-sous pp-vu">Quoi qu’on observe, elle a raison.</span>
      </div>
    {/if}
  </div>

  {#if e >= 3}
    <blockquote class="pp-cit">
      <p>&#171;&#8239;Une th&#233;orie qui n&#8217;est r&#233;futable par aucun &#233;v&#233;nement qui se puisse concevoir est d&#233;pourvue de caract&#232;re scientifique. Pour les th&#233;ories, l&#8217;irr&#233;futabilit&#233; n&#8217;est pas (comme on l&#8217;imagine souvent) vertu mais d&#233;faut.&#8239;&#187;</p>
      <span class="pp-src">Karl Popper, Conjectures et r&#233;futations (1963), chapitre 1</span>
    </blockquote>
    <p class="pp-rappel">Vous faites d&#233;j&#224; &#231;a&#8239;: on ne prouve jamais H&#8321;, on demande aux donn&#233;es de rejeter H&#8320;.</p>
  {/if}
</div>

<style>
  .pp-fig { display: flex; flex-direction: column; gap: 0.7em; }
  .pp-titre { margin: 0; font-size: 0.8em; letter-spacing: 0.14em; text-transform: uppercase; color: var(--dk-gris); }

  .pp-rangee { display: flex; justify-content: center; gap: 2em; }
  .pp-tab { flex: 0 1 46%; display: flex; flex-direction: column; gap: 0.4em; }
  .pp-tab-b { animation: pp-entre 0.55s cubic-bezier(0.34, 1.5, 0.64, 1) both; }

  .pp-grille { width: 100%; max-height: 44vh; display: block; overflow: visible; }
  .pp-serre .pp-grille { max-height: 22vh; }

  .pp-case { fill: var(--dk-fond-2); stroke: var(--dk-filet); stroke-width: 1.5; transition: fill 0.3s, stroke 0.3s; animation: pp-pose 0.35s cubic-bezier(0.34, 1.7, 0.64, 1) both; animation-delay: calc(var(--k) * 7ms); transform-box: fill-box; transform-origin: 50% 50%; }
  .pp-case.pp-ok { fill: var(--dk-accent); fill-opacity: 0.18; stroke: var(--dk-accent); stroke-width: 2.5; animation: pp-bat 0.8s ease-in-out 0.9s 3; }
  .pp-barre { stroke: var(--dk-gris-2); stroke-width: 2.5; stroke-dasharray: 1; stroke-dashoffset: 1; animation: pp-trace 0.3s ease-out both; animation-delay: calc(var(--k) * 8ms); }

  .pp-tag { font-size: 0.7em; font-weight: 600; letter-spacing: 0.16em; text-transform: uppercase; min-height: 1.2em; opacity: 0; transition: opacity 0.3s; }
  .pp-tag.pp-vu { opacity: 1; }
  .pp-tag-a { color: var(--dk-accent); }
  .pp-tag-b { color: var(--dk-gris-2); }

  .pp-nom { font-size: 0.92em; font-weight: 600; line-height: 1.25; min-height: 2.4em; opacity: 0; transition: opacity 0.35s 0.25s; }
  .pp-sous { font-size: 0.76em; line-height: 1.3; color: var(--dk-gris); min-height: 1.3em; opacity: 0; transition: opacity 0.35s 0.4s; }
  .pp-nom.pp-vu, .pp-sous.pp-vu { opacity: 1; }

  .pp-cit { margin: 0; border-left: 5px solid var(--dk-accent); padding: 0.1em 0 0.1em 0.9em; animation: pp-monte 0.5s ease-out both; }
  .pp-cit p { margin: 0; font-size: 0.86em; line-height: 1.4; }
  .pp-src { display: block; margin-top: 0.35em; font-size: 0.64em; letter-spacing: 0.04em; color: var(--dk-gris); }
  .pp-rappel { margin: 0; font-size: 0.86em; font-weight: 600; color: var(--dk-accent); animation: pp-monte 0.5s ease-out 0.35s both; }

  @keyframes pp-pose { from { opacity: 0; transform: scale(0.2); } to { opacity: 1; transform: scale(1); } }
  @keyframes pp-trace { to { stroke-dashoffset: 0; } }
  @keyframes pp-bat { 0%, 100% { fill-opacity: 0.18; } 50% { fill-opacity: 0.42; } }
  @keyframes pp-entre { from { opacity: 0; transform: translateX(2.5em); } to { opacity: 1; transform: none; } }
  @keyframes pp-monte { from { opacity: 0; transform: translateY(0.6em); } to { opacity: 1; transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .pp-case, .pp-case.pp-ok, .pp-tab-b, .pp-cit, .pp-rappel { animation: none; }
    .pp-barre { animation: none; stroke-dashoffset: 0; }
    .pp-tag, .pp-nom, .pp-sous { transition: none; }
  }
</style>
