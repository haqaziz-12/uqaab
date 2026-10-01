import type { APIRoute } from 'astro';
import { createServerClient } from '../../../../lib/supabase-server';

export const PUT: APIRoute = async ({ params, request }) => {
  const { id } = params;
  const client = createServerClient();
  const body = await request.json();

  const { error } = await client.from('faqs').update({
    question: body.question,
    answer: body.answer,
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

  const { error } = await client.from('faqs').delete().eq('id', id);

  if (error) {
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      status: 500, headers: { 'Content-Type': 'application/json' },
    });
  }
  return new Response(JSON.stringify({ success: true }), {
    status: 200, headers: { 'Content-Type': 'application/json' },
  });
};
