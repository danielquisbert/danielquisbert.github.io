import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(controller),
              const Gap(24),
              _buildProfessionalSummary(controller),
              const Gap(32),
              Text(
                'Experiencia Profesional',
                style: Get.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(24),
              ...controller.experiencias
                  .map((exp) => _buildExperienceItem(exp)),
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
                style: Get.textTheme.bodyMedium,
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
              ),
            ),
          ],
        ),
        const Gap(12),
        Text(
          exp.descripcion,
          style: Get.textTheme.bodyMedium,
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
}
