import type { APIRoute } from 'astro';
import { createServerClient } from '../../../../lib/supabase-server';

export const PUT: APIRoute = async ({ params, request }) => {
  const { id } = params;
  const client = createServerClient();
  const body = await request.json();

  const { error } = await client.from('page_sections').update({
    section_type: body.section_type,
    heading: body.heading,
    subheading: body.subheading,
    body: body.body,
    image_url: body.image_url,
    image_alt: body.image_alt,
    image_caption: body.image_caption,
    link_label: body.link_label,
    link_url: body.link_url,
    content_json: body.content_json || {},
    sort_order: body.sort_order,
    visible: body.visible,
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

  const { error } = await client.from('page_sections').delete().eq('id', id);

  if (error) {
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      status: 500, headers: { 'Content-Type': 'application/json' },
    });
  }
  return new Response(JSON.stringify({ success: true }), {
    status: 200, headers: { 'Content-Type': 'application/json' },
  });
};
