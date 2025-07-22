part of '../../flutter_artist.dart';

class BlockConfig {
  final bool leaveTheFormSafely;
  final BlockRefreshItemMode refreshItemMode;
  final BlockHiddenBehavior hiddenBehavior;

  final BlockOutsideBroadcast? outsideBroadcast;

  final BlockOutsideEventReaction? outsideEventReaction;

  final BlockInternalBroadcast? internalBroadcast;

  final BlockInternalEventReaction? internalEventReaction;

  BlockConfig({
    this.refreshItemMode = BlockRefreshItemMode.auto,
    this.leaveTheFormSafely = true,
    this.hiddenBehavior = BlockHiddenBehavior.none,
    this.outsideBroadcast,
    this.outsideEventReaction,
    this.internalBroadcast,
    this.internalEventReaction,
  });
}
