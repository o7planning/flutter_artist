part of '../core.dart';

class BlockEventReaction {
  /// The data type the block is listening to (e.g., ProductInfo).
  final Type dataType;

  /// What action should be executed upon receiving the event.
  final BlockReactionTarget target;

  /// Custom filter strategy to evaluate if this block should react.
  /// [isShelfInternalEvent] tells the block if the event originated from its own Shelf.
  final bool Function(ArtistEvent event, bool isShelfInternalEvent)?
  shouldTrigger;

  const BlockEventReaction({
    required this.dataType,
    required this.target,
    this.shouldTrigger,
  });
}
