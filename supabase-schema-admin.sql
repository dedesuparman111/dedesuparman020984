-- ================================================================
-- TAMBAHAN SCHEMA untuk Admin Portal Dede Separman
-- Jalankan di: Supabase Dashboard → SQL Editor → New Query
-- ================================================================

-- ── SITE CONFIG (Hero, Tentang, Branding) ──────────────────────
create table if not exists site_config (
  key   text primary key,
  value text
);

alter table site_config enable row level security;

create policy "Public read site_config"
  on site_config for select using (true);

create policy "Auth write site_config"
  on site_config for all
  using (auth.role() = 'authenticated');

-- ── SOCIALS (Link Sosial di Hero) ─────────────────────────────
create table if not exists socials (
  id         uuid primary key default gen_random_uuid(),
  label      text not null,
  icon       text,
  url        text not null,
  sort_order int  default 0
);

alter table socials enable row level security;

create policy "Public read socials"
  on socials for select using (true);

create policy "Auth write socials"
  on socials for all
  using (auth.role() = 'authenticated');

-- ── CONTOH DATA AWAL site_config ──────────────────────────────
insert into site_config (key, value) values
  ('hero_name',       'Dede Separman'),
  ('hero_tagline',    'Google Apps Script & Automation Specialist'),
  ('hero_desc',       'Terbiasa dengan Google Apps Script, AppSheet dan Excel untuk membuat solusi otomatis, aplikasi tanpa kode, dan olah data yang efisien.'),
  ('hero_cta_text',   'Lihat Portofolio'),
  ('hero_cta_link',   'pages/proyek.html'),
  ('hero_photo',      'assets/photo.png'),
  ('tentang_title',   'Tentang Saya'),
  ('tentang_bio1',    'Saya adalah freelancer dan developer berbasis di Bandung yang fokus pada otomatisasi proses bisnis menggunakan ekosistem Google.'),
  ('tentang_bio2',    'Dengan pengalaman bertahun-tahun, saya membantu bisnis kecil hingga menengah meningkatkan efisiensi kerja mereka.'),
  ('tentang_lokasi',  'Bandung, West Java'),
  ('tentang_year',    '2019'),
  ('tentang_projects','50'),
  ('brand_color',     '#E63946'),
  ('brand_name',      'Dede Separman')
on conflict (key) do nothing;

-- ── CONTOH DATA AWAL socials ───────────────────────────────────
insert into socials (label, icon, url, sort_order) values
  ('LinkedIn',  '💼', 'https://linkedin.com', 1),
  ('GitHub',    '🐙', 'https://github.com',   2),
  ('WhatsApp',  '📱', 'https://wa.me/62xxx',  3)
on conflict do nothing;

-- ── BUAT ADMIN USER DI SUPABASE AUTH ──────────────────────────
-- Lakukan ini via: Authentication → Users → Add User
-- Masukkan email & password admin Anda
-- JANGAN simpan password di SQL ini!

-- ── KEBIJAKAN TAMBAHAN UNTUK TABEL YANG SUDAH ADA ─────────────
-- Izinkan admin (authenticated) untuk menulis ke semua tabel

create policy if not exists "Auth write projects"
  on projects for all using (auth.role() = 'authenticated');

create policy if not exists "Auth write posts"
  on posts for all using (auth.role() = 'authenticated');

create policy if not exists "Auth write services"
  on services for all using (auth.role() = 'authenticated');

create policy if not exists "Auth write skills"
  on skills for all using (auth.role() = 'authenticated');

create policy if not exists "Auth write messages"
  on messages for all using (auth.role() = 'authenticated');
