export interface Database {
  public: {
    Tables: {
      site_settings: {
        Row: { id: number; company_name: string; legal_name: string; tagline: string | null; founded_year: number; headquarters: string | null; address: string | null; email: string | null; whatsapp_number: string | null; whatsapp_link: string | null; facebook_url: string | null; google_maps_link: string | null; logo_url: string | null; default_seo_title: string | null; default_seo_description: string | null; default_og_image: string | null; updated_at: string; };
        Insert: Partial<Database['public']['Tables']['site_settings']['Row']>;
        Update: Partial<Database['public']['Tables']['site_settings']['Row']>;
      };
      admin_profiles: {
        Row: { id: string; email: string; full_name: string | null; role: 'admin' | 'editor'; created_at: string; updated_at: string; };
        Insert: Partial<Database['public']['Tables']['admin_profiles']['Row']>;
        Update: Partial<Database['public']['Tables']['admin_profiles']['Row']>;
      };
      pages: {
        Row: { id: string; slug: string; title: string; page_type: string; status: 'draft' | 'published'; seo_title: string | null; seo_description: string | null; og_image: string | null; sort_order: number; created_at: string; updated_at: string; };
        Insert: Partial<Database['public']['Tables']['pages']['Row']>;
        Update: Partial<Database['public']['Tables']['pages']['Row']>;
      };
      page_sections: {
        Row: { id: string; page_slug: string; section_type: string; heading: string | null; subheading: string | null; body: string | null; image_url: string | null; image_alt: string | null; image_caption: string | null; link_label: string | null; link_url: string | null; content_json: Record<string, any>; sort_order: number; visible: boolean; status: 'draft' | 'published'; created_at: string; updated_at: string; };
        Insert: Partial<Database['public']['Tables']['page_sections']['Row']>;
        Update: Partial<Database['public']['Tables']['page_sections']['Row']>;
      };
      collections: {
        Row: { id: string; slug: string; name: string; description: string | null; image_url: string | null; image_alt: string | null; sort_order: number; status: 'draft' | 'published'; created_at: string; updated_at: string; };
        Insert: Partial<Database['public']['Tables']['collections']['Row']>;
        Update: Partial<Database['public']['Tables']['collections']['Row']>;
      };
      products: {
        Row: { id: string; product_id: string; slug: string; name: string; collection_type: string | null; category: string | null; size: string | null; quality: string | null; material: string | null; pile_type: string | null; description: string | null; country_origin: string; price_display: string; image_front: string | null; image_back: string | null; image_closeup: string | null; image_front_alt: string | null; image_back_alt: string | null; image_closeup_alt: string | null; featured: boolean; sort_order: number; status: 'draft' | 'published'; seo_title: string | null; seo_description: string | null; created_at: string; updated_at: string; };
        Insert: Partial<Database['public']['Tables']['products']['Row']>;
        Update: Partial<Database['public']['Tables']['products']['Row']>;
      };
      faqs: {
        Row: { id: string; question: string; answer: string; sort_order: number; status: 'draft' | 'published'; created_at: string; updated_at: string; };
        Insert: Partial<Database['public']['Tables']['faqs']['Row']>;
        Update: Partial<Database['public']['Tables']['faqs']['Row']>;
      };
      inquiries: {
        Row: { id: string; name: string; email: string; company: string | null; phone: string | null; subject: string | null; message: string; product_slug: string | null; product_name: string | null; inquiry_type: string; status: string; created_at: string; };
        Insert: Partial<Database['public']['Tables']['inquiries']['Row']>;
        Update: Partial<Database['public']['Tables']['inquiries']['Row']>;
      };
    };
  };
}
