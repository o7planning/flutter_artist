part of '../core.dart';

@_ShelfExternalAnnotation()
class _ShelfExternalUtils {
  final Shelf shelf;

  _ShelfExternalUtils(this.shelf);

  // Test Cases: [99a]
  EffectedShelfMembers calculateEffectedShelfMembersByEvents(
      List<Event> events,) {
    EffectedShelfMembers ret = EffectedShelfMembers.ofNothing();
    for (Block block in shelf.blocks) {
      List<Event> typeEvents =
          block.config.onExternalShelfEvents.blockLevelReactionOn;
      if (_hasIntersection(events, typeEvents)) {
        ret._addReQueryBlock(block);
      }
      // typeEvents = block.config.executeItemLevelReactionToEvents;
      // if (_hasIntersection(events, typeEvents)) {
      //   ret._addRefreshCurrItmBlock(block);
      // }
    }
    for (Scalar scalar in shelf.scalars) {
      List<Event> typeEvents =
          scalar.config.onExternalShelfEvents.scalarLevelReactionOn;
      if (_hasIntersection(events, typeEvents)) {
        ret._addReQueryScalar(scalar);
      }
    }
    return ret;
  }

  bool _hasIntersection(List<Event> typeEvent1s, List<Event> typeEvent2s) {
    for (Event te1 in typeEvent1s) {
      if (typeEvent2s.contains(te1)) {
        return true;
      }
    }
    return false;
  }
}
