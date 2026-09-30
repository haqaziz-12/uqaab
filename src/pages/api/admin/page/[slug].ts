import type { APIRoute } from 'astro';
import { createServerClient } from '../../../lib/supabase-server';

export const PUT: APIRoute = async ({ params, request }) => {
  const { slug } = params;
  const client = createServerClient();
  const body = await request.json();

  const { error } = await client.from('pages').update({
    title: body.title,
    seo_title: body.seo_title,
    seo_description: body.seo_description,
    status: body.status,
    sort_order: body.sort_order,
  }).eq('slug', slug);

  if (error) {
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      status: 500, headers: { 'Content-Type': 'application/json' },
    });
  }
  return new Response(JSON.stringify({ success: true }), {
    status: 200, headers: { 'Content-Type': 'application/json' },
  });
};
