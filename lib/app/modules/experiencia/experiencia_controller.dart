import 'package:get/get.dart';

class ExperienciaController extends GetxController {
  final experiencias = <Experiencia>[].obs;

  @override
  void onInit() {
    super.onInit();
    cargarExperiencias();
  }

  void cargarExperiencias() {
    experiencias.assignAll([
      Experiencia('Desarrollador Senior', 'Empresa A', '2020 - Presente', 'Desarrollo de aplicaciones web y móviles utilizando Flutter y React.'),
      Experiencia('Desarrollador Full Stack', 'Empresa B', '2018 - 2020', 'Implementación de soluciones end-to-end utilizando Node.js y Angular.'),
      Experiencia('Desarrollador Junior', 'Empresa C', '2016 - 2018', 'Mantenimiento y mejora de aplicaciones existentes en Java y PHP.'),
    ]);
  }
}

class Experiencia {
  final String puesto;
  final String empresa;
  final String periodo;
  final String descripcion;

  Experiencia(this.puesto, this.empresa, this.periodo, this.descripcion);
}