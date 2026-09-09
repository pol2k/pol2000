// Detecte les diapos dont le contenu depasse la hauteur utile.
// Une diapo qui deborde est une diapo coupee au projecteur.
//
// Les figures pilotees au clic (brancherTemps) grandissent d'un temps a
// l'autre: une diapo qui tient a l'arrivee peut deborder au dernier temps.
// On avance donc chaque diapo au clavier jusqu'a ce que la touche fasse
// changer de diapo, en mesurant a chaque temps, et on garde le pire.
//
// Usage: CHROMIUM=/usr/sbin/chromium node outils/deborde.mjs <url> [largeur] [hauteur]
import { chromium } from '@playwright/test';

const [, , url, w = '1920', h = '1080'] = process.argv;
// CHROMIUM=/chemin/vers/chromium pour utiliser le navigateur du système plutôt que le téléchargement de Playwright.
const b = await chromium.launch(process.env.CHROMIUM ? { executablePath: process.env.CHROMIUM } : {});
const p = await b.newPage({ viewport: { width: Number(w), height: Number(h) } });
await p.goto(url, { waitUntil: 'networkidle' });
await p.waitForTimeout(600);

const MAX_TEMPS = 12;

const mesurer = (n) =>
  p.evaluate((n) => {
    const d = document.querySelectorAll('.diapo, .proto-deck > section')[n];
    // On compare les enfants du conteneur de contenu a sa boite de contenu.
    // scrollHeight ne suffit pas: .diapo-in centre ses enfants (flex,
    // justify-content: center), et ce qui depasse par le haut n'est pas
    // compte dans scrollHeight. Constate sur une diapo dont le titre
    // passait sous le bandeau alors que la mesure disait zero.
    const inner = d.querySelector('.diapo-in') ?? d.querySelector('.corps') ?? d;
    const r = inner.getBoundingClientRect();
    const cs = getComputedStyle(inner);
    const haut = r.top + parseFloat(cs.paddingTop);
    const bas = r.bottom - parseFloat(cs.paddingBottom);
    // Les enfants positionnes en absolu (bande d'identite en pied de titre)
    // ne participent pas au flux: on les ignore.
    const enfants = [...inner.children].filter((c) => !['absolute', 'fixed'].includes(getComputedStyle(c).position));
    const t = Math.min(...enfants.map((c) => c.getBoundingClientRect().top));
    const b = Math.max(...enfants.map((c) => c.getBoundingClientRect().bottom));
    const debord = enfants.length ? Math.round(Math.max(0, haut - t) + Math.max(0, b - bas)) : 0;
    const titre = d.querySelector('h1, h2')?.textContent.trim().slice(0, 46) ?? '(sans titre)';
    return { debord, titre };
  }, n);

const ouSuisJe = () =>
  p.evaluate(() => {
    const deck = document.querySelector('.deck, .proto-deck');
    return Math.round(deck.scrollTop / deck.clientHeight);
  });

const total = await p.evaluate(() => document.querySelectorAll('.diapo, .proto-deck > section').length);
const res = [];
for (let i = 0; i < total; i++) {
  await p.evaluate((n) => {
    const d = document.querySelector('.deck, .proto-deck');
    d.scrollTo({ top: n * d.clientHeight, behavior: 'instant' });
  }, i);
  await p.waitForTimeout(350);
  let pire = await mesurer(i);
  let temps = 0;
  for (let k = 0; k < MAX_TEMPS; k++) {
    await p.keyboard.press('ArrowRight');
    await p.waitForTimeout(320);
    if ((await ouSuisJe()) !== i) break;
    temps = k + 1;
    const m = await mesurer(i);
    if (m.debord > pire.debord) pire = m;
  }
  if (pire.debord > 0) res.push({ i, temps, ...pire });
}
await b.close();
console.log(`${res.length} diapo(s) débordent à ${w}x${h} :`);
for (const r of res) console.log(`  #${String(r.i).padStart(2)}  +${r.debord}px  ${r.titre}${r.temps ? ` · ${r.temps} temps` : ''}`);
process.exit(res.length ? 1 : 0);
