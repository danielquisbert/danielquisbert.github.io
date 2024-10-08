import 'package:get/get.dart';

class BlogController extends GetxController {
  final posts = <Post>[].obs;

  @override
  void onInit() {
    super.onInit();
    cargarPosts();
  }

  void cargarPosts() {
    posts.assignAll([
      Post('Introducción a Flutter', 'Flutter es un framework de UI...', '2023-05-01'),
      Post('GetX: Gestión de estado', 'GetX es una solución poderosa...', '2023-04-15'),
      Post('Diseño responsive en Flutter', 'Crear interfaces adaptables...', '2023-04-01'),
    ]);
  }

  void abrirPost(Post post) {
    // Implementa la lógica para abrir el post completo
    Get.snackbar('Post seleccionado', 'Has seleccionado: ${post.titulo}');
  }
}

class Post {
  final String titulo;
  final String resumen;
  final String fecha;

  Post(this.titulo, this.resumen, this.fecha);
}