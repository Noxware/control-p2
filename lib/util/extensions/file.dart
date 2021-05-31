import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:control_p2/util/helpers/random.dart';

extension NxFileExtension on File {
  Future<File> safeMoveToDirectory(Directory newLocation) async {
    await newLocation.create(recursive: true);
    return move(
        await _safePath('${newLocation.path}/${path.basename(this.path)}'));
  }

  /// https://stackoverflow.com/questions/54692763/flutter-how-to-move-file
  Future<File> move(String newPath) async {
    try {
      return await this.rename(newPath);
    } on FileSystemException catch (e) {
      // if rename fails, copy the source file and then delete it
      final newFile = await this.copy(newPath);
      await this.delete();
      return newFile;
    }
  }

  static Future<String> _safePath(String targetPath) async {
    // TODO: un-hardcode things
    // TODO: long ext can break this

    if (!await File(targetPath).exists()) {
      return targetPath;
    } else {
      final name = path.basenameWithoutExtension(targetPath);
      final ext = path.extension(targetPath);
      final dir = Directory(path.dirname(targetPath));
      final improbable = '_' + RandomHelper.getRandomString(8);

      // Total filename will have less than 80 chars. 10 is 8 rounded.
      final maxNameLength = 80 - ext.length - 10;
      final newName =
          name.length > maxNameLength ? name.substring(0, maxNameLength) : name;

      final newPath = '${dir.path}/$newName$improbable$ext';

      if (!await File(newPath).exists()) {
        return newPath;
      } else {
        return await _safePath(newPath);
      }
    }
  }
}
