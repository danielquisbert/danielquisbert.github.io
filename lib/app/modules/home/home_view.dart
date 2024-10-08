import 'package:danielquisbert_github_io/app/modules/blog/blog_view.dart';
import 'package:danielquisbert_github_io/app/modules/portafolio/portafolio_view.dart';
import 'package:danielquisbert_github_io/app/modules/terminal/terminal_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../themes/app_theme.dart';
import '../direccion/direccion_view.dart';
import '../experiencia/experiencia_view.dart';
import 'home_controller.dart';


class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Row(
                children: [
                  _buildSidebar(),
                  Expanded(
                    child: Navigator(
                      key: Get.nestedKey(1),
                      onGenerateRoute: (settings) {
                        switch (settings.name) {
                          case Routes.DIRECCION:
                            return GetPageRoute(page: () => DireccionView());
                          case Routes.EXPERIENCIA:
                            return GetPageRoute(page: () => ExperienciaView());
                          case Routes.PORTAFOLIO:
                            return GetPageRoute(page: () => PortafolioView());
                          case Routes.BLOG:
                            return GetPageRoute(page: () => BlogView());
                          case Routes.TERMINAL:
                            return GetPageRoute(page: () => TerminalView());
                          
                          default:
                            return GetPageRoute(page: () => _buildDesktop());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTopBar() {
    return Container(
      color: Colors.white.withOpacity(0.8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.apple, color: Colors.black),
              SizedBox(width: 16),
              Text('Finder', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(width: 16),
              Text('File', style: TextStyle(color: Colors.black)),
              SizedBox(width: 16),
              Text('Edit', style: TextStyle(color: Colors.black)),
              SizedBox(width: 16),
              Text('View', style: TextStyle(color: Colors.black)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.wifi, color: Colors.black),
              SizedBox(width: 8),
              Icon(Icons.battery_full, color: Colors.black),
              SizedBox(width: 8),
              Obx(() => Text(controller.currentTime.value, 
                style: TextStyle(color: Colors.black, fontSize: 14)
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 200,
      color: AppTheme.sidebarColor,
      child: ListView(
        children: [
          SizedBox(height: 16),
          _sidebarItem(Icons.home, 'Home', Routes.HOME),
          _sidebarItem(Icons.person, 'Dirección', Routes.DIRECCION),
          _sidebarItem(Icons.work, 'Experiencia', Routes.EXPERIENCIA),
          _sidebarItem(Icons.folder, 'Portafolio', Routes.PORTAFOLIO),
          _sidebarItem(Icons.article, 'Blog', Routes.BLOG),
          _sidebarItem(Icons.terminal, 'Terminal', Routes.TERMINAL),
          Divider(),
          _sidebarItem(Icons.settings, 'Configuración', Routes.CONFIGURACION),
        ],
      ),
    );
  }

  
  Widget _sidebarItem(IconData icon, String label, String route) {
  return ListTile(
    leading: Icon(icon, color: AppTheme.accentColor),
    title: Text(label, style: TextStyle(color: Colors.black87)),
    onTap: () => Get.toNamed(route),
  );
}

  Widget _buildDesktop() {
    return Container(
      padding: EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _desktopIcon(Icons.folder, 'Documents'),
          _desktopIcon(Icons.photo, 'Pictures'),
          _desktopIcon(Icons.music_note, 'Music'),
          _desktopIcon(Icons.video_library, 'Videos'),
          _desktopIcon(Icons.computer, 'Applications'),
        ],
      ),
    );
  }

  Widget _desktopIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, size: 36, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.black87)),
      ],
    );
  }
}