part of '../flutter_artist.dart';

///
///
class ScalarOutsideEventReaction {
  final bool intrinsicMode;
  final ScalarReaction? reaction;
  final List<Event>? _events;

  const ScalarOutsideEventReaction.custom({
    required List<Event> events,
    required ScalarReaction this.reaction,
  })  : intrinsicMode = false,
        _events = events;

  List<Type> getDataEventTypes() {
    if (_events == null) {
      return [];
    }
    return _events!.map((e) => e.dataType).toList();
  }
}

enum ScalarReaction {
  reQuery,
}
