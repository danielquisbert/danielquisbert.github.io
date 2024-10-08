import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TerminalController extends GetxController {
  final output = <String>[].obs;
  final inputController = TextEditingController();
  final currentDirectory = '/home/danielquisbert'.obs;
  final fileSystem = {
    '/home/danielquisbert': ['documentos', 'imágenes', 'música', 'vídeos'],
    '/home/danielquisbert/documentos': ['informe.txt', 'proyecto.pdf'],
    '/home/danielquisbert/imágenes': ['foto1.jpg', 'foto2.png'],
    '/home/danielquisbert/música': ['cancion1.mp3', 'cancion2.mp3'],
    '/home/danielquisbert/vídeos': ['video1.mp4', 'video2.mp4'],
  };

  @override
  void onInit() {
    super.onInit();
    output.add('Bienvenido a la Terminal Linux simulada. Escribe un comando o "help" para ver la lista de comandos disponibles.');
  }

  void ejecutarComando(String comando) {
    output.add('$comando');
    
    final args = comando.split(' ');
    final cmd = args[0].toLowerCase();
    
    switch (cmd) {
      case 'ls':
        ls(args);
        break;
      case 'cd':
        cd(args);
        break;
      case 'pwd':
        pwd();
        break;
      case 'mkdir':
        mkdir(args);
        break;
      case 'rm':
        rm(args);
        break;
      case 'cat':
        cat(args);
        break;
      case 'echo':
        echo(args);
        break;
      case 'date':
        date();
        break;
      case 'whoami':
        whoami();
        break;
      case 'uname':
        uname(args);
        break;
      case 'help':
        help();
        break;
      default:
        output.add('Comando no reconocido: $cmd. Escribe "help" para ver la lista de comandos disponibles.');
    }

    inputController.clear();
    update();
  }

  void ls(List<String> args) {
    if (args.contains('-l')) {
      // Simulación de formato largo
      fileSystem[currentDirectory]?.forEach((file) {
        output.add('drwxr-xr-x 2 danielquisbert users 4096 ${DateTime.now().toString()} $file');
      });
    } else {
      output.add(fileSystem[currentDirectory]?.join('  ') ?? 'Directorio vacío');
    }
  }

  void cd(List<String> args) {
    if (args.length < 2) {
      currentDirectory.value = '/home/danielquisbert';
    } else if (args[1] == '..') {
      final parts = currentDirectory.split('/');
      if (parts.length > 2) {
        currentDirectory.value = parts.sublist(0, parts.length - 1).join('/');
      }
    } else if (fileSystem.containsKey('${currentDirectory.value}/${args[1]}')) {
      currentDirectory.value = '${currentDirectory.value}/${args[1]}';
    } else {
      output.add('cd: ${args[1]}: No such file or directory');
    }
  }

  void pwd() {
    output.add(currentDirectory.value);
  }

  void mkdir(List<String> args) {
    if (args.length < 2) {
      output.add('mkdir: missing operand');
    } else {
      final newDir = '${currentDirectory.value}/${args[1]}';
      if (!fileSystem.containsKey(newDir)) {
        fileSystem[newDir] = [];
        fileSystem[currentDirectory.value]?.add(args[1]);
        output.add('Directory created: ${args[1]}');
      } else {
        output.add('mkdir: cannot create directory ${args[1]}: File exists');
      }
    }
  }

  void rm(List<String> args) {
    if (args.length < 2) {
      output.add('rm: missing operand');
    } else {
      if (fileSystem[currentDirectory.value]?.contains(args[1]) ?? false) {
        fileSystem[currentDirectory.value]?.remove(args[1]);
        output.add('Removed: ${args[1]}');
      } else {
        output.add('rm: cannot remove ${args[1]}: No such file or directory');
      }
    }
  }

  void cat(List<String> args) {
    if (args.length < 2) {
      output.add('cat: missing operand');
    } else {
      if (fileSystem[currentDirectory.value]?.contains(args[1]) ?? false) {
        output.add('Contents of ${args[1]}:\nThis is a simulated file content.');
      } else {
        output.add('cat: ${args[1]}: No such file or directory');
      }
    }
  }

  void echo(List<String> args) {
    output.add(args.sublist(1).join(' '));
  }

  void date() {
    output.add(DateTime.now().toString());
  }

  void whoami() {
    output.add('danielquisbert');
  }

  void uname(List<String> args) {
    if (args.contains('-a')) {
      output.add('Linux Simulated 5.10.0-generic #1 SMP Dart Flutter x86_64 GNU/Linux');
    } else {
      output.add('Linux');
    }
  }

  void help() {
    output.add('''
Comandos disponibles:
  ls        - Lista el contenido del directorio
  cd        - Cambia el directorio actual
  pwd       - Muestra el directorio de trabajo actual
  mkdir     - Crea un nuevo directorio
  rm        - Elimina archivos o directorios
  cat       - Muestra el contenido de un archivo
  echo      - Muestra un mensaje en la terminal
  date      - Muestra la fecha y hora actual
  whoami    - Muestra el nombre del usuario actual
  uname     - Muestra información del sistema
  help      - Muestra esta lista de comandos
''');
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}