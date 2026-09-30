import { createPublicServerClient } from './supabase-server';
import type { SiteSettings, Page, PageSection, Collection, Product, Faq } from '../types';

export async function getSiteSettings(): Promise<SiteSettings | null> {
  const client = createPublicServerClient();
  const { data, error } = await client.from('site_settings').select('*').eq('id', 1).single();
  if (error) return null;
  return data as SiteSettings;
}

export async function getPageBySlug(slug: string): Promise<Page | null> {
  const client = createPublicServerClient();
  const { data, error } = await client.from('pages').select('*').eq('slug', slug).single();
  if (error || !data) return null;
  return data as Page;
}

export async function getAllPages(): Promise<Page[]> {
  const client = createPublicServerClient();
  const { data, error } = await client.from('pages').select('*').order('sort_order', { ascending: true });
  if (error || !data) return [];
  return data as Page[];
}

export async function getPageSections(pageSlug: string): Promise<PageSection[]> {
  const client = createPublicServerClient();
  const { data, error } = await client.from('page_sections').select('*').eq('page_slug', pageSlug).eq('status', 'published').eq('visible', true).order('sort_order', { ascending: true });
  if (error || !data) return [];
  return data as PageSection[];
}

export async function getCollections(): Promise<Collection[]> {
  const client = createPublicServerClient();
  const { data, error } = await client.from('collections').select('*').eq('status', 'published').order('sort_order', { ascending: true });
  if (error || !data) return [];
  return data as Collection[];
}

export async function getProducts(): Promise<Product[]> {
  const client = createPublicServerClient();
  const { data, error } = await client.from('products').select('*').eq('status', 'published').order('sort_order', { ascending: true });
  if (error || !data) return [];
  return data as Product[];
}

export async function getProductBySlug(slug: string): Promise<Product | null> {
  const client = createPublicServerClient();
  const { data, error } = await client.from('products').select('*').eq('slug', slug).eq('status', 'published').single();
  if (error || !data) return null;
  return data as Product;
}

export async function getFeaturedProducts(limit = 4): Promise<Product[]> {
  const client = createPublicServerClient();
  const { data, error } = await client.from('products').select('*').eq('status', 'published').eq('featured', true).order('sort_order', { ascending: true }).limit(limit);
  if (error || !data) return [];
  return data as Product[];
}

export async function getRelatedProducts(product: Product, limit = 4): Promise<Product[]> {
  const client = createPublicServerClient();
  const { data, error } = await client.from('products').select('*').eq('status', 'published').neq('id', product.id).or(`collection_type.eq.${product.collection_type},category.eq.${product.category}`).order('sort_order', { ascending: true }).limit(limit);
  if (error || !data) return [];
  return data as Product[];
}

export async function getFaqs(): Promise<Faq[]> {
  const client = createPublicServerClient();
  const { data, error } = await client.from('faqs').select('*').eq('status', 'published').order('sort_order', { ascending: true });
  if (error || !data) return [];
  return data as Faq[];
}

export async function createInquiry(inquiry: {
  name: string; email: string; company?: string; phone?: string; subject?: string;
  message: string; product_slug?: string; product_name?: string; inquiry_type?: string;
}): Promise<{ success: boolean; error?: string }> {
  const client = createPublicServerClient();
  const { error } = await client.from('inquiries').insert({
    name: inquiry.name, email: inquiry.email, company: inquiry.company || null,
    phone: inquiry.phone || null, subject: inquiry.subject || null, message: inquiry.message,
    product_slug: inquiry.product_slug || null, product_name: inquiry.product_name || null,
    inquiry_type: (inquiry.inquiry_type as any) || 'general',
  });
  if (error) return { success: false, error: error.message };
  return { success: true };
}
