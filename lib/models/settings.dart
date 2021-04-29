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

  /// Main constructor
  const Settings({required this.vars, required this.decisions});

  /// Constructs from a standard json
  factory Settings.fromJson(Map json) {
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
  }

  /// Constructs a Settings object from yaml settings
  factory Settings.fromYamlSettings(Map yaml) {
    final vars = (yaml['vars'] as Map? ?? {}).cast<String, dynamic>();
    final decisions = (yaml['decisions'] as Map? ?? {})
        .entries
        .map((e) => Decision.fromYamlSettings(e.key, e.value))
        .toList();

    return Settings(vars: vars, decisions: decisions);
  }

  /// Copy with implementation
  Settings copyWith({
    Map<String, dynamic>? vars,
    List<Decision>? decisions,
  }) {
    return Settings(
      vars: vars ?? this.vars,
      decisions: decisions ?? this.decisions,
    );
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}
