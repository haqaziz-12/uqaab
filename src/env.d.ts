/// <reference path="../.astro/types.d.ts" />
/// <reference types="@cloudflare/workers-types" />

interface ImportMetaEnv {
  readonly PUBLIC_SITE_URL: string;
  readonly SUPABASE_URL: string;
  readonly SUPABASE_ANON_KEY: string;
  readonly SUPABASE_SERVICE_ROLE_KEY: string;
  readonly FORMSPREE_ENDPOINT?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}

declare namespace App {
  interface Locals {
    user: {
      id: string;
      email: string;
      aud?: string;
    } | null;
  }
}
