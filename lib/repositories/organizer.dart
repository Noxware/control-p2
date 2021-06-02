import 'dart:io';

import 'package:control_p2/models/models.dart';
import 'package:control_p2/util/extensions/file.dart';

import 'settings.dart';

/// Provides an abstraction to get and organize resources based on decisions
class OrganizerRepository {
  final SettingsRepository settingsRepository;

  OrganizerRepository({
    required this.settingsRepository,
  });

  /// Get available resources to organize
  Future<List<Resource>> getResources() async {
    final dirs = await settingsRepository.getWorkingDirectories();
    final listsFutures = dirs.map((d) async {
      if (!await d.exists()) {
        return const <Resource>[];
      }

      return d.list().where((e) => e is File).asyncMap((e) async {
        final f = e as File;

        final uri = f.absolute.uri;
        final size = await f.length();
        final mtime = await f.lastModified();

        return Resource(
          uri: uri,
          size: size,
          mtime: mtime,
        );
      }).toList();
    });

    return (await Future.wait(listsFutures)).expand((f) => f).toList();
  }

  /// Get the list of available decisions
  Future<List<Decision>> getDecisions() async {
    return await settingsRepository.getDecisions();
  }

  /// Organize a resource based on a final decision taked.
  ///
  /// The decision must have a directory associated.
  Future<void> organize(Resource r, Decision d) async {
    if (!d.isFinal) {
      throw 'The decision must be a final decision.';
    }

    final rFile = File.fromUri(r.uri);
    await rFile.safeMoveToDirectory(d.directory!);
  }

  // move(resource, uri)?
}
