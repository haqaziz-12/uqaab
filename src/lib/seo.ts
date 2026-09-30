import type { Page, SiteSettings, Product } from '../types';

export interface SeoMeta { title: string; description: string; canonical: string; ogImage?: string; ogType?: string; structuredData?: object[]; }

export function buildSeo(page: Page | null, settings: SiteSettings | null, siteUrl: string, path: string, overrides?: Partial<SeoMeta>): SeoMeta {
  const canonical = `${siteUrl}${path}`;
  const title = overrides?.title || page?.seo_title || settings?.default_seo_title || 'UQAAB CARPET — Handmade Afghan Carpets';
  const description = overrides?.description || page?.seo_description || settings?.default_seo_description || 'Premium handmade Afghan carpets crafted by skilled artisans in Kabul.';
  const ogImage = overrides?.ogImage || page?.og_image || settings?.default_og_image || undefined;
  return { title, description, canonical, ogImage, ogType: overrides?.ogType || 'website', structuredData: overrides?.structuredData || [] };
}

export function buildProductSeo(product: Product, siteUrl: string, settings: SiteSettings | null): SeoMeta {
  const path = `/products/${product.slug}`;
  const title = product.seo_title || `${product.name} | Handmade Afghan Carpet | UQAAB CARPET`;
  const description = product.seo_description || `${product.name} — ${product.category || 'Handmade Afghan carpet'}. ${product.description || 'Crafted by skilled Afghan artisans.'} Price on enquiry.`;
  const structuredData = [{
    '@context': 'https://schema.org', '@type': 'Product', name: product.name, description,
    brand: { '@type': 'Brand', name: settings?.company_name || 'UQAAB CARPET' },
    image: product.image_front ? [product.image_front] : undefined,
    category: product.category || undefined, material: product.material || undefined,
    countryOfOrigin: product.country_origin || 'Afghanistan',
    offers: { '@type': 'Offer', priceCurrency: 'USD', availability: 'https://schema.org/PreOrder', description: 'Price on enquiry. Contact us for a quotation.' }
  }];
  return { title, description, canonical: `${siteUrl}${path}`, ogType: 'product', structuredData };
}

export function buildOrganizationSchema(settings: SiteSettings | null, siteUrl: string) {
  return { '@context': 'https://schema.org', '@type': 'Organization', name: settings?.company_name || 'UQAAB CARPET', legalName: settings?.legal_name || 'Uqaab Nawin Afghanistan Ltd.', url: siteUrl, email: settings?.email || 'uqaab.carpet@yahoo.com', foundingDate: String(settings?.founded_year || '2015'), address: { '@type': 'PostalAddress', streetAddress: settings?.address || '', addressCountry: 'AF' }, sameAs: [settings?.facebook_url].filter(Boolean) };
}

export function buildBreadcrumbSchema(items: { name: string; url: string }[]) {
  return { '@context': 'https://schema.org', '@type': 'BreadcrumbList', itemListElement: items.map((item, index) => ({ '@type': 'ListItem', position: index + 1, name: item.name, item: item.url })) };
}

export function buildFaqSchema(faqs: { question: string; answer: string }[]) {
  return { '@context': 'https://schema.org', '@type': 'FAQPage', mainEntity: faqs.map((faq) => ({ '@type': 'Question', name: faq.question, acceptedAnswer: { '@type': 'Answer', text: faq.answer } })) };
}
