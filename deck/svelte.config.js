import adapter from '@sveltejs/adapter-static';

export default {
  kit: {
    adapter: adapter({ fallback: null, strict: true }),
    // Chemins relatifs: condition pour qu'un deck compilé s'ouvre en file://
    // sur un portable sans réseau, devant une salle.
    paths: { relative: true },
    prerender: {
      // Le PDF du plan de cours vit dans syllabus/ à la racine du dépôt, pas
      // dans le build: le crawler ne peut pas le voir, mais Cloudflare le sert.
      handleHttpError: ({ path, message }) => {
        if (path.endsWith('.pdf')) return;
        throw new Error(message);
      }
    }
  }
};
