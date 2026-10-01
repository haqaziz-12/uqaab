import type { APIRoute } from 'astro';
import { createServerClient } from '../../../../lib/supabase-server';

export const POST: APIRoute = async ({ request }) => {
  const client = createServerClient();
  const body = await request.json();

  const { error } = await client.from('collections').insert({
    slug: body.slug,
    name: body.name,
    description: body.description,
    image_url: body.image_url,
    sort_order: body.sort_order || 0,
    status: body.status || 'published',
  });

  if (error) {
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      status: 500, headers: { 'Content-Type': 'application/json' },
    });
  }
  return new Response(JSON.stringify({ success: true }), {
    status: 200, headers: { 'Content-Type': 'application/json' },
  });
};
