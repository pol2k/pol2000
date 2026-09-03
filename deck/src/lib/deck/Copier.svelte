<script>
  /**
   * Un bouton « copier », posable à côté de n'importe quel bloc de code.
   *
   * La logique vivait dans Code.svelte, donc seuls les blocs de prompt en
   * profitaient. Les commandes d'installation, elles, se recopiaient à la
   * main — c'est précisément là qu'une faute de frappe coûte cher.
   *
   * Le bouton ne se positionne pas lui-même: dans un bloc de code il se pose
   * en haut à droite, ailleurs il reste dans le fil. C'est le contexte qui
   * décide, pas lui.
   */
  let { texte, etiquette = 'copier' } = $props();

  let js = $state(false);
  let etat = $state('pret'); // 'pret' | 'copie' | 'echec'
  let minuteur = 0;

  $effect(() => {
    js = true;
    return () => clearTimeout(minuteur);
  });

  async function copier(ev) {
    // Certaines diapositives avancent leur animation au clic n'importe où:
    // le bouton ne doit pas les faire avancer en même temps.
    ev.stopPropagation();

    const contenu = String(texte).trim();
    let ok = false;

    // navigator.clipboard exige un contexte sécurisé. Le deck est prévu pour
    // être projeté depuis un fichier local, où il peut manquer: on retombe
    // alors sur la vieille méthode, qui marche partout.
    try {
      if (navigator.clipboard?.writeText) {
        await navigator.clipboard.writeText(contenu);
        ok = true;
      }
    } catch {
      ok = false;
    }

    if (!ok) {
      try {
        const z = document.createElement('textarea');
        z.value = contenu;
        z.setAttribute('readonly', '');
        z.style.cssText = 'position:fixed;top:-1000px;opacity:0';
        document.body.appendChild(z);
        z.select();
        ok = document.execCommand('copy');
        document.body.removeChild(z);
      } catch {
        ok = false;
      }
    }

    etat = ok ? 'copie' : 'echec';
    clearTimeout(minuteur);
    minuteur = setTimeout(() => (etat = 'pret'), 1600);
  }
</script>

{#if js}
  <button
    class="copier"
    class:fait={etat === 'copie'}
    class:rate={etat === 'echec'}
    type="button"
    onclick={copier}
    aria-label="Copier dans le presse-papiers"
  >
    {etat === 'copie' ? 'copié' : etat === 'echec' ? 'échec' : etiquette}
  </button>
{/if}
