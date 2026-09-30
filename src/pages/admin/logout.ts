import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ cookies, redirect }) => {
  const allCookies = cookies.getAll();
  for (const cookie of allCookies) {
    if (cookie.name.startsWith('sb-')) {
      cookies.delete(cookie.name, { path: '/' });
    }
  }
  return redirect('/admin/login', 302);
};
