<script>
  /**
   * Une bonne théorie interdit des choses. Plus elle en interdit, plus elle
   * risque, plus elle vaut. Deux prédictions posées sur le même axe : le
   * nombre de sièges qu’un parti obtient. Quatre temps.
   *
   *   0  Les deux prédictions, en toutes lettres, sans dessin. B arrive
   *      après A et sonne, à la première écoute, comme la plus fine des
   *      deux : c’est le piège que la suite fait sauter.
   *   1  L’axe de A : une bande rouge étroite (30 à 35), tout le reste
   *      hachuré. Elle exclut 73 résultats sur 79.
   *   2  Le même axe pour B, gris plat d’un bout à l’autre : tout lui va.
   *      Elle n’exclut rien, donc elle ne risque rien.
   *   3  Le verdict, la citation de Popper, puis le rappel : la classe a
   *      déjà rencontré l’idée à la séance 1, sous le nom de H₀.
   *
   * Le langage des couleurs porte la leçon et ne doit pas l’inverser : le
   * rouge (l’accent du deck) marque la bande que A s’autorise, donc le cou
   * qu’elle tend ; le gris hachuré marque ce qu’elle exclut ; le gris plat
   * et uniforme de B la fait lire comme inerte, pas comme généreuse.
   *
   * Exemple inventé pour le cours : aucun parti réel, aucune donnée. La
   * prédiction porte sur un résultat à venir, pas sur une mesure.
   *
   * Citation : Karl Popper, Conjectures et réfutations (1963), chapitre 1,
   * dans la traduction française publiée. On cite le chapitre seulement,
   * pas de page. Schéma : coordonnées fixes, aucun tirage au sort.
   */
  import { brancherTemps } from '../temps.js';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 3, lire: () => e, ecrire: (v) => (e = v) });
  });

  // L’axe : 0 à 78 sièges, donc 79 résultats possibles. La bande permise
  // par la prédiction A en couvre 6 (de 30 à 35), et en exclut 73.
  const SIEGES = 78;
  const X0 = 74, X1 = 972;
  const YB = 40, HB = 42; // la barre des résultats
  const x = (v) => X0 + (v / SIEGES) * (X1 - X0);
  const TICKS = [0, 20, 40, 60, 78];
  const BAS = 30, HAUT = 35;
  // Les trois répétitions du mot « compatible » sur la barre de B.
  const REPETES = [13, 39, 65];
</script>

<div class="visuel pp-fig" class:pp-serre={e >= 3} bind:this={hote}>
  <p class="pp-exemple">exemple</p>

  <div class="pp-cartes">
    <div class="pp-carte pp-carte-a">
      <span class="pp-quoi">pr&#233;diction A</span>
      <p class="pp-dit">&#171;&#8239;Ce parti obtiendra entre 30 et 35 si&#232;ges.&#8239;&#187;</p>
    </div>
    <div class="pp-carte pp-carte-b">
      <span class="pp-quoi">pr&#233;diction B</span>
      <p class="pp-dit">&#171;&#8239;Ce parti obtiendra un r&#233;sultat qui refl&#233;tera l&#8217;humeur de l&#8217;&#233;lectorat.&#8239;&#187;</p>
    </div>
  </div>

  {#if e === 0}
    <p class="pp-q">Laquelle des deux peut avoir tort&#8239;?</p>
  {/if}

  {#if e >= 1}
    <div class="pp-piste">
      <svg
        class="pp-axe"
        viewBox="0 0 1000 116"
        role="img"
        aria-label="Un axe des si&#232;ges obtenus, gradu&#233; de 0 &#224; 78. Une bande rouge &#233;troite couvre les r&#233;sultats de 30 &#224; 35&#8239;; tout le reste de l&#8217;axe, de 0 &#224; 30 et de 35 &#224; 78, est hachur&#233; en gris et marqu&#233; exclu."
      >
        <defs>
          <pattern id="pp-hachure" width="10" height="10" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
            <line x1="0" y1="0" x2="0" y2="10" class="pp-hach" />
          </pattern>
        </defs>

        <text x={X0} y="20" class="pp-qui pp-qui-a">pr&#233;diction A</text>
        <text x={X1} y="20" class="pp-unite">si&#232;ges obtenus</text>
        <!-- Pas de mot « compatible » ici : la bande ne fait que six sièges sur
             soixante-dix-neuf, le mot y est plus large qu'elle et retombait sur
             les bornes 30 et 35. La bande rouge et ses deux bornes suffisent. -->

        <!-- Ce que la prédiction exclut : hachuré, gris, sans rouge. -->
        <g class="pp-exclus">
          <rect x={X0} y={YB} width={x(BAS) - X0} height={HB} class="pp-hachure" />
          <rect x={x(HAUT)} y={YB} width={X1 - x(HAUT)} height={HB} class="pp-hachure" />
          <text x={(X0 + x(BAS)) / 2} y={YB + HB / 2 + 6} class="pp-exclu">exclu</text>
          <text x={(x(HAUT) + X1) / 2} y={YB + HB / 2 + 6} class="pp-exclu">exclu</text>
        </g>

        <!-- Ce qu’elle s’autorise : six résultats sur soixante-dix-neuf. -->
        <rect x={x(BAS)} y={YB} width={x(HAUT) - x(BAS)} height={HB} class="pp-bande" />
        <line x1={x(BAS)} y1={YB - 8} x2={x(BAS)} y2={YB} class="pp-amorce" />
        <line x1={x(HAUT)} y1={YB - 8} x2={x(HAUT)} y2={YB} class="pp-amorce" />
        <text x={x(BAS) - 7} y={YB - 12} class="pp-borne pp-borne-g">30</text>
        <text x={x(HAUT) + 7} y={YB - 12} class="pp-borne pp-borne-d">35</text>

        {#each TICKS as t}
          <line x1={x(t)} y1={YB + HB} x2={x(t)} y2={YB + HB + 9} class="pp-tick" />
          <text x={x(t)} y={YB + HB + 30} class="pp-tick-t">{t}</text>
        {/each}
      </svg>

      <p class="pp-bilan">
        <span class="pp-compte">elle exclut <strong>73</strong> r&#233;sultats sur 79</span>
        <span class="pp-note">Presque n&#8217;importe quel r&#233;sultat la tuerait.</span>
      </p>
    </div>
  {/if}

  {#if e >= 2}
    <div class="pp-piste pp-piste-b">
      <svg
        class="pp-axe"
        viewBox="0 0 1000 116"
        role="img"
        aria-label="Le m&#234;me axe des si&#232;ges obtenus, de 0 &#224; 78, recouvert d&#8217;un bout &#224; l&#8217;autre par une bande grise uniforme qui porte le mot compatible r&#233;p&#233;t&#233; sur toute sa longueur. Aucune portion n&#8217;est hachur&#233;e."
      >
        <text x={X0} y="20" class="pp-qui pp-qui-b">pr&#233;diction B</text>
        <text x={X1} y="20" class="pp-unite">si&#232;ges obtenus</text>

        <rect x={X0} y={YB} width={X1 - X0} height={HB} class="pp-plein" />
        {#each REPETES as v}
          <text x={x(v)} y={YB + HB / 2 + 6} class="pp-plein-t">compatible</text>
        {/each}

        {#each TICKS as t}
          <line x1={x(t)} y1={YB + HB} x2={x(t)} y2={YB + HB + 9} class="pp-tick" />
          <text x={x(t)} y={YB + HB + 30} class="pp-tick-t">{t}</text>
        {/each}
      </svg>

      <p class="pp-bilan">
        <span class="pp-compte pp-compte-b">elle exclut <strong>0</strong> r&#233;sultat sur 79</span>
        <span class="pp-note pp-note-b">Quel que soit le r&#233;sultat, elle aura eu raison.</span>
      </p>
    </div>
  {/if}

  {#if e >= 3}
    <p class="pp-verdict">Seule la premi&#232;re vous apprend quelque chose&#8239;: c&#8217;est la seule qui pouvait &#233;chouer.</p>
    <blockquote class="pp-cit">
      <p>&#171;&#8239;Une th&#233;orie qui n&#8217;est r&#233;futable par aucun &#233;v&#233;nement qui se puisse concevoir est d&#233;pourvue de caract&#232;re scientifique. Pour les th&#233;ories, l&#8217;irr&#233;futabilit&#233; n&#8217;est pas (comme on l&#8217;imagine souvent) vertu mais d&#233;faut.&#8239;&#187;</p>
      <span class="pp-src">Karl Popper, Conjectures et r&#233;futations (1963), chapitre 1</span>
    </blockquote>
    <p class="pp-rappel">Vous faites d&#233;j&#224; &#231;a&#8239;: on ne prouve jamais H&#8321;, on demande aux donn&#233;es de rejeter H&#8320;.</p>
  {/if}
</div>

<style>
  .pp-fig { display: flex; flex-direction: column; gap: 0.55em; }
  text { font-family: var(--dk-mono); }

  .pp-exemple { margin: 0; font-size: 0.62em; letter-spacing: 0.18em; text-transform: uppercase; color: var(--dk-gris-2); }

  /* Les deux prédictions, en toutes lettres. Elles restent à l'écran
     jusqu'au bout, en plus petit : les axes en dessous parlent d'elles. */
  .pp-cartes { display: flex; gap: 1.2em; align-items: stretch; }
  .pp-carte { flex: 1 1 50%; border: 2px solid var(--dk-filet); padding: 0.45em 0.7em 0.55em; display: flex; flex-direction: column; gap: 0.2em; transition: font-size 0.3s, border-color 0.3s; }
  .pp-carte-a { border-color: var(--dk-encre); }
  .pp-carte-b { animation: pp-monte 0.5s ease-out 0.8s both; }
  .pp-serre .pp-carte { font-size: 0.82em; }
  .pp-quoi { font-size: 0.6em; font-weight: 600; letter-spacing: 0.16em; text-transform: uppercase; color: var(--dk-gris); }
  .pp-carte-a .pp-quoi { color: var(--dk-accent); }
  .pp-dit { margin: 0; font-size: 0.86em; line-height: 1.35; }

  .pp-q { margin: 0.1em 0 0; font-size: 0.95em; font-weight: 600; color: var(--dk-accent); animation: pp-monte 0.45s ease-out 1.5s both; }

  /* Un axe, son compte et sa conséquence. */
  .pp-piste { display: flex; flex-direction: column; gap: 0.2em; animation: pp-monte 0.4s ease-out both; }
  .pp-axe { width: 100%; max-height: 15vh; display: block; overflow: visible; }
  .pp-serre .pp-axe { max-height: 12vh; }

  .pp-qui { font-size: 17px; font-weight: 600; letter-spacing: 0.12em; text-anchor: start; }
  .pp-qui-a { fill: var(--dk-accent); }
  .pp-qui-b { fill: var(--dk-gris-2); }
  .pp-unite { font-size: 15px; letter-spacing: 0.1em; text-anchor: end; fill: var(--dk-gris); }

  /* Ce que A exclut : hachures grises, discrètes, jamais rouges. Le rouge
     dit « elle a tendu le cou », pas « elle est cassée ». */
  .pp-hach { stroke: var(--dk-gris-2); stroke-width: 2; }
  .pp-hachure { fill: url(#pp-hachure); stroke: var(--dk-gris-2); stroke-width: 2; }
  .pp-exclus { animation: pp-parait 0.45s ease-out 0.4s both; }
  .pp-exclu { font-size: 17px; font-weight: 600; letter-spacing: 0.22em; text-anchor: middle; fill: var(--dk-gris); paint-order: stroke; stroke: var(--dk-fond); stroke-width: 6; }

  /* Ce que A s’autorise : plein, net, rouge. */
  .pp-bande { fill: var(--dk-accent); animation: pp-ouvre 0.5s cubic-bezier(0.34, 1.5, 0.64, 1) both; transform-box: fill-box; transform-origin: 50% 50%; }
  .pp-amorce { stroke: var(--dk-accent); stroke-width: 3; }
  .pp-borne { font-size: 18px; font-weight: 600; fill: var(--dk-accent); }
  .pp-borne-g { text-anchor: end; }
  .pp-borne-d { text-anchor: start; }

  /* B : un aplat gris, uniforme, sans texture et sans accent. Rien à voir,
     rien d’exclu, rien en jeu. */
  .pp-plein { fill: var(--dk-gris-2); animation: pp-etale 0.6s cubic-bezier(0.5, 0, 0.3, 1) both; transform-box: fill-box; transform-origin: 0% 50%; }
  .pp-plein-t { font-size: 16px; font-weight: 600; letter-spacing: 0.16em; text-anchor: middle; fill: var(--dk-fond); }

  .pp-tick { stroke: var(--dk-filet); stroke-width: 3; }
  .pp-tick-t { font-size: 16px; text-anchor: middle; fill: var(--dk-gris); }

  .pp-bilan { display: flex; flex-wrap: wrap; align-items: baseline; gap: 0.2em 1.1em; margin: 0; }
  .pp-compte { font-size: 0.82em; font-weight: 600; color: var(--dk-accent); }
  .pp-compte strong { font-size: 1.25em; }
  .pp-compte-b { color: var(--dk-gris-2); }
  .pp-note { font-size: 0.82em; line-height: 1.3; }
  .pp-note-b { color: var(--dk-gris); }

  .pp-verdict { margin: 0.1em 0 0; font-size: 0.9em; font-weight: 600; color: var(--dk-accent); animation: pp-monte 0.45s ease-out both; }
  .pp-cit { margin: 0; border-left: 5px solid var(--dk-accent); padding: 0.1em 0 0.1em 0.9em; animation: pp-monte 0.5s ease-out 0.2s both; }
  .pp-cit p { margin: 0; font-size: 0.82em; line-height: 1.38; }
  .pp-src { display: block; margin-top: 0.3em; font-size: 0.62em; letter-spacing: 0.04em; color: var(--dk-gris); }
  .pp-rappel { margin: 0; font-size: 0.84em; font-weight: 600; color: var(--dk-accent); animation: pp-monte 0.5s ease-out 0.4s both; }

  @keyframes pp-monte { from { opacity: 0; transform: translateY(0.5em); } to { opacity: 1; transform: none; } }
  @keyframes pp-parait { from { opacity: 0; } to { opacity: 1; } }
  @keyframes pp-ouvre { from { opacity: 0; transform: scaleX(0.1); } to { opacity: 1; transform: none; } }
  @keyframes pp-etale { from { transform: scaleX(0); } to { transform: none; } }

  @media (prefers-reduced-motion: reduce) {
    .pp-carte-b, .pp-q, .pp-piste, .pp-exclus, .pp-bande, .pp-plein,
    .pp-verdict, .pp-cit, .pp-rappel { animation: none; }
    .pp-carte { transition: none; }
  }
</style>
