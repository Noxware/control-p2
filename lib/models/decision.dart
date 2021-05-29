import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:control_p2/util/extensions/map.dart';

/// Represents a decision about how to clasify a file.
///
/// This normally comes from the settings yaml.
@immutable
class Decision extends Equatable {
  /// The decision name used for displaying the option.
  /// It must be unique among its siblings.
  final String name;

  /// A list of children decisions (the result of choosing this).
  final List<Decision> children;

  /// The directory where to move the file if this decision is taken.
  final Directory? directory;

  /// Main constructor of this class
  const Decision({
    required this.name,
    required this.children,
    required this.directory,
  });

  /// Construct from json
  factory Decision.fromJson(Map json) {
    final childrenJson = json['children'] as List?;
    final children =
        childrenJson?.map((c) => Decision.fromJson(c)).toList() ?? [];

    final directoryPath = json['directory'];
    final directory = directoryPath != null ? Directory(directoryPath) : null;

    return Decision(
      name: json['name'],
      children: children,
      directory: directory,
    );
  }

  /// Convert to json
  Map toJson() {
    return {
      'name': name,
      'directory': directory?.path,
      'children': children.map((c) => c.toJson()).toList(),
    };
  }

  /// Standard copy with implementation
  Decision copyWith({
    String? name,
    List<Decision>? children,
    Directory? directory,
  }) {
    return Decision(
      name: name ?? this.name,
      children: children ?? this.children,
      directory: directory ?? this.directory,
    );
  }

  @override
  List<Object?> get props => [name, directory, children];

  /// From yaml settings
  factory Decision.fromYamlSettings(String name, dynamic content) {
    if (content is String) {
      return Decision(name: name, directory: Directory(content), children: []);
    } else if (content is Map) {
      final underscore =
          content.filter((e) => e.key.toString().startsWith('_'));
      final nonUnderscore = content.withoutKeys(underscore.keys);

      final directory = underscore['_directory'] != null
          ? Directory(underscore['_directory'])
          : null;
      final children = nonUnderscore.entries
          .map((e) => Decision.fromYamlSettings(e.key, e.value))
          .toList();

      return Decision(name: name, children: children, directory: directory);
    } else {
      throw 'Invalid yaml settings. The value of a decision can only be of type "String" or "Map".';
    }
  }

  /// Check if the desicion is a final desicion.
  ///
  /// A final desicion is a desicion that has an asociated directory, so it can
  /// be used as a target
  bool get isFinal => directory != null;
}
