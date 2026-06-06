# Dede Separman — Portfolio Website

Static portfolio website built with **HTML · Vanilla CSS · Vanilla JS**  
Backend database: **Supabase** (PostgreSQL via REST API, no SDK needed)  
Deploy: **Vercel** (or GitHub Pages)

---

## 📁 Project Structure

```
dede-portfolio/
├── index.html                  ← Homepage / Hero
├── pages/
│   ├── tentang.html            ← About page
│   ├── skill.html              ← Skills page
│   ├── proyek.html             ← Portfolio/Projects page
│   ├── layanan.html            ← Services page
│   ├── blog.html               ← Blog listing
│   ├── blog-post.html          ← Single blog post (dynamic)
│   └── kontak.html             ← Contact form
├── css/
│   ├── main.css                ← Global styles, design tokens
│   └── pages.css               ← Inner-page specific styles
├── js/
│   ├── supabase-client.js      ← Supabase REST wrapper
│   └── main.js                 ← Global JS (navbar, counters, etc.)
├── assets/
│   ├── photo.png               ← Your profile photo (replace this!)
│   └── icons/                  ← Favicon etc.
├── supabase-schema.sql         ← Run this in Supabase SQL Editor
├── vercel.json                 ← Vercel config (clean URLs, cache, security)
└── README.md
```

---

## 🚀 Setup Guide

### 1. Supabase Database

1. Go to [supabase.com](https://supabase.com) → Create a new project
2. Open **SQL Editor → New Query**
3. Paste the entire contents of `supabase-schema.sql` and click **Run**
4. Go to **Settings → API** and copy:
   - **Project URL** (e.g. `https://abcdef.supabase.co`)
   - **anon public key**

### 2. Connect Supabase to Frontend

Open `js/supabase-client.js` and replace the two constants at the top:

```js
const SUPABASE_URL  = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_ANON = 'YOUR_ANON_PUBLIC_KEY';
```

> ✅ The anon key is **safe to expose** in client-side code — it's intended for public read operations. Supabase RLS (Row Level Security) policies protect sensitive data.

### 3. Add Your Photo

Replace `assets/photo.png` with your own profile photo.  
Recommended: transparent background PNG, min 600px height.

### 4. Deploy to Vercel

```bash
# Option A: Vercel CLI
npm i -g vercel
cd dede-portfolio
vercel

# Option B: Drag & drop
# Go to vercel.com → New Project → Upload folder
```

Or connect your **GitHub repo** for automatic deployments on every push.

---

## 🗄️ Supabase Tables

| Table      | Purpose                              | Public Read |
|------------|--------------------------------------|-------------|
| `projects` | Portfolio projects                   | ✅ Yes      |
| `posts`    | Blog posts (published only)          | ✅ Yes      |
| `messages` | Contact form submissions             | ❌ Auth only|
| `services` | Services offered                     | ✅ Yes      |
| `skills`   | Skills with categories & levels      | ✅ Yes      |

### Managing Content

Use the **Supabase Table Editor** (like a spreadsheet) to:
- Add/edit projects
- Write/publish blog posts
- View contact messages
- Update services & skills

---

## 🔧 Customization

### Colors
Edit CSS variables in `css/main.css`:
```css
:root {
  --red:   #E63946;   /* Main accent color */
  --black: #1A1A2E;   /* Text & backgrounds */
}
```

### Fonts
Currently using **Bebas Neue** (headings) + **DM Sans** (body).  
Change the Google Fonts link in each HTML file's `<head>`.

### Navigation
To add/remove menu items, edit the `<nav class="navbar__menu">` in each HTML file.

---

## 📝 Notes on Google Apps Script Compatibility

This site is a **static HTML site** — it does NOT use Google Apps Script as a host.  
GAS web apps (`doGet/doPost`) have limitations (no custom domains, slow cold start).  
By deploying on **Vercel + Supabase**, you get:

- ✅ Custom domain support
- ✅ HTTPS by default
- ✅ Fast global CDN
- ✅ 100% free tier for personal portfolios
- ✅ Proper contact form with database storage

If you still want to use a **GAS Web App as API** (e.g. to read from Google Sheets), you can call your GAS `doGet` URL from `supabase-client.js` as an additional data source.

---

## 📦 Dependencies

**None.** Pure HTML + CSS + JS. No npm, no build step, no bundler.  
Fonts loaded from Google Fonts CDN.

---

Built with ❤️ in Bandung, West Java.
