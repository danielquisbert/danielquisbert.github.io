import 'package:get/get.dart';
import 'portafolio_controller.dart';

class PortafolioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PortafolioController>(() => PortafolioController());
  }
}