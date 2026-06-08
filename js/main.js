/**
 * main.js
 * Global interactivity: navbar scroll, burger menu,
 * stat counters, dynamic project cards, language toggle.
 */

document.addEventListener('DOMContentLoaded', () => {

  /* ── NAVBAR SCROLL EFFECT ── */
  const navbar = document.getElementById('navbar');
  if (navbar) {
    const onScroll = () => navbar.classList.toggle('scrolled', window.scrollY > 20);
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  }

  /* ── BURGER MENU ── */
  const burger  = document.getElementById('burgerBtn');
  const navMenu = document.getElementById('navMenu');
  if (burger && navMenu) {
    burger.addEventListener('click', () => {
      const open = navMenu.classList.toggle('open');
      burger.classList.toggle('open', open);
      burger.setAttribute('aria-expanded', String(open));
    });
    // Close when link clicked
    navMenu.querySelectorAll('.navbar__link').forEach(link => {
      link.addEventListener('click', () => {
        navMenu.classList.remove('open');
        burger.classList.remove('open');
      });
    });
  }

  /* ── ACTIVE LINK HIGHLIGHT ── */
  const currentPath = window.location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.navbar__link').forEach(link => {
    const href = link.getAttribute('href').split('/').pop();
    if (href === currentPath) link.classList.add('active');
    else link.classList.remove('active');
  });

  /* ── FOOTER YEAR ── */
  const yearEl = document.getElementById('year');
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  /* ── STAT COUNTER ANIMATION ── */
  const statEls = document.querySelectorAll('.stat-number[data-target]');
  if (statEls.length) {
    const countUp = (el) => {
      const target = +el.dataset.target;
      const duration = 1800;
      const step = 16;
      const increment = target / (duration / step);
      let current = 0;
      const timer = setInterval(() => {
        current = Math.min(current + increment, target);
        el.textContent = Math.floor(current);
        if (current >= target) clearInterval(timer);
      }, step);
    };
    // Trigger when visible
    const obs = new IntersectionObserver((entries) => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          countUp(e.target);
          obs.unobserve(e.target);
        }
      });
    }, { threshold: 0.5 });
    statEls.forEach(el => obs.observe(el));
  }

  /* ── PROJECTS GRID (Homepage) ── */
  const projectsGrid = document.getElementById('projectsGrid');
  if (projectsGrid && window.DB) {
    window.DB.loadProjects({ limit: 3 })
      .then(projects => renderProjects(projectsGrid, projects))
      .catch(() => renderProjectsFallback(projectsGrid));
  }

  

  /* ── SCROLL REVEAL ── */
  const revealEls = document.querySelectorAll(
    '.service-card, .project-card, .stat-item, .blog-card, .skill-item'
  );
  if (revealEls.length && 'IntersectionObserver' in window) {
    const revealObs = new IntersectionObserver((entries) => {
      entries.forEach((e, i) => {
        if (e.isIntersecting) {
          // delay tetap via inline delay; tanpa injection CSS
          e.target.style.transitionDelay = `${i * 0.07}s`;
          e.target.classList.add('reveal-target', 'revealed');
          revealObs.unobserve(e.target);
        }
      });
    }, { threshold: 0.12 });

    revealEls.forEach(el => {
      el.classList.add('reveal-target');
      revealObs.observe(el);
    });
  }
});

/* ── HELPERS ── */

function renderProjects(container, projects) {
  if (!projects || !projects.length) {
    renderProjectsFallback(container);
    return;
  }
  container.innerHTML = projects.map(p => `
    <article class="project-card">
      ${p.image_url
        ? `<img src="${p.image_url}" alt="${p.title}" class="project-card__img" loading="lazy">`
        : `<div class="project-card__img-placeholder">${p.emoji || '🛠️'}</div>`
      }
      <div class="project-card__body">
        <span class="project-tag">${p.tag || 'Project'}</span>
        <h3>${p.title}</h3>
        <p>${p.summary || ''}</p>
        ${p.url ? `<a href="${p.url}" target="_blank" class="btn btn--outline" style="margin-top:1rem;font-size:.75rem;padding:.5rem 1rem;">Lihat →</a>` : ''}
      </div>
    </article>
  `).join('');
}

function renderProjectsFallback(container) {
  // Static fallback when Supabase is not configured
  const fallback = [
    { emoji: '📋', tag: 'Google Apps Script', title: 'Sistem Absensi Otomatis', summary: 'Otomatisasi absensi karyawan menggunakan Google Sheets & Apps Script.' },
    { emoji: '📊', tag: 'AppSheet', title: 'Aplikasi Inventaris', summary: 'App mobile no-code untuk manajemen stok gudang secara real-time.' },
    { emoji: '📈', tag: 'Excel', title: 'Dashboard Keuangan', summary: 'Dashboard laporan keuangan bulanan dengan macro Excel & Power Query.' },
  ];
  renderProjects(container, fallback);
}

/* ── CONTACT FORM HANDLER ── */
function initContactForm() {
  const form = document.getElementById('contactForm');
  if (!form) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const btn = form.querySelector('[type="submit"]');
    const status = document.getElementById('formStatus');

    btn.disabled = true;
    btn.textContent = 'Mengirim...';

    const data = {
      name:    form.name.value.trim(),
      email:   form.email.value.trim(),
      subject: form.subject?.value.trim() || '',
      message: form.message.value.trim(),
    };

    try {
      if (window.DB) {
        await window.DB.sendContactMessage(data);
      }
      if (status) {
        status.textContent = '✅ Pesan berhasil dikirim! Saya akan segera menghubungi Anda.';
        status.className = 'form-status form-status--success';
      }
      form.reset();
    } catch (err) {
      if (status) {
        status.textContent = '❌ Gagal mengirim pesan. Silakan coba lagi atau hubungi via email.';
        status.className = 'form-status form-status--error';
      }
    } finally {
      btn.disabled = false;
      btn.textContent = 'Kirim Pesan';
    }
  });
}

// Initialize contact form if present
initContactForm();
