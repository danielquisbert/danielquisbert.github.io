import 'package:get/get.dart';
import 'terminal_controller.dart';

class TerminalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TerminalController>(() => TerminalController());
  }
}