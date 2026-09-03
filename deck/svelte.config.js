import adapter from '@sveltejs/adapter-static';

export default {
  kit: {
    adapter: adapter({ fallback: null, strict: true }),
    // Chemins relatifs: condition pour qu'un deck compilé s'ouvre en file://
    // sur un portable sans réseau, devant une salle.
    paths: { relative: true }
  }
};
