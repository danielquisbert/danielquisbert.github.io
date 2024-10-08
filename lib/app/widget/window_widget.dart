import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../themes/app_theme.dart';

class WindowWidget extends StatelessWidget {
  final String title;
  final Widget content;
  final VoidCallback onClose;

  // ignore: use_super_parameters
  const WindowWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.macosDarkTheme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: onClose,
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
                const Gap(80), // Para balancear el título
              ],
            ),
          ),
          Expanded(child: content),
        ],
      ),
    );
  }
}
