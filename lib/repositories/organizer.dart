import 'dart:html';

import 'package:control_p2/models/models.dart';

import 'settings.dart';

/// Provides an abstraction to get and organize resources based on decisions
class OrganizerRepository {
  final SettingsRepository _settingsRepository;

  OrganizerRepository({required SettingsRepository settingsRepository})
      : _settingsRepository = settingsRepository;

  /// Get available resources to organize
  Future<List<Resource>> getResources() async {
    final dir = await _settingsRepository.getWorkingDirectory();
    return await dir
        .list()
        .where((e) => e is File)
        .map((e) => Resource(e.absolute.uri))
        .toList();
  }

  /// Get the list of available decisions
  Future<List<Decision>> getDecisions() {
    throw UnimplementedError();
  }

  /// Organize a resource based on a final decision taked.
  ///
  /// The decision must have a directory associated.
  Future<void> organize(Resource res, Decision des) {
    throw UnimplementedError();
  }

  // move(resource, uri)?
}
