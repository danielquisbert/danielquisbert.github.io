import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final currentTime = ''.obs;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _updateTime());
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }

  void _updateTime() {
    final now = DateTime.now();
    currentTime.value = DateFormat('EEE MMM d  h:mm a').format(now);
  }
}