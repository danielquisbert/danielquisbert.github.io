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
      Proyecto('App de Fitness', 'Aplicación móvil para seguimiento de rutinas', 'https://ejemplo.com/fitness-app.jpg'),
      Proyecto('E-commerce', 'Plataforma de comercio electrónico', 'https://ejemplo.com/ecommerce.jpg'),
      Proyecto('Sistema de Gestión', 'Software de gestión empresarial', 'https://ejemplo.com/gestion.jpg'),
      Proyecto('Juego Móvil', 'Juego casual para Android e iOS', 'https://ejemplo.com/juego.jpg'),
    ]);
  }
}

class Proyecto {
  final String nombre;
  final String descripcion;
  final String imagenUrl;

  Proyecto(this.nombre, this.descripcion, this.imagenUrl);
}