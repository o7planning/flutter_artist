part of '../flutter_artist.dart';

class _ShelfRelationshipController {
  Function(ShelfBlockScalarType shelfBlockType)? _setShelfBlockType;

  void setFluBlockType(ShelfBlockScalarType shelfBlockType) {
    if (_setShelfBlockType != null) {
      _setShelfBlockType!(shelfBlockType);
    }
  }
}
