import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'portafolio_controller.dart';
import '../../themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class PortafolioView extends GetView<PortafolioController> {
  const PortafolioView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PortafolioController>(
      init: PortafolioController(),
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * .2, vertical: Get.height * .1),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemCount: controller.proyectos.length,
            itemBuilder: (context, index) {
              final proyecto = controller.proyectos[index];
              return _buildProjectCard(proyecto);
            },
          ),
        );
      },
    );
  }

  String getCorsProxyUrl(String originalUrl) {
    return 'https://cors-anywhere.herokuapp.com/$originalUrl';
  }

  Widget _buildProjectCard(Proyecto proyecto) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _launchURL(proyecto.url),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                    imageUrl: proyecto.imagenUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) {
                      log('Error loading image: $url, $error');
                      return Container(
                        color: Colors.red[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red),
                            if (kIsWeb)
                              Text(
                                  'Error de carga de imagen (posible problema CORS)',
                                  style: TextStyle(color: Colors.red)),
                            Text('URL: $url',
                                style: TextStyle(color: Colors.red)),
                            Text('Error: $error',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    proyecto.nombre,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    proyecto.descripcion,
                    style: Get.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: proyecto.tecnologias
                        .map((tech) => Chip(
                              label: Text(tech, style: TextStyle(fontSize: 10)),
                              backgroundColor:
                                  AppTheme.accentColor.withOpacity(0.1),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
