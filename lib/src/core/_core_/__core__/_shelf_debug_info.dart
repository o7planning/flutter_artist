part of '../core.dart';

class _ShelfDebugInfo<ID extends Object> {
  final Shelf _shelf;

  int _initQueryTaskUnitsCount = 0;

  int get initQueryTasksCount => _initQueryTaskUnitsCount;

  _ShelfDebugInfo({required Shelf shelf}) : _shelf = shelf;
}
