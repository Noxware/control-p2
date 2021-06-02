import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a local or remote classifiable resource
@immutable
class Resource extends Equatable {
  final Uri uri;
  final int? size;
  final DateTime? mtime;

  const Resource({
    required this.uri,
    required this.size,
    required this.mtime,
  });

  @override
  List<Object?> get props => [uri, size, mtime];

  bool get isLocal => uri.isScheme('file');

  bool get isRemote => !uri.isScheme('file');

  bool get isImage => [
        'jpg',
        'jpeg',
        'png',
        'webp',
        'bmp',
      ].contains(uri.pathSegments.last.split('.').last);

  bool get isText => [
        // Normal
        'txt',

        // Data
        'json',
        'yaml',
        'ini',
        'xml',

        // Code
        'py',
        'html',
        'js',
        'css',
        'ts',
      ].contains(uri.pathSegments.last.split('.').last);
}
