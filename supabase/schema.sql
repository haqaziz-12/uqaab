-- UQAAB CARPET — Complete Supabase Database Schema (FIXED)
-- Paste this entire script into Supabase SQL Editor and Run.

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS site_settings (
    id INT PRIMARY KEY DEFAULT 1,
    company_name TEXT NOT NULL DEFAULT 'UQAAB CARPET',
    legal_name TEXT NOT NULL DEFAULT 'Uqaab Nawin Afghanistan Ltd.',
    tagline TEXT DEFAULT 'The Art of Afghan Weaving. Crafted for the World.',
    founded_year INT DEFAULT 2015,
    headquarters TEXT DEFAULT 'Kabul, Afghanistan',
    address TEXT DEFAULT 'House #3, Opposite to Ansar Hospital, Shahrak Pamir, Kotal Khair Khana, Kabul, Afghanistan',
    email TEXT DEFAULT 'uqaab.carpet@yahoo.com',
    whatsapp_number TEXT DEFAULT '+93 77 144 4555',
    whatsapp_link TEXT DEFAULT 'https://wa.me/93771444555',
    facebook_url TEXT DEFAULT 'https://www.facebook.com/share/1ZU2fMvYiZ/',
    google_maps_link TEXT DEFAULT 'https://maps.app.goo.gl/yErNn6pui4mbvPeE7',
    logo_url TEXT DEFAULT 'https://acmeg.org.af/wp-content/uploads/2024/12/newlogo-1-400x212.png',
    default_seo_title TEXT,
    default_seo_description TEXT,
    default_og_image TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE site_settings ADD CONSTRAINT site_settings_singleton CHECK (id = 1);
INSERT INTO site_settings (id) VALUES (1) ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS admin_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    full_name TEXT,
    role TEXT NOT NULL DEFAULT 'editor' CHECK (role IN ('admin', 'editor')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    page_type TEXT NOT NULL DEFAULT 'standard',
    status TEXT NOT NULL DEFAULT 'published' CHECK (status IN ('draft', 'published')),
    seo_title TEXT,
    seo_description TEXT,
    og_image TEXT,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS page_sections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    page_slug TEXT NOT NULL REFERENCES pages(slug) ON DELETE CASCADE,
    section_type TEXT NOT NULL,
    heading TEXT,
    subheading TEXT,
    body TEXT,
    image_url TEXT,
    image_alt TEXT,
    image_caption TEXT,
    link_label TEXT,
    link_url TEXT,
    content_json JSONB DEFAULT '{}'::jsonb,
    sort_order INT DEFAULT 0,
    visible BOOLEAN DEFAULT TRUE,
    status TEXT NOT NULL DEFAULT 'published' CHECK (status IN ('draft', 'published')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS collections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    image_alt TEXT,
    sort_order INT DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'published' CHECK (status IN ('draft', 'published')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id TEXT UNIQUE,
    slug TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    collection_type TEXT,
    category TEXT,
    size TEXT,
    quality TEXT,
    material TEXT,
    pile_type TEXT,
    description TEXT,
    country_origin TEXT DEFAULT 'Afghanistan',
    price_display TEXT NOT NULL DEFAULT 'Price on enquiry',
    image_front TEXT,
    image_back TEXT,
    image_closeup TEXT,
    image_front_alt TEXT,
    image_back_alt TEXT,
    image_closeup_alt TEXT,
    featured BOOLEAN DEFAULT FALSE,
    sort_order INT DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'published' CHECK (status IN ('draft', 'published')),
    seo_title TEXT,
    seo_description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS faqs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    sort_order INT DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'published' CHECK (status IN ('draft', 'published')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS inquiries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    company TEXT,
    phone TEXT,
    subject TEXT,
    message TEXT NOT NULL,
    product_slug TEXT,
    product_name TEXT,
    inquiry_type TEXT NOT NULL DEFAULT 'general' CHECK (inquiry_type IN ('general', 'wholesale', 'product', 'export')),
    status TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'read', 'responded', 'archived')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_page_sections_page_slug ON page_sections(page_slug);
CREATE INDEX IF NOT EXISTS idx_page_sections_sort ON page_sections(page_slug, sort_order);
CREATE INDEX IF NOT EXISTS idx_products_slug ON products(slug);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_collection ON products(collection_type);
CREATE INDEX IF NOT EXISTS idx_products_status ON products(status);
CREATE INDEX IF NOT EXISTS idx_products_featured ON products(featured);
CREATE INDEX IF NOT EXISTS idx_products_sort ON products(sort_order);
CREATE INDEX IF NOT EXISTS idx_collections_slug ON collections(slug);
CREATE INDEX IF NOT EXISTS idx_faqs_sort ON faqs(sort_order);
CREATE INDEX IF NOT EXISTS idx_inquiries_created ON inquiries(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_inquiries_status ON inquiries(status);

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_site_settings_updated BEFORE UPDATE ON site_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_admin_profiles_updated BEFORE UPDATE ON admin_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_pages_updated BEFORE UPDATE ON pages
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_page_sections_updated BEFORE UPDATE ON page_sections
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_collections_updated BEFORE UPDATE ON collections
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_products_updated BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER trg_faqs_updated BEFORE UPDATE ON faqs
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE page_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;
ALTER TABLE inquiries ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM admin_profiles
        WHERE id = auth.uid() AND role IN ('admin', 'editor')
    );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE POLICY "Public can read site settings"
    ON site_settings FOR SELECT TO anon, authenticated
    USING (TRUE);
CREATE POLICY "Admins can update site settings"
    ON site_settings FOR UPDATE TO authenticated
    WITH CHECK (is_admin());

CREATE POLICY "Admins can read all admin profiles"
    ON admin_profiles FOR SELECT TO authenticated
    USING (is_admin() OR id = auth.uid());
CREATE POLICY "Admins can insert admin profiles"
    ON admin_profiles FOR INSERT TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can update admin profiles"
    ON admin_profiles FOR UPDATE TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can delete admin profiles"
    ON admin_profiles FOR DELETE TO authenticated
    USING (is_admin());

CREATE POLICY "Public reads published pages"
    ON pages FOR SELECT TO anon, authenticated
    USING (status = 'published' OR is_admin());
CREATE POLICY "Admins can insert pages"
    ON pages FOR INSERT TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can update pages"
    ON pages FOR UPDATE TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can delete pages"
    ON pages FOR DELETE TO authenticated
    USING (is_admin());

CREATE POLICY "Public reads published visible sections"
    ON page_sections FOR SELECT TO anon, authenticated
    USING ((status = 'published' AND visible = TRUE) OR is_admin());
CREATE POLICY "Admins can insert page sections"
    ON page_sections FOR INSERT TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can update page sections"
    ON page_sections FOR UPDATE TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can delete page sections"
    ON page_sections FOR DELETE TO authenticated
    USING (is_admin());

CREATE POLICY "Public reads published collections"
    ON collections FOR SELECT TO anon, authenticated
    USING (status = 'published' OR is_admin());
CREATE POLICY "Admins can insert collections"
    ON collections FOR INSERT TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can update collections"
    ON collections FOR UPDATE TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can delete collections"
    ON collections FOR DELETE TO authenticated
    USING (is_admin());

CREATE POLICY "Public reads published products"
    ON products FOR SELECT TO anon, authenticated
    USING (status = 'published' OR is_admin());
CREATE POLICY "Admins can insert products"
    ON products FOR INSERT TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can update products"
    ON products FOR UPDATE TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can delete products"
    ON products FOR DELETE TO authenticated
    USING (is_admin());

CREATE POLICY "Public reads published faqs"
    ON faqs FOR SELECT TO anon, authenticated
    USING (status = 'published' OR is_admin());
CREATE POLICY "Admins can insert faqs"
    ON faqs FOR INSERT TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can update faqs"
    ON faqs FOR UPDATE TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can delete faqs"
    ON faqs FOR DELETE TO authenticated
    USING (is_admin());

CREATE POLICY "Public can submit inquiries"
    ON inquiries FOR INSERT TO anon, authenticated
    WITH CHECK (TRUE);
CREATE POLICY "Admins can read inquiries"
    ON inquiries FOR SELECT TO authenticated
    USING (is_admin());
CREATE POLICY "Admins can update inquiries"
    ON inquiries FOR UPDATE TO authenticated
    WITH CHECK (is_admin());
CREATE POLICY "Admins can delete inquiries"
    ON inquiries FOR DELETE TO authenticated
    USING (is_admin());

INSERT INTO storage.buckets (id, name, public)
VALUES ('media', 'media', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
VALUES ('product-images', 'product-images', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Public can read media"
    ON storage.objects FOR SELECT TO anon, authenticated
    USING (bucket_id = 'media');
CREATE POLICY "Admins can upload media"
    ON storage.objects FOR INSERT TO authenticated
    WITH CHECK (bucket_id = 'media' AND is_admin());
CREATE POLICY "Admins can update media"
    ON storage.objects FOR UPDATE TO authenticated
    WITH CHECK (bucket_id = 'media' AND is_admin());
CREATE POLICY "Admins can delete media"
    ON storage.objects FOR DELETE TO authenticated
    USING (bucket_id = 'media' AND is_admin());

CREATE POLICY "Public can read product images"
    ON storage.objects FOR SELECT TO anon, authenticated
    USING (bucket_id = 'product-images');
CREATE POLICY "Admins can upload product images"
    ON storage.objects FOR INSERT TO authenticated
    WITH CHECK (bucket_id = 'product-images' AND is_admin());
CREATE POLICY "Admins can update product images"
    ON storage.objects FOR UPDATE TO authenticated
    WITH CHECK (bucket_id = 'product-images' AND is_admin());
CREATE POLICY "Admins can delete product images"
    ON storage.objects FOR DELETE TO authenticated
    USING (bucket_id = 'product-images' AND is_admin());

INSERT INTO pages (slug, title, page_type, sort_order, seo_title, seo_description) VALUES
    ('home', 'Home', 'standard', 1, 'UQAAB CARPET — Handmade Afghan Carpets | Manufacturer & Exporter', 'Premium handmade Afghan carpets crafted by skilled artisans in Kabul. Manufacturing, wholesale, and international exports. Request a quotation.'),
    ('about', 'About Us', 'standard', 2, 'About UQAAB CARPET | Afghan Carpet Manufacturer Since 2015', 'Uqaab Nawin Afghanistan Ltd., founded in Kabul in 2015, produces handmade Afghan carpets combining traditional weaving with contemporary design for global markets.'),
    ('products', 'Our Products', 'products', 3, 'Our Carpets | Handmade Afghan Rug Catalog', 'Browse handmade Afghan carpets by collection, category, and origin. Each rug crafted by skilled Afghan artisans. Inquire for wholesale and export pricing.'),
    ('craft', 'Our Craft / Artisanship', 'standard', 4, 'Our Craft | Afghan Carpet Weaving Artisanship', 'Discover the traditional Afghan weaving techniques behind UQAAB CARPET — from hand-knotting to natural dyeing, preserving centuries of craft heritage.'),
    ('services', 'Services', 'standard', 5, 'Services | Carpet Manufacturing, Wholesale & Export', 'Handmade Afghan carpet manufacturing, wholesale supply, and international export services from UQAAB CARPET in Kabul.'),
    ('wholesale-exports', 'Wholesale & International Exports', 'standard', 6, 'Wholesale & International Carpet Exports | UQAAB CARPET', 'Wholesale handmade Afghan carpets and international export to the US, Europe, China, and UAE. Submit a trade inquiry for bulk pricing and custom orders.'),
    ('vision-mission', 'Our Vision & Mission', 'standard', 7, 'Vision & Mission | UQAAB CARPET', 'Our vision: to be a globally recognized leader in handcrafted Afghan carpets, preserving cultural heritage while inspiring appreciation for authentic craftsmanship.'),
    ('faq', 'FAQ', 'standard', 8, 'FAQ | UQAAB CARPET', 'Frequently asked questions about handmade Afghan carpets, wholesale ordering, international exports, and custom designs from UQAAB CARPET.'),
    ('contact', 'Contact Us', 'standard', 9, 'Contact Us | UQAAB CARPET', 'Contact UQAAB CARPET in Kabul, Afghanistan. Email, WhatsApp, and location. Request quotations for handmade Afghan carpets, wholesale, and export.'),
    ('privacy', 'Privacy Policy', 'legal', 90, 'Privacy Policy | UQAAB CARPET', 'Privacy policy for UQAAB CARPET website — how we handle your data and protect your privacy.'),
    ('terms', 'Terms & Conditions', 'legal', 91, 'Terms & Conditions | UQAAB CARPET', 'Terms and conditions for using the UQAAB CARPET website and services.')
ON CONFLICT (slug) DO NOTHING;

INSERT INTO page_sections (page_slug, section_type, heading, subheading, body, image_url, image_alt, link_label, link_url, sort_order, content_json) VALUES
    ('home', 'hero', 'The Art of Afghan Weaving. Crafted for the World.', 'Handmade carpets from Kabul — heritage techniques, contemporary design.', NULL, NULL, 'UQAAB CARPET hero banner', 'Explore Our Carpets', '/products', 1, '{}'::jsonb),
    ('home', 'text_block', 'A Tradition of Craftsmanship', 'Founded in Kabul in 2015', 'Uqaab Nawin Afghanistan Ltd. specializes in producing handmade Afghan carpets recognized for their artistry and craftsmanship. Our designs draw inspiration from Afghan culture and traditional weaving, combining heritage patterns with contemporary aesthetics.', NULL, NULL, 'Learn About Us', '/about', 2, '{}'::jsonb),
    ('home', 'stat_band', 'Our Reach', NULL, NULL, NULL, NULL, NULL, NULL, 3, '{"stats": [{"label": "Founded", "value": "2015"}, {"label": "Carpets Produced", "value": "10,000+ sqm"}, {"label": "Export Destinations", "value": "US, China, Europe, UAE"}]}'::jsonb),
    ('home', 'cta_band', 'Partner with UQAAB CARPET', 'Request a quotation for wholesale, export, or custom carpet inquiries.', NULL, NULL, NULL, 'Request a Quote', '/inquiry', 4, '{}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO page_sections (page_slug, section_type, heading, subheading, body, image_url, image_alt, link_label, link_url, sort_order, content_json) VALUES
    ('about', 'hero', 'About UQAAB CARPET', 'Handmade Afghan carpets from Kabul since 2015.', NULL, NULL, 'About page hero', NULL, NULL, 1, '{}'::jsonb),
    ('about', 'text_block', 'Our Story', NULL, 'Uqaab Nawin Afghanistan Ltd., founded in 2015 in Kabul, specializes in producing handmade Afghan carpets recognized for their artistry and craftsmanship. The company reports having manufactured more than 10,000 square meters of carpets. Its designs draw inspiration from Afghan culture and traditional weaving, combining heritage patterns with contemporary aesthetics.', NULL, NULL, NULL, NULL, 2, '{}'::jsonb),
    ('about', 'text_block', 'Global Reach', NULL, 'The company serves local and international markets and exports to destinations including the United States, China, Europe, and the United Arab Emirates. Its carpets are made by skilled artisans, with a focus on individuality, durability, craftsmanship, and preserving Afghan weaving traditions.', NULL, NULL, NULL, NULL, 3, '{}'::jsonb),
    ('about', 'text_block', 'Community Impact', NULL, 'The company aims to support local livelihoods and economic development through carpet production, while maintaining a commitment to responsible sourcing and sustainable development.', NULL, NULL, NULL, NULL, 4, '{}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO page_sections (page_slug, section_type, heading, subheading, body, image_url, image_alt, link_label, link_url, sort_order, content_json) VALUES
    ('craft', 'hero', 'Our Craft', 'Preserving centuries of Afghan weaving tradition.', NULL, NULL, 'Craft page hero', NULL, NULL, 1, '{}'::jsonb),
    ('craft', 'text_block', 'Weaving Heritage', NULL, 'Afghan carpet weaving is a centuries-old tradition. Each carpet is hand-knotted by skilled artisans who have inherited their craft through generations. The techniques, patterns, and materials reflect the rich cultural heritage of Afghanistan.', NULL, NULL, NULL, NULL, 2, '{}'::jsonb),
    ('craft', 'text_block', 'The Process', NULL, 'From design and material preparation to weaving, washing, and finishing, each carpet passes through multiple stages of meticulous handwork. Every knot is tied by hand, ensuring durability and individuality in every piece.', NULL, NULL, NULL, NULL, 3, '{}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO page_sections (page_slug, section_type, heading, subheading, body, image_url, image_alt, link_label, link_url, sort_order, content_json) VALUES
    ('services', 'hero', 'Our Services', 'Manufacturing, wholesale, and international export.', NULL, NULL, 'Services hero', NULL, NULL, 1, '{}'::jsonb),
    ('services', 'card_grid', 'What We Offer', NULL, NULL, NULL, NULL, NULL, NULL, 2, '{"cards": [{"title": "Manufacturing", "description": "Handmade carpet production using traditional Afghan weaving techniques."}, {"title": "Wholesale", "description": "Bulk supply for retailers and distributors seeking authentic Afghan carpets."}, {"title": "International Export", "description": "Exporting to the US, China, Europe, and the UAE."}]}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO page_sections (page_slug, section_type, heading, subheading, body, image_url, image_alt, link_label, link_url, sort_order, content_json) VALUES
    ('wholesale-exports', 'hero', 'Wholesale & International Exports', 'Partner with UQAAB CARPET for bulk and export orders.', NULL, NULL, 'Wholesale hero', NULL, NULL, 1, '{}'::jsonb),
    ('wholesale-exports', 'text_block', 'Wholesale Overview', NULL, 'We offer wholesale pricing for retailers, distributors, and trade buyers seeking authentic handmade Afghan carpets. Custom designs and bulk orders can be arranged. Contact us for pricing and availability.', NULL, NULL, 'Submit Trade Inquiry', '/inquiry', 2, '{}'::jsonb),
    ('wholesale-exports', 'text_block', 'Export Destinations', NULL, 'We export to the United States, China, Europe, and the United Arab Emirates. Specific shipping terms and lead times are confirmed per order.', NULL, NULL, NULL, NULL, 3, '{}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO page_sections (page_slug, section_type, heading, subheading, body, image_url, image_alt, link_label, link_url, sort_order, content_json) VALUES
    ('vision-mission', 'hero', 'Our Vision & Mission', 'Preserving heritage. Inspiring the world.', NULL, NULL, 'Vision hero', NULL, NULL, 1, '{}'::jsonb),
    ('vision-mission', 'text_block', 'Our Vision', NULL, 'To become a globally recognized leader in handcrafted Afghan carpets, preserving cultural heritage while inspiring appreciation for authentic craftsmanship and responsible Afghan weaving traditions.', NULL, NULL, NULL, NULL, 2, '{}'::jsonb),
    ('vision-mission', 'text_block', 'Our Mission', NULL, 'Excellence in craftsmanship and attention to detail. Preservation of traditional Afghan weaving techniques. International growth through culturally authentic, contemporary designs. Support for local livelihoods, responsible sourcing, and sustainable development. Exceptional customer service and reliable product experiences.', NULL, NULL, NULL, NULL, 3, '{}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO page_sections (page_slug, section_type, heading, subheading, body, image_url, image_alt, link_label, link_url, sort_order, content_json) VALUES
    ('contact', 'hero', 'Contact Us', 'Get in touch with UQAAB CARPET.', NULL, NULL, 'Contact hero', NULL, NULL, 1, '{}'::jsonb),
    ('contact', 'map_embed', 'Our Location', 'House #3, Opposite to Ansar Hospital, Shahrak Pamir, Kotal Khair Khana, Kabul, Afghanistan.', NULL, NULL, 'Map of Kabul location', NULL, NULL, 2, '{}'::jsonb),
    ('contact', 'form_embed', 'Send Us a Message', NULL, NULL, NULL, NULL, NULL, NULL, 3, '{}'::jsonb)
ON CONFLICT DO NOTHING;

INSERT INTO collections (slug, name, description, sort_order) VALUES
    ('heritage', 'Heritage Collection', 'Traditional Afghan patterns and motifs passed down through generations of weavers.', 1),
    ('contemporary', 'Contemporary Collection', 'Modern designs inspired by Afghan weaving traditions, suited for contemporary interiors.', 2),
    ('kilim', 'Kilim Collection', 'Flat-woven carpets featuring geometric patterns and bold colors.', 3)
ON CONFLICT (slug) DO NOTHING;

INSERT INTO faqs (question, answer, sort_order) VALUES
    ('What types of carpets does UQAAB CARPET produce?', 'We produce handmade Afghan carpets including hand-knotted rugs and flat-woven kilims, featuring both traditional and contemporary designs.', 1),
    ('Where are your carpets made?', 'All our carpets are handmade by skilled artisans in Kabul, Afghanistan.', 2),
    ('Do you offer wholesale pricing?', 'Yes, we offer wholesale pricing for retailers, distributors, and trade buyers. Please submit a wholesale inquiry for pricing details.', 3),
    ('Which countries do you export to?', 'We export to the United States, China, Europe, and the United Arab Emirates. Additional destinations may be available upon request.', 4),
    ('Can I request a custom design?', 'Yes, custom designs can be arranged. Please contact us with your requirements for a custom quotation.', 5),
    ('How do I place an order or request a quotation?', 'You can request a quotation through our website inquiry form, via WhatsApp, or by email. We will respond with pricing and availability.', 6),
    ('What are your carpet dimensions?', 'Carpet dimensions vary by product. Please refer to individual product listings or contact us for specific size requirements.', 7),
    ('How do I care for an Afghan carpet?', 'Regular vacuuming, rotation, and professional cleaning when needed will help preserve your carpet. Avoid direct sunlight and moisture.', 8),
    ('Do you ship internationally?', 'Yes, we offer international shipping. Shipping terms and costs are confirmed per order based on destination and quantity.', 9),
    ('How can I contact you?', 'You can reach us via email at uqaab.carpet@yahoo.com, via WhatsApp, or through the contact form on our website.', 10)
ON CONFLICT DO NOTHING;

INSERT INTO products (product_id, slug, name, collection_type, category, size, quality, material, pile_type, description, country_origin, price_display, sort_order, status) VALUES
    ('UC-001', 'heritage-burgundy-classic', 'Heritage Burgundy Classic', 'Heritage Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'A classic Afghan hand-knotted carpet featuring traditional burgundy tones and heritage motifs. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 1, 'published'),
    ('UC-002', 'heritage-ivory-medallion', 'Heritage Ivory Medallion', 'Heritage Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'An elegant hand-knotted carpet with an ivory field and central medallion design. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 2, 'published'),
    ('UC-003', 'heritage-charcoal-geometric', 'Heritage Charcoal Geometric', 'Heritage Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'A geometric-patterned hand-knotted carpet in deep charcoal tones. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 3, 'published'),
    ('UC-004', 'contemporary-minimal-wool', 'Contemporary Minimal Wool', 'Contemporary Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'A contemporary minimalist design in natural wool tones. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 4, 'published'),
    ('UC-005', 'contemporary-gold-accent', 'Contemporary Gold Accent', 'Contemporary Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'A modern carpet with subtle gold accent patterns on a warm neutral field. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 5, 'published'),
    ('UC-006', 'contemporary-abstract-burgundy', 'Contemporary Abstract Burgundy', 'Contemporary Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'An abstract contemporary design featuring burgundy and ivory contrasts. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 6, 'published'),
    ('UC-007', 'kilim-geometric-red', 'Kilim Geometric Red', 'Kilim Collection', 'Kilim', NULL, NULL, NULL, NULL, 'A flat-woven kilim with bold geometric patterns in red and ivory. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 7, 'published'),
    ('UC-008', 'kilim-striped-warm', 'Kilim Striped Warm', 'Kilim Collection', 'Kilim', NULL, NULL, NULL, NULL, 'A striped kilim in warm earth tones, lightweight and versatile. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 8, 'published'),
    ('UC-009', 'kilim-diamond-pattern', 'Kilim Diamond Pattern', 'Kilim Collection', 'Kilim', NULL, NULL, NULL, NULL, 'A flat-woven kilim featuring traditional diamond motifs. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 9, 'published'),
    ('UC-010', 'heritage-tribal-charcoal', 'Heritage Tribal Charcoal', 'Heritage Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'A tribal-inspired hand-knotted carpet in charcoal and muted gold. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 10, 'published'),
    ('UC-011', 'contemporary-ivory-line', 'Contemporary Ivory Line', 'Contemporary Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'A contemporary carpet with clean linear patterns on an ivory field. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 11, 'published'),
    ('UC-012', 'heritage-gold-border', 'Heritage Gold Border', 'Heritage Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'A traditional carpet with an ornate gold border and burgundy field. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 12, 'published'),
    ('UC-013', 'kilim-natural-wool', 'Kilim Natural Wool', 'Kilim Collection', 'Kilim', NULL, NULL, NULL, NULL, 'A natural wool kilim in earthy tones with subtle geometric details. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 13, 'published'),
    ('UC-014', 'contemporary-warm-tones', 'Contemporary Warm Tones', 'Contemporary Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'A contemporary carpet blending warm beige and burgundy tones. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 14, 'published'),
    ('UC-015', 'heritage-classic-ivory', 'Heritage Classic Ivory', 'Heritage Collection', 'Hand-Knotted', NULL, NULL, NULL, NULL, 'A classic hand-knotted carpet in ivory with traditional Afghan motifs. Placeholder entry — specifications to be confirmed.', 'Afghanistan', 'Price on enquiry', 15, 'published')
ON CONFLICT (slug) DO NOTHING;

CREATE OR REPLACE FUNCTION handle_new_admin_user()
RETURNS TRIGGER AS $$
DECLARE
    existing_count INT;
BEGIN
    SELECT COUNT(*) INTO existing_count FROM admin_profiles;
    INSERT INTO admin_profiles (id, email, role)
    VALUES (
        NEW.id,
        NEW.email,
        CASE WHEN existing_count = 0 THEN 'admin' ELSE 'editor' END
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_admin_user();

-- DONE
