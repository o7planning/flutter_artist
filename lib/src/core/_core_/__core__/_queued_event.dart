part of '../core.dart';

class QueuedEvent<ID extends Object> {
  final Shelf? eventShelf;

  final EventType eventType;
  final ID? itemId;
  final List<Event> events;

  QueuedEvent({
    required this.eventType,
    required this.eventShelf,
    required this.events,
    required this.itemId,
  });

  String? get eventShelfName => eventShelf?.name;
}
