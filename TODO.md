# TODO — Tampilan Lebih Profesional

## Step 1: CSS reusable untuk reveal & spacing ✅
- Tambahkan `.reveal-target` dan `.revealed` di `css/main.css`
- Tambahkan helper spacing (`.mt-auto`) untuk tombol tanpa inline style

## Step 2: Rapikan JS reveal + hapus injection CSS ✅
- Hapus pembuatan `<style>` untuk `.revealed` dari `js/main.js`
- Pastikan JS hanya mengubah class (`reveal-target`, `revealed`) + delay

## Step 3: Rapikan `pages/layanan.html` ✅
- Hapus inline `style="height:300px"` pada skeleton -> pakai class `.project-skeleton--tall`
- Hapus inline `style="margin-top:auto"` pada tombol -> pakai class `.mt-auto`
