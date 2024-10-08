import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'experiencia_controller.dart';
import '../../themes/app_theme.dart';

class ExperienciaView extends GetView<ExperienciaController> {
  const ExperienciaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiencia'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<ExperienciaController>(
        init:
            ExperienciaController(), // Inicializa el controlador aquí si es necesario
        builder: (controller) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.experiencias.length,
            itemBuilder: (context, index) {
              final exp = controller.experiencias[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.work, color: AppTheme.accentColor),
                  ),
                  title: Text(exp.puesto,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(exp.empresa),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exp.periodo,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic)),
                          const Gap(8),
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
