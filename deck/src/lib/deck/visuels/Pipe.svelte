<script>
  /**
   * Le pipe |> : « et ensuite ». L'image de la routine du matin vient du
   * deck FAS1001 ; sans pipe on lit de l'intérieur vers l'extérieur, avec
   * le pipe on lit dans l'ordre où ça se passe. Deux temps : la version
   * emboîtée, puis la version enchaînée.
   */
  import { brancherTemps } from '../temps.js';
  let e = $state(0);
  let hote = $state(null);
  $effect(() => {
    if (!hote) return;
    e = 0;
    return brancherTemps(hote, { total: 1, lire: () => e, ecrire: (v) => (e = v) });
  });
</script>

<div class="visuel pipe" bind:this={hote}>
  <div class="col">
    <span class="et">SANS · on lit de l’intérieur vers l’extérieur</span>
    <pre>s_habiller(
  se_secher(
    se_doucher(
      se_lever(moi)
    )
  )
)</pre>
  </div>
  <div class="col apres" class:vu={e === 1}>
    <span class="et">AVEC · on lit dans l’ordre</span>
    <pre>moi |&gt;
  se_lever() |&gt;
  se_doucher() |&gt;
  se_secher() |&gt;
  s_habiller()</pre>
    <p>Le pipe prend ce qui est à gauche et le passe à la fonction de droite. Lisez <code>|&gt;</code> comme « et ensuite ». Vous croiserez aussi <code>%&gt;%</code> : même chose, plus vieux.</p>
  </div>
</div>

<style>
  .pipe { display: grid; grid-template-columns: 1fr 1fr; gap: 1.6em; align-items: start; }
  .col { display: flex; flex-direction: column; gap: 0.5em; }
  .et { font-size: 0.62em; letter-spacing: 0.16em; font-weight: 600; color: var(--dk-gris); }
  .apres .et { color: var(--dk-accent); }
  pre { margin: 0; font-family: var(--dk-mono); font-size: 1.15em; line-height: 1.5; border: 3px solid var(--dk-encre); padding: 0.7em 1em; white-space: pre; }
  .apres pre { border-color: var(--dk-accent); }
  .apres { opacity: 0.18; transition: opacity 0.4s; }
  .apres.vu { opacity: 1; }
  .apres p { margin: 0; font-size: 0.82em; line-height: 1.45; color: var(--dk-gris); }
</style>
