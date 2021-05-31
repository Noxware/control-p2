import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'decision.dart';

/// Settings of the app
@immutable
class Settings extends Equatable {
  /// Custom variables defined by the user
  final Map<String, dynamic> vars;

  /// List of decisions configured by the user
  final List<Decision> decisions;

  /// (Temp) The selected folder to organize
  final List<Directory> workingDirectories;

  /// Main constructor
  const Settings({
    required this.vars,
    required this.decisions,
    required this.workingDirectories,
  });

  /// Constructs from a standard json
  /*factory Settings.fromJson(Map json) {
    final vars = (json['vars'] as Map? ?? {}).cast<String, dynamic>();
    final decisions = (json['decisions'] as List? ?? [])
        .map((e) => Decision.fromJson(e))
        .toList();

    return Settings(vars: vars, decisions: decisions);
  }

  /// Converts this Settings object to json
  Map toJson() {
    return {
      'vars': vars,
      'decisions': decisions.map((d) => d.toJson()).toList(),
    };
  }*/

  /// Constructs a Settings object from yaml settings
  factory Settings.fromYamlSettings(Map yaml) {
    final vars = (yaml['vars'] as Map? ?? {}).cast<String, dynamic>();
    final decisions = (yaml['decisions'] as Map? ?? {})
        .entries
        .map((e) => Decision.fromYamlSettings(e.key, e.value))
        .toList();
    final workingDirs =
        (yaml['working_dirs'] as List).map((d) => Directory(d)).toList();

    return Settings(
      vars: vars,
      decisions: decisions,
      workingDirectories: workingDirs,
    );
  }

  /// Copy with implementation
  Settings copyWith({
    Map<String, dynamic>? vars,
    List<Decision>? decisions,
    List<Directory>? workingDirectory,
  }) {
    return Settings(
      vars: vars ?? this.vars,
      decisions: decisions ?? this.decisions,
      workingDirectories: workingDirectory ?? this.workingDirectories,
    );
  }

  @override
  List<Object?> get props => [vars, decisions, workingDirectories];
}
