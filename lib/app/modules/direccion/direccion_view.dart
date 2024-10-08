import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'direccion_controller.dart';
import '../../themes/app_theme.dart';

class DireccionView extends GetView<DireccionController> {
  const DireccionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dirección'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => _buildInfoTile(Icons.location_on, 'Dirección',
                    controller.direccion.value)),
                const Divider(color: Colors.white24),
                Obx(() => _buildInfoTile(
                    Icons.phone, 'Teléfono', controller.telefono.value)),
                const Divider(color: Colors.white24),
                Obx(() => _buildInfoTile(
                    Icons.email, 'Email', controller.email.value)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.accentColor),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white)),
    );
  }
}
