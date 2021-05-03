import 'decision.dart';
import 'record.dart';

class DecisionTakedRecord extends Record {
  final Decision decision;
  final DateTime datetime;

  DecisionTakedRecord(this.decision) : datetime = DateTime.now().toUtc();

  @override
  List<Object?> get props => [decision, datetime];
}
