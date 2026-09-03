<script>
  /**
   * Datacamp: le logo (récupéré à la source, jamais redessiné), une fenêtre
   * d'exercice telle qu'on la voit — consigne à gauche, éditeur à droite —
   * et le curseur qui tape la réponse. L'accès est gratuit pour le cours.
   * « [1] 49.72 » est la vraie moyenne de cps25_age_in_years (ces_inspect.R).
   */
  import { base } from '$app/paths';
  const LIGNES = ['# Calculez la moyenne de l\'âge', 'mean(ces$age)'];
  let tape = $state('');
  let i = 0;
  $effect(() => {
    const txt = LIGNES[1];
    const id = setInterval(() => {
      i = (i + 1) % (txt.length + 14);
      tape = txt.slice(0, Math.min(i, txt.length));
    }, 140);
    return () => clearInterval(id);
  });
</script>

<div class="visuel dc">
  <div class="entete">
    <img src="{base}/img/datacamp.png" alt="Datacamp" class="logo" />
    <div>
      <strong>Un exercice par semaine, chez vous.</strong>
      <span>Gratuit pour le cours. Corrigé sur-le-champ. 10 % de la note.</span>
    </div>
  </div>
  <div class="fenetre">
    <div class="barre"><i></i><i></i><i></i><span>Introduction à R · Exercice 3 de 12</span></div>
    <div class="corps">
      <div class="consigne">
        <h4>Consigne</h4>
        <p>Le vecteur <code>ces$age</code> contient l'âge de chaque répondant.e. Calculez la moyenne.</p>
        <ul><li>Utilisez la fonction <code>mean()</code>.</li><li>Appuyez sur <em>Soumettre</em>.</li></ul>
      </div>
      <div class="editeur">
        <div class="script">
          <span class="com">{LIGNES[0]}</span>
          <span class="code">{tape}<b class="curseur">▍</b></span>
        </div>
        <div class="console">
          <span class="prompt">&gt; </span><span class="sortie">{tape === LIGNES[1] ? '[1] 49.72' : ''}</span>
        </div>
        <div class="actions"><span class="btn ghost">Exécuter</span><span class="btn">Soumettre la réponse</span></div>
      </div>
    </div>
  </div>
  <div class="semaines">
    {#each Array.from({ length: 14 }) as _, k}<i class:jalon={k === 7 || k === 13}></i>{/each}
    <span class="j1">dim. 25 oct. · 5 %</span><span class="j2">ven. 18 déc. · 5 %</span>
  </div>
</div>

<style>
  .dc { display: flex; flex-direction: column; gap: 0.8em; }
  .entete { display: flex; align-items: center; gap: 1em; }
  .logo { height: 3.2em; width: 3.2em; border: 2px solid var(--dk-encre); }
  .entete strong { display: block; font-size: 1.15em; }
  .entete span { font-size: 0.8em; color: var(--dk-gris); }
  .fenetre { border: 3px solid var(--dk-encre); background: var(--dk-fond); }
  .barre { display: flex; align-items: center; gap: 0.4em; background: var(--dk-encre); color: var(--dk-fond); padding: 0.35em 0.7em; font-size: 0.7em; }
  .barre i { width: 0.7em; height: 0.7em; border-radius: 50%; background: var(--dk-fond); opacity: 0.85; }
  .barre span { margin-left: 0.8em; letter-spacing: 0.06em; }
  .corps { display: grid; grid-template-columns: 1fr 1.4fr; }
  .consigne { padding: 0.8em 1em; border-right: 3px solid var(--dk-encre); font-size: 0.78em; }
  .consigne h4 { margin: 0 0 0.4em; font-size: 0.85em; letter-spacing: 0.14em; text-transform: uppercase; color: var(--dk-gris); }
  .consigne p, .consigne li { margin: 0 0 0.4em; line-height: 1.45; }
  .consigne ul { padding-left: 1.2em; margin: 0; }
  .editeur { display: flex; flex-direction: column; }
  .script { flex: 1; padding: 0.8em 1em; font-family: var(--dk-mono); font-size: 0.85em; display: flex; flex-direction: column; gap: 0.3em; min-height: 5.5em; }
  .com { color: var(--dk-gris); }
  .code { color: var(--dk-encre); font-weight: 600; }
  .curseur { animation: clignote 1s steps(1) infinite; color: var(--dk-accent); font-weight: 400; }
  @keyframes clignote { 50% { opacity: 0; } }
  .console { background: var(--dk-encre); color: var(--dk-fond); font-family: var(--dk-mono); font-size: 0.8em; padding: 0.5em 1em; min-height: 2em; }
  .prompt { color: var(--dk-accent-clair); }
  .actions { display: flex; justify-content: flex-end; gap: 0.5em; padding: 0.5em 0.8em; border-top: 2px solid var(--dk-filet); }
  .btn { font-size: 0.68em; letter-spacing: 0.08em; padding: 0.4em 0.9em; background: var(--dk-accent); color: var(--dk-fond); font-weight: 600; }
  .btn.ghost { background: transparent; color: var(--dk-encre); border: 2px solid var(--dk-encre); }
  .semaines { position: relative; display: flex; gap: 0.3em; padding-bottom: 1.4em; }
  .semaines i { flex: 1; height: 0.9em; background: var(--dk-gris-2); }
  .semaines i.jalon { background: var(--dk-accent); }
  .semaines span { position: absolute; top: 1.2em; font-size: 0.62em; color: var(--dk-accent); font-weight: 600; }
  .j1 { left: 50%; transform: translateX(-50%); } .j2 { right: 0; }
</style>
