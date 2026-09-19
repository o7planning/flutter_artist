part of '../core.dart';

class ScalarEventReaction {
  /// The data type the scalar is listening to (e.g., ProductInfo).
  final Type dataType;

  /// Target component to refresh. For scalar, this is always scalar-level.
  final ScalarReactionTarget target;

  /// Custom filter strategy to evaluate if this scalar should react.
  /// [isShelfInternalEvent] tells the scalar if the event originated from its own Shelf.
  final bool Function(ArtistEvent event, bool isShelfInternalEvent)?
      shouldTrigger;

  const ScalarEventReaction({
    required this.dataType,
    this.target = ScalarReactionTarget.scalar,
    this.shouldTrigger,
  });
}
