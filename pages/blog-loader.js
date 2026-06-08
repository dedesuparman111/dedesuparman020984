/**
 * blog-loader.js
 * Load and render blog posts from Supabase
 */

async function initBlog() {
  const blogGrid = document.getElementById('blogGrid');
  const emptyState = document.getElementById('blogEmptyState');
  
  if (!blogGrid) return;
  
  try {
    // Load blog posts dari Supabase
    if (!window.DB) {
      throw new Error('Database client tidak tersedia');
    }
    
    const posts = await window.DB.getPosts();
    
    if (!posts || posts.length === 0) {
      emptyState.style.display = 'block';
      return;
    }
    
    emptyState.style.display = 'none';
    
    // Render blog posts
    blogGrid.innerHTML = posts.map(post => `
      <article class="blog-card">
        <div class="blog-card__emoji">${post.emoji || '📝'}</div>
        <h3>${post.title}</h3>
        <p class="blog-card__excerpt">${post.excerpt || post.content.substring(0, 100) + '...'}</p>
        <div class="blog-card__meta">
          <span class="blog-card__date">${new Date(post.created_at).toLocaleDateString('id-ID')}</span>
          ${post.reading_time ? `<span class="blog-card__reading-time">${post.reading_time} min baca</span>` : ''}
        </div>
        <a href="blog-post.html?slug=${post.slug}" class="btn btn--outline" style="margin-top:1rem;font-size:.75rem;padding:.5rem 1rem;">Baca Selengkapnya →</a>
      </article>
    `).join('');
    
  } catch (error) {
    console.error('Error loading blog:', error);
    emptyState.style.display = 'block';
  }
}

// Jalankan saat DOM loaded
document.addEventListener('DOMContentLoaded', initBlog);
