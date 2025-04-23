part of '../flutter_artist.dart';

///
///
class ScalarOutsideEventReaction {
  final bool intrinsicMode;
  final ScalarReaction? reaction;
  final List<Type>? _events;

  const ScalarOutsideEventReaction.intrinsic({
    required ScalarReaction this.reaction,
  })  : intrinsicMode = true,
        _events = null;

  const ScalarOutsideEventReaction.custom({
    required List<Type> events,
    required ScalarReaction this.reaction,
  })  : intrinsicMode = false,
        _events = events;
}

enum ScalarReaction {
  query,
  refreshCurrentItem;
}
