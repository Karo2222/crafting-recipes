import 'dart:convert' show utf8;
import 'dart:io';

import 'package:crypto/crypto.dart' show md5;
import 'package:path_provider/path_provider.dart';
import 'package:craftingrecipes/helpers/constants.dart';

/// Helpers for media files that are cached in the app's documents directory.
///
/// Files are stored as `<documents>/<folder>/<ownerId>/<md5(url)>.<ext>`.
class AppUtil {
  AppUtil._();

  static const _knownExtensions = [
    'jpg', 'png', 'webp', 'wav', 'mp3', 'mp4', 'pdf', 'gltf', 'glb', //
  ];

  /// Deterministic local file name for a remote [url].
  static String getFileName(String url) {
    final hash = md5.convert(utf8.encode(url)).toString();
    final extension = _knownExtensions.firstWhere(
      (ext) => url.contains('.$ext'),
      orElse: () => 'png',
    );
    return '$hash.$extension';
  }

  static String getImagesFolderPath(Directory base, String folder) =>
      '${base.path}/$folder/';

  /// Returns (and creates if needed) the folder for files of [ownerId].
  static Future<String> createFolderInAppDocDir(
    String ownerId,
    String folder,
  ) async {
    final documents = await getApplicationDocumentsDirectory();
    final target = Directory('${getImagesFolderPath(documents, folder)}/$ownerId/');
    if (!await target.exists()) {
      await target.create(recursive: true);
    }
    return target.path;
  }

  /// Local path of a cached file, or an empty string if it is not cached.
  static Future<String> filePath(
    Object? ownerId,
    String? url,
    String folder,
  ) async {
    if (url == null || url.isEmpty) return '';
    final documents = await getApplicationDocumentsDirectory();
    final path =
        '${getImagesFolderPath(documents, folder)}$ownerId/${getFileName(url)}';
    return await File(path).exists() ? path : '';
  }

  static Future<void> deleteAllImages() async {
    final documents = await getApplicationDocumentsDirectory();
    await deleteFolderContent(
      getImagesFolderPath(documents, Const.imagesFolderName.key),
    );
  }

  /// Removes everything inside [path] but keeps the folder itself.
  static Future<void> deleteFolderContent(String path) async {
    final folder = Directory(path);
    if (!await folder.exists()) return;
    await for (final entry in folder.list()) {
      await entry.delete(recursive: true);
    }
  }
}
