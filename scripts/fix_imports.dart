// Script to fix import path inconsistencies
// This script will update all imports to use core/errors instead of core/error

import 'dart:io';

void main() async {
  // Get all Dart files in the project
  final srcDir = Directory('lib');
  final List<FileSystemEntity> entities = await _getAllDartFiles(srcDir);

  int fixedFiles = 0;

  // Process each file
  for (var entity in entities) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = await entity.readAsString();

      // Check for core/error imports and replace with core/errors
      if (content.contains("import '") && content.contains('core/error/')) {
        String updatedContent =
            content.replaceAll('core/error/', 'core/errors/');

        if (content != updatedContent) {
          await entity.writeAsString(updatedContent);
          print('Fixed imports in: ${entity.path}');
          fixedFiles++;
        }
      }
    }
  }

  print('Completed! Fixed imports in $fixedFiles files.');

  // Create a task to remove duplicate files if needed
  print("\nImportant: You may need to remove duplicate files.");
  print("The following directories both contain error handling files:");
  print("- lib/core/error");
  print("- lib/core/errors\n");
  print(
      "Standardize on 'lib/core/errors' and delete 'lib/core/error' if the files are identical.");
}

Future<List<FileSystemEntity>> _getAllDartFiles(Directory directory) async {
  List<FileSystemEntity> files = [];

  await for (var entity
      in directory.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity);
    }
  }

  return files;
}
