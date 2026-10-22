<script>
  /**
   * Les étapes 1 à 6 du TP 1 de Blais et Gélineau, en une seule diapo : le
   * même article reste en toile de fond et défile d'une étape à l'autre,
   * sans coupure (demande du professeur). Chaque étape garde ses passages et
   * sa carte (M8Art1 à M8Art6, qui exportent ETATS et rendent la carte du
   * temps e); M8Fil les met bout à bout sur un seul M8Article.
   *
   * Le titre et la bande des sept étapes (TmParcours) suivent la marche.
   * etape (bind:etape) remonte au bandeau de la diapo.
   *
   * Rendu sans enveloppe : TmParcours, le titre et .m8a restent enfants
   * directs de .diapo-in (M8Article s'y étale sur toute la largeur).
   */
  import { fade } from 'svelte/transition';
  import TmParcours from './TmParcours.svelte';
  import M8Article from './M8Article.svelte';
  import M8Art1, { ETATS as E1 } from './M8Art1.svelte';
  import M8Art2, { ETATS as E2 } from './M8Art2.svelte';
  import M8Art3, { ETATS as E3 } from './M8Art3.svelte';
  import M8Art4, { ETATS as E4 } from './M8Art4.svelte';
  import M8Art5, { ETATS as E5 } from './M8Art5.svelte';
  import M8Art6, { ETATS as E6 } from './M8Art6.svelte';

  let { etape = $bindable(1) } = $props();

  const ETAPES = [
    { titre: 'Une question claire', etats: E1, Carte: M8Art1 },
    { titre: 'La littérature, comme à Risk', etats: E2, Carte: M8Art2 },
    { titre: 'Des hypothèses tirées de la littérature', etats: E3, Carte: M8Art3 },
    { titre: 'Les données et les variables', etats: E4, Carte: M8Art4 },
    { titre: 'La pertinence : ok, donc ?', etats: E5, Carte: M8Art5 },
    { titre: 'La contribution', etats: E6, Carte: M8Art6 }
  ];

  // Tous les temps, bout à bout; chacun sait à quelle étape il appartient.
  const QUI = ETAPES.flatMap((et, i) => et.etats.map((_, k) => ({ i, k })));
  const ETATS = ETAPES.flatMap((et) => et.etats);

  let e = $state(0);
  const ici = $derived(QUI[e]);
  $effect(() => { etape = ici.i + 1; });
</script>

<TmParcours ici={ici.i + 1} />
<h2 class="e">{#key ici.i}<span in:fade={{ duration: 500, delay: 250 }}>{ETAPES[ici.i].titre}</span>{/key}</h2>
<M8Article etats={ETATS} bind:e>
  {#snippet note(n)}
    {@const q = QUI[n]}
    {@const Carte = ETAPES[q.i].Carte}
    <Carte e={q.k} />
  {/snippet}
</M8Article>
