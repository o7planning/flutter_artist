part of '../core.dart';

enum EventType {
  creation,
  update,
  deletion,
  mix;
}

@immutable
class ArtistEvent {
  /// The actual data type payload (e.g., ProductInfo)
  final Type dataType;

  /// Defines how far this event can travel
  final EventScope scope;

  /// The unique identifier of the originating Shelf instance.
  /// This prevents distinct Shelves of the same type from conflicting.
  final String? sourceShelfId;

  const ArtistEvent({
    required this.dataType,
    this.scope = EventScope.global,
    this.sourceShelfId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ArtistEvent &&
              runtimeType == other.runtimeType &&
              dataType == other.dataType &&
              scope == other.scope &&
              sourceShelfId == other.sourceShelfId;

  @override
  int get hashCode =>
      dataType.hashCode ^ scope.hashCode ^ sourceShelfId.hashCode;

  @override
  String toString() =>
      'ArtistEvent($dataType, scope: $scope, source: $sourceShelfId)';
}
