import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a record of something that happened (like the user taking a
/// certain decision or moving a file)
@immutable
abstract class Record extends Equatable {
  /// Converts the record to a serializable json map
  /*Map toJson();*/

  /// The time when the recorded event ocurred
  DateTime get datetime;
}
