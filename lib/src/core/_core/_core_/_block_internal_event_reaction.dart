part of '../../_fa_core.dart';

///
///
class BlockInternalEventReaction {
  final bool intrinsicMode;
  final BlockReaction? reaction;
  final List<Event>? _events;

  const BlockInternalEventReaction.intrinsic({
    required BlockReaction this.reaction,
  })  : intrinsicMode = true,
        _events = null;

  const BlockInternalEventReaction.custom({
    required List<Event> events,
    required BlockReaction this.reaction,
  })  : intrinsicMode = false,
        _events = events;
}
