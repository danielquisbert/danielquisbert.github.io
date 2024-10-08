import 'package:get/get.dart';
import 'direccion_controller.dart';

class DireccionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DireccionController>(() => DireccionController());
  }
}