part of '../core.dart';

@Deprecated("Delete, replaced by BlockReceivedEventInfo")
class DeferredEvent<ID> {
  final Shelf? eventShelf;

  final EventType eventType;
  final ID? itemId;
  final List<Type> events;

  DeferredEvent({
    required this.eventType,
    required this.eventShelf,
    required this.events,
    required this.itemId,
  });

  String? get eventShelfName => eventShelf?.name;
}
