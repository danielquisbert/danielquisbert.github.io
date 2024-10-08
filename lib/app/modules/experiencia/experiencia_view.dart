import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'experiencia_controller.dart';
import '../../themes/app_theme.dart';

class ExperienciaView extends GetView<ExperienciaController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Experiencia'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<ExperienciaController>(
        init: ExperienciaController(), // Inicializa el controlador aquí si es necesario
        builder: (controller) {
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.experiencias.length,
            itemBuilder: (context, index) {
              final exp = controller.experiencias[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.work, color: AppTheme.accentColor),
                  ),
                  title: Text(exp.puesto, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(exp.empresa),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exp.periodo, style: TextStyle(fontStyle: FontStyle.italic)),
                          SizedBox(height: 8),
                          Text(exp.descripcion),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}