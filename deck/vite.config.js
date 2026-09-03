import { sveltekit } from '@sveltejs/kit/vite';

export default {
  plugins: [sveltekit()],
  test: { include: ['tests/**/*.test.js'] }
};
