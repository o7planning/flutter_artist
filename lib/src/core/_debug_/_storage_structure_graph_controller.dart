part of '../_fa_core.dart';

class _StorageStructureGraphController {
  Function(Shelf shelf)? _setSelectedShelf;

  void setSelectedShelf(Shelf shelf) {
    if (_setSelectedShelf != null) {
      _setSelectedShelf!(shelf);
    }
  }
}
