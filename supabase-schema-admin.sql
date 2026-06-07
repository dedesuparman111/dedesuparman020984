-- ================================================================
-- DEDE SEPARMAN PORTFOLIO — Supabase Full Schema
-- Jalankan di: Supabase Dashboard → SQL Editor → New Query
-- ================================================================


-- ══════════════════════════════════════════════════════════════
--  1. TABEL UTAMA
-- ══════════════════════════════════════════════════════════════

-- ── PROJECTS ──────────────────────────────────────────────────
create table if not exists projects (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  summary     text,
  description text,
  tag         text,
  emoji       text,
  image_url   text,
  url         text,
  sort_order  int  default 0,
  created_at  timestamptz default now()
);

alter table projects enable row level security;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='projects' and policyname='Public read projects') then
    create policy "Public read projects" on projects for select using (true);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='projects' and policyname='Auth write projects') then
    create policy "Auth write projects" on projects for all using (auth.role() = 'authenticated');
  end if;
end $$;


-- ── POSTS (Blog) ───────────────────────────────────────────────
create table if not exists posts (
  id           uuid primary key default gen_random_uuid(),
  title        text not null,
  slug         text unique not null,
  excerpt      text,
  content      text,
  cover_emoji  text,
  cover_color  text default '#F7F8FA',
  read_time    int  default 5,
  published    boolean default false,
  published_at timestamptz,
  created_at   timestamptz default now()
);

alter table posts enable row level security;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='posts' and policyname='Public read published posts') then
    create policy "Public read published posts" on posts for select using (published = true);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='posts' and policyname='Auth write posts') then
    create policy "Auth write posts" on posts for all using (auth.role() = 'authenticated');
  end if;
end $$;


-- ── MESSAGES (Kontak) ─────────────────────────────────────────
create table if not exists messages (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  email      text not null,
  subject    text,
  message    text not null,
  read       boolean default false,
  created_at timestamptz default now()
);

alter table messages enable row level security;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='messages' and policyname='Anyone can send message') then
    create policy "Anyone can send message" on messages for insert with check (true);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='messages' and policyname='Auth read messages') then
    create policy "Auth read messages" on messages for select using (auth.role() = 'authenticated');
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='messages' and policyname='Auth write messages') then
    create policy "Auth write messages" on messages for all using (auth.role() = 'authenticated');
  end if;
end $$;


-- ── SERVICES (Layanan) ────────────────────────────────────────
create table if not exists services (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  description text,
  icon        text,
  price_label text,
  features    text[],
  sort_order  int  default 0
);

alter table services enable row level security;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='services' and policyname='Public read services') then
    create policy "Public read services" on services for select using (true);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='services' and policyname='Auth write services') then
    create policy "Auth write services" on services for all using (auth.role() = 'authenticated');
  end if;
end $$;


-- ── SKILLS ────────────────────────────────────────────────────
create table if not exists skills (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  category    text,
  icon        text,
  level       int  default 80,
  sort_order  int  default 0
);

alter table skills enable row level security;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='skills' and policyname='Public read skills') then
    create policy "Public read skills" on skills for select using (true);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='skills' and policyname='Auth write skills') then
    create policy "Auth write skills" on skills for all using (auth.role() = 'authenticated');
  end if;
end $$;


-- ── SITE CONFIG (Hero, Tentang, Branding) ─────────────────────
create table if not exists site_config (
  key   text primary key,
  value text
);

alter table site_config enable row level security;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='site_config' and policyname='Public read site_config') then
    create policy "Public read site_config" on site_config for select using (true);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='site_config' and policyname='Auth write site_config') then
    create policy "Auth write site_config" on site_config for all using (auth.role() = 'authenticated');
  end if;
end $$;


-- ── SOCIALS (Link Sosial Hero) ────────────────────────────────
create table if not exists socials (
  id         uuid primary key default gen_random_uuid(),
  label      text not null,
  icon       text,
  url        text not null,
  sort_order int  default 0
);

alter table socials enable row level security;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='socials' and policyname='Public read socials') then
    create policy "Public read socials" on socials for select using (true);
  end if;
end $$;

do $$ begin
  if not exists (select 1 from pg_policies where tablename='socials' and policyname='Auth write socials') then
    create policy "Auth write socials" on socials for all using (auth.role() = 'authenticated');
  end if;
end $$;


-- ══════════════════════════════════════════════════════════════
--  2. DATA AWAL (SAMPLE)
-- ══════════════════════════════════════════════════════════════

-- ── Projects ──────────────────────────────────────────────────
insert into projects (title, summary, tag, emoji, sort_order) values
  ('Sistem Absensi Otomatis',    'Otomatisasi absensi karyawan via Google Forms & Sheets + email notifikasi.', 'Google Apps Script', '📋', 1),
  ('Aplikasi Inventaris Gudang', 'App mobile AppSheet untuk manajemen stok real-time.',                         'AppSheet',           '📦', 2),
  ('Dashboard Keuangan Bulanan', 'Laporan otomatis dengan Power Query, Pivot Table & grafik dinamis.',          'Excel',              '📈', 3),
  ('Portal Digital CKBLogistic', 'HUB internal untuk data logistik, resi, dan kurir berbasis GAS Web App.',    'Web App',            '🌐', 4),
  ('Email Blast Personalisasi',  'Kirim ratusan email personalisasi otomatis via Gmail + Google Sheets.',       'Google Apps Script', '📧', 5),
  ('Sistem Pengajuan Cuti',      'Alur approval cuti karyawan tanpa kode menggunakan AppSheet + Sheets.',       'AppSheet',           '📱', 6)
on conflict do nothing;

-- ── Services ──────────────────────────────────────────────────
insert into services (title, description, icon, price_label, features, sort_order) values
  ('Google Apps Script', 'Otomatisasi penuh proses bisnis Anda dengan skrip custom.', '⚡', 'Mulai Rp 300rb',
   ARRAY['Integrasi Google Workspace','Trigger & Scheduler','Custom Add-on','API Integration'], 1),
  ('AppSheet No-Code App', 'Bangun aplikasi mobile/web tanpa coding berbasis Sheets atau DB.', '📱', 'Mulai Rp 500rb',
   ARRAY['Formulir dinamis','Notifikasi push','Offline support','Role-based access'], 2),
  ('Excel & Data Processing', 'Otomatisasi laporan, dashboard, dan olah data kompleks.', '📊', 'Mulai Rp 200rb',
   ARRAY['Macro & VBA','Power Query','Pivot dinamis','Template laporan'], 3),
  ('Web App Development', 'Web app ringan HTML/CSS/JS dengan backend Apps Script atau Supabase.', '🌐', 'Mulai Rp 800rb',
   ARRAY['Responsive design','REST API integration','Supabase database','Deploy Vercel/GAS'], 4)
on conflict do nothing;

-- ── Skills ────────────────────────────────────────────────────
insert into skills (name, category, icon, level, sort_order) values
  ('Google Apps Script',   'Google Workspace', '⚡', 95, 1),
  ('Google Sheets',        'Google Workspace', '📊', 95, 2),
  ('AppSheet',             'No-Code Tools',    '📱', 90, 3),
  ('Google Forms',         'Google Workspace', '📋', 85, 4),
  ('Microsoft Excel',      'Office Tools',     '📈', 90, 5),
  ('HTML / CSS',           'Web Development',  '🌐', 80, 6),
  ('JavaScript',           'Web Development',  '🟨', 75, 7),
  ('Supabase',             'Database',         '🐘', 70, 8),
  ('Power Query',          'Office Tools',     '🔄', 85, 9),
  ('REST API Integration', 'Web Development',  '🔗', 75, 10)
on conflict do nothing;

-- ── Site Config ───────────────────────────────────────────────
insert into site_config (key, value) values
  ('hero_name',        'Dede Separman'),
  ('hero_tagline',     'Google Apps Script & Automation Specialist'),
  ('hero_desc',        'Terbiasa dengan Google Apps Script, AppSheet dan Excel untuk membuat solusi otomatis, aplikasi tanpa kode, dan olah data yang efisien.'),
  ('hero_cta_text',    'Lihat Portofolio'),
  ('hero_cta_link',    'pages/proyek.html'),
  ('hero_photo',       'assets/photo.png'),
  ('tentang_title',    'Tentang Saya'),
  ('tentang_bio1',     'Saya adalah freelancer dan developer berbasis di Bandung yang fokus pada otomatisasi proses bisnis menggunakan ekosistem Google.'),
  ('tentang_bio2',     'Dengan pengalaman bertahun-tahun, saya membantu bisnis kecil hingga menengah meningkatkan efisiensi kerja mereka.'),
  ('tentang_lokasi',   'Bandung, West Java'),
  ('tentang_email',    ''),
  ('tentang_year',     '2019'),
  ('tentang_projects', '50'),
  ('tentang_cv',       ''),
  ('brand_color',      '#E63946'),
  ('brand_name',       'Dede Separman')
on conflict (key) do nothing;

-- ── Socials ───────────────────────────────────────────────────
insert into socials (label, icon, url, sort_order) values
  ('LinkedIn', '💼', 'https://linkedin.com',  1),
  ('GitHub',   '🐙', 'https://github.com',    2),
  ('WhatsApp', '📱', 'https://wa.me/62xxx',   3)
on conflict do nothing;


-- ══════════════════════════════════════════════════════════════
--  3. STORAGE (Cover Gambar Proyek)
--     Bucket: project-covers
--     - Public read untuk gambar cover di website
--     - Authenticated write (upload/update/delete) untuk admin panel
-- ══════════════════════════════════════════════════════════════

-- Buat bucket untuk cover proyek
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'project-covers',
  'project-covers',
  true,
  5242880, -- 5MB
  array['image/png','image/jpeg','image/webp','image/gif']
)
on conflict (id) do nothing;

-- Policies Storage: Public read semua object di bucket project-covers
do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'Public read project-covers'
  ) then
    create policy "Public read project-covers"
      on storage.objects
      for select
      using (bucket_id = 'project-covers');
  end if;
end $$;

-- Policies Storage: Authenticated write untuk bucket project-covers
do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'storage'
      and tablename = 'objects'
      and policyname = 'Auth write project-covers'
  ) then
    create policy "Auth write project-covers"
      on storage.objects
      for all
      using (bucket_id = 'project-covers' and auth.role() = 'authenticated');
  end if;
end $$;

-- Catatan:
-- Pastikan Storage RLS aktif (biasanya sudah default).
-- Jika upload gagal, cek: bucket name, policies, dan apakah Anda login via admin.html.

-- ══════════════════════════════════════════════════════════════
--  4. SELESAI
--  Langkah selanjutnya:
--  → Buat user admin di: Authentication → Users → Add User
--  → Masukkan email & password admin Anda
-- ══════════════════════════════════════════════════════════════
