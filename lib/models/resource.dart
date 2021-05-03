import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a local or remote classifiable resource
@immutable
class Resource extends Equatable {
  final Uri uri;

  const Resource(this.uri);

  @override
  List<Object?> get props => [uri];

  bool get isLocal => throw UnimplementedError();
  bool get isRemote => throw UnimplementedError();
  bool get isImage => throw UnimplementedError();
  bool get isText => throw UnimplementedError();
}
