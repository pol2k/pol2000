<script>
  /**
   * Trois façons de se tromper en tapant, et ce que R répond à chacune.
   * Les messages sont ceux de R 4.6, copiés tels quels : la salle doit
   * apprendre à les reconnaître, pas à les craindre.
   */
  const CAS = [
    { t: 'La parenthèse qui manque', bon: 'mean(ages)', mal: 'mean(ages', err: 'unexpected end of input', c: 'R attend encore. Il ne dit rien, ou il dit ceci : il manque quelque chose pour fermer.' },
    { t: 'La virgule qui manque', bon: 'c(24, 30)', mal: 'c(24 30)', err: 'unexpected numeric constant', c: 'Deux valeurs collées. R lit un nombre là où il attendait une virgule.' },
    { t: 'La majuscule de trop', bon: 'ages', mal: 'Ages', err: "object 'Ages' not found", c: 'R distingue les majuscules. Ages et ages sont deux objets, et le second n’existe pas.' }
  ];
</script>

<div class="visuel syntaxe">
  {#each CAS as k, i}
    <div class="cas" style="animation-delay: {i * 120}ms">
      <strong>{k.t}</strong>
      <div class="paire">
        <div class="bon"><span class="et">oui</span><code>{k.bon}</code></div>
        <div class="mal"><span class="et">non</span><code>{k.mal}</code></div>
      </div>
      <pre class="err">Error: {k.err}</pre>
      <p>{k.c}</p>
    </div>
  {/each}
</div>

<style>
  .syntaxe { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1em; }
  .cas { border: 2px solid var(--dk-encre); padding: 0.9em 0.9em 0.8em; display: flex; flex-direction: column; gap: 0.5em; animation: fondu 0.5s both; }
  .cas strong { font-size: 1.05em; }
  .paire { display: flex; flex-direction: column; gap: 0.35em; }
  .paire > div { display: grid; grid-template-columns: 2.6em 1fr; align-items: center; gap: 0.5em; }
  .et { font-size: 0.6em; letter-spacing: 0.14em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .bon .et { color: var(--dk-encre); }
  .mal .et { color: var(--dk-accent); }
  .paire code { font-size: 1.05em; background: var(--dk-fond-2); padding: 0.15em 0.45em; }
  .mal code { color: var(--dk-accent); text-decoration: underline wavy var(--dk-accent); text-underline-offset: 0.2em; }
  .err { margin: 0; font-family: var(--dk-mono); font-size: 0.66em; color: var(--dk-accent); background: var(--dk-fond-2); border-left: 0.3em solid var(--dk-accent); padding: 0.4em 0.6em; white-space: pre-wrap; }
  .cas p { margin: 0; font-size: 0.74em; line-height: 1.4; color: var(--dk-gris); }
  @keyframes fondu { from { opacity: 0; transform: translateY(0.3em); } to { opacity: 1; transform: none; } }
</style>
