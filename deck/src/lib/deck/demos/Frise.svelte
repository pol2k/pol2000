<script>
  import { base } from '$app/paths';
  import { REFERENCES } from '$lib/data/references.js';

  /**
   * Frise défilante de l'histoire de l'IA.
   *
   * Chaque repère est placé à sa DATE RÉELLE. L'échelle compte deux segments à
   * la MÊME graduation, séparés par une interruption déclarée: sans elle, la
   * frise traversait 39 ans vides entre 1958 et 1997, soit une vingtaine de
   * secondes d'écran vide. L'interruption est marquée et nommée, jamais masquée.
   *
   * Le défilement démarre à l'arrivée sur la diapositive et s'arrête à la fin.
   */
  const PX_PAR_AN = 115;
  const SEGMENTS = [
    { de: 1948, a: 1962 },
    { de: 1995, a: 2027 }
  ];
  const COUPURE = 300;

  const DEB_B = (SEGMENTS[0].a - SEGMENTS[0].de) * PX_PAR_AN + COUPURE;
  const LARGEUR = DEB_B + (SEGMENTS[1].a - SEGMENTS[1].de) * PX_PAR_AN;

  const pos = (an) =>
    an <= SEGMENTS[0].a
      ? (an - SEGMENTS[0].de) * PX_PAR_AN
      : DEB_B + (an - SEGMENTS[1].de) * PX_PAR_AN;

  const ENTREES = [
    { an: 1950, t: 'Le jeu de l’imitation', s: 'Turing', img: 'turing.jpg', p: 'turing1950' },
    { an: 1956, t: 'Le terme est forgé', s: 'Dartmouth', img: 'mccarthy.jpg', p: 'mccarthy1955' },
    { an: 1958, t: 'Le perceptron', s: 'Rosenblatt', img: 'perceptron.jpg' },
    { an: 1997, t: 'Deep Blue bat Kasparov', s: 'IBM', img: 'deepblue.jpg' },
    { an: 2003, t: 'Premier modèle de langue neuronal', s: 'Bengio · Montréal', img: 'bengio.jpg', p: 'bengio2003' },
    { an: 2009, t: 'ImageNet', s: 'Fei-Fei Li', img: 'feifei.jpg' },
    { an: 2012, t: 'AlexNet', s: 'Krizhevsky · Sutskever · Hinton', p: 'krizhevsky2012' },
    { an: 2014, t: 'Google achète DeepMind', s: '', img: 'deepmind.png', logo: true },
    { an: 2015, t: 'Le mécanisme d’attention', s: 'Bahdanau · Cho · Bengio', p: 'bahdanau2015' },
    { an: 2016, t: 'AlphaGo bat Lee Sedol', s: 'Hassabis', img: 'hassabis.jpg' },
    { an: 2017, t: 'Le transformer', s: 'Vaswani et al. · Google', p: 'vaswani2017' },
    { an: 2018, t: 'GPT-1', s: '', img: 'openai.png', logo: true },
    { an: 2019, t: 'GPT-2' },
    { an: 2020, t: 'GPT-3', s: '175 milliards de paramètres', p: 'brown2020' },
    { an: 2021, t: 'Anthropic est fondée', s: '', img: 'anthropic.png', logo: true },
    { an: 2022.92, t: 'ChatGPT', s: '30 novembre' },
    { an: 2023.2, t: 'GPT-4 et Claude', s: 'mars' },
    { an: 2024.77, t: 'Deux prix Nobel', s: 'Hinton · Hassabis', img: 'hinton.jpg' },
    { an: 2025.42, t: 'LawZero', s: 'Bengio · Montréal', img: 'bengio.jpg' }
  ];

  const DECENNIES = [1950, 1960, 2000, 2010, 2020];

  let piste = $state(null);
  let hote = $state(null);
  let js = $state(false);
  let etat = $state('arret'); // 'arret' | 'joue' | 'pause' | 'fini'


  $effect(() => {
    if (!hote || !piste) return;
    js = true;

    const deck = hote.closest('.deck');
    const diapo = hote.closest('.diapo');
    if (!deck || !diapo) return;

    // On lit la position du deck plutôt que de s'en remettre à un observateur
    // d'intersection: avec l'accrochage au défilement, celui-ci se déclenchait
    // dès le chargement et la frise était déjà au milieu à l'arrivée.
    const monIndex = [...deck.querySelectorAll('.diapo')].indexOf(diapo);
    let dernier = 0, af = 0;
    const VITESSE = 105; // px par seconde

    function pas(t) {
      if (etat !== 'joue') return;
      const dt = dernier ? Math.min((t - dernier) / 1000, 0.1) : 0;
      dernier = t;
      const max = piste.scrollWidth - piste.clientWidth;
      const suivant = piste.scrollLeft + VITESSE * dt;
      if (suivant >= max) {
        piste.scrollLeft = max;
        etat = 'fini';
        return;
      }
      piste.scrollLeft = suivant;
      af = requestAnimationFrame(pas);
    }

    function demarrer(depuisZero) {
      if (depuisZero) piste.scrollLeft = 0;
      dernier = 0;
      etat = 'joue';
      cancelAnimationFrame(af);
      af = requestAnimationFrame(pas);
    }

    function basculer() {
      if (etat === 'joue') { etat = 'pause'; cancelAnimationFrame(af); }
      else demarrer(etat === 'fini');
    }

    // Un clic n'importe où sur la diapositive commande le défilement. Un
    // glissement pour faire défiler la frise à la main ne déclenche pas de
    // clic, il ne bascule donc rien.
    diapo.addEventListener('click', basculer);

    let ici = false;
    function verifier() {
      const y = Math.round(deck.scrollTop / deck.clientHeight) === monIndex;
      if (y && !ici) { ici = true; demarrer(true); }
      else if (!y && ici) {
        ici = false; etat = 'arret'; cancelAnimationFrame(af); piste.scrollLeft = 0;
      }
    }

    deck.addEventListener('scroll', verifier, { passive: true });
    verifier();
    const t0 = setTimeout(verifier, 350); // après l'accrochage

    return () => {
      deck.removeEventListener('scroll', verifier);
      diapo.removeEventListener('click', basculer);
      clearTimeout(t0);
      cancelAnimationFrame(af);
      etat = 'arret';
    };
  });
</script>

<div class="frise" bind:this={hote}>
  <div class="piste" bind:this={piste}>
    <div class="rail" style="width: {LARGEUR}px">
      <div class="axe"></div>

      {#each DECENNIES as d}
        <div class="dec" style="left: {pos(d)}px"><span>{d}</span></div>
      {/each}

      <div class="coupure" style="left: {DEB_B - COUPURE}px; width: {COUPURE}px">
        <span class="coupure-txt">1962 à 1995</span>
      </div>

      {#each ENTREES as e, i}
        <div class="ent {i % 2 ? 'bas' : 'haut'}" style="left: {pos(e.an)}px">
          <div class="tige"></div>
          <div class="carte">
            {#if e.img}
              <img class:logo={e.logo} src="{base}/img/histoire/{e.img}" alt={e.s || e.t} />
            {/if}
            <p class="an">{Math.floor(e.an)}</p>
            <p class="t">{e.t}</p>
            {#if e.s}<p class="s">{e.s}</p>{/if}
            {#if e.p}<p class="pap">{REFERENCES[e.p].titre} <span class="ref">{REFERENCES[e.p].court}</span></p>{/if}
          </div>
        </div>
      {/each}
    </div>
  </div>

  {#if js}
    <p class="cmd">
      {etat === 'joue'
        ? 'cliquez pour mettre en pause'
        : etat === 'fini'
          ? 'cliquez pour rejouer'
          : 'cliquez pour reprendre'}
    </p>
  {/if}
</div>

<style>
  /* La frise a sa propre échelle: héritée de la diapo, elle était démesurée. */
  .frise {
    width: 100vw;
    margin-left: calc(50% - 50vw);
    position: relative;
    font-size: 0.58em;
  }

  .piste { overflow-x: auto; overflow-y: hidden; scrollbar-width: none; }
  .piste::-webkit-scrollbar { display: none; }

  .rail { position: relative; height: 30em; }

  .axe { position: absolute; left: 0; right: 0; top: 50%; height: 2px; background: var(--dk-encre); }

  .dec {
    position: absolute; top: 50%; transform: translate(-50%, 0.5em);
    font-family: var(--dk-mono); font-size: 0.66em;
    letter-spacing: 0.14em; color: var(--dk-gris);
  }
  .dec::before {
    content: ''; position: absolute; left: 50%; top: -0.75em;
    width: 1px; height: 0.55em; background: var(--dk-gris-2);
  }

  /* La rupture doit se voir: sans elle, la frise comprimerait 33 ans en
     silence et fausserait les distances. Elle affiche les années sautées
     plutôt qu'une étiquette technique. */
  .coupure {
    position: absolute; top: 0; bottom: 0;
    display: flex; align-items: center; justify-content: center;
    border-left: 2px dashed var(--dk-gris-2);
    border-right: 2px dashed var(--dk-gris-2);
  }
  .coupure-txt {
    font-family: var(--dk-mono); font-size: 0.58em;
    letter-spacing: 0.14em; text-transform: uppercase; color: var(--dk-gris);
    writing-mode: vertical-rl; text-orientation: mixed;
  }

  .ent { position: absolute; top: 50%; width: 8.2em; transform: translateX(-50%); }
  .ent .tige { position: absolute; left: 50%; width: 2px; background: var(--dk-accent); }
  .ent.haut { transform: translate(-50%, -100%); padding-bottom: 2.4em; }
  .ent.haut .tige { bottom: 0; height: 2.4em; }
  .ent.bas { padding-top: 2.4em; }
  .ent.bas .tige { top: 0; height: 2.4em; }

  .ent::after {
    content: ''; position: absolute; left: 50%; transform: translate(-50%, -50%);
    width: 0.42em; height: 0.42em; background: var(--dk-accent);
  }
  .ent.haut::after { bottom: -0.21em; top: auto; transform: translate(-50%, 50%); }
  .ent.bas::after { top: 0; }

  .carte { display: flex; flex-direction: column; gap: 0.12em; }
  .ent.haut .carte { justify-content: flex-end; }

  .carte img {
    width: 100%; height: 5em; object-fit: cover;
    object-position: center 28%;
    border: 2px solid var(--dk-encre);
    filter: grayscale(1) contrast(1.04);
    margin-bottom: 0.35em;
  }
  .carte img.logo {
    height: 2.8em; object-fit: contain; border: 0;
    filter: none; padding: 0.5em 0; align-self: flex-start;
  }

  .carte .an {
    font-family: var(--dk-mono); font-size: 1.15em; font-weight: 600;
    line-height: 1; color: var(--dk-accent); margin: 0;
  }
  .carte .t { font-size: 0.8em; line-height: 1.25; margin: 0; }
  .carte .s { font-size: 0.66em; line-height: 1.3; color: var(--dk-gris); margin: 0; }
  .carte .pap {
    /* Trois lignes au plus: le titre de Dartmouth débordait de sa carte. */
    display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical;
    overflow: hidden;
    font-size: 0.6em; line-height: 1.28; margin: 0.25em 0 0;
    color: var(--dk-encre); border-left: 2px solid var(--dk-accent);
    padding-left: 0.5em;
  }
  .carte .pap .ref { color: var(--dk-gris); white-space: nowrap; }

  /* Indication seulement: la commande est le clic sur la diapositive. */
  .cmd {
    position: absolute; right: 1.8em; bottom: -1.7em; margin: 0;
    font-family: var(--dk-mono); font-size: 0.58em;
    letter-spacing: 0.14em; text-transform: uppercase;
    color: var(--dk-gris-2); pointer-events: none;
  }
</style>
