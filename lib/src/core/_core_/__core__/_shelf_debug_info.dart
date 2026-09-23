part of '../core.dart';

class _ShelfDebugInfo {
  final Shelf _shelf;

  int _lazyLoadId = 0;

  int get lazyLoadId => _lazyLoadId;

  _ShelfDebugInfo({required Shelf shelf}) : _shelf = shelf;
}
