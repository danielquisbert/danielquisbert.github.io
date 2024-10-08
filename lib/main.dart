import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/themes/app_theme.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "danielquisbert",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.macosDarkTheme,
      debugShowCheckedModeBanner: false,
    ),
  );
}
