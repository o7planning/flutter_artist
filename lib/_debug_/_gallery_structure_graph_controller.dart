part of '../flutter_artist.dart';

class _GalleryStructureGraphController {
  Function(Shelf shelf)? _setSelectedShelf;

  void setSelectedShelf(Shelf shelf) {
    if (_setSelectedShelf != null) {
      _setSelectedShelf!(shelf);
    }
  }
}
