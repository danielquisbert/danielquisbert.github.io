import 'package:get/get.dart';

class PortafolioController extends GetxController {
  final proyectos = <Proyecto>[].obs;

  @override
  void onInit() {
    super.onInit();
    cargarProyectos();
  }

  void cargarProyectos() {
    proyectos.assignAll([
      Proyecto(
        nombre: 'App ge0tic',
        descripcion: 'Aplicación educativa con juegos de mapas',
        imagenUrl:
            'https://dummyimage.com/300x200/3498db/ffffff&text=App+ge0tic',
        url:
            'https://play.google.com/store/apps/details?id=com.ge0tic.bo&hl=es_BO',
        tecnologias: ['Flutter', 'Mapas', 'Juegos educativos'],
      ),
      Proyecto(
        nombre: 'ARTEC App',
        descripcion:
            'App móvil para centro de capacitación con inscripción a cursos',
        imagenUrl:
            'https://dummyimage.com/300x200/3498db/ffffff&text=ARTEC+App',
        url: 'https://play.google.com/store/apps/details?id=com.artec.bo',
        tecnologias: ['Flutter', 'Firebase', 'Gestión de cursos'],
      ),
      Proyecto(
        nombre: 'AsistenciApp',
        descripcion: 'Aplicación para registrar asistencias',
        imagenUrl:
            'https://dummyimage.com/300x200/3498db/ffffff&text=AsistenciApp',
        url:
            'https://play.google.com/store/apps/details?id=com.gecko.asistencias',
        tecnologias: [
          'Flutter',
          'Base de datos local',
          'Gestión de asistencias'
        ],
      ),
      Proyecto(
        nombre: 'AppLuz',
        descripcion: 'App para consumidores de servicio eléctrico en La Paz',
        imagenUrl: 'https://dummyimage.com/300x200/3498db/ffffff&text=AppLuz',
        url: 'https://play.google.com/store/search?q=appluz&c=apps&hl=es_BO',
        tecnologias: ['Flutter', 'Pagos QR', 'Gestión de consumo eléctrico'],
      ),
      Proyecto(
        nombre: 'DELBENI Móvil',
        descripcion: 'Aplicación para calcular el consumo eléctrico',
        imagenUrl:
            'https://dummyimage.com/300x200/3498db/ffffff&text=DELBENI+Móvil',
        url:
            'https://play.google.com/store/apps/details?id=com.endetecnologias.appedb&hl=es_BO',
        tecnologias: ['Flutter', 'Cálculos de consumo', 'UX/UI'],
      ),
      Proyecto(
        nombre: 'Sitio ge0tic',
        descripcion: 'Sitio web con información del proyecto y juegos de mapas',
        imagenUrl:
            'https://dummyimage.com/300x200/3498db/ffffff&text=Sitio+ge0tic',
        url: 'https://ge0tic.github.io/',
        tecnologias: ['HTML', 'CSS', 'JavaScript', 'Mapas interactivos'],
      ),
      Proyecto(
        nombre: 'Sitio web ARTEC',
        descripcion:
            'Sitio web con CMS Spip, generador de certificados y gestión de inscripciones',
        imagenUrl:
            'https://dummyimage.com/300x200/3498db/ffffff&text=Sitio+web+ARTEC',
        url: 'https://arte-tecnologias.com/',
        tecnologias: [
          'SPIP CMS',
          'PHP',
          'Certificados digitales',
          'Gestión de inscripciones'
        ],
      ),
    ]);
  }
}

class Proyecto {
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final String url;
  final List<String> tecnologias;

  Proyecto({
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    required this.url,
    required this.tecnologias,
  });
}
