import type { APIRoute } from 'astro';
import { createServerClient } from '../../../lib/supabase-server';

export const POST: APIRoute = async ({ request }) => {
  const client = createServerClient();
  const body = await request.json();

  const { error } = await client.from('products').insert({
    product_id: body.product_id,
    slug: body.slug,
    name: body.name,
    collection_type: body.collection_type,
    category: body.category,
    size: body.size,
    quality: body.quality,
    material: body.material,
    pile_type: body.pile_type,
    description: body.description,
    country_origin: body.country_origin || 'Afghanistan',
    price_display: 'Price on enquiry',
    image_front: body.image_front,
    image_back: body.image_back,
    image_closeup: body.image_closeup,
    image_front_alt: body.image_front_alt,
    image_back_alt: body.image_back_alt,
    image_closeup_alt: body.image_closeup_alt,
    featured: body.featured || false,
    sort_order: body.sort_order || 0,
    status: body.status || 'published',
    seo_title: body.seo_title,
    seo_description: body.seo_description,
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
