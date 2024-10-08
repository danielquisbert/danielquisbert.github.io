import 'package:get/get.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class WindowData {
  final Widget content;
  final String title;

  WindowData(this.content, this.title);
}

class HomeController extends GetxController {
  final currentTime = ''.obs;
  late Timer _timer;
  final windows = <WindowData>[].obs;
  final currentWindowIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _updateTime();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
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

  void openWindow(Widget windowContent, String title) {
    final windowData = WindowData(windowContent, title);
    final existingIndex = windows.indexWhere((window) => window.title == title);
    if (existingIndex != -1) {
      currentWindowIndex.value = existingIndex;
    } else {
      windows.add(windowData);
      currentWindowIndex.value = windows.length - 1;
    }
  }

  void closeCurrentWindow() {
    if (currentWindowIndex.value != -1) {
      windows.removeAt(currentWindowIndex.value);
      if (windows.isEmpty) {
        currentWindowIndex.value = -1;
      } else {
        currentWindowIndex.value = windows.length - 1;
      }
    }
  }
}
