<script>
  /**
   * L'article de Blais et Gélineau, puis les étapes 1 à 6 de leur TP 1, en
   * une seule diapo : le même article reste en toile de fond et défile d'un
   * temps à l'autre, sans coupure (demande du professeur).
   *
   *   la une        la première page entière, et sa référence APA;
   *   leur TP 1     on zoome dans le texte : « Et si Blais et Gélineau
   *                 remettaient votre TP 1 ? », la bande des sept étapes;
   *   étapes 1 à 6  chacune garde ses passages et sa carte (M8Art1 à M8Art6,
   *                 qui exportent ETATS et rendent la carte du temps e).
   *
   * Le titre et la bande des sept étapes (TmParcours) suivent la marche.
   * bandeau (bind:bandeau) remonte au bandeau de la diapo.
   *
   * Rendu sans enveloppe : TmParcours, le titre et .m8a restent enfants
   * directs de .diapo-in (M8Article s'y étale sur toute la largeur).
   */
  import { fade } from 'svelte/transition';
  import { BG } from '$lib/data/seance8.js';
  import TmParcours from './TmParcours.svelte';
  import M8Article from './M8Article.svelte';
  import M8Art1, { ETATS as E1 } from './M8Art1.svelte';
  import M8Art2, { ETATS as E2 } from './M8Art2.svelte';
  import M8Art3, { ETATS as E3 } from './M8Art3.svelte';
  import M8Art4, { ETATS as E4 } from './M8Art4.svelte';
  import M8Art5, { ETATS as E5 } from './M8Art5.svelte';
  import M8Art6, { ETATS as E6 } from './M8Art6.svelte';

  let { bandeau = $bindable('Pratique dans R') } = $props();

  // n = l'étape du TP 1 (0 : pas encore une étape).
  const ETAPES = [
    { n: 0, titre: 'Blais et Gélineau (2007)', bandeau: 'Pratique dans R', etats: [{ vue: 'page', passages: [] }] },
    { n: 0, titre: 'Et si Blais et Gélineau remettaient votre TP 1 ?', bandeau: 'Leur TP 1', etats: [{ passages: [], focus: { page: 0, y: 12 } }] },
    { n: 1, titre: 'Une question claire', etats: E1, Carte: M8Art1 },
    { n: 2, titre: 'La littérature, comme à Risk', etats: E2, Carte: M8Art2 },
    { n: 3, titre: 'Des hypothèses tirées de la littérature', etats: E3, Carte: M8Art3 },
    { n: 4, titre: 'Les données et les variables', etats: E4, Carte: M8Art4 },
    { n: 5, titre: 'La pertinence : ok, donc ?', etats: E5, Carte: M8Art5 },
    { n: 6, titre: 'La contribution', etats: E6, Carte: M8Art6 }
  ];

  // Tous les temps, bout à bout; chacun sait à quelle étape il appartient.
  const QUI = ETAPES.flatMap((et, i) => et.etats.map((_, k) => ({ i, k })));
  const ETATS = ETAPES.flatMap((et) => et.etats);

  let e = $state(0);
  const ici = $derived(QUI[e]);
  const et = $derived(ETAPES[ici.i]);
  $effect(() => { bandeau = et.bandeau || `Leur TP 1 · étape ${et.n}`; });
</script>

<TmParcours ici={et.n} cache={ici.i === 0} />
<h2 class="e">{#key ici.i}<span in:fade={{ duration: 500, delay: 250 }}>{et.titre}</span>{/key}</h2>
<M8Article etats={ETATS} bind:e>
  {#snippet note(n)}
    {@const q = QUI[n]}
    {#if q.i === 0}
      <span class="m8f-eti">L’article</span>
      <p class="m8f-ref" lang="en">Blais, A., &amp; Gélineau, F. (2007). Winning, losing and satisfaction with democracy. <em>Political Studies</em>, <em>55</em>(2), 425–441. <span class="m8f-doi">https://doi.org/{BG.doi}</span></p>
    {:else if q.i === 1}
      <span class="m8f-eti">Votre TP 1</span>
      <p class="m8f-grand">Sept étapes. On cherche chacune dans leur texte.</p>
    {:else}
      {@const Carte = ETAPES[q.i].Carte}
      <Carte e={q.k} />
    {/if}
  {/snippet}
</M8Article>

<style>
  .m8f-eti { font-size: 0.62em; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 600; color: var(--dk-gris); }
  .m8f-ref { margin: 0; font-size: 0.95em; line-height: 1.45; }
  .m8f-doi { color: var(--dk-accent); overflow-wrap: anywhere; }
  .m8f-grand { margin: 0; font-size: 1.35em; font-weight: 700; line-height: 1.3; }
</style>
