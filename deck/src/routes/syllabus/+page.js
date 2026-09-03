/**
 * The plan de cours is written once, in syllabus/plan-de-cours-A26.md, and
 * rendered here at build time. Headings get stable ids so the table of
 * contents and deep links work; the first h1 is dropped because the page
 * carries its own masthead.
 */
import { marked } from 'marked';
import source from '../../../../syllabus/plan-de-cours-A26.md?raw';

export const prerender = true;

const slug = (t) =>
  t
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');

export function load() {
  const toc = [];
  const renderer = {
    heading({ tokens, depth }) {
      const html = this.parser.parseInline(tokens);
      const brut = tokens.map((t) => t.raw).join('');
      const id = slug(brut);
      if (depth === 2) toc.push({ id, text: brut });
      return `<h${depth} id="${id}">${html}</h${depth}>\n`;
    }
  };
  marked.use({ renderer, gfm: true });
  // The page carries its own masthead: everything before the first section
  // (title, subtitle, institution line) is dropped.
  const corps = source.slice(source.indexOf('\n## '));
  const html = marked.parse(corps);
  return { html, toc };
}
