import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a file with immutable properties.
///
/// It does not offer operations. The file might not even exist.
@immutable
class DummyFile extends Equatable {
  final String path;

  const DummyFile(this.path);

  @override
  List<Object?> get props => [path];
}
