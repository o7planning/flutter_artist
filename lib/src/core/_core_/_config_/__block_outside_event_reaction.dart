part of '../core.dart';

///
///
@Deprecated("Xoa di")
class BlockOutsideEventReaction {
  final BlockReaction? reaction;
  final List<Event>? _events;

  const BlockOutsideEventReaction.custom({
    required List<Event> events,
    required BlockReaction this.reaction,
  }) : _events = events;
}

@Deprecated("Xoa di")
enum BlockReaction {
  reQuery,
  refreshCurrentItem;
}
