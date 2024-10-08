import 'package:get/get.dart';

class ExperienciaController extends GetxController {
  final experiencias = <Experiencia>[].obs;
  final educacion = <Educacion>[].obs;
  final ponencias = <Ponencia>[].obs;
  final certificaciones = <String>[].obs;

  final String name = 'Daniel M. Quisbert Calle';
  final String title =
      'Ingeniero de Software | Desarrollador Flutter | Líder de Proyectos';
  final String contact =
      'dani3l.quisb3rt@gmail.com | +591 671 45303 | La Paz, Bolivia';
  final String photoAssetPath = 'assets/images/profile_photo.jpg';
  final String professionalSummary =
      'Ingeniero de software con más de 15 años de experiencia en el sector tecnológico, enfocado en desarrollo móvil con Flutter y gestión de proyectos. Experiencia en liderazgo de equipos de desarrollo y entrega de soluciones tecnológicas. Conocimientos en tecnologías geoespaciales y sistemas de información, con aplicaciones en diversos sectores como el eléctrico, gubernamental y educativo.';

  @override
  void onInit() {
    super.onInit();
    cargarExperiencias();
    cargarEducacion();
    cargarPonencias();
    cargarCertificaciones();
  }

  void cargarExperiencias() {
    experiencias.assignAll([
      Experiencia(
        puesto: 'Gestor de Proyectos',
        empresa: 'ENDE SERVICIOS Y CONSTRUCCIONES S.A.',
        periodo: 'Enero 2024 - Presente',
        descripcion:
            'Coordinación del desarrollo de aplicaciones móviles y frontend para proyectos de ENDE Corporación. Responsable de la planificación, ejecución y entrega de soluciones tecnológicas.',
        habilidades: [
          'Flutter',
          'Gestión de Proyectos',
          'Desarrollo Frontend',
          'Análisis de Sistemas'
        ],
      ),
      Experiencia(
        puesto: 'Ingeniero de Software',
        empresa: 'ENDE TECNOLOGÍAS S.A.',
        periodo: '2017 - 2023',
        descripcion:
            'Desarrollo de aplicaciones Flutter para la corporación ENDE, incluyendo AppLuz y DELBENI Móvil. Implementación de funcionalidades como autenticación JWT, integración de mapas, generación de QR para pagos y notificaciones push con Firebase.',
        habilidades: [
          'Flutter',
          'JWT',
          'Firebase',
          'Mapas OSM/Google',
          'Generación QR',
          'Desarrollo móvil'
        ],
      ),
      Experiencia(
        puesto: 'Desarrollador Freelance',
        empresa: 'ARTEC Arte & Tecnologías',
        periodo: 'Diciembre 2023 - Junio 2024',
        descripcion: 'Desarrollo de sitio web con SPIP CMS y aplicación móvil.',
        habilidades: [
          'SPIP CMS',
          'Desarrollo Web',
          'Desarrollo de Apps Móviles',
          'Google Play Store'
        ],
      ),
      Experiencia(
        puesto: 'Desarrollador Freelance',
        empresa: 'RENZOCORREDOR',
        periodo: 'Octubre 2021 - Octubre 2022',
        descripcion:
            'Desarrollo del sitio web de la Registraduría Nacional del Estado de Colombia utilizando CMS Spip.',
        habilidades: ['SPIP CMS', 'Desarrollo Web', 'Gestión de Contenidos'],
      ),
      Experiencia(
        puesto: 'Administrador de Bases de Datos PostgreSQL',
        empresa: 'Autoridad de Pensiones y Seguros - APS',
        periodo: 'Octubre 2016 - Diciembre 2016',
        descripcion:
            'Coordinación del equipo técnico para la migración de información de aportes de AFP a PostgreSQL.',
        habilidades: [
          'PostgreSQL',
          'Migración de Datos',
          'Coordinación de Equipo'
        ],
      ),
      Experiencia(
        puesto: 'Especialista en Procesamiento de Base de Datos',
        empresa: 'Instituto Nacional de Estadística - INE',
        periodo: 'Junio 2016 - Septiembre 2016',
        descripcion:
            'Coordinación del equipo técnico informático de 60 personas. Capacitación en uso de dispositivos móviles y gestión de infraestructura TI para sistemas de encuestas.',
        habilidades: [
          'Gestión de Equipos',
          'Capacitación',
          'Infraestructura TI'
        ],
      ),
      Experiencia(
        puesto: 'Responsable de la Plataforma GeoFAO',
        empresa:
            'FAO - Organización de las Naciones Unidas para la Alimentación y la Agricultura',
        periodo: 'Febrero 2016 - Mayo 2016',
        descripcion:
            'Coordinación multidisciplinaria para recolección y publicación de información agrícola. Implementación y administración de la plataforma geográfica GeoFAO.',
        habilidades: [
          'Sistemas de Información Geográfica',
          'Coordinación de Proyectos',
          'GeoFAO'
        ],
      ),
      Experiencia(
        puesto: 'Analista de Sistemas de Información Geográfica',
        empresa: 'CADEB S.A.',
        periodo: 'Enero 2015 - Enero 2016',
        descripcion:
            'Desarrollo del sistema de gestión de reclamos técnicos utilizando Genexus, OpenLayers y Android.',
        habilidades: ['Genexus', 'OpenLayers', 'Android', 'SIG'],
      ),
      Experiencia(
        puesto: 'Consultor Informático',
        empresa: 'GeoBolivia',
        periodo: 'Octubre 2012 - Enero 2015',
        descripcion:
            'Desarrollo de scripts bash, visores de mapas temáticos en OpenLayers y CMS Spip. Actualización del IDE geOrchestra v16.4.',
        habilidades: ['Bash', 'OpenLayers', 'SPIP CMS', 'geOrchestra'],
      ),
    ]);
  }

  void cargarEducacion() {
    educacion.assignAll([
      Educacion(
        titulo: 'Maestría en TI y Seguridad Informática (Egresado)',
        institucion: 'Universidad Autónoma del Beni "José Ballivián"',
        periodo: 'Febrero 2021 - Diciembre 2022',
      ),
      Educacion(
        titulo: 'Diplomado en Sistemas de Información Geográfica',
        institucion: 'UMSA, La Paz',
        periodo: 'Mayo 2017 - Diciembre 2017',
      ),
      Educacion(
        titulo:
            'Licenciado en Informática, mención en Ingeniería de Sistemas Informáticos',
        institucion: 'UMSA, La Paz',
        periodo: 'Agosto 2007 - Diciembre 2014',
      ),
    ]);
  }

  void cargarPonencias() {
    ponencias.assignAll([
      Ponencia(
        titulo:
            'Tecnologías geoespaciales en la industria del sector eléctrico',
        evento: 'UMSA - Carrera de informática',
        tipo: 'Nacional',
      ),
      Ponencia(
        titulo:
            'Sistemas de Información Geográfica y servicios web geográficos',
        evento: 'UMSA - Carrera de informática',
        tipo: 'Nacional',
      ),
      Ponencia(
        titulo: 'Sistemas de Información Geográfica - GIS',
        evento: 'UMSA – Sociedad Científica Estudiantil',
        tipo: 'Nacional',
      ),
      Ponencia(
        titulo:
            'Instalación y configuración del mapa OpenStreetMap para Offline en Linux',
        evento:
            'State of the Map Latam 2017 - OpenStreetMap Perú, Universidad Nacional Mayor de San Marcos, Lima',
        tipo: 'Internacional',
      ),
    ]);
  }

  void cargarCertificaciones() {
    certificaciones.assignAll([
      'Gestión de proyectos (según guía del PMBOK del PMI), Tekhne',
      'Flutter Certified Application Developer',
      'Desarrollo en Android',
      'Taller Introductorio Tecnología SmallWorld',
      'Desarrollo web con CodeIgniter (framework PHP)',
      'Hibernate Framework Java, Educomser',
      'PostgreSQL, Educomser',
      'Instalación y configuración de servidores DNS, Vicepresidencia del Estado Plurinacional de Bolivia - ADSIB',
      'Módulo I DBA ORACLE, Fundación PROYDESA',
    ]);
  }
}

class Experiencia {
  final String puesto;
  final String empresa;
  final String periodo;
  final String descripcion;
  final List<String> habilidades;

  Experiencia({
    required this.puesto,
    required this.empresa,
    required this.periodo,
    required this.descripcion,
    required this.habilidades,
  });
}

class Educacion {
  final String titulo;
  final String institucion;
  final String periodo;

  Educacion({
    required this.titulo,
    required this.institucion,
    required this.periodo,
  });
}

class Ponencia {
  final String titulo;
  final String evento;
  final String tipo;

  Ponencia({
    required this.titulo,
    required this.evento,
    required this.tipo,
  });
}
