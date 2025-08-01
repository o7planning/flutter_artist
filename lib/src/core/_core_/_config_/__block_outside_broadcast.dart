part of '../core.dart';

///
/// outsideBroadcast: {
///    Okr:
/// }
///
@Deprecated("Xoa di")
class BlockOutsideBroadcast {
  final List<Event> events;

  const BlockOutsideBroadcast.custom({
    required this.events,
  });
}

@Deprecated("Xoa di")
class Event {
  final Type dataType;

  Event(this.dataType);
}
