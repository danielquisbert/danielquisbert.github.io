import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/themes/app_theme.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Mi Portfolio",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.macosTheme,
      debugShowCheckedModeBanner: false,
    ),
  );
}