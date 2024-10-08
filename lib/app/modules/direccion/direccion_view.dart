import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'direccion_controller.dart';
import '../../themes/app_theme.dart';

class DireccionView extends GetView<DireccionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dirección'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Obx(() => _buildInfoTile(Icons.location_on, 'Dirección', controller.direccion.value)),
                      Divider(),
                      Obx(() => _buildInfoTile(Icons.phone, 'Teléfono', controller.telefono.value)),
                      Divider(),
                      Obx(() => _buildInfoTile(Icons.email, 'Email', controller.email.value)),
                    ],
                  ),
                ),
              ),
            ],
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
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}