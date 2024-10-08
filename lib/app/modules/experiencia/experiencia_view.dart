import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'experiencia_controller.dart';
import '../../themes/app_theme.dart';

class ExperienciaView extends GetView<ExperienciaController> {
  const ExperienciaView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExperienciaController>(
      init: ExperienciaController(),
      builder: (controller) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * .2, vertical: Get.height * .1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(controller),
              const Gap(24),
              _buildProfessionalSummary(controller),
              const Gap(32),
              _buildSectionTitle('Experiencia Profesional'),
              ...controller.experiencias
                  .map((exp) => _buildExperienceItem(exp)),
              const Gap(32),
              _buildSectionTitle('Educación'),
              ...controller.educacion.map((edu) => _buildEducationItem(edu)),
              const Gap(32),
              _buildSectionTitle('Ponencias'),
              ...controller.ponencias.map((pon) => _buildPresentationItem(pon)),
              const Gap(32),
              _buildSectionTitle('Certificaciones'),
              _buildCertificationsList(controller.certificaciones),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ExperienciaController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(controller.photoAssetPath),
        ),
        const Gap(24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.name,
                style: Get.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                controller.title,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.accentColor,
                ),
              ),
              const Gap(8),
              Text(
                controller.contact,
                style:
                    Get.textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalSummary(ExperienciaController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen Profesional',
          style: Get.textTheme.headlineSmall?.copyWith(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        Text(
          controller.professionalSummary,
          style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Get.textTheme.headlineMedium?.copyWith(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(24),
      ],
    );
  }

  Widget _buildExperienceItem(Experiencia exp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exp.puesto,
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    exp.empresa,
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: AppTheme.accentColor,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              exp.periodo,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const Gap(12),
        Text(
          exp.descripcion,
          style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        const Gap(16),
        _buildSkillsList(exp.habilidades),
        const Gap(24),
        const Divider(color: Colors.grey),
        const Gap(24),
      ],
    );
  }

  Widget _buildSkillsList(List<String> habilidades) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: habilidades
          .map((habilidad) => Chip(
                label: Text(habilidad),
                backgroundColor: AppTheme.accentColor.withOpacity(0.1),
                labelStyle: TextStyle(color: AppTheme.accentColor),
              ))
          .toList(),
    );
  }

  Widget _buildEducationItem(Educacion edu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          edu.titulo,
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          edu.institucion,
          style: Get.textTheme.titleMedium?.copyWith(
            color: AppTheme.accentColor,
          ),
        ),
        Text(
          edu.periodo,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: Colors.white70,
          ),
        ),
        const Gap(16),
      ],
    );
  }

  Widget _buildPresentationItem(Ponencia pon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pon.titulo,
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          pon.evento,
          style: Get.textTheme.titleMedium?.copyWith(
            color: AppTheme.accentColor,
          ),
        ),
        Text(
          pon.tipo,
          style: Get.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: Colors.white70,
          ),
        ),
        const Gap(16),
      ],
    );
  }

  Widget _buildCertificationsList(List<String> certificaciones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: certificaciones
          .map((cert) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle,
                        color: AppTheme.accentColor, size: 20),
                    const Gap(8),
                    Expanded(
                      child: cert.contains('Flutter Certified')
                          ? InkWell(
                              onTap: () => launchUrl(Uri.parse(
                                  'https://androidatc.com/_transcript.php?action=public&u=lMLczaXbl9WnmaSSlODYstbWxZucX5PQ2w%3D%3D')),
                              child: Text(
                                cert,
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          : Text(
                              cert,
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
