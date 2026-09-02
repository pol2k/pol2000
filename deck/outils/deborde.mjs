// Detecte les diapos dont le contenu depasse la hauteur utile.
// Une diapo qui deborde est une diapo coupee au projecteur.
import { chromium } from '@playwright/test';

const [, , url, w = '1920', h = '1080'] = process.argv;
// CHROMIUM=/chemin/vers/chromium pour utiliser le navigateur du système plutôt que le téléchargement de Playwright.
const b = await chromium.launch(process.env.CHROMIUM ? { executablePath: process.env.CHROMIUM } : {});
const p = await b.newPage({ viewport: { width: Number(w), height: Number(h) } });
await p.goto(url, { waitUntil: 'networkidle' });
await p.waitForTimeout(600);
const res = await p.evaluate(() =>
  [...document.querySelectorAll('.diapo, .proto-deck > section')]
    .map((d, i) => {
      // On mesure le conteneur de contenu contre lui-meme: s'il defile,
      // c'est qu'il deborde. Independant du placement des marges et de
      // la presence d'un bandeau.
      const inner = d.querySelector('.diapo-in') ?? d.querySelector('.corps') ?? d;
      const debord =
        inner === d
          ? Math.round(
              [...d.children].reduce((a, c) => a + c.getBoundingClientRect().height, 0) -
                d.clientHeight
            )
          : Math.round(inner.scrollHeight - inner.clientHeight);
      const titre = d.querySelector('h1, h2')?.textContent.trim().slice(0, 46) ?? '(sans titre)';
      return { i, debord, titre };
    })
    .filter((x) => x.debord > 0)
);
await b.close();
console.log(`${res.length} diapo(s) débordent à ${w}x${h} :`);
for (const r of res) console.log(`  #${String(r.i).padStart(2)}  +${r.debord}px  ${r.titre}`);
process.exit(res.length ? 1 : 0);
