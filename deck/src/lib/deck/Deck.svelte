<script>
  import { untrack } from 'svelte';
  import { dansUnChamp } from './temps.js';
  import { allerA, creerDeck, etiquette, precedent, progression, suivant } from './navigation.js';
  import '@fontsource/ibm-plex-mono/400.css';
  import '@fontsource/ibm-plex-mono/500.css';
  import '@fontsource/ibm-plex-mono/600.css';
  import '@fontsource/ibm-plex-mono/400-italic.css';
  import './deck.css';

  // logo = image affichée dans le pied, sur chaque diapo (identité de l'établissement).
  let { total, logo = '', children } = $props();

  // Le deck est navigable sans JavaScript: cet état ne sert qu'au confort
  // (barre de progression, pastilles, compteur). Il ne commande jamais la
  // visibilité d'une diapo.
  let deck = $state(creerDeck(untrack(() => total)));
  let conteneur = $state(null);
  let js = $state(false);

  // Ajustement de la taille pour un projecteur donné. Confort seulement:
  // sans JavaScript, --zoom garde sa valeur par défaut de 1.
  const ZOOMS = [0.8, 0.9, 1, 1.12, 1.25];
  let z = $state(2);

  // La minuterie de pause, commandée depuis n'importe quelle diapositive.
  // Elle sert à la personne qui enseigne: on veut voir de loin ce qu'il
  // reste, sans changer de diapositive ni sortir son téléphone.
  const DUREES = [5, 10, 15];
  let pause = $state(false);
  let fin = $state(0);
  let reste = $state(0);
  let bat = null;

  const mm = $derived(String(Math.floor(Math.max(reste, 0) / 60)).padStart(2, '0'));
  const ss = $derived(String(Math.max(reste, 0) % 60).padStart(2, '0'));

  function battre() {
    clearTimeout(bat);
    reste = Math.max(0, Math.round((fin - Date.now()) / 1000));
    if (reste > 0) bat = setTimeout(battre, 250);
  }
  function partir(min) {
    fin = Date.now() + min * 60 * 1000;
    battre();
  }
  function fermerPause() {
    clearTimeout(bat);
    pause = false;
    reste = 0;
  }

  $effect(() => { js = true; });

  function versDiapo(n) {
    deck = allerA(deck, n);
    conteneur?.children[deck.index]?.scrollIntoView({ block: 'start' });
  }

  function auClavier(e) {
    // Tapé dans un champ (l'éditeur Datacamp, par exemple): ce n'est pas
    // une commande du deck, on laisse passer.
    if (dansUnChamp(e)) return;
    // Pendant une pause, le clavier ne fait plus avancer le deck: on ne veut
    // pas changer de diapositive en frôlant la télécommande.
    if (pause) {
      if (e.key === 'Escape') {
        e.preventDefault();
        fermerPause();
      }
      return;
    }
    if (e.key === 'p' || e.key === 'P') {
      e.preventDefault();
      pause = true;
      reste = 0;
      return;
    }
    if (['ArrowRight', 'ArrowDown', 'PageDown', ' '].includes(e.key)) {
      e.preventDefault();
      versDiapo(suivant(deck).index);
    } else if (['ArrowLeft', 'ArrowUp', 'PageUp'].includes(e.key)) {
      e.preventDefault();
      versDiapo(precedent(deck).index);
    } else if (e.key === '+' || e.key === '=') {
      e.preventDefault();
      z = Math.min(z + 1, ZOOMS.length - 1);
    } else if (e.key === '-' || e.key === '_') {
      e.preventDefault();
      z = Math.max(z - 1, 0);
    }
  }

  // Au défilement libre (molette, doigt), on relit la position réelle.
  function auDefilement() {
    if (!conteneur) return;
    const n = Math.round(conteneur.scrollTop / conteneur.clientHeight);
    deck = allerA(deck, n);
  }
</script>

<svelte:window onkeydown={auClavier} />

<div class="deck" style="--zoom: {ZOOMS[z]}" bind:this={conteneur} onscroll={auDefilement} tabindex="-1">
  {@render children()}
</div>

<div class="deck-barre" style="width: {progression(deck) * 100}%"></div>

<div class="deck-pied" class:sans-js={!js}>
  {#if logo}<img class="deck-logo" src={logo} alt="Université Laval" />{/if}
  <div class="deck-points">
    {#each Array.from({ length: deck.total }) as _, i}
      <button
        class="point {i === deck.index ? 'on' : ''}"
        aria-label="Aller à la diapo {i + 1}"
        onclick={() => versDiapo(i)}
      ></button>
    {/each}
  </div>
  <span>{etiquette(deck)}</span>
  {#if js && ZOOMS[z] !== 1}<span class="zoom">{Math.round(ZOOMS[z] * 100)} %</span>{/if}
</div>

{#if js}
  <button class="pause-app" onclick={() => { pause = true; reste = 0; }} aria-label="Ouvrir la minuterie de pause" title="Pause (p)">
    <svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="9" /><path d="M12 7 L12 12 L16 14" /></svg>
  </button>
{/if}

{#if pause}
  <div class="pause-voile" role="dialog" aria-label="Pause">
    {#if reste > 0}
      <p class="pause-compte">{mm}:{ss}</p>
      <p class="pause-mot">Pause</p>
    {:else if fin && reste === 0}
      <p class="pause-compte fini">00:00</p>
      <p class="pause-mot">On reprend</p>
    {:else}
      <p class="pause-mot">Combien de temps ?</p>
    {/if}
    <div class="pause-choix">
      {#each DUREES as d}
        <button onclick={() => partir(d)}>{d} min</button>
      {/each}
    </div>
    <button class="pause-fermer" onclick={fermerPause}>Fermer · Échap</button>
  </div>
{/if}
