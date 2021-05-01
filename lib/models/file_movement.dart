import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a file movement
@immutable
class FileMovement extends Equatable {
  final String pathBefore;
  final String pathAfter;

  const FileMovement(this.pathBefore, this.pathAfter);

  @override
  List<Object?> get props => [pathBefore, pathAfter];
}
