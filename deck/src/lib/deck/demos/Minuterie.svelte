<script>
  /**
   * Une minuterie de pause, commandée au clic. Elle sert à la personne qui
   * enseigne, pas au public: on veut savoir combien il reste, de loin, sans
   * sortir son téléphone.
   *
   * Sans JavaScript, la durée annoncée s'affiche telle quelle: la diapositive
   * ne dépend pas de la minuterie pour dire ce qu'elle a à dire.
   */
  let { minutes = 15 } = $props();

  const TOTAL = minutes * 60;
  let hote = $state(null);
  let js = $state(false);
  let reste = $state(TOTAL);
  let etat = $state('arret'); // 'arret' | 'marche' | 'pause' | 'fini'

  const mm = $derived(String(Math.floor(Math.max(reste, 0) / 60)).padStart(2, '0'));
  const ss = $derived(String(Math.max(reste, 0) % 60).padStart(2, '0'));
  const part = $derived(1 - Math.max(reste, 0) / TOTAL);

  $effect(() => {
    if (!hote) return;
    js = true;

    const diapo = hote.closest('.diapo');
    const deck = hote.closest('.deck');
    if (!diapo || !deck) return;

    let fin = 0, af = 0;

    function battre() {
      if (etat !== 'marche') return;
      reste = Math.max(0, Math.round((fin - Date.now()) / 1000));
      if (reste === 0) {
        etat = 'fini';
        return;
      }
      af = setTimeout(battre, 250);
    }

    function basculer() {
      if (etat === 'marche') {
        etat = 'pause';
        clearTimeout(af);
      } else if (etat === 'fini') {
        reste = TOTAL;
        etat = 'arret';
      } else {
        // On vise une heure de fin plutôt que de décrémenter: un onglet mis en
        // arrière-plan ralentit les minuteries, et la pause durerait plus long.
        fin = Date.now() + reste * 1000;
        etat = 'marche';
        clearTimeout(af);
        battre();
      }
    }

    diapo.addEventListener('click', basculer);

    // Quitter la diapositive remet la minuterie à zéro: on ne veut pas
    // retrouver une pause à moitié écoulée en revenant dessus.
    const monIndex = [...deck.querySelectorAll('.diapo')].indexOf(diapo);
    let ici = false;
    function verifier() {
      const y = Math.round(deck.scrollTop / deck.clientHeight) === monIndex;
      if (!y && ici) {
        ici = false;
        clearTimeout(af);
        etat = 'arret';
        reste = TOTAL;
      } else if (y && !ici) ici = true;
    }
    deck.addEventListener('scroll', verifier, { passive: true });
    verifier();

    return () => {
      diapo.removeEventListener('click', basculer);
      deck.removeEventListener('scroll', verifier);
      clearTimeout(af);
    };
  });
</script>

<div class="min" bind:this={hote} class:fini={etat === 'fini'}>
  {#if js}
    <div class="cadran">{mm}:{ss}</div>
    <div class="piste"><span class="rempli" style="width: {part * 100}%"></span></div>
    <p class="etq">
      {#if etat === 'arret'}cliquez pour lancer la pause
      {:else if etat === 'marche'}en cours — cliquez pour interrompre
      {:else if etat === 'pause'}en attente — cliquez pour reprendre
      {:else}la pause est terminée{/if}
    </p>
  {:else}
    <div class="cadran">{minutes} min</div>
  {/if}
</div>

<style>
  .min {
    display: flex;
    flex-direction: column;
    gap: 0.3em;
    width: 100%;
  }
  .cadran {
    font-family: var(--dk-mono);
    font-size: 4.4em;
    font-weight: 600;
    line-height: 1;
    letter-spacing: -0.05em;
    font-variant-numeric: tabular-nums;
    color: var(--dk-accent-clair);
  }
  .piste {
    height: 0.5em;
    border: 2px solid var(--dk-gris);
    max-width: 14em;
  }
  .rempli {
    display: block;
    height: 100%;
    background: var(--dk-accent-clair);
    transition: width 0.25s linear;
  }
  .etq {
    margin: 0;
    font-size: 0.62em;
    letter-spacing: 0.1em;
    color: var(--dk-gris-2);
  }
  /* À zéro, le cadran passe au blanc: visible du fond de la salle. */
  .min.fini .cadran {
    color: var(--dk-fond);
  }
  .min.fini .rempli {
    background: var(--dk-fond);
  }
</style>
