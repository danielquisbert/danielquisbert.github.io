import 'package:get/get.dart';
import 'experiencia_controller.dart';

class ExperienciaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExperienciaController>(() => ExperienciaController());
  }
}