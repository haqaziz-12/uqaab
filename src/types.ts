export interface SiteSettings {
  id: number;
  company_name: string;
  legal_name: string;
  tagline: string;
  founded_year: number;
  headquarters: string;
  address: string;
  email: string;
  whatsapp_number: string;
  whatsapp_link: string;
  facebook_url: string;
  google_maps_link: string;
  logo_url: string;
  default_seo_title: string | null;
  default_seo_description: string | null;
  default_og_image: string | null;
  updated_at: string;
}

export interface AdminProfile {
  id: string;
  email: string;
  full_name: string | null;
  role: 'admin' | 'editor';
  created_at: string;
  updated_at: string;
}

export interface Page {
  id: string;
  slug: string;
  title: string;
  page_type: 'standard' | 'products' | 'product_detail' | 'legal' | '404';
  status: 'draft' | 'published';
  seo_title: string | null;
  seo_description: string | null;
  og_image: string | null;
  sort_order: number;
  created_at: string;
  updated_at: string;
}

export interface PageSection {
  id: string;
  page_slug: string;
  section_type: SectionType;
  heading: string | null;
  subheading: string | null;
  body: string | null;
  image_url: string | null;
  image_alt: string | null;
  image_caption: string | null;
  link_label: string | null;
  link_url: string | null;
  content_json: Record<string, any>;
  sort_order: number;
  visible: boolean;
  status: 'draft' | 'published';
  created_at: string;
  updated_at: string;
}

export type SectionType =
  | 'hero' | 'text_block' | 'image_text' | 'card_grid' | 'cta_band'
  | 'stat_band' | 'faq_list' | 'map_embed' | 'form_embed' | 'export_reach';

export interface Collection {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  image_url: string | null;
  image_alt: string | null;
  sort_order: number;
  status: 'draft' | 'published';
  created_at: string;
  updated_at: string;
}

export interface Product {
  id: string;
  product_id: string;
  slug: string;
  name: string;
  collection_type: string | null;
  category: string | null;
  size: string | null;
  quality: string | null;
  material: string | null;
  pile_type: string | null;
  description: string | null;
  country_origin: string;
  price_display: string;
  image_front: string | null;
  image_back: string | null;
  image_closeup: string | null;
  image_front_alt: string | null;
  image_back_alt: string | null;
  image_closeup_alt: string | null;
  featured: boolean;
  sort_order: number;
  status: 'draft' | 'published';
  seo_title: string | null;
  seo_description: string | null;
  created_at: string;
  updated_at: string;
}

export interface Faq {
  id: string;
  question: string;
  answer: string;
  sort_order: number;
  status: 'draft' | 'published';
  created_at: string;
  updated_at: string;
}

export interface Inquiry {
  id: string;
  name: string;
  email: string;
  company: string | null;
  phone: string | null;
  subject: string | null;
  message: string;
  product_slug: string | null;
  product_name: string | null;
  inquiry_type: 'general' | 'wholesale' | 'product' | 'export';
  status: 'new' | 'read' | 'responded' | 'archived';
  created_at: string;
}

export interface StatItem { label: string; value: string; }
export interface CardItem { title: string; description: string; link_label?: string; link_url?: string; }
