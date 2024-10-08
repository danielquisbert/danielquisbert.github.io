import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'portafolio_controller.dart';

class PortafolioView extends GetView<PortafolioController> {
  const PortafolioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portafolio'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<PortafolioController>(
        init: PortafolioController(),
        builder: (controller) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.proyectos.length,
            itemBuilder: (context, index) {
              final proyecto = controller.proyectos[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(proyecto.imagenUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(proyecto.nombre,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const Gap(4),
                          Text(proyecto.descripcion,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
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
