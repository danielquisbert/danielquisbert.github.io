import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'dart:developer';
import 'package:yaml/yaml.dart';

class BlogController extends GetxController {
  final posts = <Post>[].obs;

  @override
  void onInit() {
    super.onInit();
    cargarPosts();
  }

  Future<void> cargarPosts() async {
    try {
      // Leer el índice de posts
      final String indexYaml =
          await rootBundle.loadString('assets/blog/index.yaml');
      final List<dynamic> postsIndex = loadYaml(indexYaml)['posts'];

      for (var postInfo in postsIndex) {
        final String fileName = postInfo['file'];
        final String content =
            await rootBundle.loadString('assets/blog/$fileName');
        log("content: $content");
        // Extraer metadatos y contenido
        final (metadata, markdownContent) = _parseMarkdownFile(content);

        posts.add(Post(
          titulo: metadata['title'] ?? 'Sin título',
          resumen: metadata['summary'] ?? '',
          fecha: DateTime.tryParse(metadata['date'] ?? '') ?? DateTime.now(),
          imagenUrl: metadata['image'],
          contenido: markdownContent,
        ));
      }

      posts.sort((a, b) =>
          b.fecha.compareTo(a.fecha)); // Ordenar por fecha descendente
      update();
    } catch (e) {
      log('Error al cargar los posts: $e');
    }
  }

  (Map<String, String>, String) _parseMarkdownFile(String content) {
    final lines = content.split('\n');
    final metadata = <String, String>{};
    int contentStart = 0;

    if (lines[0].trim() == '---') {
      for (int i = 1; i < lines.length; i++) {
        if (lines[i].trim() == '---') {
          contentStart = i + 1;
          break;
        }
        final parts = lines[i].split(':');
        if (parts.length == 2) {
          metadata[parts[0].trim()] = parts[1].trim();
        }
      }
      log("metadata $metadata");
    }

    return (metadata, lines.sublist(contentStart).join('\n').trim());
  }
}

class Post {
  final String titulo;
  final String resumen;
  final DateTime fecha;
  final String? imagenUrl;
  final String contenido;

  Post({
    required this.titulo,
    required this.resumen,
    required this.fecha,
    this.imagenUrl,
    required this.contenido,
  });
}
