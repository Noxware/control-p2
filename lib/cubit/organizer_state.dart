part of 'organizer_cubit.dart';

abstract class OrganizerState extends Equatable {
  const OrganizerState();

  @override
  List<Object?> get props => [];
}

/// The cubit has not been initialized yet
class OrganizerInitial extends OrganizerState {
  const OrganizerInitial();
}

/// Intial data is loading
class OrganizerLoading extends OrganizerState {
  const OrganizerLoading();
}

/// Loaded snapshot
class OrganizerSnapshot extends OrganizerState {
  final Resource? resource;
  final List<Decision> decisions;

  const OrganizerSnapshot({
    required this.resource,
    required this.decisions,
  });

  @override
  List<Object?> get props => [resource, decisions];

  bool get isEmpty => resource == null;
}

/// An error ocurred
class OrganizerError extends OrganizerState {
  final Object error;
  final Object stackTrace;

  const OrganizerError(this.error, this.stackTrace);

  @override
  List<Object?> get props => [error, stackTrace];
}
