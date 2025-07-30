part of '../core.dart';

///
///
class ScalarInternalEventReaction {
  final bool intrinsicMode;
  final ScalarReaction? reaction;
  final List<Event>? _events;

  const ScalarInternalEventReaction.custom({
    required List<Event> events,
    required ScalarReaction this.reaction,
  })  : intrinsicMode = false,
        _events = events;

  List<Type> getDataEventTypes() {
    if (_events == null) {
      return [];
    }
    return _events.map((e) => e.dataType).toList();
  }
}
