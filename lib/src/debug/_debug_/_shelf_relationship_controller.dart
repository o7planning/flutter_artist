import '../../core/_fa_core.dart';

class ShelfRelationshipController {
  Function(ShelfBlockScalarType shelfBlockType)? setShelfBlockType;

  void setFluBlockType(ShelfBlockScalarType shelfBlockType) {
    if (setShelfBlockType != null) {
      setShelfBlockType!(shelfBlockType);
    }
  }
}
