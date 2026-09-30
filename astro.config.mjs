import { defineConfig } from 'astro/config';
import cloudflare from '@astrojs/cloudflare';
import sitemap from '@astrojs/sitemap';
import preact from '@astrojs/preact';

export default defineConfig({
  output: 'server',
  adapter: cloudflare({
    platformProxy: { enabled: true },
  }),
  site: 'https://uqaabcarpet.com',
  integrations: [sitemap(), preact()],
  build: {
    inlineStylesheets: 'auto',
  },
  vite: {
    optimizeDeps: { exclude: ['@supabase/ssr'] },
  },
});
