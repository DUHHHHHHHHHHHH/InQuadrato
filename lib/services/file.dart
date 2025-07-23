import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<Directory> getImportDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final importDir = Directory(
      '${documentsDir.path}${Platform.pathSeparator}Inquadra3D${Platform.pathSeparator}import',
    );

    if (!await importDir.exists()) {
      await importDir.create(recursive: true);
      print('Cartella import creata in: ${importDir.path}');
    } else {
      print('Cartella import già esistente in: ${importDir.path}');
    }

    return importDir;
  }

  static Future<List<File>> listaModelliImportati() async {
    final dir = await getImportDirectory();
    if (!await dir.exists()) return [];

    final files = dir.listSync(recursive: true).whereType<File>().where((file) {
      final ext = file.path.toLowerCase();
      return ext.endsWith('.obj') ||
          ext.endsWith('.fbx') ||
          ext.endsWith('.glb');
    }).toList();

    return files;
  }
}
