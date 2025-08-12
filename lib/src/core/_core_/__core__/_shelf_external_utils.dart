part of '../core.dart';

@_ShelfExternalAnnotation()
class ShelfExternalUtils {
  final Shelf shelf;

  ShelfExternalUtils(this.shelf);

  EffectedShelfMembers calculateEffectedShelfMembersByEvents(
      List<Type> events) {
    EffectedShelfMembers ret = EffectedShelfMembers(
      shelfReactionType: ShelfReactionType.external,
    );
    for (Block block in shelf.blocks) {
      List<Type> types = block.config.reQueryByExternalShelfEvents;
      if (_hasIntersection(events, types)) {
        ret._addReQueryBlock(block);
      }
      types = block.config.refreshCurrItemByExternalShelfEvents;
      if (_hasIntersection(events, types)) {
        ret._addRefreshCurrItmBlock(block);
      }
    }
    for (Scalar scalar in shelf.scalars) {
      List<Type> types = scalar.config.reQueryByExternalShelfEvents;
      if (_hasIntersection(events, types)) {
        ret._addReQueryScalar(scalar);
      }
    }
    return ret;
  }

  bool _hasIntersection(List<Type> type1s, List<Type> type2s) {
    for (Type t1 in type1s) {
      if (type2s.contains(t1)) {
        return true;
      }
    }
    return false;
  }
}
