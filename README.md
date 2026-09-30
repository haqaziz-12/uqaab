# UQAAB CARPET — Enterprise Website

**Handmade Afghan Carpets | Manufacturer & Exporter**
Uqaab Nawin Afghanistan Ltd. — Kabul, Afghanistan

## Architecture

- **Framework:** Astro (SSR mode)
- **Hosting:** Cloudflare Workers (Static Assets + SSR)
- **Database/Auth/Storage:** Supabase (PostgreSQL)
- **Admin Panel:** Full CMS dashboard at `/admin`
- **Styling:** Custom CSS design system (no external UI framework)

## Quick Start

### 1. Supabase Setup

1. Create a new Supabase project at https://supabase.com
2. Go to SQL Editor → New Query
3. Paste the entire contents of `supabase/schema.sql`
4. Click Run — creates all tables, RLS, storage buckets, 15 starter products
5. Go to Authentication → Users → Add User
6. Enter admin email + strong password → check Auto Confirm User
7. First user automatically gets admin role

### 2. Environment Variables (Cloudflare Dashboard)

Workers & Pages → your project → Settings → Variables & Secrets:

| Variable | Type | Description |
|---|---|---|
| PUBLIC_SITE_URL | Var | Production URL |
| SUPABASE_URL | Var | Supabase project URL |
| SUPABASE_ANON_KEY | Var | Supabase anon key |
| SUPABASE_SERVICE_ROLE_KEY | Secret | Server-only, never in frontend |

### 3. Deploy to Cloudflare

1. Push this repository to GitHub
2. Workers & Pages → Create → Connect Git
3. Select repository, framework auto-detected as Astro
4. Build command: npm run build, output: dist
5. Deploy

### 4. Admin Access

Navigate to /admin → login with Supabase credentials

## Important Notes

- All product data is placeholder — replace via admin panel
- WhatsApp number must be validated before launch
- Privacy Policy and Terms need legal review
- Company claims are company-provided and unverified
