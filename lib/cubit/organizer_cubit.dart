import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:control_p2/models/models.dart';
import 'package:control_p2/repositories/organizer.dart';
import 'package:control_p2/util/extensions/uri.dart';

part 'organizer_state.dart';

/// Cubit to mangage the state of the organizer screen
class OrganizerCubit extends Cubit<OrganizerState> {
  /// Repository to get and organize resources (and to interact with other
  /// things of the organizer).
  final OrganizerRepository organizerRepository;

  /// A list of resources with the decisions that were taken over them.
  ///
  /// A frame is just that, a resource with a list of decisions asociated.
  /// Decisions can have related data (normally states that can be restored).
  ///
  /// This is used like a history of decisions taked over resources.
  final List<DecisionFrame> decisionFrames = [];

  /// A queue of resources that are going to be organized.
  late final Queue<Resource> _resources;

  /// The first avaiable decisions.
  late final List<Decision> _initialDecisions;

  /// The constructor of this cubit. You must provide an [OrganizerRepository].
  ///
  /// Make sure to call [init] after the creation of this cubit.
  OrganizerCubit({
    required this.organizerRepository,
  }) : super(const OrganizerInitial());

  /// Initialize the cubit.
  Future<void> init() async {
    try {
      // Loading state
      emit(const OrganizerLoading());

      // Start loading the necessary data.
      final resourcesFuture = organizerRepository.getResources();
      final decisionsFuture = organizerRepository.getDecisions();

      // Wait for data
      _resources = Queue.from(await resourcesFuture);
      _initialDecisions = await decisionsFuture;

      if (_resources.isNotEmpty) {
        // Add a decision frame for the resource.
        decisionFrames.add(DecisionFrame(_resources.first));

        // Emit the resource and the initial decisions
        emit(OrganizerSnapshot(
          resource: _resources.first,
          decisions: _initialDecisions,
        ));
      } else {
        // No resource to organize
        emit(OrganizerSnapshot(
          resource: null,
          decisions: const [],
        ));
      }
    } catch (e, st) {
      emit(OrganizerError(e, st));
      rethrow;
    }
  }

  /// Omit the clasification of the current resource.
  Future<void> omit() {
    return takeDecision(const Decision.omit());
  }

  /// Launch the current resource uri.
  Future<void> launch() async {
    final snapshot = state as OrganizerSnapshot;
    return snapshot.resource?.uri.launch();
  }

  /// Take a decision over the current resource
  Future<void> takeDecision(Decision decision) async {
    final snapshot = state as OrganizerSnapshot;

    // No resource to organize
    if (snapshot.isEmpty) {
      return;
    }

    // Add this decision to the history of the current resource with
    // the current snapshot associated (used to undo the operation)
    decisionFrames.last.addDecision(decision, data: snapshot);

    try {
      if (decision.isFinal) {
        // Organize the resource
        await organizerRepository.organize(snapshot.resource!, decision);

        // After organizing it, remove it from the queue.
        _resources.removeFirst();

        // If there are still resources to organize
        if (_resources.isNotEmpty) {
          decisionFrames.add(DecisionFrame(_resources.first));

          emit(OrganizerSnapshot(
            resource: _resources.first,
            decisions: _initialDecisions,
          ));
        } else {
          emit(OrganizerSnapshot(
            resource: null,
            decisions: const [],
          ));
        }
      } else {
        emit(OrganizerSnapshot(
          resource: snapshot.resource,
          decisions: decision.children,
        ));
      }
    } catch (e, st) {
      emit(OrganizerError(e, st));
      rethrow;
    }
  }
}

/// A decision frame is a list of decisions asociated to a resource.
class DecisionFrame {
  final Resource resource;
  final List<Decision> _decisions = [];
  final List<Object?> _datas = [];

  DecisionFrame(this.resource);

  List<Decision> get decisions => _decisions;

  void addDecision(Decision decision, {Object? data}) {
    _decisions.add(decision);
    _datas.add(data);
  }
}
