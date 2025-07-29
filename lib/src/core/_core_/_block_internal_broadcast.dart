part of '../_fa_core.dart';

///
/// internalBroadcast: {
///    Okr:
/// }
///
class BlockInternalBroadcast {
  final bool intrinsicEventMode;
  final List<Event> events;

  const BlockInternalBroadcast.intrinsic()
      : intrinsicEventMode = true,
        events = const [];

  const BlockInternalBroadcast.custom({
    required this.events,
  }) : intrinsicEventMode = false;
}
