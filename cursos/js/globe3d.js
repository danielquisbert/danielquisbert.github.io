/* =============================================
   GeoNexus — Globo 3D Realista · v2
   Daniel Quisbert · 2026
   Three.js r128 (global THREE)
   ---------------------------------------------
   - Texturas satelitales (NASA Blue Marble)
   - Relieve (bump), océanos especulares y nubes
   - Atmósfera con shader fresnel
   - Luces de ciudades en el lado nocturno
   - Rotación con arrastre + inercia + auto-rotación
   - Marcador de La Paz con etiqueta
   - Geolocalización del usuario + arco hacia La Paz
   ============================================= */

(function () {
  'use strict';

  const container = document.getElementById('globe-container');
  if (!container || typeof THREE === 'undefined') return;

  /* ---------- Configuración ---------- */
  const GLOBE_RADIUS = 1;
  const LA_PAZ = { lat: -16.4897, lon: -68.1193 };
  const TEXTURES = {
    day:      'https://unpkg.com/three-globe@2.31.0/example/img/earth-blue-marble.jpg',
    bump:     'https://unpkg.com/three-globe@2.31.0/example/img/earth-topology.png',
    water:    'https://unpkg.com/three-globe@2.31.0/example/img/earth-water.png',
    night:    'https://unpkg.com/three-globe@2.31.0/example/img/earth-night.jpg',
    clouds:   'https://unpkg.com/three-globe@2.31.0/example/img/clouds/clouds.png',
  };
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ---------- Escena base ---------- */
  const scene = new THREE.Scene();

  const camera = new THREE.PerspectiveCamera(38, 1, 0.1, 100);
  // Distancia suficiente para que el globo (r=1) + atmósfera (r=1.16) quepan
  // completos en el encuadre, con la cámara centrada (sin offset vertical).
  camera.position.set(0, 0, 3.7);

  const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  renderer.outputEncoding = THREE.sRGBEncoding;
  container.appendChild(renderer.domElement);

  /* ---------- Iluminación tipo "sol" ---------- */
  scene.add(new THREE.AmbientLight(0x404a5a, 0.85));

  const sun = new THREE.DirectionalLight(0xfff3e0, 1.35);
  sun.position.set(-3, 1.2, 2.5);
  scene.add(sun);

  // Luz de contorno fría (rim) para profundidad
  const rim = new THREE.DirectionalLight(0x3a9bdc, 0.35);
  rim.position.set(3, -1, -2);
  scene.add(rim);

  /* ---------- Grupo del globo (rota completo) ---------- */
  const globeGroup = new THREE.Group();
  scene.add(globeGroup);

  const loader = new THREE.TextureLoader();
  loader.setCrossOrigin('anonymous');

  function loadTex(url, onLoad) {
    return loader.load(url, onLoad, undefined, () => {
      console.warn('GeoNexus globe: no se pudo cargar la textura', url);
    });
  }

  /* ---------- Tierra ---------- */
  const earthMat = new THREE.MeshPhongMaterial({
    color: 0x2a3a5c, // fallback si las texturas no cargan
    shininess: 18,
    specular: new THREE.Color(0x666666),
  });

  loadTex(TEXTURES.day, (t) => {
    t.encoding = THREE.sRGBEncoding;
    earthMat.map = t;
    earthMat.color.set(0xffffff);
    earthMat.needsUpdate = true;
  });
  loadTex(TEXTURES.bump, (t) => {
    earthMat.bumpMap = t;
    earthMat.bumpScale = 0.012;
    earthMat.needsUpdate = true;
  });
  loadTex(TEXTURES.water, (t) => {
    // Océanos con reflejo, continentes mate
    earthMat.specularMap = t;
    earthMat.needsUpdate = true;
  });

  const earth = new THREE.Mesh(new THREE.SphereGeometry(GLOBE_RADIUS, 96, 96), earthMat);
  globeGroup.add(earth);

  /* ---------- Luces de ciudades (lado nocturno) ---------- */
  // Capa aditiva con la textura nocturna, atenuada hacia el lado iluminado
  const nightMat = new THREE.ShaderMaterial({
    uniforms: {
      nightMap: { value: null },
      sunDirection: { value: sun.position.clone().normalize() },
    },
    vertexShader: `
      varying vec2 vUv;
      varying vec3 vWorldNormal;
      void main() {
        vUv = uv;
        vWorldNormal = normalize(mat3(modelMatrix) * normal);
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
      }
    `,
    fragmentShader: `
      uniform sampler2D nightMap;
      uniform vec3 sunDirection;
      varying vec2 vUv;
      varying vec3 vWorldNormal;
      void main() {
        float nightFactor = clamp(-dot(normalize(vWorldNormal), normalize(sunDirection)), 0.0, 1.0);
        vec3 night = texture2D(nightMap, vUv).rgb;
        gl_FragColor = vec4(night * pow(nightFactor, 1.5) * 1.2, 1.0);
      }
    `,
    blending: THREE.AdditiveBlending,
    transparent: true,
    depthWrite: false,
  });

  loadTex(TEXTURES.night, (t) => {
    t.encoding = THREE.sRGBEncoding;
    nightMat.uniforms.nightMap.value = t;
    const nightMesh = new THREE.Mesh(new THREE.SphereGeometry(GLOBE_RADIUS * 1.001, 96, 96), nightMat);
    globeGroup.add(nightMesh);
  });

  /* ---------- Nubes ---------- */
  let clouds = null;
  loadTex(TEXTURES.clouds, (t) => {
    t.encoding = THREE.sRGBEncoding;
    const cloudMat = new THREE.MeshPhongMaterial({
      map: t,
      transparent: true,
      opacity: 0.55,
      depthWrite: false,
    });
    clouds = new THREE.Mesh(new THREE.SphereGeometry(GLOBE_RADIUS * 1.012, 96, 96), cloudMat);
    globeGroup.add(clouds);
  });

  /* ---------- Atmósfera (fresnel glow) ---------- */
  const atmosphereMat = new THREE.ShaderMaterial({
    uniforms: {
      glowColor: { value: new THREE.Color(0x3da9ff) },
    },
    vertexShader: `
      varying vec3 vNormal;
      void main() {
        vNormal = normalize(normalMatrix * normal);
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
      }
    `,
    fragmentShader: `
      uniform vec3 glowColor;
      varying vec3 vNormal;
      void main() {
        float intensity = pow(0.65 - dot(vNormal, vec3(0.0, 0.0, 1.0)), 3.5);
        gl_FragColor = vec4(glowColor, 1.0) * intensity;
      }
    `,
    side: THREE.BackSide,
    blending: THREE.AdditiveBlending,
    transparent: true,
    depthWrite: false,
  });
  const atmosphere = new THREE.Mesh(new THREE.SphereGeometry(GLOBE_RADIUS * 1.16, 64, 64), atmosphereMat);
  scene.add(atmosphere);

  // Halo interno sutil sobre la superficie
  const innerGlowMat = new THREE.ShaderMaterial({
    uniforms: { glowColor: { value: new THREE.Color(0x6fc3ff) } },
    vertexShader: atmosphereMat.vertexShader,
    fragmentShader: `
      uniform vec3 glowColor;
      varying vec3 vNormal;
      void main() {
        float intensity = pow(1.0 - abs(dot(vNormal, vec3(0.0, 0.0, 1.0))), 4.0);
        gl_FragColor = vec4(glowColor, 1.0) * intensity * 0.45;
      }
    `,
    blending: THREE.AdditiveBlending,
    transparent: true,
    depthWrite: false,
  });
  const innerGlow = new THREE.Mesh(new THREE.SphereGeometry(GLOBE_RADIUS * 1.002, 64, 64), innerGlowMat);
  globeGroup.add(innerGlow);

  /* Nota: se eliminó el campo de estrellas — llenaba el canvas cuadrado y
     marcaba sus bordes como un "cuadro". El fondo lo dan las partículas CSS. */

  /* ---------- Utilidades geográficas ---------- */
  function latLonToVector3(lat, lon, radius) {
    const phi = (90 - lat) * (Math.PI / 180);
    const theta = (lon + 180) * (Math.PI / 180);
    return new THREE.Vector3(
      -radius * Math.sin(phi) * Math.cos(theta),
      radius * Math.cos(phi),
      radius * Math.sin(phi) * Math.sin(theta)
    );
  }

  /* ---------- Marcadores ---------- */
  function createMarker(lat, lon, color) {
    const group = new THREE.Group();
    const pos = latLonToVector3(lat, lon, GLOBE_RADIUS * 1.005);

    const dot = new THREE.Mesh(
      new THREE.SphereGeometry(0.014, 16, 16),
      new THREE.MeshBasicMaterial({ color })
    );
    dot.position.copy(pos);
    group.add(dot);

    // Anillo pulsante orientado a la superficie
    const ring = new THREE.Mesh(
      new THREE.RingGeometry(0.02, 0.026, 32),
      new THREE.MeshBasicMaterial({ color, transparent: true, opacity: 0.8, side: THREE.DoubleSide })
    );
    ring.position.copy(pos);
    ring.lookAt(pos.clone().multiplyScalar(2));
    group.add(ring);

    // Columna de luz
    const beamHeight = 0.12;
    const beam = new THREE.Mesh(
      new THREE.CylinderGeometry(0.0025, 0.006, beamHeight, 8, 1, true),
      new THREE.MeshBasicMaterial({ color, transparent: true, opacity: 0.45 })
    );
    const beamPos = latLonToVector3(lat, lon, GLOBE_RADIUS * 1.005 + beamHeight / 2);
    beam.position.copy(beamPos);
    beam.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), beamPos.clone().normalize());
    group.add(beam);

    globeGroup.add(group);
    return { group, dot, ring, anchor: pos.clone() };
  }

  const laPazMarker = createMarker(LA_PAZ.lat, LA_PAZ.lon, 0x39ff14);
  let userMarker = null;
  let connectionArc = null;

  /* ---------- Red de comunidad: miembros conectados ----------
     Puntos discretos en ciudades de la región conectados a La Paz
     con arcos finos, simulando la comunidad GeoNexus activa. */
  const COMMUNITY_NODES = [
    { lat: -12.0464, lon: -77.0428, arc: true  },  // Lima
    { lat:   4.7110, lon: -74.0721, arc: true  },  // Bogotá
    { lat:  -0.1807, lon: -78.4678, arc: false },  // Quito
    { lat: -33.4489, lon: -70.6693, arc: true  },  // Santiago
    { lat: -34.6037, lon: -58.3816, arc: true  },  // Buenos Aires
    { lat:  19.4326, lon: -99.1332, arc: true  },  // CDMX
    { lat: -23.5505, lon: -46.6333, arc: false },  // São Paulo
    { lat:  40.4168, lon:  -3.7038, arc: true  },  // Madrid
    { lat:   9.9281, lon: -84.0907, arc: false },  // San José
    { lat: -17.7833, lon: -63.1821, arc: false },  // Santa Cruz
    { lat: -25.2637, lon: -57.5759, arc: false },  // Asunción
    { lat:  10.4806, lon: -66.9036, arc: false },  // Caracas
  ];

  const communityDots = [];
  COMMUNITY_NODES.forEach((node, i) => {
    const pos = latLonToVector3(node.lat, node.lon, GLOBE_RADIUS * 1.004);

    const dot = new THREE.Mesh(
      new THREE.SphereGeometry(0.0085, 10, 10),
      new THREE.MeshBasicMaterial({ color: 0x00e5ff, transparent: true, opacity: 0.85 })
    );
    dot.position.copy(pos);
    dot.userData.phase = i * 0.7; // desfase para parpadeo orgánico
    globeGroup.add(dot);
    communityDots.push(dot);

    if (node.arc) {
      const start = latLonToVector3(node.lat, node.lon, GLOBE_RADIUS * 1.004);
      const end = latLonToVector3(LA_PAZ.lat, LA_PAZ.lon, GLOBE_RADIUS * 1.004);
      const dist = start.distanceTo(end);
      const mid = start.clone().add(end).multiplyScalar(0.5)
        .normalize()
        .multiplyScalar(GLOBE_RADIUS * (1.03 + dist * 0.25));
      const curve = new THREE.QuadraticBezierCurve3(start, mid, end);
      const arc = new THREE.Mesh(
        new THREE.TubeGeometry(curve, 48, 0.0018, 6, false),
        new THREE.MeshBasicMaterial({ color: 0x00e5ff, transparent: true, opacity: 0.22 })
      );
      globeGroup.add(arc);
    }
  });

  /* ---------- Arco entre dos puntos ---------- */
  function createArc(latA, lonA, latB, lonB, color) {
    const start = latLonToVector3(latA, lonA, GLOBE_RADIUS * 1.005);
    const end = latLonToVector3(latB, lonB, GLOBE_RADIUS * 1.005);
    const dist = start.distanceTo(end);
    const mid = start.clone().add(end).multiplyScalar(0.5)
      .normalize()
      .multiplyScalar(GLOBE_RADIUS * (1.05 + dist * 0.35));

    const curve = new THREE.QuadraticBezierCurve3(start, mid, end);
    const tube = new THREE.Mesh(
      new THREE.TubeGeometry(curve, 64, 0.004, 8, false),
      new THREE.MeshBasicMaterial({ color, transparent: true, opacity: 0.0 })
    );
    globeGroup.add(tube);

    // Partícula viajera sobre el arco
    const traveler = new THREE.Mesh(
      new THREE.SphereGeometry(0.011, 12, 12),
      new THREE.MeshBasicMaterial({ color: 0xffffff })
    );
    globeGroup.add(traveler);

    return { curve, tube, traveler, progress: 0, fadeIn: 0 };
  }

  /* ---------- Etiquetas HTML que siguen marcadores ---------- */
  const laPazLabel = document.getElementById('la-paz-label');
  const userLabel = document.getElementById('user-label');
  const projVec = new THREE.Vector3();

  function updateLabel(labelEl, anchorLocal) {
    if (!labelEl) return;
    projVec.copy(anchorLocal).applyMatrix4(globeGroup.matrixWorld);

    // Ocultar si el punto está en la cara oculta del globo
    const toCamera = camera.position.clone().sub(projVec).normalize();
    const surfaceNormal = projVec.clone().normalize();
    const facing = surfaceNormal.dot(toCamera);

    projVec.project(camera);
    const x = (projVec.x * 0.5 + 0.5) * container.clientWidth;
    const y = (-projVec.y * 0.5 + 0.5) * container.clientHeight;

    if (facing > 0.12) {
      labelEl.classList.add('visible');
      const offY = labelEl.dataset.offsetY ? parseInt(labelEl.dataset.offsetY, 10) : -14;
      labelEl.style.transform = `translate(${Math.round(x + 16)}px, ${Math.round(y + offY)}px)`;
    } else {
      labelEl.classList.remove('visible');
    }
  }

  /* ---------- Geolocalización del usuario ---------- */
  function reverseGeocode(lat, lon) {
    // Servicio gratuito pensado para uso client-side, sin API key
    return fetch(`https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${lat}&longitude=${lon}&localityLanguage=es`)
      .then((r) => r.json())
      .then((d) => d.city || d.locality || d.principalSubdivision || '')
      .catch(() => '');
  }

  function initGeolocation() {
    if (!('geolocation' in navigator)) return;

    navigator.geolocation.getCurrentPosition(
      (pos) => {
        const { latitude, longitude } = pos.coords;

        // ¿El visitante está en La Paz (o muy cerca)? Si los dos marcadores
        // caen en el mismo punto, los badges se encimaban. En ese caso se
        // fusionan en una sola etiqueta y no se crea marcador ni arco extra.
        const nearLaPaz =
          Math.hypot(latitude - LA_PAZ.lat, longitude - LA_PAZ.lon) < 1.2; // ~130 km

        if (nearLaPaz) {
          // El visitante está en La Paz: la etiqueta existente ya identifica
          // el punto, no se duplica marcador, arco ni texto.
        } else {
          userMarker = createMarker(latitude, longitude, 0x00e5ff);
          connectionArc = createArc(latitude, longitude, LA_PAZ.lat, LA_PAZ.lon, 0x00e5ff);
          // Etiqueta del usuario debajo del marcador (La Paz va arriba)
          if (userLabel) userLabel.dataset.offsetY = '12';

          // Mostrar el nombre real del lugar del visitante
          reverseGeocode(latitude, longitude).then((name) => {
            if (name && userLabel) userLabel.textContent = name.toUpperCase();
          });
        }

        // Girar suavemente el globo hacia el usuario
        const targetY = -((longitude + 180) * Math.PI / 180) + Math.PI * 0.5;
        rotationTarget = { active: true, y: targetY, x: THREE.MathUtils.degToRad(latitude) * 0.35 };
      },
      () => { /* Permiso denegado o error: el globo funciona igual */ },
      { enableHighAccuracy: false, timeout: 8000, maximumAge: 600000 }
    );
  }

  /* ---------- Interacción: arrastre con inercia ---------- */
  let isDragging = false;
  let lastX = 0, lastY = 0;
  let velX = 0, velY = 0;
  let rotX = 0.15;           // inclinación inicial
  let rotY = 4.4;            // mostrar Sudamérica de inicio
  let autoRotate = !prefersReducedMotion;
  let rotationTarget = { active: false, x: 0, y: 0 };
  let idleTimer = null;

  const dom = renderer.domElement;

  function pointerDown(x, y) {
    isDragging = true;
    autoRotate = false;
    rotationTarget.active = false;
    lastX = x; lastY = y;
    clearTimeout(idleTimer);
  }
  function pointerMove(x, y) {
    if (!isDragging) return;
    const dx = x - lastX;
    const dy = y - lastY;
    velY = dx * 0.005;
    velX = dy * 0.0035;
    rotY += velY;
    rotX += velX;
    rotX = THREE.MathUtils.clamp(rotX, -1.1, 1.1);
    lastX = x; lastY = y;
  }
  function pointerUp() {
    if (!isDragging) return;
    isDragging = false;
    // Reanudar auto-rotación tras 4s de inactividad
    idleTimer = setTimeout(() => { if (!prefersReducedMotion) autoRotate = true; }, 4000);
  }

  dom.addEventListener('mousedown', (e) => pointerDown(e.clientX, e.clientY));
  window.addEventListener('mousemove', (e) => pointerMove(e.clientX, e.clientY));
  window.addEventListener('mouseup', pointerUp);

  dom.addEventListener('touchstart', (e) => {
    if (e.touches.length === 1) pointerDown(e.touches[0].clientX, e.touches[0].clientY);
  }, { passive: true });
  dom.addEventListener('touchmove', (e) => {
    if (e.touches.length === 1) pointerMove(e.touches[0].clientX, e.touches[0].clientY);
  }, { passive: true });
  dom.addEventListener('touchend', pointerUp);

  /* ---------- Resize ---------- */
  function resize() {
    const w = container.clientWidth;
    const h = container.clientHeight;
    renderer.setSize(w, h);
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
  }
  resize();
  window.addEventListener('resize', resize);

  /* ---------- Animación ---------- */
  let paused = false;
  document.addEventListener('visibilitychange', () => {
    paused = document.hidden;
  });

  const clock = new THREE.Clock();

  function animate() {
    requestAnimationFrame(animate);
    if (paused) return;

    const dt = Math.min(clock.getDelta(), 0.05);
    const t = clock.elapsedTime;

    // Auto-rotación / inercia / acercamiento a objetivo
    if (rotationTarget.active) {
      rotY += (rotationTarget.y - rotY) * 0.04;
      rotX += (rotationTarget.x - rotX) * 0.04;
      if (Math.abs(rotationTarget.y - rotY) < 0.005) {
        rotationTarget.active = false;
        idleTimer = setTimeout(() => { if (!prefersReducedMotion) autoRotate = true; }, 5000);
      }
    } else if (autoRotate) {
      rotY += dt * 0.07;
    } else if (!isDragging) {
      // inercia con fricción
      rotY += velY;
      rotX = THREE.MathUtils.clamp(rotX + velX, -1.1, 1.1);
      velY *= 0.94;
      velX *= 0.94;
    }

    globeGroup.rotation.y = rotY;
    globeGroup.rotation.x = rotX;

    // Nubes derivan lentamente respecto a la tierra
    if (clouds) clouds.rotation.y += dt * 0.012;

    // Pulso de anillos de marcadores
    const pulse = 1 + Math.sin(t * 2.4) * 0.35;
    laPazMarker.ring.scale.setScalar(pulse);
    laPazMarker.ring.material.opacity = 0.85 - (pulse - 1) * 1.4;
    if (userMarker) {
      userMarker.ring.scale.setScalar(pulse);
      userMarker.ring.material.opacity = 0.85 - (pulse - 1) * 1.4;
    }

    // Parpadeo orgánico de los nodos de comunidad (desfasados)
    communityDots.forEach((d) => {
      d.material.opacity = 0.55 + Math.sin(t * 1.8 + d.userData.phase) * 0.3;
    });

    // Arco: fade-in + partícula viajera
    if (connectionArc) {
      if (connectionArc.fadeIn < 0.55) {
        connectionArc.fadeIn += dt * 0.3;
        connectionArc.tube.material.opacity = connectionArc.fadeIn;
      }
      connectionArc.progress = (connectionArc.progress + dt * 0.25) % 1;
      const p = connectionArc.curve.getPoint(connectionArc.progress);
      connectionArc.traveler.position.copy(p);
    }

    globeGroup.updateMatrixWorld();
    updateLabel(laPazLabel, laPazMarker.anchor);
    if (userMarker) updateLabel(userLabel, userMarker.anchor);

    renderer.render(scene, camera);
  }

  animate();
  initGeolocation();
})();
