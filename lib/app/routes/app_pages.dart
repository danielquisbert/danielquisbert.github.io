import 'package:get/get.dart';
import '../modules/direccion/direccion_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/direccion/direccion_binding.dart';

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
  // ignore: constant_identifier_names
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.DIRECCION,
      page: () => const DireccionView(),
      binding: DireccionBinding(),
    ),
    GetPage(
      name: Routes.EXPERIENCIA,
      page: () => const ExperienciaView(),
      binding: ExperienciaBinding(),
    ),
    GetPage(
      name: Routes.PORTAFOLIO,
      page: () => const PortafolioView(),
      binding: PortafolioBinding(),
    ),
    GetPage(
      name: Routes.BLOG,
      page: () => const BlogView(),
      binding: BlogBinding(),
    ),
    GetPage(
      name: Routes.TERMINAL,
      page: () => const TerminalView(),
      binding: TerminalBinding(),
    ),
    // Añade las demás rutas aquí (Configuración, Correo, Calendario)
  ];
}
