part of '../core.dart';

///
/// outsideBroadcast: {
///    Okr:
/// }
///
@Deprecated("Xoa di")
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

@Deprecated("Xoa di")
class Event {
  final Type dataType;

  Event(this.dataType);
}
