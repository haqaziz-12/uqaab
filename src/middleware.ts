import { defineMiddleware } from 'astro:middleware';

export const onRequest = defineMiddleware(async (context, next) => {
  const { pathname } = context.url;

  // Only protect /admin routes (but not /admin/login or /admin/logout)
  if (pathname.startsWith('/admin') && pathname !== '/admin/login' && pathname !== '/admin/logout') {
    // Check for Supabase auth cookie
    const allCookies = context.cookies.getAll();
    const hasAuthCookie = allCookies.some(c => c.name.startsWith('sb-') && c.name.includes('auth-token'));

    if (!hasAuthCookie) {
      return context.redirect('/admin/login');
    }

    // If we have a cookie, let the request through
    context.locals.user = { id: '', email: '', aud: '' };
  }

  return next();
});
