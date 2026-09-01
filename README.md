# POL-2000 — Méthodologie quantitative

Site du cours **POL-2000 : Méthodologie quantitative**, Université Laval,
Département de science politique.

- **Site public :** <https://pol2000.com>
- **Session :** automne 2026 — jeudis 15h30 à 18h20, en présentiel
- **Enseignant :** Laurence-Olivier M. Foisy — <mail@mfoisy.com>

## Contenu du dépôt

| Chemin | Rôle |
|---|---|
| `index.html` | Page d'accueil. Le calendrier, les évaluations et la grille des diapositives sont injectés à l'exécution. |
| `course_config.json` | Source des données du site : calendrier, évaluations, diapositives, rencontres. **Modifier ce fichier plutôt que le HTML.** |
| `assets/js/course_logic.js` | Lit `course_config.json` et construit le DOM. |
| `syllabus/` | Plan de cours : page web, source Markdown, PDF et sources LaTeX. |
| `docs/plan-de-cours.md` | Référence de contenu pour le travail sur le dépôt. |
| `reference/` | Plan de cours officiel de l'offre précédente (H24). |
| `slides/` | Diapositives Quarto/reveal.js. |

## Développement

Le site est statique. `course_config.json` est chargé par requête HTTP, donc
ouvrir `index.html` directement depuis le disque ne fonctionne pas :

```bash
python3 -m http.server 8000   # puis http://localhost:8000
```

Reconstruire le PDF du plan de cours :

```bash
./syllabus/pdf/build.sh
```

## Déploiement

Hébergé sur **Cloudflare Pages**, connecté à ce dépôt GitHub. Toute poussée sur
`main` déclenche une reconstruction et publie immédiatement sur pol2000.com. Il
n'y a aucun environnement de préproduction.

Voir `AGENTS.md` pour les conventions de travail dans ce dépôt.

## Crédits

Le gabarit visuel est **Prologue** par [HTML5 UP](https://html5up.net)
(@ajlkn), utilisé sous licence [CC BY 3.0](http://creativecommons.org/licenses/by/3.0/).
Voir `README.txt` et `LICENSE.txt`.
