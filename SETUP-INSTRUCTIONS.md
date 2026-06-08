# 🛠️ INSTRUKSI SETUP BLOG - FIX RLS SECURITY

## ❌ MASALAH SAAT INI
Error saat menyimpan blog: **"new row violates row-level security policy for table 'posts'"**

---

## ✅ SOLUSI LANGKAH DEMI LANGKAH

### **Step 1: Buka Supabase Dashboard**
1. Pergi ke https://supabase.com
2. Login ke project Anda
3. Navigasi ke: **SQL Editor** → **New Query**

### **Step 2: Jalankan Script Fix**
Salin semua kode di bawah dan paste ke SQL Editor:

```sql
-- ================================================================
-- FIX: Blog Posts RLS Security Policy
-- ================================================================
-- DROP existing policies yang mungkin konflikt
DROP POLICY IF EXISTS "Auth write posts" on posts;
DROP POLICY IF EXISTS "Public read published posts" on posts;
DROP POLICY IF EXISTS "Admins write posts" on posts;

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
```

3. Klik **"Run"** (atau tekan Ctrl+Enter)
4. Tunggu hingga berhasil ✅

### **Step 3: Verifikasi**
Jalankan query ini untuk check policies:
```sql
SELECT tablename, policyname, qual, with_check FROM pg_policies WHERE tablename='posts';
```

Anda harusnya melihat 4 policies untuk `posts` table:
- ✅ Public read published posts
- ✅ Authenticated insert posts
- ✅ Authenticated update posts
- ✅ Authenticated delete posts

---

## 🧪 TEST SEKARANG

1. Buka https://ddsuparman0984.vercel.app/admin.html
2. Login dengan kredensial admin
3. Navigasi ke **Blog** section
4. Klik **+ Buat Post Baru**
5. Isi form dan klik **Simpan**

Seharusnya berhasil! 🎉

---

## ⚠️ JIKA MASIH ERROR

Cek hal-hal ini:

1. **Pastikan RLS aktif** di table `posts`:
   ```sql
   SELECT tablename, rowsecurity FROM pg_tables WHERE tablename='posts';
   ```
   Seharusnya `rowsecurity = true`

2. **Pastikan sudah login** ke admin panel sebelum save

3. **Lihat error detail** di browser console (F12 → Console tab)

4. **Jika perlu reset**, drop semua policies terlebih dahulu:
   ```sql
   DROP POLICY IF EXISTS "Public read published posts" on posts;
   DROP POLICY IF EXISTS "Authenticated insert posts" on posts;
   DROP POLICY IF EXISTS "Authenticated update posts" on posts;
   DROP POLICY IF EXISTS "Authenticated delete posts" on posts;
   ```
   Kemudian jalankan script fix di atas lagi.

---

## 📚 PENJELASAN TEKNIS

- **RLS (Row Level Security)**: Fitur database untuk mengontrol akses baris
- **FOR SELECT**: Policy untuk READ
- **FOR INSERT**: Policy untuk CREATE
- **FOR UPDATE**: Policy untuk EDIT
- **FOR DELETE**: Policy untuk HAPUS
- **WITH CHECK**: Kondisi yang harus terpenuhi untuk operasi write
- **USING**: Kondisi yang harus terpenuhi untuk operasi read

Policy lama menggunakan `FOR ALL` tapi tanpa `WITH CHECK`, sehingga INSERT/UPDATE/DELETE ditolak.
