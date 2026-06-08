-- ================================================================
-- FIX: Blog Posts RLS Security Policy
-- Jalankan di: Supabase Dashboard → SQL Editor → New Query
-- ================================================================
-- Masalah: Admin tidak bisa INSERT/UPDATE/DELETE posts dari admin.html
-- Solusi: Update RLS policy untuk allow authenticated users

-- 1. DROP existing policies yang mungkin konflikt
DROP POLICY IF EXISTS "Auth write posts" on posts;
DROP POLICY IF EXISTS "Public read published posts" on posts;
DROP POLICY IF EXISTS "Admins write posts" on posts;

-- 2. CREATE new policies yang lebih clear

-- PUBLIC READ: Siapa saja bisa baca posts yang published
CREATE POLICY "Public read published posts" on posts
  FOR SELECT
  USING (published = true);

-- AUTHENTICATED INSERT: Hanya user yang sudah login bisa buat post baru
CREATE POLICY "Authenticated insert posts" on posts
  FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

-- AUTHENTICATED UPDATE: Hanya user yang sudah login bisa update post
CREATE POLICY "Authenticated update posts" on posts
  FOR UPDATE
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

-- AUTHENTICATED DELETE: Hanya user yang sudah login bisa delete post
CREATE POLICY "Authenticated delete posts" on posts
  FOR DELETE
  USING (auth.role() = 'authenticated');

-- ================================================================
-- Verifikasi:
-- Jalankan query di bawah untuk check existing policies:
-- ================================================================
-- SELECT tablename, policyname, qual, with_check FROM pg_policies WHERE tablename='posts';
