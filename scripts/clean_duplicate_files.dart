// Script to clean up duplicate error files
// This will remove the files in core/error since we're standardizing on core/errors

import 'dart:io';

void main() async {
  final errorDir = Directory('lib/core/error');

  if (await errorDir.exists()) {
    print('Removing duplicate error files from lib/core/error...');

    await for (var entity in errorDir.list()) {
      if (entity is File) {
        // Check if equivalent file exists in errors directory
        final errorsFile =
            File('lib/core/errors/${entity.uri.pathSegments.last}');

        if (await errorsFile.exists()) {
          print('Removing duplicate file: ${entity.path}');
          await entity.delete();
        } else {
          print(
              'Warning: ${entity.path} does not have a counterpart in lib/core/errors/');
        }
      }
    }

    // Try to remove the directory if empty
    final remainingFiles = await errorDir.list().toList();
    if (remainingFiles.isEmpty) {
      print('Removing empty directory: ${errorDir.path}');
      await errorDir.delete();
    } else {
      print(
          'Warning: ${errorDir.path} still contains files and was not removed');
    }

    print('Clean-up completed!');
  } else {
    print('Directory lib/core/error does not exist. No clean-up needed.');
  }
}
