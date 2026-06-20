// ==================== DARK MODE ==================== //
const themeToggle = document.getElementById('themeToggle');
const html = document.documentElement;

const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
const savedTheme = localStorage.getItem('theme');
const initialTheme = savedTheme || (prefersDark ? 'dark' : 'light');

html.setAttribute('data-theme', initialTheme);

themeToggle.addEventListener('click', () => {
    const currentTheme = html.getAttribute('data-theme');
    const newTheme = currentTheme === 'light' ? 'dark' : 'light';
    html.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
});

// ==================== WHATSAPP CONFIGURATION ==================== //
const PHONE_NUMBER = '59164222142';
const COMPROBANTE_MESSAGE = 'Hola, completé mi pago. Adjunto el comprobante/voucher para confirmar mi inscripción.';
const WESTERN_MESSAGE = 'Hola, me interesa pagar con Western Union. Por favor, pásame los datos bancarios.';

// Detectar si es móvil
function isMobileDevice() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

// Generar enlace de WhatsApp
function getWhatsAppLink(message) {
    const encodedMessage = encodeURIComponent(message);
    
    if (isMobileDevice()) {
        // En móvil, abre la app de WhatsApp
        return `whatsapp://send?phone=${PHONE_NUMBER}&text=${encodedMessage}`;
    } else {
        // En computadora, abre WhatsApp Web
        return `https://web.whatsapp.com/send?phone=${PHONE_NUMBER}&text=${encodedMessage}`;
    }
}

// ==================== BUTTON HANDLERS ==================== //

// Botón: Enviar comprobante
const whatsappComprobanteBtn = document.getElementById('whatsappComprobante');
if (whatsappComprobanteBtn) {
    whatsappComprobanteBtn.addEventListener('click', () => {
        const link = getWhatsAppLink(COMPROBANTE_MESSAGE);
        window.open(link, isMobileDevice() ? '_self' : '_blank');
    });
}

// Botón: Contactar para Western Union
const whatsappWesternBtn = document.getElementById('whatsappWestern');
if (whatsappWesternBtn) {
    whatsappWesternBtn.addEventListener('click', () => {
        const link = getWhatsAppLink(WESTERN_MESSAGE);
        window.open(link, isMobileDevice() ? '_self' : '_blank');
    });
}

// Enlace: WhatsApp general (contacto)
const whatsappGeneralLink = document.getElementById('whatsappGeneral');
if (whatsappGeneralLink) {
    whatsappGeneralLink.addEventListener('click', (e) => {
        e.preventDefault();
        const link = getWhatsAppLink('Hola, tengo una pregunta sobre los cursos.');
        window.open(link, isMobileDevice() ? '_self' : '_blank');
    });
}

// Smooth scrolling
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    });
});