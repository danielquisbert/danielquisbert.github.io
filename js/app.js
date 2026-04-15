/* =============================================
   GeoNexus — Main Application JS
   Daniel Quisbert · 2026
   ============================================= */

document.addEventListener('DOMContentLoaded', () => {
  initYear();
  loadCourses();
  initScrollReveal();
});

/* ---------- YEAR ---------- */
function initYear() {
  const el = document.getElementById('year');
  if (el) el.textContent = new Date().getFullYear();
}

/* ---------- PORTFOLIO TOGGLE ---------- */
function togglePortfolio() {
  const content = document.getElementById('portfolioContent');
  const icon = document.getElementById('portfolioIcon');
  const text = document.getElementById('portfolioText');

  content.classList.toggle('active');

  if (content.classList.contains('active')) {
    icon.textContent = '✖️';
    text.textContent = 'Cerrar';
  } else {
    icon.textContent = '📂';
    text.textContent = 'Ver Portfolio y Testimonios';
  }
}

/* ---------- SCROLL REVEAL ---------- */
function initScrollReveal() {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
        }
      });
    },
    { threshold: 0.12, rootMargin: '0px 0px -40px 0px' }
  );

  document.querySelectorAll('.reveal').forEach((el) => observer.observe(el));
}

/* ---------- LOAD COURSES FROM config.json ---------- */
async function loadCourses() {
  const container = document.getElementById('coursesContainer');
  if (!container) return;

  try {
    const response = await fetch('config.json');
    const config = await response.json();
    const courses = config.courses;

    container.innerHTML = '';

    const sorted = [...courses].sort((a, b) => a.priority - b.priority);

    sorted.forEach((course) => {
      if (!course.enabled) return;

      const card = document.createElement('div');
      card.className = 'course-card reveal';

      const options = { day: 'numeric', month: 'long' };
      let badge = '';
      let button = '';
      let cardOpacity = '';

      switch (course.status) {
        case 'open': {
          const seatsLeft = course.availableSeats;
          if (seatsLeft <= config.courseDefaults.minSeatsForUrgency) {
            badge = `<span class="badge badge-urgency">🔥 ¡ÚLTIMOS ${seatsLeft} CUPOS!</span>`;
            button = `
              <a href="https://wa.me/${config.contact.inscription.number}?text=Hola!%20Quiero%20inscribirme%20en%20el%20curso%20${encodeURIComponent(course.courseTitle)}"
                 target="_blank"
                 class="btn-block btn-warning btn-pulse">
                🔥 ¡Reservar Mi Cupo YA!
              </a>`;
          } else {
            badge = `<span class="badge badge-open">✅ Inscripciones Abiertas</span>`;
            if (seatsLeft <= config.courseDefaults.showCounterWhenSeatsBelow) {
              badge += `<span class="badge badge-seats">${seatsLeft}/${course.totalSeats} cupos</span>`;
            }
            button = `
              <a href="https://wa.me/${config.contact.inscription.number}?text=Hola!%20Quiero%20inscribirme%20en%20el%20curso%20${encodeURIComponent(course.courseTitle)}"
                 target="_blank"
                 class="btn-block btn-primary">
                📝 Inscribirme Ahora
              </a>`;
          }
          break;
        }
        case 'coming_soon': {
          const startDate = new Date(course.startDate);
          const dateStr = startDate.toLocaleDateString('es-BO', options);
          badge = `<span class="badge badge-soon">🔜 Próximamente</span>
                   <span class="badge badge-date">Inicia: ${dateStr}</span>`;
          button = `
            <a href="https://wa.me/${config.contact.inscription.number}?text=Hola!%20Quiero%20reservar%20pre-inscripción%20para%20${encodeURIComponent(course.courseTitle)}"
               target="_blank"
               class="btn-block btn-outline-primary">
              🚀 Reservar Pre-inscripción
            </a>`;
          break;
        }
        case 'full': {
          cardOpacity = 'opacity-75';
          const nextDate = course.nextCohort
            ? new Date(course.nextCohort.startDate)
            : new Date();
          const nextDateStr = nextDate.toLocaleDateString('es-BO', options);
          badge = `<span class="badge badge-full">❌ Cupos Agotados</span>
                   <span class="badge badge-next">📅 Próximo: ${nextDateStr}</span>`;
          if (course.nextCohort && course.nextCohort.waitlistEnabled) {
            button = `
              <a href="https://wa.me/${config.contact.inscription.number}?text=Hola!%20Quiero%20anotarme%20en%20lista%20de%20espera%20para%20${encodeURIComponent(course.courseTitle)}"
                 target="_blank"
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
            <a href="https://wa.me/${config.contact.inscription.number}?text=Hola!%20Quiero%20información%20del%20próximo%20grupo%20de%20${encodeURIComponent(course.courseTitle)}"
               target="_blank"
               class="btn-block btn-outline">
              🔔 Notificarme Próximo Grupo
            </a>`;
          break;
        }
        default:
          return;
      }

      if (cardOpacity) card.classList.add(cardOpacity);

      // Features HTML
      const featuresHTML = course.features
        .map((f) => `<li>✓ ${f}</li>`)
        .join('');

      // Modules HTML
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

    // Re-observe new cards
    initScrollReveal();
  } catch (error) {
    console.error('Error loading courses:', error);
    container.innerHTML =
      '<p class="loading-text">No se pudieron cargar los cursos. Intenta recargar la página.</p>';
  }
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

function switchTab(tab) {
  document.querySelectorAll('.tab-btn').forEach((btn) => btn.classList.remove('active'));
  document.querySelectorAll('.tab-content').forEach((c) => c.classList.remove('active'));

  // Find the clicked button
  if (event && event.target) {
    event.target.classList.add('active');
  }

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

// Close modal on overlay click / ESC
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
