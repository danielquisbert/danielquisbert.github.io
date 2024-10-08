import 'package:get/get.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/direccion/direccion_binding.dart';
import '../modules/direccion/direccion_view.dart';
import '../modules/experiencia/experiencia_binding.dart';
import '../modules/experiencia/experiencia_view.dart';
import '../modules/portafolio/portafolio_binding.dart';
import '../modules/portafolio/portafolio_view.dart';
import '../modules/blog/blog_binding.dart';
import '../modules/blog/blog_view.dart';
import '../modules/terminal/terminal_binding.dart';
import '../modules/terminal/terminal_view.dart';
// Importa los demás módulos aquí

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.DIRECCION,
      page: () => DireccionView(),
      binding: DireccionBinding(),
    ),
    GetPage(
      name: Routes.EXPERIENCIA,
      page: () => ExperienciaView(),
      binding: ExperienciaBinding(),
    ),
    GetPage(
      name: Routes.PORTAFOLIO,
      page: () => PortafolioView(),
      binding: PortafolioBinding(),
    ),
    GetPage(
      name: Routes.BLOG,
      page: () => BlogView(),
      binding: BlogBinding(),
    ),
    GetPage(
      name: Routes.TERMINAL,
      page: () => TerminalView(),
      binding: TerminalBinding(),
    ),
    // Añade las demás rutas aquí (Configuración, Correo, Calendario)
  ];
}