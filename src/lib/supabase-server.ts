import { createClient } from '@supabase/supabase-js';
import type { Database } from './db-types';

function getEnv(key: string): string {
  const value = (typeof process !== 'undefined' && process.env?.[key]) || (typeof globalThis !== 'undefined' && (globalThis as any)[key]) || '';
  return value;
}

export function getSupabaseUrl(): string { return getEnv('SUPABASE_URL'); }
export function getSupabaseServiceKey(): string { return getEnv('SUPABASE_SERVICE_ROLE_KEY'); }
export function getSupabaseAnonKey(): string { return getEnv('SUPABASE_ANON_KEY'); }

export function createServerClient() {
  const url = getSupabaseUrl();
  const key = getSupabaseServiceKey();
  if (!url || !key) {
    throw new Error('Supabase server client requires SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY. Set these in .env or Cloudflare dashboard.');
  }
  return createClient<Database>(url, key, { auth: { persistSession: false } });
}

export function createPublicServerClient() {
  const url = getSupabaseUrl();
  const key = getSupabaseAnonKey();
  if (!url || !key) {
    throw new Error('Supabase public client requires SUPABASE_URL and SUPABASE_ANON_KEY.');
  }
  return createClient<Database>(url, key, { auth: { persistSession: false } });
}
