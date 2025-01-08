part of '../flutter_artist.dart';

class _StorageChangeManager {
  final Map<String, Shelf> _registedShelfMap = {};

  // ===========================================================================
  // ===========================================================================

  void _registerShelf(String shelfName, Shelf shelf) {
    _registedShelfMap[shelfName] = shelf;
  }
}
