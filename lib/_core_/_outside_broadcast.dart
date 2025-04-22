part of '../flutter_artist.dart';

class OutsideBroadcast {
  final List<Event> events;

  const OutsideBroadcast({
    this.events = const [],
  });
}

class Event {
  final Type itemType;

  Event(this.itemType);
}
