import '../../core/_core/code.dart';

class ShelfRelationshipController {
  Function(ShelfBlockScalarType shelfBlockType)? setShelfBlockType;

  void setFluBlockType(ShelfBlockScalarType shelfBlockType) {
    if (setShelfBlockType != null) {
      setShelfBlockType!(shelfBlockType);
    }
  }
}
