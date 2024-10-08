import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../blog/blog_view.dart';
import '../experiencia/experiencia_view.dart';
import '../portafolio/portafolio_view.dart';
import '../terminal/terminal_view.dart';
import 'home_controller.dart';
import '../../themes/app_theme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/map_background.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopBar(),
                Expanded(child: _buildWindowArea()),
                _buildDock(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return AppBar(
      backgroundColor: Colors.black.withOpacity(0.8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.apple, color: Colors.white),
              SizedBox(width: 16),
              Text('Finder', style: TextStyle(color: Colors.white)),
              SizedBox(width: 16),
              Text('File', style: TextStyle(color: Colors.white)),
              SizedBox(width: 16),
              Text('Edit', style: TextStyle(color: Colors.white)),
              SizedBox(width: 16),
              Text('View', style: TextStyle(color: Colors.white)),
            ],
          ),
          Obx(() => Text(controller.currentTime.value,
              style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildWindowArea() {
    return Obx(() => IndexedStack(
          index: controller.currentWindowIndex.value,
          children: controller.windows.map((window) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
              child: Column(
                children: [
                  _buildWindowTopBar(window.title),
                  Expanded(child: window.content),
                ],
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildWindowTopBar(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                onPressed: () => controller.closeCurrentWindow(),
                color: Colors.red,
              ),
              IconButton(
                icon: const Icon(Icons.remove, size: 16),
                onPressed: () {},
                color: Colors.yellow,
              ),
              IconButton(
                icon: const Icon(Icons.crop_square, size: 16),
                onPressed: () {},
                color: Colors.green,
              ),
            ],
          ),
          Text(title, style: const TextStyle(color: Colors.white)),
          const SizedBox(width: 80),
        ],
      ),
    );
  }

  Widget _buildDock() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dockIcon(Icons.work, 'Experiencia', () => _openExperiencia()),
          _dockIcon(Icons.folder, 'Portafolio', () => _openPortafolio()),
          _dockIcon(Icons.terminal, 'Terminal', () => _openTerminal()),
          _dockIcon(Icons.article, 'Blog', () => _openBlog()),
        ],
      ),
    );
  }

  Widget _dockIcon(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Tooltip(
        message: label,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 30, color: Colors.white),
              ),
              const Gap(4),
              Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  void _openExperiencia() {
    controller.openWindow(const ExperienciaView(), 'Experiencia');
  }

  void _openPortafolio() {
    controller.openWindow(const PortafolioView(), 'Portafolio');
  }

  void _openTerminal() {
    controller.openWindow(const TerminalView(), 'Terminal');
  }

  void _openBlog() {
    controller.openWindow(const BlogView(), 'Blog');
  }
}
