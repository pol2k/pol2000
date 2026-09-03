// Capture des diapos pour vérifier la mise en page à une résolution donnée.
// Usage: node outils/capture.mjs <url> <dossier> <largeur> <hauteur> <index...>
import { chromium } from '@playwright/test';

const [, , url, out, w, h, ...idx] = process.argv;
// CHROMIUM=/chemin/vers/chromium pour utiliser le navigateur du système plutôt que le téléchargement de Playwright.
const b = await chromium.launch(process.env.CHROMIUM ? { executablePath: process.env.CHROMIUM } : {});
const p = await b.newPage({ viewport: { width: Number(w), height: Number(h) } });
await p.goto(url, { waitUntil: 'networkidle' });
await p.waitForTimeout(700);
for (const i of idx) {
  await p.evaluate((n) => {
    const d = document.querySelector('.deck, .proto-deck');
    d.scrollTo({ top: n * d.clientHeight, behavior: 'instant' });
  }, Number(i));
  await p.waitForTimeout(450);
  await p.screenshot({ path: `${out}/d${w}x${h}-${i}.png` });
}
await b.close();
console.log('captures faites');
