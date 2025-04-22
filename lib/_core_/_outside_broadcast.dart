part of '../flutter_artist.dart';

class OutsideBroadcast {
  final bool defaultEventMode;
  final List<Event> events;

  const OutsideBroadcast.defaultEvents()
      : defaultEventMode = true,
        events = const [];

  const OutsideBroadcast.customEvents({
    required this.events,
  }) : defaultEventMode = false;
}

class Event {
  final Type itemType;

  Event(this.itemType);
}
