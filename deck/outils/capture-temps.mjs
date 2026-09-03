// Capture d'une diapo à un temps donné: on s'y rend, on avance de k temps au
// clavier, puis on photographie. Usage:
//   node outils/capture-temps.mjs <url> <dossier> <index> <k> [largeur] [hauteur]
import { chromium } from '@playwright/test';

const [, , url, out, idx, k, w = '1920', h = '1080'] = process.argv;
const b = await chromium.launch(process.env.CHROMIUM ? { executablePath: process.env.CHROMIUM } : {});
const p = await b.newPage({ viewport: { width: Number(w), height: Number(h) } });
await p.goto(url, { waitUntil: 'networkidle' });
await p.waitForTimeout(600);
await p.evaluate((n) => {
  const d = document.querySelector('.deck');
  d.scrollTo({ top: n * d.clientHeight, behavior: 'instant' });
}, Number(idx));
await p.waitForTimeout(700);
for (let i = 0; i < Number(k); i++) {
  await p.keyboard.press('ArrowRight');
  await p.waitForTimeout(250);
}
await p.waitForTimeout(1300);
await p.screenshot({ path: `${out}/t${w}x${h}-${idx}-k${k}.png` });
await b.close();
console.log(`capturé ${idx} au temps ${k}`);
