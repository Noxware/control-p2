import 'package:control_p2/models/models.dart';

/// Provides an abstraction to get and organize resources based on decisions
class OrganizerRepository {
  /// Get available resources to organize
  Future<List<Resource>> getResources() {
    throw UnimplementedError();
  }

  /// Get the list of available decisions
  Future<List<Decision>> getDecisions() {
    throw UnimplementedError();
  }

  /// Organize a resource based on a final decision taked.
  ///
  /// The decision must have a directory associated.
  Future<void> organize(Resource res, Decision des) {
    throw UnimplementedError();
  }

  // move(resource, uri)?
}
