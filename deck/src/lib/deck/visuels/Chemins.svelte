<script>
  /**
   * Chemin absolu contre chemin relatif, puis le piège de Windows. Deux
   * temps : les deux chemins, puis l'avertissement. Le chemin est dessiné
   * comme un fil de dossiers : la partie fixe (propre à l'ordinateur) en
   * gris, le dossier ouvert dans Positron en encre, la partie relative en
   * rouge. Le message d'erreur est celui de R 4.6.1, copié tel quel :
   * « C:\Users » fait planter R parce que la barre oblique inverse y est un
   * caractère spécial.
   */
  import { brancherTemps } from '../temps.js';
  import Picto from '../Picto.svelte';
  const FIXE = ['Users', 'vous', 'Documents'];
  const REL = ['data', 'ces2025.csv'];
  // Chez qui le chemin marche : vous, moi, l'auxiliaire, le portable de l'examen.
  const CHEZ = [
    { qui: 'vous', pic: 'humain' },
    { qui: 'moi', pic: 'humain' },
    { qui: 'l’auxiliaire', pic: 'humain' },
    { qui: 'l’examen', pic: 'terminal' }
  ];
  const ABS_OK = [true, false, false, false];
  const REL_OK = [true, true, true, true];
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

{#snippet fil(racine, fixe, sep, cls, tag)}
  <div class="fil {cls}">
    {#if racine}<span class="m fixe">{racine}</span>{/if}
    {#each fixe as f}
      <span class="sep fixe">{sep}</span><span class="m fixe">{f}</span>
    {/each}
    <span class="sep fixe">{sep}</span>
    <span class="pos">
      {#if tag}<span class="tag">ouvert dans Positron</span>{/if}
      <span class="m dossier">pol2000</span>
    </span>
    {#each REL as r}
      <span class="sep rel">{sep}</span><span class="m rel">{r}</span>
    {/each}
  </div>
{/snippet}

{#snippet chez(ok)}
  <div class="chez">
    {#each CHEZ as c, i}
      <span class="qui" class:ok={ok[i]}>
        <Picto nom={c.pic} taille="1.6em" />
        <span class="nom">{c.qui}</span>
        <span class="v"><Picto nom={ok[i]?'coche':'croix'} taille="1.1em" /></span>
      </span>
    {/each}
  </div>
{/snippet}

<div class="visuel chemins" bind:this={hote}>
  <div class="deux">
    <div class="col">
      <div class="tete"><span class="et">ABSOLU · depuis la racine de l’ordinateur</span><span class="verdict non"><Picto nom="croix" taille="1.3em" /></span></div>
      <div class="fils">
        <div class="os"><span class="osn">Windows</span>{@render fil('C:', FIXE, '/', 'long', false)}</div>
        <div class="os"><span class="osn">Mac</span>{@render fil('', FIXE, '/', 'long', false)}</div>
      </div>
      {@render chez(ABS_OK)}
      <p>Ne marche que sur <strong>votre</strong> ordinateur.</p>
    </div>
    <div class="col bon">
      <div class="tete"><span class="et">RELATIF · depuis le dossier ouvert dans Positron</span><span class="verdict oui"><Picto nom="coche" taille="1.3em" /></span></div>
      <div class="fils">
        {@render fil('…', [], '/', 'court', true)}
      </div>
      {@render chez(REL_OK)}
      <p>Marche partout où le dossier <code>pol2000</code> existe.</p>
      <em>c’est celui-là</em>
    </div>
  </div>
  <div class="win" class:vu={e === 1}>
    <span class="et">ATTENTION, WINDOWS</span>
    <div class="win-corps">
      <div class="ligne mal">
        {@render fil('C:', FIXE, '\\', 'long', false)}
        <pre class="err">Error: '\U' used without hex digits in character string</pre>
      </div>
      <div class="ligne bien">
        <span class="fix"><span class="gros">→</span> remplacez <code>\</code> par <code>/</code></span>
        {@render fil('C:', FIXE, '/', 'long', false)}
        <span class="mieux">Ou mieux : un chemin relatif.</span>
      </div>
    </div>
  </div>
</div>

<style>
  .chemins { display: flex; flex-direction: column; gap: 0.8em; }
  .deux { display: grid; grid-template-columns: 1.2fr 1fr; gap: 1em; }
  .col { border: 2px solid var(--dk-encre); padding: 0.8em 1em; display: flex; flex-direction: column; gap: 0.6em; }
  .col.bon { border: 3px solid var(--dk-accent); }
  .tete { display: flex; justify-content: space-between; align-items: center; gap: 0.6em; }
  .et { font-size: 0.6em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .bon .et { color: var(--dk-accent); }
  .verdict { display: flex; }
  .verdict.non { color: var(--dk-accent); }
  .verdict.oui { color: var(--dk-encre); }
  /* Le fil de dossiers. */
  .fils { display: flex; flex-direction: column; gap: 0.4em; }
  .os { display: flex; align-items: center; gap: 0.6em; }
  .osn { font-size: 0.55em; letter-spacing: 0.12em; text-transform: uppercase; color: var(--dk-gris-2); width: 5.5em; flex: none; }
  .fil { display: flex; flex-wrap: wrap; align-items: center; gap: 0.15em; font-family: var(--dk-mono); }
  .fil.long { font-size: 0.66em; }
  .fil.court { font-size: 1.1em; margin-top: 1.1em; }
  .m { border: 2px solid var(--dk-gris-2); padding: 0.1em 0.4em; line-height: 1.3; white-space: nowrap; }
  .m.fixe { color: var(--dk-gris); background: var(--dk-fond-2); }
  .m.dossier { border-color: var(--dk-encre); background: var(--dk-encre); color: var(--dk-fond); font-weight: 600; }
  .m.rel { border-color: var(--dk-accent); color: var(--dk-accent); font-weight: 600; }
  .sep { font-weight: 600; color: var(--dk-gris-2); padding: 0 0.1em; }
  .sep.rel { color: var(--dk-accent); }
  .court .fixe { opacity: 0.25; }
  .court .m.fixe { border-style: dashed; background: none; }
  .pos { position: relative; display: inline-flex; }
  .tag { position: absolute; left: 0; bottom: 100%; margin-bottom: 0.15em; font-size: 0.5em; letter-spacing: 0.12em; text-transform: uppercase; white-space: nowrap; color: var(--dk-encre); font-weight: 600; border-bottom: 2px solid var(--dk-encre); }
  /* Chez qui ça marche. */
  .chez { display: flex; gap: 1.2em; justify-content: center; }
  .qui { display: flex; flex-direction: column; align-items: center; gap: 0.2em; color: var(--dk-gris); }
  .qui.ok { color: var(--dk-encre); }
  .nom { font-size: 0.6em; letter-spacing: 0.06em; }
  .v { color: var(--dk-accent); display: flex; }
  .ok .v { color: var(--dk-encre); }
  .col p { margin: 0; font-size: 0.78em; line-height: 1.45; color: var(--dk-gris); text-align: center; }
  .col em { margin-top: auto; font-style: normal; font-size: 0.72em; font-weight: 600; color: var(--dk-accent); letter-spacing: 0.06em; text-align: center; }
  /* Windows. */
  .win { border: 3px dashed var(--dk-accent); padding: 0.7em 1em 0.8em; display: flex; flex-direction: column; gap: 0.5em; opacity: 0.12; transition: opacity 0.4s; }
  .win.vu { opacity: 1; }
  .win .et { color: var(--dk-accent); }
  .win-corps { display: flex; flex-direction: column; gap: 0.5em; }
  .ligne { display: flex; flex-wrap: wrap; align-items: center; gap: 0.5em 1.2em; }
  .mal .sep { color: var(--dk-accent); font-size: 1.5em; padding: 0; line-height: 0.8; }
  .bien .sep { color: var(--dk-encre); }
  .err { margin: 0; font-family: var(--dk-mono); font-size: 0.66em; color: var(--dk-accent); background: var(--dk-fond-2); border-left: 0.3em solid var(--dk-accent); padding: 0.4em 0.6em; white-space: pre-wrap; }
  .fix { display: inline-flex; align-items: center; gap: 0.3em; font-size: 0.72em; font-weight: 600; white-space: nowrap; }
  .gros { font-size: 1.8em; line-height: 1; color: var(--dk-accent); }
  .mieux { font-size: 0.78em; color: var(--dk-accent); font-weight: 600; white-space: nowrap; }
</style>
