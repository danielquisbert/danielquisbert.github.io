/* =============================================
   GeoNexus — Main Application JS · v2
   Daniel Quisbert · 2026
   ============================================= */

let SITE_CONFIG = null;

document.addEventListener('DOMContentLoaded', () => {
  initYear();
  loadSite();
  initContentProtection();
});

/* =============================================
   CONTENT PROTECTION — ANTI-INSPECT / ANTI-COPY
   ============================================= */
function initContentProtection() {

  // 1. Bloquear click derecho
  document.addEventListener('contextmenu', (e) => {
    e.preventDefault();
    return false;
  });

  // 2. Bloquear atajos de DevTools e inspección
  document.addEventListener('keydown', (e) => {
    const blocked = [
      e.key === 'F12',
      e.ctrlKey && e.shiftKey && e.key === 'I',
      e.ctrlKey && e.shiftKey && e.key === 'J',
      e.ctrlKey && e.shiftKey && e.key === 'C',
      e.ctrlKey && e.shiftKey && e.key === 'K',
      e.ctrlKey && e.shiftKey && e.key === 'E',
      e.ctrlKey && e.shiftKey && e.key === 'M',
      e.ctrlKey && e.key === 'u',
      e.ctrlKey && e.key === 's',
      e.ctrlKey && e.key === 'p',
    ];

    if (blocked.some(Boolean)) {
      e.preventDefault();
      e.stopPropagation();
      return false;
    }
  });

  // 3. Bloquear selección de texto (excepto inputs)
  document.addEventListener('selectstart', (e) => {
    const tag = e.target.tagName;
    if (tag === 'INPUT' || tag === 'TEXTAREA') return;
    e.preventDefault();
  });

  // 4. Bloquear copiar
  document.addEventListener('copy', (e) => {
    const tag = e.target.tagName;
    if (tag === 'INPUT' || tag === 'TEXTAREA') return;
    e.preventDefault();
  });

  // 5. Bloquear cortar
  document.addEventListener('cut', (e) => e.preventDefault());

  // 6. Bloquear drag de imágenes y elementos
  document.addEventListener('dragstart', (e) => e.preventDefault());

  // 7. Detección de DevTools por tamaño de ventana
  const threshold = 160;
  let devToolsOpen = false;

  setInterval(() => {
    const w = window.outerWidth - window.innerWidth > threshold;
    const h = window.outerHeight - window.innerHeight > threshold;
    if ((w || h) && !devToolsOpen) {
      devToolsOpen = true;
      console.clear();
      console.log('%c⚠️ GeoNexus — Contenido protegido', 'color:#00e5ff;font-size:20px;font-weight:bold');
      console.log('%cEl uso de herramientas de desarrollo está restringido.', 'color:#ff6b35;font-size:14px');
    } else if (!w && !h) {
      devToolsOpen = false;
    }
  }, 1000);

  // 8. Console branding
  console.clear();
  console.log('%c🌍 GeoNexus by Daniel Quisbert', 'color:#39ff14;font-size:16px;font-weight:bold');

  // 9. Anti-debugger (una sola vez al cargar)
  (function () {
    const t = performance.now();
    debugger;
    if (performance.now() - t > 100) console.clear();
  })();

  // 10. Inyectar CSS de protección
  const shield = document.createElement('style');
  shield.id = 'geonexus-shield';
  shield.textContent = `
    body {
      -webkit-user-select: none;
      -moz-user-select: none;
      -ms-user-select: none;
      user-select: none;
    }
    input, textarea {
      -webkit-user-select: text;
      -moz-user-select: text;
      -ms-user-select: text;
      user-select: text;
    }
    @media print {
      body { display: none !important; }
      html::after {
        content: '⚠️ Contenido protegido — GeoNexus by Daniel Quisbert';
        display: block;
        text-align: center;
        padding: 4rem;
        font-size: 2rem;
        color: #333;
      }
    }
    img {
      -webkit-user-drag: none;
      -khtml-user-drag: none;
      -moz-user-drag: none;
      user-drag: none;
      pointer-events: none;
    }
    a, a *, iframe, button, button *, summary, details,
    .btn-block, .btn-toggle, .btn-whatsapp, .btn-telegram,
    .btn-payment-methods, .btn-download, .btn-send-voucher,
    .modal-close-btn, .tab-btn, .whatsapp-float,
    .project-link, .social-link, .course-modules,
    .video-facade, .video-facade *,
    .carousel-arrow, .carousel-dot, .testimonial-tab,
    .globe-wrapper canvas {
      pointer-events: auto !important;
    }
  `;
  document.head.appendChild(shield);
}

/* ---------- YEAR ---------- */
function initYear() {
  const el = document.getElementById('year');
  if (el) el.textContent = new Date().getFullYear();
}

/* ---------- SCROLL REVEAL ---------- */
function initScrollReveal() {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.12, rootMargin: '0px 0px -40px 0px' }
  );

  document.querySelectorAll('.reveal:not(.visible)').forEach((el) => observer.observe(el));
}

/* =============================================
   CARGA CENTRAL DEL SITIO (config.json)
   ============================================= */
async function loadSite() {
  try {
    const response = await fetch('config.json');
    SITE_CONFIG = await response.json();

    renderCourses(SITE_CONFIG);
    renderTestimonials(SITE_CONFIG);
    initScrollReveal();
  } catch (error) {
    console.error('Error cargando config.json:', error);
    const container = document.getElementById('coursesContainer');
    if (container) {
      container.innerHTML =
        '<p class="loading-text">No se pudieron cargar los cursos. Intenta recargar la página.</p>';
    }
  }
}

/* ---------- COURSES ---------- */
function renderCourses(config) {
  const container = document.getElementById('coursesContainer');
  if (!container) return;

  const courses = config.courses || [];
  container.innerHTML = '';

  const sorted = [...courses].sort((a, b) => a.priority - b.priority);
  const dateOpts = { day: 'numeric', month: 'long' };

  sorted.forEach((course) => {
    if (!course.enabled) return;

    const card = document.createElement('div');
    card.className = 'course-card reveal';

    let badge = '';
    let button = '';
    let cardOpacity = '';

    const waNumber = config.contact.inscription.number;
    const titleEnc = encodeURIComponent(course.courseTitle);

    switch (course.status) {
      case 'open': {
        const seatsLeft = course.availableSeats;
        if (seatsLeft <= config.courseDefaults.minSeatsForUrgency) {
          badge = `<span class="badge badge-urgency">🔥 ¡ÚLTIMOS ${seatsLeft} CUPOS!</span>`;
          button = `
            <a href="https://wa.me/${waNumber}?text=Hola!%20Quiero%20inscribirme%20en%20el%20curso%20${titleEnc}"
               target="_blank" rel="noopener"
               class="btn-block btn-warning btn-pulse">
              🔥 ¡Reservar Mi Cupo YA!
            </a>`;
        } else {
          badge = `<span class="badge badge-open">✅ Inscripciones Abiertas</span>`;
          if (seatsLeft <= config.courseDefaults.showCounterWhenSeatsBelow) {
            badge += `<span class="badge badge-seats">${seatsLeft}/${course.totalSeats} cupos</span>`;
          }
          button = `
            <a href="https://wa.me/${waNumber}?text=Hola!%20Quiero%20inscribirme%20en%20el%20curso%20${titleEnc}"
               target="_blank" rel="noopener"
               class="btn-block btn-primary">
              📝 Inscribirme Ahora
            </a>`;
        }
        break;
      }
      case 'coming_soon': {
        badge = `<span class="badge badge-soon">🔜 Próximamente</span>`;
        if (course.startDate) {
          const dateStr = new Date(course.startDate).toLocaleDateString('es-BO', dateOpts);
          badge += `<span class="badge badge-date">Inicia: ${dateStr}</span>`;
        }
        button = `
          <a href="https://wa.me/${waNumber}?text=Hola!%20Quiero%20reservar%20pre-inscripción%20para%20${titleEnc}"
             target="_blank" rel="noopener"
             class="btn-block btn-outline-primary">
            🚀 Reservar Pre-inscripción
          </a>`;
        break;
      }
      case 'full': {
        cardOpacity = 'opacity-75';
        badge = `<span class="badge badge-full">❌ Cupos Agotados</span>`;
        if (course.nextCohort && course.nextCohort.startDate) {
          const nextDateStr = new Date(course.nextCohort.startDate).toLocaleDateString('es-BO', dateOpts);
          badge += `<span class="badge badge-next">📅 Próximo: ${nextDateStr}</span>`;
        }
        if (course.nextCohort && course.nextCohort.waitlistEnabled) {
          button = `
            <a href="https://wa.me/${waNumber}?text=Hola!%20Quiero%20anotarme%20en%20lista%20de%20espera%20para%20${titleEnc}"
               target="_blank" rel="noopener"
               class="btn-block btn-outline">
              🔔 Lista de Espera
            </a>`;
        } else {
          button = `<button class="btn-block btn-outline" disabled>🔒 Cupos Agotados</button>`;
        }
        break;
      }
      case 'inprogress': {
        cardOpacity = 'opacity-60';
        badge = `<span class="badge badge-progress">🎓 En Progreso</span>`;
        button = `
          <a href="https://wa.me/${waNumber}?text=Hola!%20Quiero%20información%20del%20próximo%20grupo%20de%20${titleEnc}"
             target="_blank" rel="noopener"
             class="btn-block btn-outline">
            🔔 Notificarme Próximo Grupo
          </a>`;
        break;
      }
      default:
        return;
    }

    if (cardOpacity) card.classList.add(cardOpacity);

    const featuresHTML = course.features
      .map((f) => `<li>✓ ${f}</li>`)
      .join('');

    const modulesHTML = course.modules
      .map(
        (m) => `
      <div class="module-item">
        <span class="module-icon">${m.icon}</span>
        <div>
          <strong>${m.title}</strong>
          <p>${m.description}</p>
        </div>
      </div>`
      )
      .join('');

    card.innerHTML = `
      <div class="course-badges">${badge}</div>
      <div class="course-level">${course.courseLevel}</div>
      <h3 class="course-title">${course.courseTitle}</h3>
      <p class="course-description">${course.description}</p>

      <div class="course-meta">
        <span>🕐 ${course.duration}</span>
        <span>📅 ${course.schedule}</span>
        <span>📹 ${course.modality}</span>
      </div>

      <div class="course-price">
        <span class="price-usd">$${course.price.usd} USD</span>
        ${course.price.bolivianos !== null ? `<span class="price-bs">Bs. ${course.price.bolivianos}</span>` : ''}
      </div>

      <div class="course-features">
        <h4>✨ Incluye:</h4>
        <ul>${featuresHTML}</ul>
      </div>

      <details class="course-modules" id="modules-${course.id}">
        <summary>📚 Ver Módulos del Curso</summary>
        <div class="modules-list">${modulesHTML}</div>
      </details>

      <div class="course-actions">
        ${button}
        ${
          course.status === 'open'
            ? `<button class="btn-payment-methods" onclick="openPaymentModal()">💳 Ver Métodos de Pago</button>`
            : ''
        }
      </div>
    `;

    container.appendChild(card);
  });
}

/* =============================================
   TESTIMONIALS — Carrusel con pestañas por grupo
   ============================================= */
function renderTestimonials(config) {
  const container = document.getElementById('testimonialsContainer');
  if (!container || !config.testimonials) return;

  const groups = config.testimonials.groups || [];
  container.innerHTML = '';

  // Pestañas para alternar entre grupos
  const tabs = document.createElement('div');
  tabs.className = 'testimonial-tabs';
  tabs.setAttribute('role', 'tablist');

  groups.forEach((group, gi) => {
    const tab = document.createElement('button');
    tab.className = 'testimonial-tab' + (gi === 0 ? ' active' : '');
    tab.textContent = group.label;
    tab.setAttribute('role', 'tab');
    tab.setAttribute('aria-selected', gi === 0 ? 'true' : 'false');
    tab.addEventListener('click', () => switchTestimonialGroup(group.id, tab));
    tabs.appendChild(tab);
  });
  container.appendChild(tabs);

  // Paneles con carrusel por grupo
  groups.forEach((group, gi) => {
    const panel = document.createElement('div');
    panel.className = 'testimonial-panel' + (gi === 0 ? ' active' : '');
    panel.id = `testimonial-panel-${group.id}`;
    panel.setAttribute('role', 'tabpanel');

    const slidesHTML = group.videos
      .map(
        (v, i) => `
      <div class="carousel-slide" data-index="${i}">
        <div class="testimonial-video">
          <button class="video-facade" data-video-id="${v.id}" aria-label="Reproducir testimonio: ${v.name}">
            <img src="https://i.ytimg.com/vi/${v.id}/hqdefault.jpg" alt="Miniatura del video: ${v.name}" loading="lazy">
            <span class="play-btn" aria-hidden="true">▶</span>
          </button>
          <div class="testimonial-info">
            <h5>${v.name}</h5>
            <p>${v.description}</p>
          </div>
        </div>
      </div>`
      )
      .join('');

    const dotsHTML = group.videos
      .map((_, i) => `<button class="carousel-dot${i === 0 ? ' active' : ''}" data-index="${i}" aria-label="Ir al video ${i + 1}"></button>`)
      .join('');

    panel.innerHTML = `
      <p class="testimonial-group-subtitle">${group.subtitle}</p>
      <div class="carousel">
        <button class="carousel-arrow carousel-prev" aria-label="Video anterior">‹</button>
        <div class="carousel-track" tabindex="0">
          ${slidesHTML}
        </div>
        <button class="carousel-arrow carousel-next" aria-label="Video siguiente">›</button>
      </div>
      <div class="carousel-dots">${dotsHTML}</div>
    `;

    container.appendChild(panel);
    initCarousel(panel);
  });
}

function switchTestimonialGroup(groupId, clickedTab) {
  document.querySelectorAll('.testimonial-tab').forEach((t) => {
    t.classList.remove('active');
    t.setAttribute('aria-selected', 'false');
  });
  clickedTab.classList.add('active');
  clickedTab.setAttribute('aria-selected', 'true');

  document.querySelectorAll('.testimonial-panel').forEach((p) => {
    p.classList.remove('active');
    // Pausar videos del panel oculto: restaurar facade
    p.querySelectorAll('.video-embed-live').forEach((live) => restoreFacade(live));
  });
  const panel = document.getElementById(`testimonial-panel-${groupId}`);
  if (panel) panel.classList.add('active');
}

function initCarousel(panel) {
  const track = panel.querySelector('.carousel-track');
  const prev = panel.querySelector('.carousel-prev');
  const next = panel.querySelector('.carousel-next');
  const dots = panel.querySelectorAll('.carousel-dot');
  const slides = panel.querySelectorAll('.carousel-slide');

  const slideWidth = () => slides[0] ? slides[0].getBoundingClientRect().width : track.clientWidth;

  prev.addEventListener('click', () => track.scrollBy({ left: -slideWidth(), behavior: 'smooth' }));
  next.addEventListener('click', () => track.scrollBy({ left: slideWidth(), behavior: 'smooth' }));

  dots.forEach((dot) => {
    dot.addEventListener('click', () => {
      const i = parseInt(dot.dataset.index, 10);
      track.scrollTo({ left: i * slideWidth(), behavior: 'smooth' });
    });
  });

  // Actualizar dot activo según scroll
  let scrollTimer = null;
  track.addEventListener('scroll', () => {
    clearTimeout(scrollTimer);
    scrollTimer = setTimeout(() => {
      const i = Math.round(track.scrollLeft / slideWidth());
      dots.forEach((d, di) => d.classList.toggle('active', di === i));
    }, 80);
  });

  // Click-to-play: el iframe de YouTube se carga solo al hacer clic
  panel.querySelectorAll('.video-facade').forEach((facade) => {
    facade.addEventListener('click', () => playVideo(facade));
  });
}

function playVideo(facade) {
  const videoId = facade.dataset.videoId;
  const wrapper = document.createElement('div');
  wrapper.className = 'video-embed video-embed-live';
  wrapper.dataset.videoId = videoId;
  wrapper.dataset.label = facade.getAttribute('aria-label') || '';
  wrapper.innerHTML = `
    <iframe src="https://www.youtube-nocookie.com/embed/${videoId}?autoplay=1&rel=0"
            title="Testimonio en video"
            frameborder="0"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen></iframe>
  `;
  facade.replaceWith(wrapper);
}

function restoreFacade(liveEmbed) {
  const videoId = liveEmbed.dataset.videoId;
  const label = liveEmbed.dataset.label || 'Reproducir testimonio';
  const facade = document.createElement('button');
  facade.className = 'video-facade';
  facade.dataset.videoId = videoId;
  facade.setAttribute('aria-label', label);
  facade.innerHTML = `
    <img src="https://i.ytimg.com/vi/${videoId}/hqdefault.jpg" alt="Miniatura del video" loading="lazy">
    <span class="play-btn" aria-hidden="true">▶</span>
  `;
  facade.addEventListener('click', () => playVideo(facade));
  liveEmbed.replaceWith(facade);
}

/* ---------- PAYMENT MODAL ---------- */
function openPaymentModal() {
  const modal = document.getElementById('paymentModal');
  if (modal) {
    modal.classList.add('active');
    document.body.style.overflow = 'hidden';
  }
}

function closePaymentModal() {
  const modal = document.getElementById('paymentModal');
  if (modal) {
    modal.classList.remove('active');
    document.body.style.overflow = 'auto';
  }
}

function switchTab(tab, btn) {
  document.querySelectorAll('.tab-btn').forEach((b) => b.classList.remove('active'));
  document.querySelectorAll('.tab-content').forEach((c) => c.classList.remove('active'));

  if (btn) btn.classList.add('active');

  const tabEl = document.getElementById(tab + '-tab');
  if (tabEl) tabEl.classList.add('active');
}

function downloadQR(filename, downloadName) {
  const link = document.createElement('a');
  link.href = filename;
  link.download = downloadName;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

// Cerrar modal con clic en overlay / tecla ESC
document.addEventListener('click', (e) => {
  if (e.target.id === 'paymentModal') closePaymentModal();
});
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') closePaymentModal();
});

/* ---------- HELPER ---------- */
function formatDate(dateString) {
  const date = new Date(dateString);
  return date.toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
}
