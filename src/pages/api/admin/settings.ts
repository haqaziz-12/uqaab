import type { APIRoute } from 'astro';
import { createServerClient } from '../../../lib/supabase-server';

export const PUT: APIRoute = async ({ request }) => {
  const client = createServerClient();
  const body = await request.json();

  const { error } = await client.from('site_settings').update({
    company_name: body.company_name,
    legal_name: body.legal_name,
    tagline: body.tagline,
    founded_year: body.founded_year,
    headquarters: body.headquarters,
    address: body.address,
    email: body.email,
    whatsapp_number: body.whatsapp_number,
    whatsapp_link: body.whatsapp_link,
    facebook_url: body.facebook_url,
    google_maps_link: body.google_maps_link,
    logo_url: body.logo_url,
    default_seo_title: body.default_seo_title,
    default_seo_description: body.default_seo_description,
  }).eq('id', 1);

  if (error) {
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      status: 500, headers: { 'Content-Type': 'application/json' },
    });
  }
  return new Response(JSON.stringify({ success: true }), {
    status: 200, headers: { 'Content-Type': 'application/json' },
  });
};
