/**
 * supabase-client.js
 * ──────────────────────────────────────────────────────
 * Lightweight Supabase REST wrapper (no SDK required).
 * All fetch calls use the REST API directly so this file
 * works in any static environment (Vercel, GitHub Pages).
 *
 * ⚠️  Replace the two constants below with your own values
 *     from: https://supabase.com/dashboard → Settings → API
 * ──────────────────────────────────────────────────────
 */

const SUPABASE_URL    = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_ANON   = 'YOUR_ANON_PUBLIC_KEY';   // safe to expose client-side

/**
 * Generic REST fetcher for Supabase PostgREST.
 * @param {string} table   - Table name
 * @param {string} query   - PostgREST query string, e.g. "select=*&order=created_at.desc"
 * @returns {Promise<Array>}
 */
async function supabaseFetch(table, query = 'select=*') {
  const url = `${SUPABASE_URL}/rest/v1/${table}?${query}`;
  const res = await fetch(url, {
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': `Bearer ${SUPABASE_ANON}`,
      'Content-Type': 'application/json',
    },
  });
  if (!res.ok) throw new Error(`Supabase error: ${res.status} ${res.statusText}`);
  return res.json();
}

/**
 * POST / INSERT to a Supabase table.
 * @param {string} table
 * @param {Object} payload
 * @returns {Promise<Object>}
 */
async function supabaseInsert(table, payload) {
  const url = `${SUPABASE_URL}/rest/v1/${table}`;
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      'apikey': SUPABASE_ANON,
      'Authorization': `Bearer ${SUPABASE_ANON}`,
      'Content-Type': 'application/json',
      'Prefer': 'return=representation',
    },
    body: JSON.stringify(payload),
  });
  if (!res.ok) throw new Error(`Supabase insert error: ${res.status}`);
  return res.json();
}

/* ── EXPORTED HELPERS ── */

/** Load projects, optionally filtered by tag */
async function loadProjects({ limit = 6, tag = null } = {}) {
  let q = `select=*&order=created_at.desc&limit=${limit}`;
  if (tag) q += `&tag=eq.${encodeURIComponent(tag)}`;
  return supabaseFetch('projects', q);
}

/** Load blog posts */
async function loadPosts({ limit = 6 } = {}) {
  return supabaseFetch('posts', `select=*&order=published_at.desc&limit=${limit}&published=eq.true`);
}

/** Load a single post by slug */
async function loadPostBySlug(slug) {
  const rows = await supabaseFetch('posts', `select=*&slug=eq.${encodeURIComponent(slug)}&limit=1`);
  return rows[0] ?? null;
}

/** Send a contact form message */
async function sendContactMessage({ name, email, subject, message }) {
  return supabaseInsert('messages', { name, email, subject, message });
}

/** Load services */
async function loadServices() {
  return supabaseFetch('services', 'select=*&order=sort_order.asc');
}

/** Load skills */
async function loadSkills() {
  return supabaseFetch('skills', 'select=*&order=category.asc,sort_order.asc');
}

/* Make globally available */
window.DB = {
  loadProjects,
  loadPosts,
  loadPostBySlug,
  sendContactMessage,
  loadServices,
  loadSkills,
};
