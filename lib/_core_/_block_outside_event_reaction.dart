part of '../flutter_artist.dart';

///
///
class BlockOutsideEventReaction {
  final bool intrinsicMode;
  final BlockReaction? reaction;
  final List<Type>? _events;

  const BlockOutsideEventReaction.intrinsic({
    required BlockReaction this.reaction,
  })  : intrinsicMode = true,
        _events = null;

  const BlockOutsideEventReaction.custom({
    required List<Type> events,
    required BlockReaction this.reaction,
  })  : intrinsicMode = false,
        _events = events;
}

enum BlockReaction {
  query,
  refreshCurrentItem;
}
