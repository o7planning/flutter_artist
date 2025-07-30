import '../../core/_core/core.dart';

class ShelfRelationshipController {
  Function(ShelfBlockScalarType shelfBlockType)? setShelfBlockType;

  void setFluBlockType(ShelfBlockScalarType shelfBlockType) {
    if (setShelfBlockType != null) {
      setShelfBlockType!(shelfBlockType);
    }
  }
}
