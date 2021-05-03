import 'record.dart';

/// Represents a file movement
class FileMovedRecord extends Record {
  final String before;
  final String after;
  final DateTime datetime;

  FileMovedRecord(this.before, this.after) : datetime = DateTime.now();

  @override
  List<Object?> get props => [before, after, datetime];

  /*@override
  Map toJson() {
    return {
      'type': 'fileMoved',
      'datetime': DateTime.now().toUtc().toString(),
      'before': before,
      'after': after,
    };
  }*/
}
