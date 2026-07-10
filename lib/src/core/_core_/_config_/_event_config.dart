part of '../core.dart';

enum EventType {
  creation,
  update,
  deletion,
  unknown;
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

class BlockEventReaction {
  /// The data type the block is listening to (e.g., ProductInfo).
  final Type dataType;

  /// What action should be executed upon receiving the event.
  final BlockReactionTarget target;

  /// Custom filter strategy to evaluate if this block should react.
  /// [isLocal] tells the block if the event originated from its own Shelf.
  final bool Function(ArtistEvent event, bool isLocal)? shouldTrigger;

  const BlockEventReaction({
    required this.dataType,
    required this.target,
    this.shouldTrigger,
  });
}

// class Event extends Equatable {
//   final Type dataType;
//
//   const Event(this.dataType);
//
//   // IMPORTANT:
//   @override
//   List<Object?> get props => [dataType];
//
//   @override
//   String toString() {
//     return "Event($dataType)";
//   }
// }
