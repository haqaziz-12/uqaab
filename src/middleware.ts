import { defineMiddleware } from 'astro:middleware';
import { createClient } from '@supabase/supabase-js';

export const onRequest = defineMiddleware(async (context, next) => {
  const { pathname } = context.url;

  if (pathname.startsWith('/admin') && pathname !== '/admin/login') {
    const authCookie = context.cookies.get('sb-access-token')?.value;

    if (!authCookie) {
      return context.redirect('/admin/login');
    }

    const supabaseUrl = import.meta.env.SUPABASE_URL || (globalThis as any).SUPABASE_URL;
    const supabaseAnonKey = import.meta.env.SUPABASE_ANON_KEY || (globalThis as any).SUPABASE_ANON_KEY;

    if (supabaseUrl && supabaseAnonKey) {
      try {
        const client = createClient(supabaseUrl, supabaseAnonKey, {
          auth: { persistSession: false },
        });
        const { data, error } = await client.auth.getUser(authCookie);

        if (error || !data.user) {
          return context.redirect('/admin/login');
        }
        context.locals.user = data.user;
      } catch {
        return context.redirect('/admin/login');
      }
    } else {
      return context.redirect('/admin/login');
    }
  }

  return next();
});
