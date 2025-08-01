part of '../core.dart';

///
///
@Deprecated("Xoa di")
class ScalarOutsideEventReaction {
  final ScalarReaction? reaction;
  final List<Event>? _events;

  const ScalarOutsideEventReaction.custom({
    required List<Event> events,
    required ScalarReaction this.reaction,
  }) : _events = events;

  List<Type> getDataEventTypes() {
    if (_events == null) {
      return [];
    }
    return _events.map((e) => e.dataType).toList();
  }
}

@Deprecated("Xoa di")
enum ScalarReaction {
  reQuery,
}
