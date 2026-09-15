<script>
  /**
   * Pis, la médiane, ça sert à quoi ? Neuf salaires fictifs, puis le PDG
   * entre dans la pièce. Trois temps.
   *
   *   0  Neuf personnes arrivent une à une avec leur salaire. Sous la ligne,
   *      sur une échelle de salaires, la médiane (rouge) et la moyenne
   *      (encre) tombent presque au même endroit.
   *   1  Le PDG, deux fois plus grand, entre par la droite avec ses
   *      2 000 000 $. La moyenne est recalculée et file hors du dessin; la
   *      médiane bouge à peine et clignote.
   *   2  La réponse apparaît.
   *
   * Les salaires sont fictifs et dits tels. La moyenne et la médiane sont
   * calculées ici, jamais tapées.
   */
  import { brancherTemps } from '../temps.js';
  import Pis from './Pis.svelte';

  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 2, lire: () => e, ecrire: (v) => (e = v) });
  });

  const SALAIRES = [38000, 42000, 45000, 47000, 50000, 52000, 55000, 60000, 64000];
  const PDG = 2000000;
  const moyenne = (v) => v.reduce((s, x) => s + x, 0) / v.length;
  const mediane = (v) => {
    const t = [...v].sort((a, b) => a - b);
    const m = Math.floor(t.length / 2);
    return t.length % 2 ? t[m] : (t[m - 1] + t[m]) / 2;
  };
  const avant = { moy: moyenne(SALAIRES), med: mediane(SALAIRES) };
  const apres = { moy: moyenne([...SALAIRES, PDG]), med: mediane([...SALAIRES, PDG]) };
  const argent = (v) => `${Math.round(v).toLocaleString('fr-CA')} $`;

  // Le sol et les personnes, régulièrement espacées.
  const SOL = 214;
  const px = (i) => 70 + i * 84;
  const XPDG = 880;

  // L'échelle des salaires, sous le sol : de 30 000 à 70 000 $.
  const AXE = 300, A0 = 70, A1 = 790;
  const sx = (v) => A0 + ((v - 30000) / 40000) * (A1 - A0);
  const BORD = 975;

  const moyX = $derived(e >= 1 ? BORD : sx(avant.moy));
  const medX = $derived(e >= 1 ? sx(apres.med) : sx(avant.med));
  const moyTexte = $derived(`moyenne · ${argent(e >= 1 ? apres.moy : avant.moy)}`);
  const medTexte = $derived(`médiane · ${argent(e >= 1 ? apres.med : avant.med)}`);
</script>

<Pis stat="la médiane" reponse="Pour parler du salaire « typique », on prend la médiane." vu={e >= 2} source="exemple fictif">
  {#snippet children()}
    <svg bind:this={hote} class="salle" viewBox="0 0 1000 380" role="img" aria-label="Neuf salaires fictifs de 38 000 à 64 000 dollars : médiane et moyenne proches de 50 000. Un PDG à 2 000 000 dollars arrive : la moyenne dépasse 245 000, la médiane passe à 51 000. Exemple fictif.">
      <line x1="30" y1={SOL} x2="970" y2={SOL} class="sol" />

      {#each SALAIRES as s, i}
        <g class="gens" style="transform: translate({px(i)}px, {SOL}px); --d: {i * 90}ms">
          <g class="corps">
            <rect x="-11" y="-92" width="22" height="22" class="tete-p" />
            <line x1="0" y1="-70" x2="0" y2="-34" />
            <line x1="-16" y1="-60" x2="16" y2="-60" />
            <line x1="0" y1="-34" x2="-12" y2="0" />
            <line x1="0" y1="-34" x2="12" y2="0" />
          </g>
          <text y="-104" class="sal">{argent(s)}</text>
        </g>
      {/each}

      <!-- Le PDG : deux fois plus grand, il entre à grandes enjambées. -->
      <g class="pdg" class:entre={e >= 1} style="--x: {XPDG}px; --y: {SOL}px">
        <g class="grandi">
          <g class="marche" class:va={e === 1}>
            <rect x="-11" y="-92" width="22" height="22" class="tete-p" />
            <line x1="0" y1="-70" x2="0" y2="-34" />
            <line x1="-16" y1="-60" x2="16" y2="-60" />
            <line x1="0" y1="-34" x2="-12" y2="0" class="jambe g" />
            <line x1="0" y1="-34" x2="12" y2="0" class="jambe d" />
          </g>
        </g>
        <text y="-196" class="sal rouge">{argent(PDG)}</text>
        <text y="24" class="qui">le PDG</text>
      </g>

      <!-- L'échelle des salaires. -->
      <line x1={A0} y1={AXE} x2={A1} y2={AXE} class="axe" />
      {#each [30000, 40000, 50000, 60000, 70000] as t}
        <line x1={sx(t)} y1={AXE - 5} x2={sx(t)} y2={AXE + 5} class="axe" />
      {/each}

      <!-- La moyenne, au-dessus de l'échelle. Elle file hors du dessin au temps 1. -->
      <g class="marq" style="transform: translateX({moyX}px)">
        <path d="M -9 {AXE - 22} L 9 {AXE - 22} L 0 {AXE - 6} Z" class="tri-moy" />
        {#if e >= 1}
          <path d="M -60 {AXE - 14} L -16 {AXE - 14} M -26 {AXE - 22} L -16 {AXE - 14} L -26 {AXE - 6}" class="fleche" />
        {/if}
        <text y={AXE - 32} class="lab-moy" class:fin={e >= 1}>{moyTexte}</text>
      </g>

      <!-- La médiane, sous l'échelle. Elle bouge à peine et clignote. -->
      <g class="marq" style="transform: translateX({medX}px)">
        {#key e >= 1}
          <g class:flash={e >= 1}>
            <path d="M -9 {AXE + 22} L 9 {AXE + 22} L 0 {AXE + 6} Z" class="tri-med" />
            <text y={AXE + 48} class="lab-med">{medTexte}</text>
          </g>
        {/key}
      </g>

      <text x="975" y="372" class="fictif">exemple fictif</text>
    </svg>
  {/snippet}
</Pis>

<style>
  .salle { width: 100%; height: 100%; max-height: 44vh; display: block; overflow: visible; }
  text { font-family: var(--dk-mono); }
  .sol { stroke: var(--dk-encre); stroke-width: 3; }

  .gens line, .pdg line { stroke: var(--dk-encre); stroke-width: 4; stroke-linecap: square; }
  .tete-p { fill: var(--dk-fond); stroke: var(--dk-encre); stroke-width: 4; }
  .gens .corps { transform-box: fill-box; transform-origin: 50% 100%; animation: pop 0.5s cubic-bezier(0.34, 1.7, 0.64, 1) both; animation-delay: var(--d); }
  .gens .sal { animation: fondu 0.4s both; animation-delay: calc(var(--d) + 200ms); }
  .sal { font-size: 15px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .sal.rouge { fill: var(--dk-accent); font-size: 18px; }
  .qui { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }

  .pdg { opacity: 0; transform: translate(calc(var(--x) + 220px), var(--y)); transition: transform 1.1s cubic-bezier(0.25, 1, 0.5, 1), opacity 0.3s; }
  .pdg.entre { opacity: 1; transform: translate(var(--x), var(--y)); }
  .grandi { transform: scale(2); transform-origin: 0 0; }
  .marche.va { animation: bob 0.28s ease-in-out 4; }
  .jambe { transform-box: fill-box; transform-origin: 50% 0; }
  .marche.va .jambe.g { animation: pas 0.28s ease-in-out 4 alternate; }
  .marche.va .jambe.d { animation: pas 0.28s ease-in-out 4 alternate-reverse; }

  .axe { stroke: var(--dk-gris); stroke-width: 2.5; }
  .marq { transition: transform 1s cubic-bezier(0.34, 1.3, 0.64, 1); }
  .tri-moy { fill: var(--dk-encre); }
  .tri-med { fill: var(--dk-accent); }
  .fleche { fill: none; stroke: var(--dk-encre); stroke-width: 3; animation: fondu 0.3s 0.8s both; }
  .lab-moy { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-encre); }
  .lab-moy.fin { text-anchor: end; }
  .lab-med { font-size: 16px; font-weight: 600; text-anchor: middle; fill: var(--dk-accent); }
  .flash { animation: clignote 0.35s ease-in-out 0.5s 4 alternate; }
  .fictif { font-size: 14px; text-anchor: end; fill: var(--dk-gris-2); letter-spacing: 0.06em; }

  @keyframes pop { from { opacity: 0; transform: scale(0); } to { opacity: 1; transform: scale(1); } }
  @keyframes fondu { from { opacity: 0; } to { opacity: 1; } }
  @keyframes bob { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-4px); } }
  @keyframes pas { from { transform: rotate(-18deg); } to { transform: rotate(18deg); } }
  @keyframes clignote { from { opacity: 1; } to { opacity: 0.25; } }

  @media (prefers-reduced-motion: reduce) {
    .gens .corps, .gens .sal, .fleche, .flash, .marche.va, .marche.va .jambe { animation: none; }
    .pdg, .marq { transition: none; }
  }
</style>
