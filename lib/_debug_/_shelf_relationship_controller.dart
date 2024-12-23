part of '../flutter_artist.dart';

class _ShelfRelationshipController {
  Function(ShelfBlockType shelfBlockType)? _setShelfBlockType;

  void setFluBlockType(ShelfBlockType shelfBlockType) {
    if (_setShelfBlockType != null) {
      _setShelfBlockType!(shelfBlockType);
    }
  }
}
