import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';

import 'package:control_p2/models/models.dart';

/// Interact with settings independently of their origin
class SettingsRepository {
  const SettingsRepository();

  /// Get the LOCAL settings file loaded as a model
  static Future<Settings> _getSettings() async {
    final file = File('./settings.yaml');

    if (!await file.exists()) {
      final template = await rootBundle.loadString('assets/settings.yaml');
      file.writeAsString(template);
    }

    final content = await file.readAsString();
    final yaml = loadYaml(content);
    return Settings.fromYamlSettings(yaml);
  }

  /// Obtain the list of posible decisions over a file
  Future<List<Decision>> getDecisions() async {
    return (await _getSettings()).decisions;
  }
}
