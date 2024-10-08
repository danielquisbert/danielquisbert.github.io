import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'blog_controller.dart';
import '../../themes/app_theme.dart';

class BlogView extends GetView<BlogController> {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<BlogController>(
        init: BlogController(),
        builder: (controller) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        const Icon(Icons.article, color: AppTheme.accentColor),
                  ),
                  title: Text(post.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(post.resumen,
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Text(post.fecha,
                      style: const TextStyle(color: Colors.grey)),
                  onTap: () => controller.abrirPost(post),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
