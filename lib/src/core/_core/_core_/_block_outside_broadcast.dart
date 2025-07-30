part of '../code.dart';

///
/// outsideBroadcast: {
///    Okr:
/// }
///
class BlockOutsideBroadcast {
  final bool intrinsicEventMode;
  final List<Event> events;

  const BlockOutsideBroadcast.intrinsic()
      : intrinsicEventMode = true,
        events = const [];

  const BlockOutsideBroadcast.custom({
    required this.events,
  }) : intrinsicEventMode = false;
}

class Event {
  final Type dataType;

  Event(this.dataType);
}
