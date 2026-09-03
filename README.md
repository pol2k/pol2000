# pol2000.com

Site du cours **POL-2000 — Méthodologie quantitative**, Université Laval,
Département de science politique. Automne 2026.

- Site : https://pol2000.com
- Plan de cours : https://pol2000.com/syllabus/
- Diapositives : https://pol2000.com/slides/

## Comment c'est fait

Le site et les diapositives sont un seul projet SvelteKit, dans `deck/`.
La construction est exportée à la racine du dépôt, que Cloudflare Pages
publie telle quelle, sans étape de construction.

```bash
cd deck
npm install          # une fois
npm run build        # → deck/build/
npm run exporter     # → index.html, syllabus/index.html, slides/, _app/, img/
```

Tout ce que le site affiche sur l'offre (séances, évaluations, équipe,
liens) vient de `deck/src/lib/data/cours.js`. Le plan de cours est écrit
une fois, dans `syllabus/plan-de-cours-A26.md`, et rendu à la construction.

Les consignes pour les agents sont dans `AGENTS.md`.
