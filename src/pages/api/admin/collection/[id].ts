import type { APIRoute } from 'astro';
import { createServerClient } from '../../../../lib/supabase-server';

export const PUT: APIRoute = async ({ params, request }) => {
  const { id } = params;
  const client = createServerClient();
  const body = await request.json();

  const { error } = await client.from('collections').update({
    name: body.name,
    slug: body.slug,
    description: body.description,
    image_url: body.image_url,
    image_alt: body.image_alt,
    sort_order: body.sort_order,
    status: body.status,
  }).eq('id', id);

  if (error) {
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      status: 500, headers: { 'Content-Type': 'application/json' },
    });
  }
  return new Response(JSON.stringify({ success: true }), {
    status: 200, headers: { 'Content-Type': 'application/json' },
  });
};

export const DELETE: APIRoute = async ({ params }) => {
  const { id } = params;
  const client = createServerClient();

  const { error } = await client.from('collections').delete().eq('id', id);

  if (error) {
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      status: 500, headers: { 'Content-Type': 'application/json' },
    });
  }
  return new Response(JSON.stringify({ success: true }), {
    status: 200, headers: { 'Content-Type': 'application/json' },
  });
};
