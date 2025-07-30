part of '../_debug.dart';

class ShelfRelationshipController {
  Function(ShelfBlockScalarType shelfBlockType)? _setShelfBlockType;

  void setFluBlockType(ShelfBlockScalarType shelfBlockType) {
    if (_setShelfBlockType != null) {
      _setShelfBlockType!(shelfBlockType);
    }
  }
}
