import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';

import 'package:control_p2/models/models.dart';

/// Interact with settings independently of their origin
class SettingsRepository {
  const SettingsRepository();

  /// Get the LOCAL settings file loaded as a model
  static Future<Settings> _getSettings() async {
    final file = File('./settings.yaml');

    // Sync because if two parallel calls are made, one is going to try to delete
    // a non existing file
    if (!kReleaseMode && file.existsSync()) {
      file.deleteSync();
    }

    if (!await file.exists()) {
      final template = await rootBundle.loadString('assets/settings.yaml');
      await file.writeAsString(template);
    }

    final content = await file.readAsString();
    final yaml = loadYaml(content);
    return Settings.fromYamlSettings(yaml);
  }

  /// Obtain the list of posible decisions over a file
  Future<List<Decision>> getDecisions() async {
    return (await _getSettings()).decisions;
  }

  /// Directories to scan for files (where chaos is)
  Future<List<Directory>> getWorkingDirectories() async {
    return (await _getSettings()).workingDirectories;
  }
}
