import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

import 'package:control_p2/models/models.dart';
import 'package:control_p2/repositories/organizer.dart';

part 'organizer_state.dart';

class OrganizerCubit extends Cubit<OrganizerState> {
  final OrganizerRepository organizerRepository;
  final List<OrganizerSnapshot> snapshots = [];

  Queue<Resource>? _resources;
  List<Decision>? _initialDecisions;

  OrganizerCubit({
    required this.organizerRepository,
  }) : super(const OrganizerInitial());

  Future<void> init() async {
    try {
      emit(const OrganizerLoading());

      final resourcesFuture = organizerRepository.getResources();
      final desicionsFuture = organizerRepository.getDecisions();

      _resources = Queue.from(await resourcesFuture);
      _initialDecisions = await desicionsFuture;

      emit(OrganizerSnapshot(
        resource: _resources!.firstOrNull,
        decisions: _initialDecisions!,
      ));
    } catch (e, st) {
      emit(OrganizerError(e, st));
    }
  }

  @override
  void onChange(Change<OrganizerState> change) {
    if (change.nextState is OrganizerSnapshot) {
      snapshots.add(change.nextState as OrganizerSnapshot);
    }

    super.onChange(change);
  }

  Future<void> takeDecision(Decision desicion) async {
    final snapshot = state as OrganizerSnapshot;

    if (snapshot.isEmpty) {
      return;
    }

    try {
      if (desicion.isFinal) {
        await organizerRepository.organize(snapshot.resource!, desicion);
        _resources!.removeFirst();
        emit(OrganizerSnapshot(
          resource: _resources!.firstOrNull,
          decisions: _initialDecisions!,
        ));
      } else {
        emit(OrganizerSnapshot(
          resource: snapshot.resource,
          decisions: desicion.children,
        ));
      }
    } catch (e, st) {
      emit(OrganizerError(e, st));
    }
  }
}
