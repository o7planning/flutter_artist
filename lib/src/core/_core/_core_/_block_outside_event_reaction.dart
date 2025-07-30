part of '../../_fa_core.dart';

///
///
class BlockOutsideEventReaction {
  final bool intrinsicMode;
  final BlockReaction? reaction;
  final List<Event>? _events;

  const BlockOutsideEventReaction.intrinsic({
    required BlockReaction this.reaction,
  })  : intrinsicMode = true,
        _events = null;

  const BlockOutsideEventReaction.custom({
    required List<Event> events,
    required BlockReaction this.reaction,
  })  : intrinsicMode = false,
        _events = events;
}

enum BlockReaction {
  reQuery,
  refreshCurrentItem;
}
